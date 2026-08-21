class How < Formula
  desc "Learn how to use CLI apps"
  homepage "https://github.com/jonahsnider/how"
  url "https://github.com/jonahsnider/how/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "8efa637c203087e748f99038eefe89a543c333b467619e237a6d5589b801d1b2"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/how-4.1.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "ee7036c1f76c0aa2175b37a6bfa1e77db52f5c4f1cf07f0bf1e9acadd6d2969e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "866943c9daba12abc9d7bd233bd53deafc86b5db2fbaaa30f446fa2108218e9d"
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
