class Bt < Formula
  desc "Braintrust command-line interface"
  homepage "https://www.braintrust.dev/docs/reference/cli"
  url "https://github.com/braintrustdata/bt/releases/download/v0.14.0/source.tar.gz"
  sha256 "4fa5cc21d8891c85e2fcbca966eb1b9b3715d36df9965fc14e72f3aa4dc91bab"
  license "Apache-2.0"
  head "https://github.com/braintrustdata/bt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/bt-0.12.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "089f9489868b6f914b61dfd4ad2b86a029ccacaa1e20e0e0cd9037761c07a71f"
    sha256 cellar: :any,                 x86_64_linux: "5f8d08106163a4ea5cfed06c4382d93cded26e0c8752f67b92e0f678c10aee44"
  end

  depends_on "rust" => :build

  conflicts_with "bootterm", because: "both install a `bt` executable"

  def install
    unless build.head?
      ENV["BT_VERSION_STRING"] = version.to_s
      ENV["BT_UPDATE_CHANNEL"] = "stable"
    end

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match(/\Abt \d+\.\d+\.\d+/, shell_output("#{bin}/bt --version"))
    assert_match "2026-05-14T03:01:58Z",
      shell_output("#{bin}/bt util version to-time p07639577379371417602 --utc")
  end
end
