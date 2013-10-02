require "keystone"

module LIBRARY_NAME_UCASE
	
	def self.pipeline
		@@pipeline ||= ::Keystone.bootstrap("#{root_path}/config/assets.rb")
	end

	def self.keystone_compiler
		@@keystone_compiler ||= pipeline.compiler("gator.js")
	end

	def self.root_path
		File.expand_path("#{File.dirname(__FILE__)}/../../")
	end

end
