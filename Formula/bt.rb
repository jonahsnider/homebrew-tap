class Bt < Formula
  desc "Braintrust command-line interface"
  homepage "https://www.braintrust.dev/docs/reference/cli"
  url "https://github.com/braintrustdata/bt/releases/download/v0.28.0/source.tar.gz"
  sha256 "3b732bcdd3ccd7cb7aa1c595e9a666bfe8a344156e68cf75a79204814e723c5f"
  license "Apache-2.0"
  head "https://github.com/braintrustdata/bt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/jonahsnider/homebrew-tap/releases/download/bt-0.27.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "37f4c59ef217eaa09c3e20b0003db327ff3e11a0b7a2105f9041ed7cdd57e5e6"
    sha256 cellar: :any,                 x86_64_linux: "ca898e3a638e0e86ea727c9705556f5b6ff87edf52c5428542b651bb23154f6c"
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
