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
      url "https://github.com/github/github-mcp-server/releases/download/v1.11.0/github-mcp-server_Darwin_arm64.tar.gz"
      sha256 "b08e962fb797a9069fb932c25957209026dcbaa9478f3a248a1bf2354af978ec"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v1.11.0/github-mcp-server_Darwin_x86_64.tar.gz"
      sha256 "e7cc6b5d16bcb86b01cae2ba32fa7525266a10c96db8d64df63a172ebb7b8f95"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/github/github-mcp-server/releases/download/v1.11.0/github-mcp-server_Linux_arm64.tar.gz"
      sha256 "3f7615254f6b619469c471c5d275029299ff7431c93d6075496ea4b2eec020cb"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v1.11.0/github-mcp-server_Linux_x86_64.tar.gz"
      sha256 "3b73bb7be0c8b043f861e90410df8ebdfc71b83128c54ced75fb32c4ff697fc5"
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
