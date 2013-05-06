@inputlogfile = "eq2log.txt"
@outputlogfile = "log/output.log"


# Example Regex
# .*?Players near (?<Player>.+?) feel their hearts sink.*
# .*?Drinal's Power Over Death IV hits (?<Player>.+?) .*


# define case matching for triggers and timers
# Need to find a better way of doing this 

def checkline (line=line)
  case line
 
 # Pickup Drinal cure and stop the timer running on curse thread
  when /.*?\] (?<Healer>.+?)\'s Cure Curse relieves Power Over Death .* from (?<Player>.+?)\..*/ 
   regexline = /.*?\] (?<Healer>.+?)\'s Cure Curse relieves Power Over Death .* from (?<Player>.+?)\..*/
   parts = line.match(regexline)
   dooutput "#{parts['Player']} Cured by #{parts['Healer']}"
   Thread.kill(@cursethread)
   @curecursematched += 1

# Pick up Drinal curse hit and start a timer in new thread  
  when /.*?Drinal's Power Over Death .* hits (?<Player>.+?) .*/
    
    if @cursethread.status
      
    else
    
      time = 15
      regexline = /.*?Drinal's Power Over Death .* hits (?<Player>.+?) .*/
      parts = line.match(regexline)
      startmessage = "#{parts['Player']} Cursed"
      endmessage = "Cure #{parts['Player']} \n Cure #{parts['Player']}"
    
      @cursethread = Thread.new { dotimer(time,startmessage,endmessage) }
      @cursematched += 1
    end

# Picking up when players need to move when "up top" on Drinal fight  
  when /.*?Players near (?<Player>.+?) feel their hearts sink.*/
    time = 1
    regexline = /.*?Players near (?<Player>.+?) feel their hearts sink.*/
    parts = line.match(regexline)

    dooutput "#{parts['Player']} move"    

# Pickup when to manaburn is used for power feeding    
  when /.* (?<Player>.+?)'s Manaburn hits/
    regexline = /.* (?<Player>.+?)'s Manaburn hits/
    parts = line.match(regexline)
    dooutput "Time to power feed - #{parts['Player']}"

  else

  @linesnotmatched += 1

  end
  
end