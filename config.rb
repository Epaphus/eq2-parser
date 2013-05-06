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

# Just some ramdom message stuff 

#Record zone changes
  when /.*? You have entered (?<Zone>.+?)\..*/
    regexline = /.*? You have entered (?<Zone>.+?)\..*/
    parts = line.match(regexline)
    dooutput "Zoned in to - #{parts['Zone']}"
    
#Chat Messages
  when /.*?aPC -1 (?<Player>.+?):(?<Player2>.+?)\\\/a (says|say) to the (?<Where>.+?), \"(?<Text>.+?)\".*/    
  regexline = /.*?aPC -1 (?<Player>.+?):(?<Player2>.+?)\\\/a (says|say) to the (?<Where>.+?), \"(?<Text>.+?)\".*/
  parts = line.match(regexline)
  dooutput "#{parts['Where'].capitalize}: #{parts['Player']} - #{parts['Text']}"  

#You say Messages
  when /.*?\] (?<Player>.+?) say to the (?<Where>.+?), \"(?<Text>.+?)\".*/    
  regexline = /.*?\] (?<Player>.+?) say to the (?<Where>.+?), \"(?<Text>.+?)\".*/
  parts = line.match(regexline)
  dooutput "#{parts['Where'].capitalize}: #{parts['Player']} - #{parts['Text']}"  
  
# Player Joined Group/Raid
  when /.*?\] (?<Player>.+?) has joined the(?<Text>.+?)\..*/
    regexline = /.*?\] (?<Player>.+?) has joined the(?<Text>.+?)\..*/
    parts = line.match(regexline)
    dooutput "#{parts['Player']} Joined #{parts['Text']}"
    
# Player Left Group/Raid     
  when /.*?\] (?<Player>.+?) left the (?<Text>.+?)\..*/
    regexline = /.*?\] (?<Player>.+?) left the (?<Text>.+?)\..*/
    parts = line.match(regexline)
    dooutput "#{parts['Player']} left #{parts['Text']}"
    
# Memember logged in/out    
  when /.*?Guildmate: (?<Player>.+?) has logged (?<Text>.+?)\..*/
    regexline = /.*?Guildmate: (?<Player>.+?) has logged (?<Text>.+?)\..*/  
    parts = line.match(regexline)
    dooutput "Guild Member #{parts['Player']} Logged #{parts['Text']}"    
    
# earned the achievement
  when /.*?\] (?<Player>.+?) earned the achievement \'(?<Text>.+?)\'.*/
    regexline = /.*?\] (?<Player>.+?) earned the achievement \'(?<Text>.+?)\'.*/  
    parts = line.match(regexline)
    dooutput "#{parts['Player']} earned the achievement #{parts['Text']}"    
    
# Looted item (Guild Chat)    
  when /.*?\] (?<Player>.+?) looted the Fabled .aITEM (?<itemid1>.+?) (?<itemid2>.+?):(?<Text>.+?)\\\/a..*/
    regexline = /.*?\] (?<Player>.+?) looted the Fabled .aITEM (?<itemid1>.+?) (?<itemid2>.+?):(?<Text>.+?)\\\/a..*/  
    parts = line.match(regexline)
    dooutput "Guild: #{parts['Player']} Looted #{parts['Text']}"    

# Looted item (Local chat)        
  when /.*?\] (?<Player>.+?) loots .aITEM (?<itemid1>.+?) (?<itemid2>.+?):(?<Text>.+?)\\\/a from the (?<Chest>.+?) of (?<Mob>.+?)\..*/
    regexline = /.*?\] (?<Player>.+?) loots .aITEM (?<itemid1>.+?) (?<itemid2>.+?):(?<Text>.+?)\\\/a from the (?<Chest>.+?) of (?<Mob>.+?)\..*/  
    parts = line.match(regexline)
    dooutput "Loot: #{parts['Player']} Looted #{parts['Text']} from the #{parts['Chest']} of #{parts['Mob']}"      

# Dice Random        
  when /.*? Random:(?<Player>.+?) rolls from (?<From>.+?) to (?<To>.+?) on the magic dice...and scores a (?<Score>.+?)\!.*/
    regexline = /.*? Random:(?<Player>.+?) rolls from (?<From>.+?) to (?<To>.+?) on the magic dice...and scores a (?<Score>.+?)\!.*/  
    parts = line.match(regexline)
    dooutput "Random: #{parts['Player']} Rolls #{parts['To']} and scores #{parts['Score']}"    
        
        
#  when / /
#    regexline = / /  
#    parts = line.match(regexline)
#    dooutput "Guild: #{parts['Player']} in to - #{parts['Text']}"    
    
# What to do if no match? Right now nothing other than count it    
  else

  @linesnotmatched += 1

  end
  
end