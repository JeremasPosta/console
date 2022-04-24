require 'rspec/autorun'
require './console'
Dir['test/*.rb'].each { |file| load file }
