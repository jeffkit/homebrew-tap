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
  # chronically backlogged (see the release notes for v0.7.0). Intel-Mac
  # users get an `odie` message pointing at `cargo install recursive-cli`
  # until a darwin-universal / x86_64 binary lands in 0.7.1.
  depends_on :macos
  fails_on :intel

  def install
    bin.install "recursive"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recursive --version")
  end
end
