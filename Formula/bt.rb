class Bt < Formula
  desc "Braintrust command-line interface"
  homepage "https://www.braintrust.dev/docs/reference/cli"
  url "https://github.com/braintrustdata/bt/releases/download/v0.25.0/source.tar.gz"
  sha256 "8a53c3caf443b607494c675f7d266e05c3746cb7b1fd056866165297ab9d9271"
  license "Apache-2.0"
  head "https://github.com/braintrustdata/bt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/bt-0.24.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "98d8c158a860e15ca4568f0321adace13e9197fc67665bd51a4dd1749ed8b595"
    sha256 cellar: :any,                 x86_64_linux: "9107cc364fb7713d057efce05ebd9457a5728111786880cba18718c5fccd0cde"
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
