# frozen_string_literal: true
class VirtualDisk
  attr_accessor :disk, :current_route

  ERRORS = {
    unexisting_folder: 'Unexisting folder.',
    bad_folder_name: 'Folder name cannot contain dots(.) or slashes(/\\).'
  }

  GO_TO_UPPER_FOLDER = '..'

  def initialize(disk = :drive, current_route = [])
    @disk = { disk => {} }
    @current_route = current_route
    @current_route << @disk.keys.first
  end

  def create_folder(name)
    return ERRORS[:bad_folder_name] if folder_name_valid? name

    add_folder_to current_route, name
    insert_in({}, *current_route)
  end

  def insert_in(content = {}, *folders)
    folders[0..-2]
      .inject(disk) { |temp_disk, folder| temp_disk.public_send(:[], folder) }
      .public_send(:[]=, folders.last, content)
  end

  def add_folder_to(current, name)
    current << name.to_sym
  end

  def cd(folder)
    if folder == GO_TO_UPPER_FOLDER
      current_route.pop
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
    name.match %r{(/+|\.+|\\+)}
  end
end
