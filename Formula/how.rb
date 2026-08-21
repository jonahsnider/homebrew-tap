class How < Formula
  desc "Learn how to use CLI apps"
  homepage "https://github.com/jonahsnider/how"
  url "https://github.com/jonahsnider/how/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "8efa637c203087e748f99038eefe89a543c333b467619e237a6d5589b801d1b2"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/how-4.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "a724d3e0a19374cf3d841e33c1dd5d193ad39b49c6b63c824a8fe9ef199c923f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "af32142fe86ff3ae35a73479743144e41df2afe578d6df0a72df686929f7f6e1"
  end

  depends_on "fish"

  def install
    fish_function.install Dir["functions/*.fish"]
    fish_completion.install "completions/how.fish"
    (share/"fish/vendor_conf.d").install "conf.d/how.fish"
  end

  def caveats
    return if formula_any_version_installed?("glow") ||
              formula_any_version_installed?("bat") ||
              formula_any_version_installed?("leaf-markdown-viewer")

    <<~EOS
      how works best when a Markdown viewer is installed.
      If you don't have one, try one of:
        brew install glow
        brew install bat
        brew install leaf-markdown-viewer
    EOS
  end

  test do
    system "#{Formula["fish"].bin}/fish", "-c", "how --help"
  end
end
