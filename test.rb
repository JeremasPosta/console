require 'byebug'
require 'rspec/autorun'
require './lib/document'
require './lib/virtualdisk'
Dir['test/*.rb'].each { |file| load file }
