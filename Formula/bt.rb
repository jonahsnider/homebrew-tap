class Bt < Formula
  desc "Braintrust command-line interface"
  homepage "https://www.braintrust.dev/docs/reference/cli"
  url "https://github.com/braintrustdata/bt/releases/download/v0.19.1/source.tar.gz"
  sha256 "b1535dc3f2f20b0d4c0ad349acba98b8219a35edaea7859b7a2222777ff1ac7b"
  license "Apache-2.0"
  head "https://github.com/braintrustdata/bt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/bt-0.19.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "f40ee8b72e97e731b151217786cb0156c0aa6ca812ac7a68bad33bb120ba8dde"
    sha256 cellar: :any,                 x86_64_linux: "d9a55990d1478a5fc2feedd26f9c08587e83d544d4b7c374d7eec182da42e373"
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
