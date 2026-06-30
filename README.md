# Jeff Kit's Homebrew Tap

Homebrew formulae for Jeff Kit's open source tools.

## Install

```bash
brew tap jeffkit/tap
brew install <formula>
```

## Formulae

| Formula | Description | Platforms |
|---------|-------------|-----------|
| `ilink-hub` | iLink-compatible multiplexer hub for WeChat ClawBot | macOS |
| `recursive` | Self-improving Rust coding agent (LLM-driven, tool-using, MCP-aware) | macOS (Apple Silicon) |

## `recursive`

A self-improving Rust coding agent — feeds transcripts back into goals,
runs an inner self-improve loop, and exposes LLM-tool use over MCP/HTTP.

- Source: <https://github.com/jeffkit/recursive>
- Currently ships **macOS arm64** binaries from
  [the official release](https://github.com/jeffkit/recursive/releases/latest).
  Intel-Mac users will see an `odie` message pointing at `cargo install
  recursive-cli --locked` (a darwin-universal / x86_64 build is planned
  for the 0.7.1 release).
