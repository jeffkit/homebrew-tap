# typed: false
# frozen_string_literal: true

class Recursive < Formula
  desc "Self-improving Rust coding agent — LLM-driven, tool-using, MCP-aware"
  homepage "https://github.com/jeffkit/recursive"
  url "https://github.com/jeffkit/recursive/releases/download/v0.7.0/recursive-aarch64-apple-darwin.tar.gz"
  sha256 "130c941ad8b1edcf7ac93e9c8d007ab55203148ee74ead44a5f8184a685008ac"
  license "MIT"

  # 0.7.0 ships only the macOS arm64 binary: the upstream x86_64-apple-darwin
  # target was dropped because GitHub's macos-13 Intel runner pool was
  # chronically backlogged (see the release notes for v0.7.0). The `odie` in
  # `def install` gives Intel-Mac users a clear message instead of an opaque
  # install error. A darwin-universal / x86_64 binary is planned for 0.7.1.
  depends_on :macos

  def install
    if Hardware::CPU.intel?
      odie <<~EOS
        Recursive 0.7.0 does not provide a prebuilt x86_64 macOS binary
        (the upstream x86_64 darwin target was dropped — see the 0.7.0
        release notes). Build from source instead:

          brew install rustup-init && rustup-init
          cargo install recursive-cli --locked

        A darwin-universal / x86_64 binary is planned for 0.7.1.
      EOS
    end
    bin.install "recursive"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recursive --version")
  end
end
