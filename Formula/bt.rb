class Bt < Formula
  desc "Braintrust command-line interface"
  homepage "https://www.braintrust.dev/docs/reference/cli"
  url "https://github.com/braintrustdata/bt/releases/download/v0.21.0/source.tar.gz"
  sha256 "75ee4665b64b810960cfea90a198debc666aa6de1abac1d78e8bf24d918c8899"
  license "Apache-2.0"
  head "https://github.com/braintrustdata/bt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/bt-0.21.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "05b19021afe7cf544d2808b3136ce74c896629173fdfbe0252bbe0f337920a12"
    sha256 cellar: :any,                 x86_64_linux: "01ce64c47adb97259e2e3076f5a2b159d0dfa6f96cd9a280328b44dd28b96218"
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
