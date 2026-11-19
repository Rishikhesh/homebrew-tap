cask "husky" do
  version "0.16.0"
  sha256 "f7021be02b4c46d3d68f217a8a0b275e89e520ec36a99dfcc92eb65ac4001fd5"

  url "https://github.com/Rishikhesh/husky/releases/download/v#{version}/Husky-#{version}.dmg"
  name "Husky"
  desc "Local dictation and meeting transcripts, with a listening orb"
  homepage "https://github.com/Rishikhesh/husky"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on :macos

  app "Husky.app"

  # signed with a developer certificate but not notarized: without this,
  # Gatekeeper refuses to open the downloaded app.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Husky.app"],
        writable_paths: ["{{appdir}}/Husky.app"]
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
