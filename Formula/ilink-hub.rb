# typed: false
# frozen_string_literal: true

# ilink-hub formula — Hub service only.
# The bridge (formerly ilink-hub-bridge) now ships from the separate
# jeffkit/im-agentproc repository / its own formula.
class IlinkHub < Formula
  desc "iLink-compatible multiplexer hub for WeChat ClawBot — connect one WeChat account to multiple AI agent backends"
  homepage "https://jeffkit.github.io/ilink-hub/"
  version "0.4.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.4.0/ilink-hub-macos-aarch64"
      sha256 "5857e7ae1d2ff882824453aa7299a85f3835984fec8cd94bbf3318208f346990"
    else
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.4.0/ilink-hub-macos-x86_64"
      sha256 "a11c31ad40b761d2f2b586296cc226be43d7b7f6847704dd4432a5214dcd731a"
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ilink-hub-macos-aarch64" => "ilink-hub"
    elsif OS.mac?
      bin.install "ilink-hub-macos-x86_64" => "ilink-hub"
    end
  end

  test do
    assert_match "ilink-hub", shell_output("#{bin}/ilink-hub --version")
  end
end
