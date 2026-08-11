class Spacetimedb < Formula
  desc "Database that is also a server"
  homepage "https://spacetimedb.com/"
  url "https://github.com/clockworklabs/SpacetimeDB/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "6ed3c01695a22b18bf328cf714e6f1dbc7821a91c44e56c1bf4a7d6607cac8fd"
  license "BUSL-1.1"
  head "https://github.com/clockworklabs/SpacetimeDB.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/spacetimedb-2.8.1"
    sha256 cellar: :any, arm64_tahoe: "b67d9649109239ede671e1896bdab45659a552c68a9468291cacd6c619fb585f"
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
