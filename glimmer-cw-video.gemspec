# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: glimmer-cw-video 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "glimmer-cw-video".freeze
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Andy Maleh".freeze]
  s.date = "2020-09-19"
  s.description = "Glimmer video widget with basic functionality like play, pause, loop, and reload. Support mp4, webm, and ogg. Works with both local files and web URLs.".freeze
  s.email = "andy.am@gmail.com".freeze
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "CHANGELOG.md",
    "LICENSE.txt",
    "README.md",
    "VERSION",
    "lib/glimmer-cw-video.rb",
    "lib/views/glimmer/video.rb",
    "samples/launch",
    "samples/video/hello_looped_video_with_black_background.rb",
    "samples/video/hello_video.rb",
    "samples/video/hello_video_observers.rb",
    "samples/video/videos/Ants.mp4",
    "samples/video/videos/Blackpool_Timelapse.mp4",
    "samples/video/videos/Clouds_passing_by_CCBY_NatureClip.mp4"
  ]
  s.homepage = "http://github.com/AndyObtiva/glimmer-cw-video".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.6".freeze
  s.summary = "Glimmer Custom Widget - Video".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<glimmer-dsl-swt>.freeze, [">= 4.17.0.0", "< 5.0.0.0"])
      s.add_runtime_dependency(%q<glimmer-dsl-xml>.freeze, [">= 1.0.0", "< 2.0.0"])
      s.add_runtime_dependency(%q<glimmer-dsl-css>.freeze, [">= 1.0.0", "< 2.0.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
      s.add_development_dependency(%q<jeweler>.freeze, ["= 2.3.9"])
      s.add_development_dependency(%q<coveralls>.freeze, ["= 0.8.23"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.16.1"])
      s.add_development_dependency(%q<simplecov-lcov>.freeze, ["~> 0.7.0"])
      s.add_development_dependency(%q<glimmer-cw-video>.freeze, [">= 0"])
    else
      s.add_dependency(%q<glimmer-dsl-swt>.freeze, [">= 4.17.0.0", "< 5.0.0.0"])
      s.add_dependency(%q<glimmer-dsl-xml>.freeze, [">= 1.0.0", "< 2.0.0"])
      s.add_dependency(%q<glimmer-dsl-css>.freeze, [">= 1.0.0", "< 2.0.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
      s.add_dependency(%q<jeweler>.freeze, ["= 2.3.9"])
      s.add_dependency(%q<coveralls>.freeze, ["= 0.8.23"])
      s.add_dependency(%q<simplecov>.freeze, ["~> 0.16.1"])
      s.add_dependency(%q<simplecov-lcov>.freeze, ["~> 0.7.0"])
      s.add_dependency(%q<glimmer-cw-video>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<glimmer-dsl-swt>.freeze, [">= 4.17.0.0", "< 5.0.0.0"])
    s.add_dependency(%q<glimmer-dsl-xml>.freeze, [">= 1.0.0", "< 2.0.0"])
    s.add_dependency(%q<glimmer-dsl-css>.freeze, [">= 1.0.0", "< 2.0.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
    s.add_dependency(%q<jeweler>.freeze, ["= 2.3.9"])
    s.add_dependency(%q<coveralls>.freeze, ["= 0.8.23"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.16.1"])
    s.add_dependency(%q<simplecov-lcov>.freeze, ["~> 0.7.0"])
    s.add_dependency(%q<glimmer-cw-video>.freeze, [">= 0"])
  end
end

