name "freetype"
version "2.4.12"

source :url => "http://downloads.sourceforge.net/project/freetype/freetype2/#{version}/freetype-#{version}.tar.bz2",
       :md5 => "3463102764315eb86c0d3c2e1f3ffb7d"

relative_path "freetype-#{version}"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib",
  "CPPFLAGS" => "-I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  command "./configure --prefix=#{install_dir}/embedded", :env => env
  command "make -j #{max_build_jobs}", :env => env
  command "make install"
end
