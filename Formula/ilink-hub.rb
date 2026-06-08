# typed: false
# frozen_string_literal: true

class IlinkHub < Formula
 desc "iLink-compatible multiplexer hub for WeChat ClawBot — connect one WeChat account to multiple AI agent backends"
 homepage "https://jeffkit.github.io/ilink-hub/"
 version "0.1.11"
 license "MIT"

 on_macos do
 if Hardware::CPU.arm?
 url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.11/ilink-hub-macos-aarch64"
 sha256 "0cc4a02feb60dfa02d6023cd770a9f65fd22cae341347f15d9d982a371bbc5ce"

 resource "ilink_hub_bridge" do
 url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.11/ilink-hub-bridge-macos-aarch64"
 sha256 "a4733bb2cddc4347ba5f37ab68d460a6e2dc265fff9c51406823424816d6c18c"
 end
 else
 url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.11/ilink-hub-macos-x86_64"
 sha256 "ebcd68f67ad5831b414f70f5b07e7299c8cbbd203c4cc85681a75db9cbdaaa97"

 resource "ilink_hub_bridge" do
 url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.11/ilink-hub-bridge-macos-x86_64"
 sha256 "306abba21c512597d4eaafb01edc49615638378c6891bdda267213c9a6867b21"
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
