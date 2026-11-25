class Bt < Formula
  desc "Braintrust command-line interface"
  homepage "https://www.braintrust.dev/docs/reference/cli"
  url "https://github.com/braintrustdata/bt/releases/download/v0.33.0/source.tar.gz"
  sha256 "785870fc902da8002c033435e832ba2c0552b092b7a6ca8255e514375f233ae2"
  license "Apache-2.0"
  head "https://github.com/braintrustdata/bt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/bt-0.32.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "7293f25371f52f28982b984cda0e3eb64ebd0572bbc3cae8e695d227dcee0900"
    sha256 cellar: :any,                 x86_64_linux: "e9d515747095e9760e35408593809c045671e53f282257ea5a22678d134335f1"
  end

  depends_on "node" => :build
  depends_on "pnpm@10" => :build
  depends_on "rust" => :build

  conflicts_with "bootterm", because: "both install a `bt` executable"

  def install
    unless build.head?
      ENV["BT_VERSION_STRING"] = version.to_s
      ENV["BT_UPDATE_CHANNEL"] = "stable"
    end

    # Use Homebrew's pnpm instead of downloading the version in package.json.
    (buildpath/".npmrc").write "manage-package-manager-versions=false\n"
    system "pnpm", "install", "--frozen-lockfile", "--ignore-scripts"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match(/\Abt \d+\.\d+\.\d+/, shell_output("#{bin}/bt --version"))
    assert_match "2026-05-14T03:01:58Z",
      shell_output("#{bin}/bt util version to-time p07639577379371417602 --utc")
  end
end
