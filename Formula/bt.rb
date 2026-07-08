class Bt < Formula
  desc "Braintrust command-line interface"
  homepage "https://www.braintrust.dev/docs/reference/cli"
  url "https://github.com/braintrustdata/bt/releases/download/v0.15.1/source.tar.gz"
  sha256 "d48daffdf3bc38ee7928841499aa87a66447ae843ee707ae79da6ca1d50ff9f3"
  license "Apache-2.0"
  head "https://github.com/braintrustdata/bt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/bt-0.14.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "42c76602fe328042a6f4d38c8aa5ad11ee49908c2dd60e350ef7156d12b9e34e"
    sha256 cellar: :any,                 x86_64_linux: "cfed06dc3cd1ffc0ceb9960cbb78edfbd623ddc65ca426ac302a9288b2071a3b"
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
