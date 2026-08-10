cask "audio-priority-bar" do
  version "1.2.1"
  sha256 "f29f23d8cfcb90765aa5716983254d8aa6ac3c725de87b3aed8614eef0873bc0"

  url "https://github.com/tobi/AudioPriorityBar/releases/download/v#{version}/AudioPriorityBar.zip"
  name "Audio Priority Bar"
  desc "Menu bar app that automatically manages audio device priorities"
  homepage "https://github.com/tobi/AudioPriorityBar"

  depends_on macos: :ventura

  app "AudioPriorityBar.app"
end
