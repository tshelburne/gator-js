assets_are_in "#{::Gator.root_path}/assets"

asset 'gator.js' do |a|
	a.scan 'scripts/coffee'
	a.add_assets_from ::Cronus.keystone_compiler
	a.toolchain :coffeescript, :require
end
