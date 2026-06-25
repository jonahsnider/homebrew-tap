class How < Formula
  desc "Learn how to use CLI apps"
  homepage "https://github.com/jonahsnider/how"
  url "https://github.com/jonahsnider/how/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "a0ad9b4d1480609adc0fea5f3ca933ce9f123c2cd92c0b19e95eeaf2b6bcd278"
  license "Apache-2.0"

  depends_on "fish"

  def install
    fish_function.install Dir["functions/*.fish"]
    fish_completion.install "completions/how.fish"
    (share/"fish/vendor_conf.d").install "conf.d/how.fish"
  end

  def caveats
    return if formula_any_version_installed?("glow") ||
              formula_any_version_installed?("bat") ||
              formula_any_version_installed?("leaf")

    <<~EOS
      how works best when a Markdown viewer is installed.
      If you don't have one, try one of:
        brew install glow
        brew install bat
        brew install leaf
    EOS
  end

  test do
    system "#{Formula["fish"].bin}/fish", "-c", "how --help"
  end
end
