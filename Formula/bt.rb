class Bt < Formula
  desc "Braintrust command-line interface"
  homepage "https://www.braintrust.dev/docs/reference/cli"
  url "https://github.com/braintrustdata/bt/releases/download/v0.28.1/source.tar.gz"
  sha256 "b6898dfbca9e8f51da223178bbf898a40c352657131a585965596e66a3c0ca6d"
  license "Apache-2.0"
  head "https://github.com/braintrustdata/bt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/bt-0.28.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "1b78ac1b770f60c26e39b3983ad4d57402b83edc4c13a2f4e2c21e6a96106e36"
    sha256 cellar: :any,                 x86_64_linux: "151085a52a40106d26ff7d432049f34320b1ca6331189ce2d7653b58be65eb96"
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
