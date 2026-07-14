# typed: false
# frozen_string_literal: true

class IlinkHub < Formula
  desc "iLink-compatible multiplexer hub for WeChat ClawBot — connect one WeChat account to multiple AI agent backends"
  homepage "https://jeffkit.github.io/ilink-hub/"
  version "0.3.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.3.0/ilink-hub-macos-aarch64"
      sha256 "383d30af55601bcd38cb23dfc58d52dcee2f3eeec2f374a213c666277d949f6e"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.3.0/ilink-hub-bridge-macos-aarch64"
        sha256 "0a7da7589e3575c9e1cff651cc8e63a4c5ae8985dd8b55e7da35bc33472a2d94"
      end
    else
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.3.0/ilink-hub-macos-x86_64"
      sha256 "33dc3c6985a1f530c042bd483277e09d06fec14c80e93559d3f5ec7079cd6a16"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.3.0/ilink-hub-bridge-macos-x86_64"
        sha256 "02189d66700e6e85da12cf83db5a4cfd5d18e42436d6d8b9e6e6cd06bcc8916c"
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
