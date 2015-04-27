# change root to point to where the output was saved
root='tmpout'
puts ">>> Serving: #{root}"
run Rack::Directory.new("#{root}")
