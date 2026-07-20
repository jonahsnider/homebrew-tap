cask "sentient-os" do
  version "1.0"
  sha256 "e8b64273ed5db09422e97b61251b98cfc45c3aee6791ac75b2ddffe0254909b8"

  url "https://github.com/Sentient-OS-Labs/sentient-os/releases/download/#{version}/SentientOS-#{version}.dmg",
      verified: "github.com/Sentient-OS-Labs/sentient-os/"
  name "Sentient OS"
  desc "On-device AI that reads your life and proactively acts on it"
  homepage "https://sentient-os.ai/"

  livecheck do
    url "https://sentient-os.ai/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "Sentient OS.app"

  uninstall launchctl:  "jesai.Sentient-OS-macOS.WakeHelper",
            quit:       "jesai.Sentient-OS-macOS",
            login_item: "Sentient OS",
            delete:     "/Library/LaunchDaemons/jesai.Sentient-OS-macOS.WakeHelper.plist"

  zap trash: [
    "~/Library/Application Support/jesai.Sentient-OS-macOS",
    "~/Library/Caches/jesai.Sentient-OS-macOS",
    "~/Library/Caches/SentryCrash/Sentient OS",
    "~/Library/HTTPStorages/jesai.Sentient-OS-macOS",
    "~/Library/Preferences/jesai.Sentient-OS-macOS.plist",
    "~/Library/Saved Application State/jesai.Sentient-OS-macOS.savedState",
  ]
end
