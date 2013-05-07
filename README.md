eq2-parser
============

This parses an EQ2 log file for some events, the orginal perpouse was for the Drinal curse in Harrow's End raid zone as I couldn't add the trigger correctly Guild Connect, 

To use:

Correct the path and file in config.rb to point your EQ2 log then run with 
	ruby app.rb 

The required GEMs can be installed using bundle.

	bundle install --path vendor

To Do list
------------

1. Look at reducing CPU usage as 40-60% CPU usage 
2. Look at better way of storing the triggers to make adding more easier
