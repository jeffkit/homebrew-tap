# typed: false
# frozen_string_literal: true

class Recursive < Formula
  desc "Self-improving Rust coding agent — LLM-driven, tool-using, MCP-aware"
  homepage "https://github.com/jeffkit/recursive"
  version "0.7.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/jeffkit/recursive/releases/download/v0.7.0/recursive-aarch64-apple-darwin.tar.gz"
      sha256 "130c941ad8b1edcf7ac93e9c8d007ab55203148ee74ead44a5f8184a685008ac"

      def install
        bin.install "recursive" => "recursive"
      end
    else
      odie <<~EOS
        Recursive 0.7.0 does not provide a prebuilt x86_64 macOS binary.
        The x86_64 darwin target was dropped in 0.7.0 because GitHub's
        macos-13 Intel runner pool was chronically backlogged (see the
        release notes). Build from source instead:

          cargo install recursive-cli --locked

        A darwin-universal (or x86_64) binary is planned for 0.7.1.
      EOS
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recursive --version")
  end
end
