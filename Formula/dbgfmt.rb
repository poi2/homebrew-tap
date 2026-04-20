class Dbgfmt < Formula
  desc "Pretty-print Rust Debug trait output with proper indentation"
  homepage "https://github.com/poi2/dbgfmt"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/poi2/dbgfmt/releases/download/v0.3.0/dbgfmt-aarch64-apple-darwin.tar.xz"
      sha256 "3f7208024ea68d9394399387e20e3cf3993ab6c626e6bb5af0676bb6ff97a2a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/poi2/dbgfmt/releases/download/v0.3.0/dbgfmt-x86_64-apple-darwin.tar.xz"
      sha256 "7ffe387659c7db1853dcc472a9b153c512da0937a771cc550445a3623345a629"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/poi2/dbgfmt/releases/download/v0.3.0/dbgfmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d52df50a0784b7c3eadc86d50f3d3cd3acde641e8f8377e49560fced0cc9b5aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/poi2/dbgfmt/releases/download/v0.3.0/dbgfmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ee29760c64067e8999d24ae9aa06890a28aeb0e8933c95c97f79747fc0c8ba5d"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "dbgfmt"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "dbgfmt"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "dbgfmt"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "dbgfmt"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
