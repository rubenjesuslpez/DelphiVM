
__END__ # experimental

class Tt < Thor
	include Thor::Actions

	class BaseGen < Thor::Group
		include Thor::Actions
		include PathMethods.extension
		add_runtime_options!

		def self.source_root
			GEM_ROOT
		end
		
	private

  		def _idever_path
			options[:idever].to_s
		end

		def _root_path
			Dir.pwd
		end

		def _idefolder_path
			IDEServices.ide_folde(options[:idever])
		end
	end

	class AppGen < BaseGen
		argument :name, aliases: '-n', type: :string, desc: "app name to be executed"
		def create_app
			@prj_slug = name.to_s.camelize
	 		directory(templates_newapp_path(rel: true), root_path + @prj_slug)
			inside root_path + @prj_slug do
				invoke(SamplesGen, [], options) if options[:samples]
				invoke(TestGen, [], options) if options[:test]
			end
		end
	end

	class SamplesGen < BaseGen
		def create_samples
 			directory(templates_samples_path(rel: true), samples_path)
		end
	end

	class TestGen < BaseGen
		def create_test
 			directory(templates_test_path(rel: true), test_path)
		end
	end

	class IdeGen < BaseGen
		def create_ide_folder
 			say src_idefolder_path
		end
	end

	desc "app IDE", "generate app"
	method_option :samples, type: :boolean, default: true, desc: "include samples"
	method_option :test, type: :boolean, default: true, desc: "include tests"
	method_option :idever, type: :string, default: IDEServices.default_ide, desc: "IDE version"
	def app(name)
		puts "app #{name} for #{options[:idever]}"
		invoke(AppGen, [name], options)
	end
end

