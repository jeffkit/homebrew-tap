# typed: false
# frozen_string_literal: true

class IlinkHub < Formula
  desc "iLink-compatible multiplexer hub for WeChat ClawBot — connect one WeChat account to multiple AI agent backends"
  homepage "https://jeffkit.github.io/ilink-hub/"
  version "0.2.8"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/jeffkit/ilink-hub/releases/download/mac-latest/ilink-hub-macos-aarch64"
      sha256 "52a3f8dbaf8e0e9922b29889915fb4cb03b97b695bbf9c985a243e4a0f40f3a9"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/mac-latest/ilink-hub-bridge-macos-aarch64"
        sha256 "e1cdb940bb9163be2c3ec1eb9f77433fa34a57ededa16897fad958f8caf98782"
      end
    else
      url "https://github.com/jeffkit/ilink-hub/releases/download/mac-latest/ilink-hub-macos-x86_64"
      sha256 "35fb8e4eb26888f9b6ffc05021ea0627e76a530beec5de4358b00877e8bcaf95"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/mac-latest/ilink-hub-bridge-macos-x86_64"
        sha256 "be94306d485eab5c34351e88d4a62a3d8a24af11a9f6bf3ae91140807b6c7b4e"
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

  test do
    assert_match "ilink-hub", shell_output("#{bin}/ilink-hub --version")
    assert_match "ilink-hub-bridge", shell_output("#{bin}/ilink-hub-bridge --version")
  end
end
