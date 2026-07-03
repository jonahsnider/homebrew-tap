cask "balatro-multiplayer" do
  version "1.0.18"
  sha256 "dbb8c635f3a30bca89bc835d061c0e44cb1da95238ca7ad67084ebb9450efa67"

  url "https://github.com/Balatro-Multiplayer/Balatro-Multiplayer-Launcher/releases/download/v#{version}/balatro-multiplayer-launcher.dmg",
      verified: "github.com/Balatro-Multiplayer/Balatro-Multiplayer-Launcher/"
  name "Balatro Multiplayer Launcher"
  desc "Official launcher for Balatro Multiplayer"
  homepage "https://balatromp.com/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  auto_updates true
  depends_on macos: :big_sur

  app "Balatro Multiplayer Launcher.app"

  zap trash: [
    "~/Library/Application Support/balatro-multiplayer-launcher",
    "~/Library/Logs/balatro-multiplayer-launcher",
    "~/Library/Preferences/com.balatromp.launcher.plist",
    "~/Library/Saved Application State/com.balatromp.launcher.savedState",
  ]
end
