# typed: false
# frozen_string_literal: true

class IlinkHub < Formula
  desc "iLink-compatible multiplexer hub for WeChat ClawBot — connect one WeChat account to multiple AI agent backends"
  homepage "https://jeffkit.github.io/ilink-hub/"
  version "0.1.15"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.15/ilink-hub-macos-aarch64"
      sha256 "c15fd2d2614492cc07d5de85d7e56926a94ad19f4ae21b81685836f8bdd00906"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.15/ilink-hub-bridge-macos-aarch64"
        sha256 "e83a5723474c54c80f22c706a5d2ab7c2aba83527638074a41451260f27b0868"
      end
    else
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.15/ilink-hub-macos-x86_64"
      sha256 "e912cfa2337b75f2790b65dc6353b193484f9cdd835a8b8123e321e5920ed5ff"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.15/ilink-hub-bridge-macos-x86_64"
        sha256 "cc6e779135cbf8850560f802f76bb521d3565d47ddb5b87e3dc2d0118b77e14b"
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
