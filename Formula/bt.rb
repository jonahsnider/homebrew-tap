class Bt < Formula
  desc "Braintrust command-line interface"
  homepage "https://www.braintrust.dev/docs/reference/cli"
  url "https://github.com/braintrustdata/bt/releases/download/v0.19.3/source.tar.gz"
  sha256 "d4f1264de870d96faaf8ed09a4a8d3c9f291f6b3512d4e9b544d59a010f1ff68"
  license "Apache-2.0"
  head "https://github.com/braintrustdata/bt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/bt-0.19.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "9c1dfd1cc39cf003cc5f5d7610a21899d49cb670f61d19abd123d9dba6dfaf2e"
    sha256 cellar: :any,                 x86_64_linux: "04a8d4e73c3ae6099deb7c07d56ea594434ab10add9e0edd69760da4805c64f4"
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
