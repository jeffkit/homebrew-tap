# typed: false
# frozen_string_literal: true

class IlinkHub < Formula
  desc "iLink-compatible multiplexer hub for WeChat ClawBot — connect one WeChat account to multiple AI agent backends"
  homepage "https://jeffkit.github.io/ilink-hub/"
  version "0.1.20"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.20/ilink-hub-macos-aarch64"
      sha256 "c4f21bc2b4c41000aefc4806f15171d4974b8b80c7d7baf94f89894dee905fe9"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.20/ilink-hub-bridge-macos-aarch64"
        sha256 "7dd16ccf92370c7dda0e41fcf6d40b5540cd2dde94de00667c36225e74284088"
      end
    else
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.20/ilink-hub-macos-x86_64"
      sha256 "0b255a9abb360353a9dd3112ec1a0ad4accd73a6649a573841932642eaf2ae87"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.20/ilink-hub-bridge-macos-x86_64"
        sha256 "f0b80deb48fbfaff222f1f43a955c76d2b9a3c0ddfe3416bc73713820575928c"
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
