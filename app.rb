require 'bundler'
Bundler.require

require "./config.rb"
require "./timer.rb"

# Not sure if this needs to be but best to start with a known value I think :)
@linecount = 0
@matchedlines = 0
@cursedrunning = 0
@linesnotmatched = 0
@curecursematched = 0
@cursematched = 0
# Needed so the thread exists and we don't bomb out when first checking to see if it is already running
@cursethread = Thread.new {}

# Adds time stamp to output and logs to file for later review if needed
def dooutput (message)
  #date = Time.new
  puts "[#{Time.now.strftime("%H:%M:%S")}] #{message}"
  @outputfile.puts "[#{Time.now.strftime("%H:%M:%S")}] #{message}"
end


# Output some stuff to show Parser has started up
date = Time.new
@outputfile = File.new(@outputlogfile, "a+")
@outputfile.sync =true
@outputfile.puts("")
@outputfile.puts("")
@outputfile.puts("===================")
dooutput "Parser Stated"
dooutput "Using logfile: #{@inputlogfile}"
dooutput "Outputing to: #{@outputlogfile}"
@outputfile.puts("===================")


begin
  File.open(@inputlogfile) do |log|
    log.extend(File::Tail)
    log.interval = 0.1
    log.max_interval = 1
    log.reopen_deleted = true
    log.backward(0)
    log.tail { |line| 
        checkline(line) 
        @linecount += 1
        }
  end
# Rescue for when ctrl+c is pressed so we can end the program more cleanly
rescue Interrupt => e
  puts ""
  puts "Stopping Parser"
end




# Ouput that we have ended the program and put in some random stats.
@outputfile .puts("===================")
dooutput "Parser Stopped"
dooutput "Lines read: #{@linecount}"
dooutput "Lines not matched: #{@linesnotmatched}"
dooutput "Curses: #{@cursematched}"
dooutput "Curses cured: #{@curecursematched}"
@outputfile .puts("===================")
@outputfile .close