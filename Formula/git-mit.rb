class GitMit < Formula
  desc "Minimalist set of hooks to aid pairing and link commits to issues"
  homepage "https://github.com/PurpleBooth/git-mit"
  url "https://github.com/PurpleBooth/git-mit/archive/v5.12.20.tar.gz"
  sha256 "64850e98680ce08d5bd97a369312c50a25b674025c4890ebfef16b125c573864"

  bottle do
    root_url "https://github.com/PurpleBooth/homebrew-repo/releases/download/git-mit-5.12.20"
    sha256 cellar: :any,                 big_sur:      "f7473758832abe91d0c501cbfcba309300d638ee56b14525f4ee238de0fd6c56"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "69922499829cfbbd3d8a9b492d58851033fe82d6e8096325773e4e87966d2967"
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
