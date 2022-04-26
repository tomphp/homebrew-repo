class FastConventional < Formula
  desc "Make conventional commits, faster, and consistently name scopes"
  homepage "https://github.com/PurpleBooth/fast-conventional"
  url "https://github.com/PurpleBooth/fast-conventional/archive/v2.2.5.tar.gz"
  sha256 "d65a0532ff0c254728d4c4857ba7b6ba4972ffce8b05e99338e6313c72dc5777"

  bottle do
    root_url "https://github.com/PurpleBooth/homebrew-repo/releases/download/fast-conventional-2.2.5"
    sha256 cellar: :any_skip_relocation, big_sur:      "f5a9291ecc2a29371ae19ec98b3ecd8a5335786a30bf55e2b20dac8ba5792804"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2fbb82189a2f25c27ed9553309690c62fb65315448537bc1edf9c205c1545351"
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build
  depends_on "socat" => :test
  depends_on "specdown/repo/specdown" => :test

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/fast-conventional", "completion", "bash")
    (bash_completion/"fast-conventional").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/fast-conventional", "completion", "zsh")
    (zsh_completion/"_fast-conventional").write output

    # Install fish completion
    output = Utils.safe_popen_read("#{bin}/fast-conventional", "completion", "fish")
    (fish_completion/"fast-conventional.fish").write output

    # Man pages
    output = Utils.safe_popen_read("help2man", "#{bin}/fast-conventional")
    (man1/"fast-conventional.1").write output
  end

  def caveats
    <<~EOS
      Update your git config to finish installation:
        $ git config --global alias.fci '-c "core.editor=fast-conventional editor" commit'
      To use it run
        $ git fci
      You may add any of the usual commit arguments
    EOS
  end

  test do
    system "#{bin}/fast-conventional", "-h"
    system "#{bin}/fast-conventional", "-V"
    system "specdown run --temporary-workspace-dir --add-path \"#{bin}\" \"#{prefix}\/README.md\""
  end
end
