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
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/bt-0.20.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "0f61997b7c3ff8c48dbca9614a8c08c86ce2abc8ca429d7b643eb0064b1b20f1"
    sha256 cellar: :any,                 x86_64_linux: "d0c722a07193d8a545e5602951388e411e9283999a0287cdc5b170840c4139c1"
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
