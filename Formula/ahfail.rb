class Ahfail < Formula
  desc "Plays 'ah ah ah, you didn't say the magic word' on failed screen lock attempts"
  homepage "https://gitea.weircon.dk/agw/gtk-ahfail"
  url "https://gitea.weircon.dk/agw/gtk-ahfail/archive/v0.10.0.tar.gz"
  sha256 "a96263885fedd33513b3a783243fae7a9ee58ca41e938a18afd6e42dd139d221"
  license "AGPL-3.0-only"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "gtk+3"
  depends_on "gstreamer"
  depends_on "gst-plugins-base"
  depends_on "gst-plugins-good"
  depends_on :macos

  def install
    # Pass libdir so the PAM module has DEFAULT_PATH baked in correctly for
    # both Intel (/usr/local/lib) and Apple Silicon (/opt/homebrew/lib).
    system "meson", "setup", "builddir",
           "--buildtype=release",
           "-Dlibdir=#{lib}"
    system "meson", "compile", "-C", "builddir"
    (lib/"ahfail").install "builddir/libahfail_pam.so"
    (lib/"ahfail").install "builddir/ahfail-display"
  end

  def caveats
    pam_file = if MacOS.version >= :ventura
      "/etc/pam.d/screensaverui"
    else
      "/etc/pam.d/screensaver"
    end
    <<~EOS
      To activate, add this line to #{pam_file} after the existing auth entries
      (requires sudo — this is a config file entry, not a shell command):

        auth optional #{lib}/ahfail/libahfail_pam.so

      To uninstall cleanly, remove that line before running `brew uninstall ahfail`:

        sudo sed -i '' '/ahfail/d' #{pam_file}
        brew uninstall ahfail
    EOS
  end

  test do
    assert_predicate lib/"ahfail/libahfail_pam.so", :exist?
    assert_predicate lib/"ahfail/ahfail-display", :exist?
  end
end
