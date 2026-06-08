# typed: false
# frozen_string_literal: true

class IlinkHub < Formula
  desc "iLink-compatible multiplexer hub for WeChat ClawBot — connect one WeChat account to multiple AI agent backends"
  homepage "https://jeffkit.github.io/ilink-hub/"
  version "0.1.17"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.17/ilink-hub-macos-aarch64"
      sha256 "959285241d273dc877f0bc02180247f98420a814596b1db7eb23422b072e34e1"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.17/ilink-hub-bridge-macos-aarch64"
        sha256 "0ca778b4b67e13927536a3616e5b5db43bdb1b75ed6ec9fcb60700f75ca78d8f"
      end
    else
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.17/ilink-hub-macos-x86_64"
      sha256 "d4c46899fae1fcf83dc83ed246b180f438d3e4f6ff1d1eff7bb5a97ca6f35c51"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.17/ilink-hub-bridge-macos-x86_64"
        sha256 "0994e7af7afbfd0251edce76e982b8f52ff8b63cde9b7150f13fc20b21288501"
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

  test do
    assert_match "ilink-hub", shell_output("#{bin}/ilink-hub --version")
    assert_match "ilink-hub-bridge", shell_output("#{bin}/ilink-hub-bridge --version")
  end
end
