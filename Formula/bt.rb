class Bt < Formula
  desc "Braintrust command-line interface"
  homepage "https://www.braintrust.dev/docs/reference/cli"
  url "https://github.com/braintrustdata/bt/releases/download/v0.19.2/source.tar.gz"
  sha256 "06fb3cf5b09f209f76b66af59cc1679e4b7c6a7d225269dc73ae7afd45252f04"
  license "Apache-2.0"
  head "https://github.com/braintrustdata/bt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/bt-0.19.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "670c06847b372c0e2a80a015a9a0fc8919f34646d8b497162eb1b704ba14c260"
    sha256 cellar: :any,                 x86_64_linux: "3b5ceeb8a658ad8cd141263745beac47c2a89431bbf72049232fe15f3ff1096a"
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
