# typed: false
# frozen_string_literal: true

class IlinkHub < Formula
  desc "iLink-compatible multiplexer hub for WeChat ClawBot — connect one WeChat account to multiple AI agent backends"
  homepage "https://jeffkit.github.io/ilink-hub/"
  version "0.1.7"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.7/ilink-hub-macos-aarch64"
      sha256 "90db16bfbab00e7802ee3c913282dad2a1c8879c24ec813a931b9b3a3174c6ff"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.7/ilink-hub-bridge-macos-aarch64"
        sha256 "b08dd1450359d9a2442c40e6bb8499a3c1743084386283440ea9d2b1e239cb8c"
      end
    else
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.7/ilink-hub-macos-x86_64"
      sha256 "8f96bebd60cc43a03d03e32f6c1240d3b6b45bc49aada6314b7ba71f03e80848"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.7/ilink-hub-bridge-macos-x86_64"
        sha256 "ff1bea143c9d806b07ea2ed96b3072a32795d6dde0a91119f1c4ba37a749ed6a"
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
