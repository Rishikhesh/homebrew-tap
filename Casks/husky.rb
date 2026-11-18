cask "husky" do
  version "0.15.0"
  sha256 "a79fc2c7561125522eefec1b60176e3d725ae8e9fddfafc8c2f0105212ac59b4"

  url "https://github.com/Rishikhesh/husky/releases/download/v#{version}/Husky-#{version}.dmg"
  name "Husky"
  desc "Local dictation and meeting transcripts, with a listening orb"
  homepage "https://github.com/Rishikhesh/husky"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64

  app "Husky.app"

  # signed with a developer certificate but not notarized: without this,
  # Gatekeeper refuses to open the downloaded app.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Husky.app"]
  end

  uninstall quit: "com.rishikhesh.husky"

  zap trash: [
    "~/Library/Application Support/Husky",
    "~/Library/Preferences/com.rishikhesh.husky.plist",
  ]

  caveats <<~EOS
    Husky lives in your menu bar as an orb. Setup asks for the microphone and
    Accessibility, then downloads its speech model: ~460 MB for dictation,
    ~2.9 GB more if you also turn on meetings.
  EOS
end
