# typed: false
# frozen_string_literal: true

class IlinkHub < Formula
  desc "iLink-compatible multiplexer hub for WeChat ClawBot — connect one WeChat account to multiple AI agent backends"
  homepage "https://jeffkit.github.io/ilink-hub/"
  version "0.1.14"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.14/ilink-hub-macos-aarch64"
      sha256 "8d550906243b79b8895dd9999b28dbda02f722fc847da9ffa4fbbb60f72c5323"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.14/ilink-hub-bridge-macos-aarch64"
        sha256 "c85133a387f15c2f621dc8932259a0993bf36ab9b1ef1c85163cca08960b779c"
      end
    else
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.14/ilink-hub-macos-x86_64"
      sha256 "49fbca6e47dddff0e103cc72785f1172537d9d0498e29e057c9c37acf914b94a"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.14/ilink-hub-bridge-macos-x86_64"
        sha256 "48d14eca4cb614feefd7cf7c8c5e30968534b1ab64e22d429333fd7d86a6f023"
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
