require 'optparse'
require './lib/document'

params = {}

OptionParser.new do |parser|
  parser.on("-e=s", "--email", "Your email address")
  parser.on("-u=s", "--user", "Your username")
end.parse!(into: params)

loop do
  print "#{params[:user]}@~: "
  input = gets.chomp.split
  command = input.slice!(0)&.downcase

  case command
    when 'exit', 'quit'
      exit

    when 'create_file', 'cf'
      Document.new(input[0], input[1])

    when 'show'
      puts Document.location.gimme_a_file input[0]

    when 'cls', 'clear'
      system('clear') || system('cls')

    else
      next
  end
end
