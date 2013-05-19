# Monkey-patch Omnibus to make it find software not only in
# omnibus-software gem, but also from all other gems that have
# config/software/*.rb files.
module ::Omnibus
  def self.omnibus_software_files
    Array( Gem::Specification.flat_map do |gem|
             Dir[ File.join(gem.gem_dir, "config/software/*.rb") ]
           end )
  end

  class Software
    def safe_name_from(name)
      name.gsub(':', '__')
    end

    def manifest_file_from_name(software_name)
      "#{build_dir}/#{safe_name_from(software_name)}.manifest"
    end

    def safe_name
      @safe_name ||= safe_name_from(@name)
    end

    def fetch_file
      "#{build_dir}/#{safe_name}.fetch"
    end

    def project_dir
      "#{source_dir}/#{@relative_path || safe_name}"
    end

    def inline(name=nil, &block)
      @inline ||= {}
      return @inline unless name

      # Create a child Software instance
      child = Software.new "name #{[self.name, name].join(':').inspect}",
                           @source_config,
                           project
      child.instance_eval(&block)
      child.instance_eval do
        build # <- this should not be necessary
        render_tasks
      end

      dependency child.name
      @inline[name] = child
    end
  end
end

# s3_access_key "something"
# s3_secret_key "something"
# s3_bucket "some-bucket"
# use_s3_caching true
# solaris_compiler "gcc"
