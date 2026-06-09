# typed: false
# frozen_string_literal: true

class IlinkHub < Formula
  desc "iLink-compatible multiplexer hub for WeChat ClawBot — connect one WeChat account to multiple AI agent backends"
  homepage "https://jeffkit.github.io/ilink-hub/"
  version "0.1.19"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.19/ilink-hub-macos-aarch64"
      sha256 "6bf3a754947647e0b728a993b22eccf693c43cc82c80c04ae425cc58e3e7b58c"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.19/ilink-hub-bridge-macos-aarch64"
        sha256 "294dc764a222ca683e9f9892abe0930e563d4e02634cf6f015b7942e1e4e364b"
      end
    else
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.19/ilink-hub-macos-x86_64"
      sha256 "9e9d8958acd11b802663ec7b90da160c2cef89f28f24739a13231bb7f6fc7f30"

      resource "ilink_hub_bridge" do
        url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.19/ilink-hub-bridge-macos-x86_64"
        sha256 "8fdadc563678c270c88847416c03fe1f5ab68809042aa3855d71ac40e1ee8ad2"
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
