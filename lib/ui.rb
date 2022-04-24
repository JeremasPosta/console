require 'optparse'
require './lib/document'

params = {}

OptionParser.new do |parser|
  parser.on("-e=s", "--email", "Your email address")
  parser.on("-u=s", "--user", "Your username")
end.parse!(into: params)

drive = VirtualDisk.new 'C:'
loop do
  print "#{params[:user]}@#{drive.whereami}/> "
  input = gets.chomp.split
  command = input.slice!(0)&.downcase

  case command
  when 'exit', 'quit'
    exit

  when 'create_file', 'touch'
    Document.new(*input)

  when 'show'
    content = Document.location.gimme_a_file(input.first)
    puts content unless content.nil?

  when 'cls', 'clear'
    system('clear') || system('cls')

  when 'metadata'
    puts Document.location.gimme_a_file(input.first, 'metadata')

  when 'create_folder', 'mkdir'
    drive.create_folder input.first

  when 'cd'
    drive.cd input.first

  when 'destroy'
   puts Document.destroy input.first

  else
    next
  end
end
