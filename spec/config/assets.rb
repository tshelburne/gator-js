assets_are_in "#{::Gator.root_path}/assets"

asset 'gator.js' do |a|
	a.scan 'scripts/coffee'
	a.toolchain :coffeescript, :require
end
