require "#{File.dirname(__FILE__)}/quick-debug/version"

class D
  @@logpath = '/tmp/quick-debug.txt'

  def self.logpath= path
    @@logpath = path
  end

  def self.bg(command = nil, &block)
    puts eval_inspect(caller.first, command, &block)
  end

  def self.lg(command = nil, &block)
    caller_method = caller.first
    timestamp = Time.now.strftime("%a %H:%M:%S")
    File.open(@@logpath, 'a+') do |f|
      f.puts "[#{timestamp}] #{eval_inspect(caller_method, command, &block)}"
    end
  end

  def self.str(command = nil, &block)
    eval_inspect(caller.first, command, &block)
  end

  private

  def self.eval_inspect(caller_method, command = nil, &block)
    outputs = []
    if command && [:in, :at].include?(command.to_sym)
      outputs << "[#{caller_method}]"
    end
    if block
      varname = block.call.to_s
      outputs << "#{varname} ~> #{eval(varname, block).inspect}"
    end
    outputs.join(' ')
  end
end
