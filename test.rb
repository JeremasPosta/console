require 'byebug'
require 'rspec/autorun'
require './lib/document'
require './lib/virtualdisk'
require './lib/user'
Dir['test/*.rb'].each { |file| load file }
