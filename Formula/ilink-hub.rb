# typed: false
# frozen_string_literal: true

class IlinkHub < Formula
  desc "iLink-compatible multiplexer hub for WeChat ClawBot — connect one WeChat account to multiple AI agent backends"
  homepage "https://jeffkit.github.io/ilink-hub/"
  version "0.1.16"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.16/ilink-hub-macos-aarch64"
      sha256 "05a375b3a35a5663753319164f769dbf0623ef50362632e00f7b6c7138fc6e95"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.16/ilink-hub-bridge-macos-aarch64"
        sha256 "c34181cf6bed316557c3594fd6611d359a0af6a0bed9914b39818059e1558ff7"
      end
    else
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.16/ilink-hub-macos-x86_64"
      sha256 "48cef674f08f112a8a95f07dff221a0c9c9546b9f6e4388e9ec64f0841aa36bc"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.16/ilink-hub-bridge-macos-x86_64"
        sha256 "14423ca9fb3af20720c88ba6a2ddb9145e77a0feec608b6fded7daf001d0b837"
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
