# frozen_string_literal: true
class VirtualDisk
  attr_accessor :disk, :current_route

  ERRORS = {
    unexisting_folder: 'Unexisting folder'
  }

  def initialize(disk = :'~', current_route = [])
    @disk = { disk => {} }
    @current_route = current_route
    @current_route << @disk.keys.first
  end

  def [](key)
    disk[key]
  end

  def []=(key, values)
    disk[key] += [values].flatten
    disk[key]
  end

  def create_folder(name)
    add_folder_to current_route, name
    deep_set(disk, {}, *current_route)
  end

  def deep_set(hash, value, *keys)
    keys[0...-1].inject(hash) do |acc, h|
      acc.public_send(:[], h)
    end.public_send(:[]=, keys.last, value)
  end

  def add_folder_to(current, name)
    current << name.to_sym
  end

  def cd(folder)
    if folder == '..'
      current_route.pop
    elsif folder_exist_in_this_level? folder
      add_folder_to current_route, folder
    else
      ERRORS[:unexisting_folder]
    end
  end

  def folder_exist_in_this_level? folder
    temp_current_route = current_route.dup
    add_folder_to temp_current_route, folder
    disk.dig(*temp_current_route)
  end

  def whereami
    current_route.map(&:to_s).inject { |route, n| route + '/' + n }
  end
end
