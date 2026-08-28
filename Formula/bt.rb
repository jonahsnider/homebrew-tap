class Bt < Formula
  desc "Braintrust command-line interface"
  homepage "https://www.braintrust.dev/docs/reference/cli"
  url "https://github.com/braintrustdata/bt/releases/download/v0.18.0/source.tar.gz"
  sha256 "0c264098bdf8aa9a9a686879ee360907f99573fdd55f964d564bd0143412c2d4"
  license "Apache-2.0"
  head "https://github.com/braintrustdata/bt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/bt-0.17.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "96c499b2f7429b78afd27a88570017a0fcc624e67d5bd86c9533723b823c7b79"
    sha256 cellar: :any,                 x86_64_linux: "0ea6a2015d535b3d34bf34b8fd0e82d83ef9fedaa54f5ce929c023243a8b798b"
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
