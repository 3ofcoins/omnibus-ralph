
name "ralph"
maintainer "Maciej Pasternacki <maciej@3ofcoins.net>"
homepage "https://github.com/3ofcoins/omnibus-ralph/"

replaces        "ralph"
install_path    "/opt/ralph"
build_version   Omnibus::BuildVersion.new.semver
build_iteration 1

dependency "preparation"

dependency "chef-gem"           # for embedded chef-solo
dependency "runit"
# dependency "redis"
dependency "nginx"
# mysql?

dependency "ralph"

# version manifest file
dependency "version-manifest"

exclude "\.git*"
exclude "bundler\/git"
