require "./lib/easy_find/version"

Gem::Specification.new do |s|
  s.name = "easy_find"
  s.version = EasyFind::VERSION
  s.executables << 'easy_find'
  s.platform = Gem::Platform::RUBY
  s.authors = ["Yi Wei"]
  s.email = ["yiwei.in.cyber@gmail.com"]
  s.summary = "A thin wrapper of *nix find command"
  s.description = s.summary
  s.files = Dir.glob("lib/**/*") + %w(README.md LICENSE Rakefile)
  s.require_path = "lib"
end

