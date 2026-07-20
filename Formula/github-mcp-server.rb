class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  version "1.6.0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  on_macos do
    on_arm do
      url "https://github.com/github/github-mcp-server/releases/download/v#{version}/github-mcp-server_Darwin_arm64.tar.gz"
      sha256 "cdce71ef6f893d463910678ec298bba76610ca4591bf35263f0ff0ec35928f9e"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v#{version}/github-mcp-server_Darwin_x86_64.tar.gz"
      sha256 "75bf4fb2c855a3af5381056b88afdf2e2b67e330906aadfbae9682e8dcacbd3f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/github/github-mcp-server/releases/download/v#{version}/github-mcp-server_Linux_arm64.tar.gz"
      sha256 "25f8028304202674ec2e9977fec3ca0897cac33866dabb51aefd418bc0ce7ef2"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v#{version}/github-mcp-server_Linux_x86_64.tar.gz"
      sha256 "27443d173f209e60d4af9777e624bfea3de1af24897d46cc7324f01cf279a41d"
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
