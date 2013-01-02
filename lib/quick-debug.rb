require 'pathname'
require 'pp'
require "#{File.dirname(Pathname.new(__FILE__).realpath)}/quick-debug/version"

class D
  @@logpath = '/tmp/quick-debug.txt'
  @@active = {:bg => true, :lg => true}

  def self.disable where
    locations = where == :all ? [:bg, :lg] : where
    locations.each{ |location| @@active[location] = false }
  end

  def self.enable where
    locations = where == :all ? [:bg, :lg] : where
    locations.each{ |location| @@active[location] = true }
  end

  def self.logpath= path
    @@logpath = path
  end

  def self.bg(command = nil, &block)
    return if not @@active[:bg]
    puts eval_inspect(caller.first, command, &block)
  end

  def self.lg(command = nil, &block)
    return if not @@active[:lg]
    timestamp = Time.now.strftime("%a %H:%M:%S")
    File.open(@@logpath, 'a+') do |f|
      f.puts "[#{timestamp}] #{eval_inspect(caller.first, command, &block)}"
    end
  end

  def self.str(command = nil, &block)
    eval_inspect(caller.first, command, &block)
  end

  private

  def self.eval_inspect(caller_string, command = nil, &block)
    outputs = []
    if command && [:in, :at].include?(command.to_sym)
      outputs << "[#{strip_filepath caller_string}]"
    end
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
