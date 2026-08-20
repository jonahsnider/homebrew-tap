class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/github-mcp-server-1.9.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "8d0b849c15b744cffd20342270edfc658a32aad42b72110b65481ce4418d47bd"
    sha256 cellar: :any_skip_relocation, sequoia:      "67c91665c8c5d81bec12e768a031c1a4afc93f54833ac7e6173bc0047df219db"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fedf30cbc8850e7ee243ef21c124c03a27506c09e9f3bc81e704f9504d16ba00"
  end

  on_macos do
    on_arm do
      url "https://github.com/github/github-mcp-server/releases/download/v1.10.0/github-mcp-server_Darwin_arm64.tar.gz"
      sha256 "edecaa34816b2afc9d3a0bb265109dccf5aa5040ac8bb3113c174c80acc6a765"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v1.10.0/github-mcp-server_Darwin_x86_64.tar.gz"
      sha256 "d05b697460f935988650b3ebc0390ff9f774fb3822ca989b39ef73f163bb8dbc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/github/github-mcp-server/releases/download/v1.10.0/github-mcp-server_Linux_arm64.tar.gz"
      sha256 "b37e0e80f863fd9e3ebb50be773fa0c3f73ddb9d9e735a48d5ad6dc2bf5795ac"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v1.10.0/github-mcp-server_Linux_x86_64.tar.gz"
      sha256 "0a47a49c5a54e6e26f40e17b7e8e410d753c6cd1ba23be42fb016ca91878c65c"
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
