class Spacetimedb < Formula
  desc "Database that is also a server"
  homepage "https://spacetimedb.com/"
  url "https://github.com/clockworklabs/SpacetimeDB/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "c71f4c95479f30a4ad96db83df5a18f96d658b621df08e9f9340ce9ed5d5f484"
  license "BUSL-1.1"
  head "https://github.com/clockworklabs/SpacetimeDB.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/spacetimedb-2.10.0"
    sha256 cellar: :any, arm64_tahoe: "24be1c5b655742fbb4db44e63c671a753cac42649a717a5bc4f4af7086e062c8"
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
