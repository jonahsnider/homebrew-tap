class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/github-mcp-server-1.12.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "f222b9981770792c95d594ce914cdacb4a2ac4e6b4f7f6f78606b7c085158cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bd600018153f8a540613fccee9fc2849dfcdd367488ca2a8d97db29a2236a3ed"
  end

  on_macos do
    on_arm do
      url "https://github.com/github/github-mcp-server/releases/download/v1.12.1/github-mcp-server_Darwin_arm64.tar.gz"
      sha256 "efb582c287e0dcc8897625d729a77f98c3f00a7af94b7ab6845acfe7f3274b28"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v1.12.1/github-mcp-server_Darwin_x86_64.tar.gz"
      sha256 "d820577e8199dac70ef8a306dbb95fda3b9a26adc30e1f93d7d20cec9a4b0b6d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/github/github-mcp-server/releases/download/v1.12.1/github-mcp-server_Linux_arm64.tar.gz"
      sha256 "0f613c61fa524b30278a249ae199220465ff051e79177e58866e5e677191fda9"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v1.12.1/github-mcp-server_Linux_x86_64.tar.gz"
      sha256 "e45c73a26a3c4cd643b40360db06f442de1e73a60d4eaf9e8639204ec3b95d3b"
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
