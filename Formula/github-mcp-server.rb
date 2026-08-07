class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
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
      url "https://github.com/github/github-mcp-server/releases/download/v1.8.0/github-mcp-server_Darwin_arm64.tar.gz"
      sha256 "1da9cff2490f2908e2fd051e090c5c0792cd44773ee195b85ad0f549d3c435d0"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v1.8.0/github-mcp-server_Darwin_x86_64.tar.gz"
      sha256 "5fef4459a7e67c64a8e7db3a858f992a6f03595225328f842b34f1b468a89c70"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/github/github-mcp-server/releases/download/v1.8.0/github-mcp-server_Linux_arm64.tar.gz"
      sha256 "c4b0fe8d4e31c079e5c3f3a54050a08449dae6fa8189ec5998822555ad27bde8"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v1.8.0/github-mcp-server_Linux_x86_64.tar.gz"
      sha256 "b2754921aec1b1302b19a71531d26d242ef0e7f1e05696b8444beab5a7e61d5b"
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
