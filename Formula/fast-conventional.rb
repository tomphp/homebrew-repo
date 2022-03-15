class FastConventional < Formula
  desc "Make conventional commits, faster, and consistently name scopes"
  homepage "https://github.com/PurpleBooth/fast-conventional"
  url "https://github.com/PurpleBooth/fast-conventional/archive/v2.2.0.tar.gz"
  sha256 "700a0e055a036be4fa5fbd36f997956e42b6426f88fab903a928c346f717953d"

  bottle do
    root_url "https://github.com/PurpleBooth/homebrew-repo/releases/download/fast-conventional-2.2.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "24468ead5787dcbc8f53cb9b9e818d94a9b03a1253f8746163a73d192cfb2416"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "95f5d789cd410a051758f308355c0ac642caa5d61d4a39213ebf94b13b6c1343"
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
