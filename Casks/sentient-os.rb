cask "sentient-os" do
  version "1.5"
  sha256 "383f7afa6bf07d2829ad290814882533ccf59fffbe8ac3d8a344b4dd0336c68b"

  url "https://github.com/Sentient-OS-Labs/sentient-os/releases/download/#{version}/SentientOS-#{version}.dmg"
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
