# typed: false
# frozen_string_literal: true

class IlinkHub < Formula
  desc "iLink-compatible multiplexer hub for WeChat ClawBot — connect one WeChat account to multiple AI agent backends"
  homepage "https://jeffkit.github.io/ilink-hub/"
  version "0.2.6"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.2.6/ilink-hub-macos-aarch64"
      sha256 "472b24faac539e9f0ec93cf4103d4da6c046edcd3f84e96c9a1b655ad567a594"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.2.6/ilink-hub-bridge-macos-aarch64"
        sha256 "08c6143c3db00f546b3968b1230da99b87c5752dc66bf57ae5413c53f53a7398"
      end
    else
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.2.6/ilink-hub-macos-x86_64"
      sha256 "15b968cd8f225c17839cb98385e1dd36f25ac3264ca5eb5fc1c6cb8c8cee9382"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.2.6/ilink-hub-bridge-macos-x86_64"
        sha256 "984f467507c035483c351499e92b549e9d91d395e4a9927f50528ce39d7e1536"
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
