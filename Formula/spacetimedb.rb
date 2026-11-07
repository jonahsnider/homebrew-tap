class Spacetimedb < Formula
  desc "Database that is also a server"
  homepage "https://spacetimedb.com/"
  url "https://github.com/clockworklabs/SpacetimeDB/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "32d3e0ce8c411124bc95db3b1bbaf9629ed24d3a84e7ae73bbe19c863db06e2d"
  license "BUSL-1.1"
  head "https://github.com/clockworklabs/SpacetimeDB.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/spacetimedb-2.15.0"
    sha256 cellar: :any, arm64_tahoe: "d57980f50ab15066ede7a305ab8901e02292ef1ffa057081cc11e653f545b215"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Use source-tree file discovery since the release archive lacks git metadata.
    ENV["SPACETIMEDB_NIX_BUILD_GIT_COMMIT"] = "v#{version}"
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    mv bin/"spacetimedb-cli", bin/"spacetime"

    system "cargo", "install", *std_cargo_args(path: "crates/standalone")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spacetime --version")

    system bin/"spacetime", "--root-dir", testpath/"root", "init", "hello",
           "--lang", "rust", "--server-only", "--local", "--non-interactive"
    assert_path_exists testpath/"hello/spacetimedb/Cargo.toml"
    assert_match "spacetimedb", (testpath/"hello/spacetimedb/Cargo.toml").read
  end
end
