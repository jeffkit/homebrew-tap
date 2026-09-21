# typed: false
# frozen_string_literal: true

class Recursive < Formula
  desc "Self-improving Rust coding agent — LLM-driven, tool-using, MCP-aware"
  homepage "https://github.com/jeffkit/recursive"
  url "https://github.com/jeffkit/recursive/releases/download/v0.8.1/recursive-aarch64-apple-darwin.tar.gz"
  sha256 "d6809a432233178ff3e89e660e5ce697372cd35c20f57d548419ecd5461ce796"
  license "MIT"

  # Releases ship only the macOS arm64 binary: the upstream x86_64-apple-darwin
  # target was dropped because GitHub's macos-13 Intel runner pool was
  # chronically backlogged and cross-building x86_64 from the arm64
  # `macos-latest` runner needs extra cargo SDK config. The `odie` in
  # `def install` gives Intel-Mac users a clear message instead of an opaque
  # install error.
  depends_on :macos

  def install
    if Hardware::CPU.intel?
      odie <<~EOS
        Recursive does not provide a prebuilt x86_64 macOS binary (the
        upstream x86_64 darwin target is dropped — see the release notes).
        Build from source instead:

          brew install rustup-init && rustup-init
          cargo install recursive-cli --locked
      EOS
    end
    bin.install "recursive"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recursive --version")
  end
end
