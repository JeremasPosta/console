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
      filename: filename,
      content: content,
      metadata: metadata
    }
    @@disk.insert_in(document, *@@disk.current_route)
  end

  def self.location
    @@disk
  end
end
