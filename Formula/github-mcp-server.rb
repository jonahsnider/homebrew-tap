class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  version "1.5.0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  on_macos do
    on_arm do
      url "https://github.com/github/github-mcp-server/releases/download/v#{version}/github-mcp-server_Darwin_arm64.tar.gz"
      sha256 "dcb2c448cec678027e0b727f5b4601f2775c9334e48fb80a3015b2db302de577"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v#{version}/github-mcp-server_Darwin_x86_64.tar.gz"
      sha256 "ce0027e65c55700c44f96da05a328236685a75ec0a8ec90ba4521fdaa6fd41a1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/github/github-mcp-server/releases/download/v#{version}/github-mcp-server_Linux_arm64.tar.gz"
      sha256 "fc83c56f554969e9c1e554d2918bc48431d988d10238ef900c31c181c81da4b1"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v#{version}/github-mcp-server_Linux_x86_64.tar.gz"
      sha256 "7960747815e1fefab3e76494a26b6a270d5ec513c2132eb5e19656bb2218922b"
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
