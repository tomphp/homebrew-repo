class SetupAKeyringForSops < Formula
  desc "Use gcloud to setup everything needed for SOPS"
  homepage "https://github.com/PurpleBooth/setup-a-keyring-for-sops"
  url "https://github.com/PurpleBooth/setup-a-keyring-for-sops/archive/refs/tags/v0.42.31.tar.gz"
  sha256 "11d280d4c0136092fd520267196fb8a14db31fe44c9c5e7bb110bd07bb37d36c"

  bottle do
    root_url "https://github.com/PurpleBooth/homebrew-repo/releases/download/setup-a-keyring-for-sops-0.42.31"
    sha256 cellar: :any_skip_relocation, big_sur:      "e70da87a741b071295f1f6d11ebce257c33cc2ba429c5e8925a99d38a8fd8c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "62879f2d4b8dd8697df68fbdaeca55c2f07a349f5a57440bc735322a7df087a3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  def caveats
    <<~EOS
      At runtime, gcloud must be accessible from your PATH.
      You can install gcloud from Homebrew Cask:
        brew install google-cloud-sdk
    EOS
  end

  test do
    system "#{bin}/setup-a-keyring-for-sops", "-h"
    system "#{bin}/setup-a-keyring-for-sops", "-V"
  end
end
