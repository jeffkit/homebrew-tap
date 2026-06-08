# typed: false
# frozen_string_literal: true

class IlinkHub < Formula
 desc "iLink-compatible multiplexer hub for WeChat ClawBot — connect one WeChat account to multiple AI agent backends"
 homepage "https://jeffkit.github.io/ilink-hub/"
 version "0.1.12"
 license "MIT"

 on_macos do
 if Hardware::CPU.arm?
 url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.12/ilink-hub-macos-aarch64"
 sha256 "39020a3f82782b4f4cfe98c7cf3d204bdf3e364c255c9dd546444b9e4f7c2053"

 resource "ilink_hub_bridge" do
 url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.12/ilink-hub-bridge-macos-aarch64"
 sha256 "61cb500625062bb714c2484c41b83352267a2994bc356cf50562b2aaf00b379e"
 end
 else
 url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.12/ilink-hub-macos-x86_64"
 sha256 "a74d6024b34e899d18d508f46a386e044a78a20af385c5f9abf3525aa382e4da"

 resource "ilink_hub_bridge" do
 url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.12/ilink-hub-bridge-macos-x86_64"
 sha256 "ab80090f654d13d834325eaca58721c6a0dee5bfef2b6780f9261a3ec9fd9d08"
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
