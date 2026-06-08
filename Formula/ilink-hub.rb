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
      sha256 "943f35cda38b083c02884e109a57c75af73db7785740d505d070409bce852478"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.17/ilink-hub-bridge-macos-aarch64"
        sha256 "ad4ce327e25574937bb8eca4dab6ee677f4a2921efda46b96792e1cf419cc236"
      end
    else
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.17/ilink-hub-macos-x86_64"
      sha256 "d3d12e7e4957488d836146319175eac6bc40af03a0f8564a13c36da099cec716"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.17/ilink-hub-bridge-macos-x86_64"
        sha256 "679faf7be61db4792115ce638d4dcb2be51a7c6b6aaea41ecfe2af1c6e717cd9"
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
