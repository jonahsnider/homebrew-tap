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
      url "https://github.com/github/github-mcp-server/releases/download/v1.9.0/github-mcp-server_Darwin_arm64.tar.gz"
      sha256 "cd38785573052942c337805ea365bbc27718e0bd254ee4a48e668a76b3f4a1ce"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v1.9.0/github-mcp-server_Darwin_x86_64.tar.gz"
      sha256 "7a6395a29752b3ad771bfb9d66fd1bfcb088fcbdfeb65fc22cb1146b67a3621a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/github/github-mcp-server/releases/download/v1.9.0/github-mcp-server_Linux_arm64.tar.gz"
      sha256 "11e14ce34492b6a07ae4bc567d8773fc4cd3dd77e91daf3f9cacc88b15d840ea"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v1.9.0/github-mcp-server_Linux_x86_64.tar.gz"
      sha256 "cbf38bd3364518ccf80b6a25587d5ef11655b15d63cbb48bc066384d0b5b5964"
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
