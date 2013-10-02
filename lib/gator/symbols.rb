require "keystone"

module Gator
	
	def self.pipeline
		@@pipeline ||= ::Keystone.bootstrap("#{root_path}/config/assets.rb")
	end

	def self.keystone_compiler
		@@keystone_compiler ||= pipeline.compiler("gator.min.js")
	end

	def self.root_path
		File.expand_path("#{File.dirname(__FILE__)}/../../")
	end

end
