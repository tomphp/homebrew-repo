class GitMit < Formula
  desc "Minimalist set of hooks to aid pairing and link commits to issues"
  homepage "https://github.com/PurpleBooth/git-mit"
  url "https://github.com/PurpleBooth/git-mit/archive/v5.12.14.tar.gz"
  sha256 "d0745fb43e246c6e8fdf70b4f1811ac366d88a36d1f0ff6454aaf6b84fccc465"

  bottle do
    root_url "https://github.com/PurpleBooth/homebrew-repo/releases/download/git-mit-5.12.14"
    sha256 cellar: :any,                 big_sur:      "7e444e142b614a591c9e1d5f8afcf04c09302e79e2b69c36630f1392f75a1268"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4d6977b39784b892be911c76b920e4a846d1191e32fe223840b744d8a0931821"
  end
  depends_on "help2man" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"
  on_linux do
    depends_on "libxcb"
    depends_on "libxkbcommon"
  end

  def install
    %w[
      mit-commit-msg
      mit-pre-commit
      mit-prepare-commit-msg
      git-mit
      git-mit-config
      git-mit-relates-to
      git-mit-install
    ].each do |binary|
      # Build binary
      system "cargo", "install", "--root", prefix, "--path", "./#{binary}/"

      # Completions
      output = Utils.safe_popen_read("#{bin}/#{binary}", "--completion", "bash")
      (bash_completion/binary.to_s).write output
      output = Utils.safe_popen_read("#{bin}/#{binary}", "--completion", "zsh")
      (zsh_completion/binary.to_s).write output
      output = Utils.safe_popen_read("#{bin}/#{binary}", "--completion", "fish")
      (fish_completion/binary.to_s).write output

      # Man pages
      output = Utils.safe_popen_read("help2man", "#{bin}/#{binary}")
      (man1/"#{binary}.1").write output
    end
  end

  def caveats
    <<~EOS
      Update your git config to finish installation:
        # Install into existing repository
        $ git mit-install
        # Install into all new repositories
        $ git mit-install --scope=global
    EOS
  end

  test do
    system "git", "init", testpath
    system "#{bin}/git-mit-install"
    output = Utils.popen_read("#{bin}/git-mit-config", "mit", "example")
    (testpath/"git-mit.toml").write output
    system "#{bin}/git-mit", "-c", "git-mit.toml", "se"
    system "git-mit-relates-to", "#12356"
    system "git", "add", testpath
    system "git", "commit", "-m", "Example Commit"
    system "#{bin}/git-mit-config", "lint", "available"
  end
end
