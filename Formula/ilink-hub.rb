# typed: false
# frozen_string_literal: true

class IlinkHub < Formula
 desc "iLink-compatible multiplexer hub for WeChat ClawBot — connect one WeChat account to multiple AI agent backends"
 homepage "https://jeffkit.github.io/ilink-hub/"
 version "0.1.9"
 license "MIT"

 on_macos do
 if Hardware::CPU.arm?
 url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.9/ilink-hub-macos-aarch64"
 sha256 "494d1f051fd670c843456991bf5b185276f6c3f7795fb2b1c7d99db8f6342cb4"

 resource "ilink_hub_bridge" do
 url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.9/ilink-hub-bridge-macos-aarch64"
 sha256 "4f2e6726aac0e1797fc166a555860e422ea79beb4c5035964199635cd822f365"
 end
 else
 url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.9/ilink-hub-macos-x86_64"
 sha256 "e8fe7171b9c4b0aaa835607beec0654249c2a3bf5c3e058c20d8da1b80aa0a45"

 resource "ilink_hub_bridge" do
 url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.9/ilink-hub-bridge-macos-x86_64"
 sha256 "a985e82adb626d89ba9567e4303c311f8bed69ed257aba39f530f3b582e7e9e0"
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
