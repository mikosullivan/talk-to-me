Gem::Specification.new do |spec|
	spec.name        = 'tatum'
	spec.version     = '1.0'
	spec.date        = '2023-05-18'
	spec.summary     = 'Tatum'
	spec.description = "Utilities for outputting information to the user"
	spec.authors     = ["Mike O'Sullivan"]
	spec.email       = 'mike@idocs.com'
	spec.homepage    = 'https://github.com/mikosullivan/tatum'
	spec.license     = 'MIT'
	
	spec.files = [
		'lib/tatum.rb',
		'README.md',
	];
	
	# spec.add_runtime_dependency 'text-table', ['>= 1.2.4']
	spec.add_runtime_dependency 'text-table', ['~> 1.2']
end