class Lazyreno < Formula
  desc "TUI dashboard for self-hosted Renovate CE"
  homepage "https://github.com/limehawk/lazyreno"
  url "https://github.com/limehawk/lazyreno/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "755e87b8f80c54564ab45e2e871f088185704388e71f9f9dea67ff66417d4098"
  license "MIT"
  head "https://github.com/limehawk/lazyreno.git", branch: "main"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyreno --version")
  end
end
