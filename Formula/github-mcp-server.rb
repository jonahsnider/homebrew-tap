class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/github-mcp-server-1.10.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "c0be231378558b2eed1a0458a02240db75427c3561aeb79463fab7b48c2c90ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6e6ae6a03cd6db9501af81f3a7b8d93147c2ea61f7705da1b5f53e50f4731bcf"
  end

  on_macos do
    on_arm do
      url "https://github.com/github/github-mcp-server/releases/download/v1.10.1/github-mcp-server_Darwin_arm64.tar.gz"
      sha256 "ca530ba9abf04030104166cc37e1072087a30a173e921c0ed9064f98c73ca039"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v1.10.1/github-mcp-server_Darwin_x86_64.tar.gz"
      sha256 "ea6e86baea583c6c5b55cce071c1c19253009a90f1e987788cb5eb228fcd9556"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/github/github-mcp-server/releases/download/v1.10.1/github-mcp-server_Linux_arm64.tar.gz"
      sha256 "c51dc6cf192c35a328b9f71696d42c38a9a3ba3c2ffe010da836bed071d1ac8a"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v1.10.1/github-mcp-server_Linux_x86_64.tar.gz"
      sha256 "c2629e850a344275cfc5a1590acdfd8c11476a44b688812d460163768e05572d"
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
