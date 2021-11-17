puts "Which node would you like to run memtester on?"
print "> "
node = gets.chomp

puts "How long would you like to run memtester for on #{node} (in hours)?"
print "> "
length = gets.chomp

child_pid = spawn "bash bequiet.sh bash run_memtool.sh #{node} #{length}"
