# typed: false
# frozen_string_literal: true

class IlinkHub < Formula
 desc "iLink-compatible multiplexer hub for WeChat ClawBot — connect one WeChat account to multiple AI agent backends"
 homepage "https://jeffkit.github.io/ilink-hub/"
 version "0.1.8"
 license "MIT"

 on_macos do
 if Hardware::CPU.arm?
 url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.8/ilink-hub-macos-aarch64"
 sha256 "ce463ccd042620b4065c91db15ce20be57a8934cdab87b12599f686cf712a1ea"

 resource "ilink_hub_bridge" do
 url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.8/ilink-hub-bridge-macos-aarch64"
 sha256 "735e6bf08a95edb46ecc7d4ed525b9c4c810ae7fca8b4a6cf9eb51b20ca73eca"
 end
 else
 url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.8/ilink-hub-macos-x86_64"
 sha256 "f95bc88f3f17e1c3edbf7828e0eecb518dcaab03a614520ce72058cc32d3551c"

 resource "ilink_hub_bridge" do
 url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.8/ilink-hub-bridge-macos-x86_64"
 sha256 "c623f617a071ed86893cbb3c380f95ec7681b32e7305ab3727d3dc3ce0863a30"
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
