require 'optparse'
require './lib/document'
require 'byebug'

params = {}

OptionParser.new do |parser|
  parser.on("-e=s", "--email", "Your email address")
  parser.on("-u=s", "--user", "Your username")
end.parse!(into: params)

loop do
  print "#{params[:user]}@#{Document.location.whereami}/> "
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
    puts Document.location.create_folder input.first

  when 'cd'
    input.each do |dir|
      Document.location.cd dir
    end

  when 'destroy'
   puts Document.destroy input.first

  when 'ls'
    puts Document.location.listing

  when 'seed'
    Document.new('archivo1', 'contenido1')
    Document.new('archivo2', 'contenido2')
    Document.location.create_folder 'carpeta1'
    Document.location.create_folder 'carpeta2'
    Document.location.create_folder 'carpeta2'
    Document.new('archivo3', 'contenido3')
    Document.new('archivo4', 'contenido4')
    Document.location.create_folder 'carpeta2'
    Document.location.cd '..'
    Document.location.cd '..'
    Document.new('archivo5', 'contenido5')
    Document.new('archivo6', 'contenido6')
    Document.location.cd '..'
    Document.location.cd '..'

  else
    next
  end
end
