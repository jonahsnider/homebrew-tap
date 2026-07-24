class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  version "1.7.0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/github-mcp-server-1.7.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "6663f28d896041902e730c43e70321b810f73bcea755a5392781100ca3bcf7b1"
    sha256 cellar: :any_skip_relocation, sequoia:      "00be3e23776e8518e1875627babdd1e36aaf5cb8a922d795d4469e42fac9eeb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e658b3c444f954c519cf1a9177154d884c6687e3e4290ae6768697b9218c8974"
  end

  on_macos do
    on_arm do
      url "https://github.com/github/github-mcp-server/releases/download/v#{version}/github-mcp-server_Darwin_arm64.tar.gz"
      sha256 "dbe22c73b3eb9491cc3e27dba45352b980b1c43e4c857645689a0251c5e06a21"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v#{version}/github-mcp-server_Darwin_x86_64.tar.gz"
      sha256 "d94d018641a17e9193148634c91701760ebf7963efc0b00b2a65abe7ded32d2e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/github/github-mcp-server/releases/download/v#{version}/github-mcp-server_Linux_arm64.tar.gz"
      sha256 "50bd6b4e604d1039577710431c7025a9b1c05b8acce458001bb53f792e78d43f"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v#{version}/github-mcp-server_Linux_x86_64.tar.gz"
      sha256 "b653a2a01f33e9a726b581fa0d8a8d9a05a86af419e5ab33b8e26858366d1d66"
    end
  end

  def install
    bin.install "github-mcp-server"
    prefix.install "LICENSE"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/github-mcp-server --version")

    ENV["GITHUB_PERSONAL_ACCESS_TOKEN"] = "test"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
    JSON

    out = pipe_output("#{bin}/github-mcp-server stdio 2>&1", json)
    assert_includes out, "GitHub MCP Server running on stdio"
  end
end
