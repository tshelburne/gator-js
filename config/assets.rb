assets_are_in "#{::Gator.root_path}/assets"

asset 'gator.min.js' do |a|
	a.scan 'scripts/coffee'
	a.toolchain :coffeescript, :require
	a.post_build :closure
end
