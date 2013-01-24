require 'pathname'
require 'pp'
require "#{File.dirname(Pathname.new(__FILE__).realpath)}/quick-debug/version"

class D
  @@logpath = '/tmp/quick-debug.txt'
  @@active = {:bg => true, :lg => true}
  @@print_separator = true

  def self.disable where
    locations = if where == :all
                  [:bg, :lg]
                else
                  [where]
                end
    locations.each{ |location| @@active[location] = false }
  end

  def self.enable where
    locations = if where == :all
                  [:bg, :lg]
                else
                  [where]
                end
    locations.each{ |location| @@active[location] = true }
  end

  def self.logpath= path
    @@logpath = path
  end

  def self.bg(command = nil, &block)
    return if !@@active[:bg] && command != :force
    puts eval_inspect(caller.first, &block)
  end

  def self.lg(command = nil, &block)
    return if !@@active[:lg] && command != :force
    timestamp = Time.now.strftime("%a %H:%M:%S")
    File.open(@@logpath, 'a+') do |f|
      print_separator_if_needed f
      f.puts "[#{timestamp}] #{eval_inspect(caller[1], &block)}"
    end
  end

  def self.str(command = nil, &block)
    eval_inspect(caller.first, &block)
  end

  private

  def self.print_separator_if_needed file
    if @@print_separator
      file.puts "\n\n#{'=' * 70}\n\n"
      @@print_separator = false
    end
  end

  def self.eval_inspect(caller_string, &block)
    outputs = ["[#{strip_filepath caller_string}]"]
    if block
      varname = block.call.to_s
      outputs << "#{varname} ~> #{PP.pp eval(varname, block), ''}"
    end
    outputs.join(' ')
  end

  def self.strip_filepath caller_string
    filepath_and_line = caller_string.split(':in ').first
    filepath = filepath_and_line.split(':').first
    filename = File.basename(filepath)
    caller_string.gsub filepath, filename
  end
end
