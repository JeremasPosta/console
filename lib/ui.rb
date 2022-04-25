require './lib/virtualdisk'
require './lib/document'
require './lib/user'
require 'optparse'
require 'byebug'

module Ui
  @params = {}

  def self.login
    User.start
    unless (@params[:user] || @params[:password])
      puts '> You can create your user now, login, or provide your credentials when starting Console.rb next time.'
      signup
    end
    unless User.validate_password(@params[:user].to_sym, @params[:password])
      puts '> Bad credentials, please reenter to Login or Signup.'
      signup
    end
  end

  def self.signup
    print '>> Username: '
    @params[:user] = gets.chomp

    print '>> Password: '
    @params[:password] = gets.chomp

    User.new @params[:user], @params[:password]
    User.greet @params[:user].capitalize
    login
  end

  def self.start
    OptionParser.new do |parser|
      parser.on("-u = 'example'", "--user", "Your username")
      parser.on("-k = 'example_pwd'", "--password", "Your password")
      parser.on("-p = 'file'", "--persisted", "Your virtual disk filename, without extension")
    end.parse!(into: @params)
    login

    @params[:persisted] && Document.location.mount(@params[:persisted])

    loop do
      print "#{@params[:user]}@#{Document.location.whereami}/> "
      input = gets.chomp.split
      command = input.slice!(0)&.downcase

      case command
      when 'exit', 'quit'
        if @params[:persisted]
          Document.location.dump @params[:persisted]
        end
        puts 'Bye!'
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

      when 'mount'
        Document.location.mount input.first

      when 'dump'
        Document.location.dump input.first

      when 'ruby'
        eval input.join(' ')

      when 'whoami'
        puts @params[:user]

      when 'seed'
        Document.new('archivo1', 'contenido1')
        Document.new('archivo2', 'contenido2')
        Document.location.create_folder 'carpeta1'
        Document.location.create_folder 'carpeta2'
        Document.location.create_folder 'carpeta3'
        Document.new('archivo3', 'contenido3')
        Document.new('archivo4', 'contenido4')
        Document.location.create_folder 'carpeta4'
        Document.new('archivo7', 'contenido7')
        Document.location.cd '..'
        Document.location.cd '..'
        Document.new('archivo5', 'contenido5')
        Document.new('archivo6', 'contenido6')
        Document.location.cd '..'
        Document.location.cd '..'

      when 'whereami'
        puts '/' + Document.location.whereami

      when 'whoami'
        puts @params[:user]

      else
        next
      end
    end
  end
end
