# typed: false
# frozen_string_literal: true

class IlinkHub < Formula
  desc "iLink-compatible multiplexer hub for WeChat ClawBot — connect one WeChat account to multiple AI agent backends"
  homepage "https://jeffkit.github.io/ilink-hub/"
  version "0.1.5"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.5/ilink-hub-macos-aarch64"
      sha256 "966c60d67392864ffa7f70ffd060a331523192cb051f34b427afc2d8d4146678"
    else
      url "https://github.com/jeffkit/ilink-hub/releases/download/v0.1.5/ilink-hub-macos-x86_64"
      sha256 "8419c2ecd0a1389f2c969ede47d98f9f3a6c874df70e5c34caf27bd3b077f610"
    end
  end

  def install
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "ilink-hub-macos-aarch64" => "ilink-hub"
      else
        bin.install "ilink-hub-macos-x86_64" => "ilink-hub"
      end
    end
  end

  test do
    assert_match "ilink-hub", shell_output("#{bin}/ilink-hub --version")
  end
end
