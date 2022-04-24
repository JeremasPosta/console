# frozen_string_literal: true
require './lib/virtualdisk'
class Document
  attr_accessor :content, :metadata
  attr_reader :filename

  @@disk ||= VirtualDisk.new

  def initialize(filename, content = '')
    @content = content.to_s
    @filename = filename.to_s
    save
  end

  def parent_folder
    @@disk.whereami
  end

  def save
    @metadata = "Size: #{content.size} characters, Created at: #{Time.now}."
    document =  {
      content: content,
      metadata: metadata
    }
    @@disk.create_folder(filename, **document)
  end

  def self.location
    @@disk
  end

  def self.format_disk
    @@disk = nil
    @@disk ||= VirtualDisk.new
  end
end
