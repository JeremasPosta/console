# frozen_string_literal: true
require 'json'

class VirtualDisk
  attr_accessor :disk, :current_route

  ERRORS = {
    unexisting_folder: '> Unexisting folder.',
    bad_folder_name: '> Folder name cannot contain dots(.) or slashes(/\\).'
  }

  MESSAGES = {
    folder_created: '> Created /',
    file_deleted: '> file deleted.',
    random_folder: '> A random name was chosen for you:'
  }

  GO_TO_UPPER_FOLDER = '..'
  CONTENT = 'content'
  DOTS_SLASH_FILTER = %r{(/+|\.+|\\+)}.freeze

  def initialize(disk = :drive, current_route = [])
    @disk = { disk => {} }
    @current_route = current_route
    @current_route << @disk.keys.first
  end

  def create_folder(name, **opts)
    name ||= random_folder
    return ERRORS[:bad_folder_name] if folder_name_valid? name

    add_folder_to(current_route, name)
    insert_in(opts, *current_route)
    MESSAGES[:folder_created] + name
  end

  def random_folder
    puts MESSAGES[:random_folder]
    "folder#{rand 10_000}"
  end

  def listing
    folders = current_route.dup
    disk.dig(*folders).keys.map(&:to_s).to_s[1...-1]
  end

  def cd(folder)
    folder.to_s
    if folder == GO_TO_UPPER_FOLDER
      current_route.pop if current_route.size > 1
    elsif folder_exist_in_this_level? folder
      add_folder_to current_route, folder
    else
      ERRORS[:unexisting_folder]
    end
  end

  def folder_exist_in_this_level?(folder)
    temp_current_route = current_route.dup
    add_folder_to temp_current_route, folder
    disk.dig(*temp_current_route)
  end

  def whereami
    current_route.map(&:to_s).inject { |route, folder| "#{route}/#{folder}" }
  end

  def folder_name_valid?(name)
    name.match DOTS_SLASH_FILTER
  end

  def gimme_a_file(name, property = nil)
    temp_current_route = current_route.dup
    add_folder_to temp_current_route, name
    required_param = property.nil? ? CONTENT : property
    add_folder_to temp_current_route, required_param
    disk.dig(*temp_current_route)
  end

  def destroy(filename)
    add_folder_to current_route, filename
    remove_from(disk.dup, filename.to_sym)
    filename + MESSAGES[:file_deleted]
    current_route.pop
  end

  def remove_from(temp_disk, key, level = 0)
    level += 1
    remove_from(temp_disk[current_route[level - 1]], key, level) unless level == current_route.size
    if current_route.size == level
      temp_disk.delete key
    end
    temp_disk
  end

  def insert_in(content = {}, *folders)
    folders[0...-1]
      .inject(disk) { |temp_disk, folder| temp_disk.public_send(:[], folder) }
      .public_send(:[]=, folders.last, content)

    current_route.pop unless content&.empty?
  end

  def add_folder_to(current, name)
    current << name.to_sym
  end

  def dump(filename)
    File.write(filename.to_s, disk.to_json)
  rescue Errno::ENOENT => e
    puts "Failed to dump disk with error: #{e}"
  end

  def mount(filename, *args)
    disk.merge!(JSON.parse(File.read(filename.to_s), symbolize_names: true).to_h)
  rescue Errno::ENOENT => e
    puts "> Failed to mount disk with error: #{e}" if args.empty?
    puts '> Trying to create resource...' if args.empty?
    begin
      File.write(filename.to_s, disk.to_json)
      puts '> Success!' if args.empty?
    rescue Errno::ENOENT => e
      puts "> Failed to create disk: #{e}" if args.empty?
    end
  end
end
