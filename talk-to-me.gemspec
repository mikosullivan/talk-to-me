Gem::Specification.new do |spec|
	spec.name        = 'talk-to-me'
	spec.version     = '1.0'
	spec.date        = '2023-05-18'
	spec.summary     = 'Talk to me'
	spec.description = "Utilities for outputting information to the user"
	spec.authors     = ["Mike O'Sullivan"]
	spec.email       = 'mike@idocs.com'
	spec.homepage    = 'https://github.com/mikosullivan/talk-to-me'
	spec.license     = 'MIT'
	
	spec.files = [
		'lib/talk-to-me.rb',
		'README.md',
	];
	
	# spec.add_runtime_dependency 'text-table', ['>= 1.2.4']
	spec.add_runtime_dependency 'text-table', ['~> 1.2']
end