# typed: false
# frozen_string_literal: true

class ImAgentproc < Formula
  desc "IM-side runtime for the agentproc ecosystem — bridges IMs to coding CLIs"
  homepage "https://github.com/jeffkit/im-agentproc"
  url "https://static.crates.io/crates/im-agentproc/im-agentproc-0.1.1.crate"
  sha256 "e0b7963416c9f1f4862291d93f04ce7dcb8f29c3df4af4764847dbcdbcd66e04"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  # Im-agentproc is published to crates.io; bump together with the upstream crate.

  def install
    system "cargo", "install", *std_cargo_args
  end

  # brew services start jeffkit/tap/im-agentproc
  # Runs im-agentproc in manager mode; manages all bridge profiles automatically.
  service do
    run [opt_bin/"im-agentproc", "manager"]
    keep_alive true
    log_path var/"log/im-agentproc-manager.log"
    error_log_path var/"log/im-agentproc-manager-error.log"
    environment_variables(
      RUST_LOG: "info,im_agentproc=debug",
      HOME:     Dir.home,
      PATH:     "#{HOMEBREW_PREFIX}/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin",
    )
  end

  def caveats
    <<~EOS
      After starting the service, edit the LaunchAgent plist to set your Hub URL and admin token:
        #{Dir.home}/Library/LaunchAgents/homebrew.mxcl.im-agentproc.plist

      Required environment variables:
        WEIXIN_BASE_URL   → your Hub URL (e.g. http://your-server:8765)
        ILINK_ADMIN_TOKEN → admin token from Hub config

      Then restart the service:
        brew services restart jeffkit/tap/im-agentproc

      Bridge profiles and credentials are stored in:
        ~/.ilink-hub-bridge/profiles/
        ~/.ilink-hub-bridge/credentials/
    EOS
  end

  test do
    assert_match "im-agentproc", shell_output("#{bin}/im-agentproc --version")
  end
end
