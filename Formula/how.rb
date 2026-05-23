class How < Formula
  desc "Learn how to use CLI apps"
  homepage "https://github.com/jonahsnider/how"
  url "https://github.com/jonahsnider/how/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "faca2d781f74586cecfd7be158ffe9ffaac47a79c97fdc82df46d1f7bde596a9"
  license "Apache-2.0"

  depends_on "fish"

  def install
    fish_function.install Dir["functions/*.fish"]
    fish_completion.install "completions/how.fish"
    (share/"fish/vendor_conf.d").install "conf.d/how.fish"
  end

  test do
    system "#{Formula["fish"].bin}/fish", "-c", "how --help"
  end
end
