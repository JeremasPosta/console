class User
  require 'digest'
  SALTY_HASHIE = 'fasdf4sd54g8974f45sd2fs8df4as651csd6v8sdc'

  attr_accessor :name

  @@bault ||= VirtualDisk.new :bault

  def initialize(name, raw_password)
    @name = name
    @password = secure_password raw_password
    save
  end

  def secure_password(raw_password)
    @password = Digest::SHA1.hexdigest(raw_password + SALTY_HASHIE)
  end

  def self.validate_password(user, raw_password)
    bault[user] == Digest::SHA1.hexdigest(raw_password + SALTY_HASHIE)
  end

  def save
    @@bault.mount('.bault', :no_messages)
    @@bault.disk[:bault][:"#{name}"] = @password
    @@bault.dump '.bault'
  end

  def self.bault
    @@bault.disk[:bault]
  end

  def self.start
    @@bault.mount('.bault', :no_messages)
  end

  def self.greet(name)
    puts "> Welcome #{name}, if you are using --persisted option, quit with command 'quit' or 'exit' to save your changes."
  end
end
