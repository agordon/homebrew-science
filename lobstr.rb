require 'formula'

class Lobstr < Formula
  homepage 'http://lobstr.teamerlich.org'
  url "http://erlichlab.wi.mit.edu/lobSTR/lobSTR-3.0.3.tar.gz"
  sha1 "1f1578e9d1c36eb7268037c977204152f5022361"
  head 'https://github.com/mgymrek/lobstr-code', :using => :git

  option "without-check", "Disable build-time checking (not recommended)"

  if build.head?
    depends_on :autoconf => :build
    depends_on :automake => :build
  end
  depends_on :libtool => :build
  depends_on 'pkg-config' => :build
  depends_on "cppunit" => :build
  depends_on "gsl"
  depends_on "boost"

  def install
    if build.head?
      system 'sh', './reconf'
    end
    system './configure', "--prefix=#{prefix}",
                          '--disable-dependency-tracking'
    system 'make'
    system 'make', 'check' if build.with? "check"
    system 'make', 'install'
  end

  test do
    mktemp do
      system "#{bin}/lobSTR",
               "--verbose",
               "--index-prefix", "#{share}/lobSTR/test-ref/lobSTR_",
               "--fastq", "-f", "#{share}/lobSTR/sample/tiny.fq",
               "--rg-sample", "test",
               "--rg-lib", "test",
               "--out", "./test"
      assert $?.success?
    end
  end
end
