class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/github-mcp-server-1.11.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "b9e18c4d3f3075b039d0143b0a3035e3af8acffd0c70111593a425902ad8bd90"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "495c1f62d6367f82bd0a69391139da6ad550fa67074c746e7f533f959109b7f5"
  end

  on_macos do
    on_arm do
      url "https://github.com/github/github-mcp-server/releases/download/v1.12.0/github-mcp-server_Darwin_arm64.tar.gz"
      sha256 "e559f9da66cd639d14f72ca5402d2ad8e258849d30458bbbf3347d5408b02676"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v1.12.0/github-mcp-server_Darwin_x86_64.tar.gz"
      sha256 "bd386e398f37011db94f186a7b30ddf1be943fa2d414824d749455e2c83feb42"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/github/github-mcp-server/releases/download/v1.12.0/github-mcp-server_Linux_arm64.tar.gz"
      sha256 "51f2411e93d981eb7038ca23229aa960006209ce82a4dd80a92d7875a7931a5c"
    end

    on_intel do
      url "https://github.com/github/github-mcp-server/releases/download/v1.12.0/github-mcp-server_Linux_x86_64.tar.gz"
      sha256 "f34de295acd8f1012c7f2c0e3b909d87361d0993b9489b57ee92ac72b85d7cca"
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
