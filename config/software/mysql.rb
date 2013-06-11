# Based on http://www.linuxfromscratch.org/blfs/view/svn/server/mysql.html
#
# Needs `cmake` to build, but not in target system.

name "mysql"
version "5.6.11"

dependency "libedit"
# dependency "libevent"
dependency "openssl"
dependency "zlib"

source :url => "http://cdn.mysql.com/Downloads/MySQL-5.6/#{name}-#{version}.tar.gz",
       :md5 => "9241be729964ab4594de11baa30aec48"

relative_path "#{name}-#{version}"

prefix="#{install_dir}/embedded"
libdir="#{prefix}/lib"

env = {
  "LDFLAGS" => "-L#{libdir} -Wl,-rpath,#{libdir}",
  "CPPFLAGS" => "-I#{prefix}/include",
  "LD_RUN_PATH" => libdir
}

cmake_options = [
  # "-DWITHOUT_SERVER=ON",
  "-DCMAKE_BUILD_TYPE=Release",
  "-DCMAKE_INSTALL_PREFIX=#{prefix}",
  "-DDEFAULT_CHARSET=utf8",
  "-DDEFAULT_COLLATION=utf8_general_ci",
  "-DWITH_EXTRA_CHARSETS=complex",
  # "-DWITH_LIBEVENT=system",
  "-DWITH_SSL=#{prefix}",
  "-DWITH_ZLIB=system",
  "-DZLIB_ROOT=#{prefix}"
]

build_dir = File.join(project_dir, '_build')

build do
  block do
    cmls_path = File.join(project_dir, 'CMakeLists.txt')
    cmls_lines = File.open(cmls_path).lines.
      reject { |ln| ln =~ /ADD_SUBDIRECTORY\((sql\/share|scripts)\)/ }
    lnum = cmls_lines.index { |ln| ln=~ /ADD_SUBDIRECTORY\(libmysql\)/ }
    cmls_lines.insert(lnum+1, "ADD_SUBDIRECTORY(sql/share)\nADD_SUBDIRECTORY(scripts)\n")
    File.write(cmls_path, cmls_lines.join)

    # http://bugs.mysql.com/bug.php?id=61699
    cmls_path = File.join(project_dir, 'libmysql', 'CMakeLists.txt')
    cmls_lines = Array(File.open(cmls_path).lines)
    lnum = cmls_lines.index("SET(CLIENT_API_FUNCTIONS\n")
    cmls_lines.insert(lnum, "IF (APPLE)\n   SET(CMAKE_INSTALL_NAME_DIR \"${CMAKE_INSTALL_PREFIX}/lib\")\nENDIF()\n")
    File.write(cmls_path, cmls_lines.join)

    FileUtils.mkdir_p build_dir
  end

  command "cmake #{cmake_options.join(' ')} ..", :cwd => build_dir, :env => env
  command "make", :cwd => build_dir, :env => env
  command "make install", :cwd => build_dir, :env => env
end
