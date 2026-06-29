# typed: false
# frozen_string_literal: true

class IlinkHub < Formula
  desc "iLink-compatible multiplexer hub for WeChat ClawBot — connect one WeChat account to multiple AI agent backends"
  homepage "https://jeffkit.github.io/ilink-hub/"
  version "0.2.8-mac"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.2.8-mac/ilink-hub-macos-aarch64"
      sha256 "52a3f8dbaf8e0e9922b29889915fb4cb03b97b695bbf9c985a243e4a0f40f3a9"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.2.8-mac/ilink-hub-bridge-macos-aarch64"
        sha256 "e1cdb940bb9163be2c3ec1eb9f77433fa34a57ededa16897fad958f8caf98782"
      end
    else
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.2.8-mac/ilink-hub-macos-x86_64"
      sha256 "9adf18f5ef1f31d553f840d578c2ce675e58befcd2b5027b13ca4403f3158d42"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.2.8-mac/ilink-hub-bridge-macos-x86_64"
        sha256 "9489086a9049c4fdad9ca4716536f9807426f508f1067d4895b22baba0e83b86"
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ilink-hub-macos-aarch64" => "ilink-hub"
      resource("ilink_hub_bridge").stage do
        bin.install "ilink-hub-bridge-macos-aarch64" => "ilink-hub-bridge"
      end
    elsif OS.mac?
      bin.install "ilink-hub-macos-x86_64" => "ilink-hub"
      resource("ilink_hub_bridge").stage do
        bin.install "ilink-hub-bridge-macos-x86_64" => "ilink-hub-bridge"
      end
    end
  end

  # brew services start jeffkit/tap/ilink-hub
  # Runs ilink-hub-bridge in manager mode; manages all bridge profiles automatically.
  #
  # Required after install:
  #   Edit ~/Library/LaunchAgents/homebrew.mxcl.ilink-hub.plist and add:
  #     WEIXIN_BASE_URL  → your Hub URL (e.g. http://your-server:8765)
  #     ILINK_ADMIN_TOKEN → admin token from Hub config
  service do
    run [opt_bin/"ilink-hub-bridge", "manager"]
    keep_alive true
    log_path var/"log/ilink-hub-bridge-manager.log"
    error_log_path var/"log/ilink-hub-bridge-manager-error.log"
    environment_variables(
      RUST_LOG:        "info,ilink_hub_bridge=debug",
      HOME:            Dir.home,
      WEIXIN_BASE_URL: "http://your-hub-server:8765",
      PATH:            "#{HOMEBREW_PREFIX}/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"
    )
  end

  def caveats
    <<~EOS
      After starting the service, edit the LaunchAgent plist to set your Hub URL and admin token:
        #{Dir.home}/Library/LaunchAgents/homebrew.mxcl.ilink-hub.plist

      Required environment variables:
        WEIXIN_BASE_URL   → your Hub URL (e.g. http://your-server:8765)
        ILINK_ADMIN_TOKEN → admin token from Hub config

      Then restart the service:
        brew services restart jeffkit/tap/ilink-hub

      Bridge profiles and credentials are stored in:
        ~/.ilink-hub-bridge/profiles/
        ~/.ilink-hub-bridge/credentials/
    EOS
  end

  test do
    assert_match "ilink-hub", shell_output("#{bin}/ilink-hub --version")
    assert_match "ilink-hub-bridge", shell_output("#{bin}/ilink-hub-bridge --version")
  end
end
