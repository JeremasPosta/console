# frozen_string_literal: true
require './lib/virtualdisk'
class Document
  attr_accessor :content, :metadata
  attr_reader :filename

  @@disk ||= VirtualDisk.new
  @@files_index ||= []

  def initialize(filename, content = '')
    @content = content.to_s
    @filename = filename.to_s
    save
  end

  def save
    @metadata = "Size: #{content.size} characters, Created at: #{Time.now}."
    document =  {
      content: content,
      metadata: metadata
    }
    @@disk.create_folder(filename, **document)
    @@files_index.push([{ "#{filename}": parent_folder }])
  end

  def parent_folder
    @@disk.whereami
  end

  def self.location
    @@disk
  end

  def self.destroy(filename)
    @@disk.destroy(filename)
  end

  def self.greet
    puts '> Welcome, if you are using --persisted option, quit with command quit or exit to save.'
  end
end
