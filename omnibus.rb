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
    class Inline < Software
      def safe_name
        @safe_name ||= @name.gsub(':', '__')
      end

      def manifest_file
        manifest_file_from_name(safe_name)
      end

      def fetch_file
        "#{build_dir}/#{safe_name}.fetch"
      end

      def project_dir
        "#{source_dir}/#{@relative_path || safe_name}"
      end
    end

    def inline(name, &block)
      child = Inline.new "name #{[self.name, name].join(':').inspect}",
                         @source_config,
                         project
      child.instance_eval(&block)
      child.instance_eval do
        build # <- this should not be necessary
        render_tasks
      end
      dependency(child.name)
      (class << self ; self ; end).instance_eval do
        define_method(name.to_sym) { child }
      end
      child
    end
  end
end

# s3_access_key "something"
# s3_secret_key "something"
# s3_bucket "some-bucket"
# use_s3_caching true
# solaris_compiler "gcc"
