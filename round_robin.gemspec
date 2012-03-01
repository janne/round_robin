lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
Gem::Specification.new do |s|
  s.name        = "round_robin"
  s.version     = "1.0.0"
  s.authors     = ["Jan Andersson", "Kristian Hellquist"]
  s.email       = ["jan.andersson@gmail.com"]
  s.homepage    = "http://github.com/janne/round_robin"
  s.summary     = "Library and tasks to handle round robin style workers"
  s.description = ""
  s.has_rdoc    = false

  s.add_development_dependency "rspec"
 
  s.files        = Dir.glob("lib/**/*") + %w(LICENSE README.md)
end
