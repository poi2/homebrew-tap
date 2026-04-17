class Dbgfmt < Formula
  desc "Pretty-print Rust Debug trait output with proper indentation"
  homepage "https://github.com/poi2/dbgfmt"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/poi2/dbgfmt/releases/download/v0.1.0/dbgfmt-aarch64-apple-darwin.tar.xz"
      sha256 "a6b67e5dd3a50bd1f0b52aef7862d4468c7ff44fb9f9a1fc55cb56c708ac7cd9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/poi2/dbgfmt/releases/download/v0.1.0/dbgfmt-x86_64-apple-darwin.tar.xz"
      sha256 "eb308aaa9657e443f03cc76eb9499f605603a8d9e5d29140a161bf8679da0224"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/poi2/dbgfmt/releases/download/v0.1.0/dbgfmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b430e6177591fb25bc538741fc4577a8d24776546f53166754b291d5051536b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/poi2/dbgfmt/releases/download/v0.1.0/dbgfmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "05750afde454fa3f7e6dbbc0aa5d1087f19e39dfbc32710c0d11d8aab4e4a509"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "dbgfmt" if OS.mac? && Hardware::CPU.arm?
    bin.install "dbgfmt" if OS.mac? && Hardware::CPU.intel?
    bin.install "dbgfmt" if OS.linux? && Hardware::CPU.arm?
    bin.install "dbgfmt" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
