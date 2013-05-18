
name "ralph"
maintainer "Maciej Pasternacki <maciej@3ofcoins.net>"
homepage "https://github.com/3ofcoins/omnibus-ralph/"

replaces        "ralph"
install_path    "/opt/ralph"
build_version   Omnibus::BuildVersion.new.semver
build_iteration 1

dependency "preparation"
dependency "pyrun"

# ralph dependencies/components
# dependency "somedep"

# version manifest file
dependency "version-manifest"

exclude "\.git*"
exclude "bundler\/git"
