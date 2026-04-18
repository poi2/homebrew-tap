class Dbgfmt < Formula
  desc "Pretty-print Rust Debug trait output with proper indentation"
  homepage "https://github.com/poi2/dbgfmt"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/poi2/dbgfmt/releases/download/v0.2.0/dbgfmt-aarch64-apple-darwin.tar.xz"
      sha256 "f84c2ea352163a0c2f8d19efde7ea0d3f271fd02cc075a84b21c43ff78cfcb9f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/poi2/dbgfmt/releases/download/v0.2.0/dbgfmt-x86_64-apple-darwin.tar.xz"
      sha256 "0aca33a5f56cc85dd6bf3f43e2b40247842942b29c795b8d1ac58e15b414f6d1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/poi2/dbgfmt/releases/download/v0.2.0/dbgfmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d2d53d6fdedccb74678ba0baaa6912f938fa1f80df6843bc14875dd2bd318f73"
    end
    if Hardware::CPU.intel?
      url "https://github.com/poi2/dbgfmt/releases/download/v0.2.0/dbgfmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cfe6264a6371d8d0c5c7ea19c95b725e0cee179197893ca3796772a5e46cfe81"
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
