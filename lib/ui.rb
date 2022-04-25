require './lib/virtualdisk'
require './lib/document'
require './lib/user'
require 'optparse'
require 'byebug'

module Ui
  @params = {}

  def self.start
    console_init
    login
    navigator
  end

  def self.login
    User.start
    unless (@params[:user] || @params[:password])
      puts User::MESSAGES[:initial]
      signup
    end
    unless User.validate_password(@params[:user].to_sym, @params[:password])
      puts User::MESSAGES[:bad_credentials]
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

  def self.console_init
    OptionParser.new do |parser|
      parser.on("-u = 'example'", '--user', 'Your username')
      parser.on("-k = 'example_pwd'", '--password', 'Your password')
      parser.on("-p = 'fileName'", '--persisted', 'Your virtual disk filename, without extension')
    end.parse!(into: @params)
    persisted?
  end

  def self.persisted?(action = :mount)
    if @params[:persisted]
      Document.location.mount(@params[:persisted]) if action == :mount
      Document.location.dump(@params[:persisted]) if action == :dump
    end
  end

  def self.prompt
    print "#{@params[:user]}@#{Document.location.whereami}/> "
    user_input = gets.chomp.split
    [user_input.slice!(0)&.downcase, user_input]
  end

  def self.navigator
    loop do
      command, input = *prompt

      case command
      when 'exit', 'quit'
        persisted? :dump
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
        seed

      when 'whereami'
        puts '/' + Document.location.whereami

      else
        next
      end
    end
  end

  def self.seed
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
  end
end
