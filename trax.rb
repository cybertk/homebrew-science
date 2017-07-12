class Trax < Formula
  desc "Visual Tracking eXchange protocol"
  homepage "https://github.com/votchallenge/trax"
  url "https://bintray.com/votchallenge/trax/download_file?file_path=trax-1.2.0-source.zip"
  sha256 "bb54cd3fc9c38851030a314087c946ad56526ded2a4e7b73ce8a514c4339cbda"

  head "https://github.com/votchallenge/trax.git"

  # options, enabled by default
  option "without-client", "Do not build with client support library and executable (traxclient)"
  option "with-opencv", "Build with OpenCV support)"

  depends_on "cmake" => :build
  depends_on "opencv" if build.with?("opencv")

  def install
    args = std_cmake_args
    args << "-DBUILD_CLIENT=1" if build.with?("client")
    args << "-DBUILD_OPENCV=1" if build.with?("opencv")

    system "cmake", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <trax.h>
      #include <stdio.h>
      int main()
      {
        printf("%s", trax_version());
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-ltrax", "-o", "test", "test.c"
    assert_equal version.to_s, shell_output("./test").strip
  end
end
