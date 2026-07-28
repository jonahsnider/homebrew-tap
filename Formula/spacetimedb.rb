class Spacetimedb < Formula
  desc "Database that is also a server"
  homepage "https://spacetimedb.com/"
  url "https://github.com/clockworklabs/SpacetimeDB/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "b069beb22da479fc8ae05f49452a9183cc018a96b9118af365ad5c0b60d482e8"
  license "BUSL-1.1"
  head "https://github.com/clockworklabs/SpacetimeDB.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/spacetimedb-2.7.1"
    sha256 cellar: :any, arm64_tahoe: "bc8798412f27eafda23e4efe922f1f000bfc7065c31a6d417258a0a07a1773f5"
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
