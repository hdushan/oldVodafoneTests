class PutsLogger
  def method_missing(name, *args)
    puts "[#{name.upcase}] #{args[0]}"
  end
end