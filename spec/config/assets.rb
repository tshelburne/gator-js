assets_are_in "#{::LIBRARY_NAME_UCASE.root_path}/assets"

asset 'gator.js' do |a|
	a.scan 'scripts/coffee'
	a.toolchain :coffeescript, :require
end
