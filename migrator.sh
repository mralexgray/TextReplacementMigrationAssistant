#!/usr/bin/env bash

#  Migrate "Text and Symbol Replacements" from one OS X user to anaother, new machine etc.
#  Directly taken from 	robmathers' post on AskDifferent...  
#  http://apple.stackexchange.com/questions/57960/how-can-i-export-text-substitutions-from-lion-for-import-into-mountain-lion

#  This script is untested and might be broken.....  just use the TextReplacementMigrationAssistant app instead.... It's a packaged automator action!

#  ************************************************************************************  
#  CHANGE THIS NOW!  This should point to the OLD user's $HOME folder you want to migrate.
#  for example:   OLDUSERFOLDERPATH='/Volumes/oldHardDrive/Users/stevejobs'   
#  ************************************************************************************  
OLDUSERFOLDERPATH='/full/path/to/the/Users/username'

#  This saves your OLD (ie. the one's you want to migrate) substitutions to a file to your $HOME folder.
/usr/libexec/PlistBuddy -x -c "Print NSUserReplacementItems" $OLDUSERFOLDERPATH/Library/Preferences/.GlobalPreferences.plist > ~/oldTextReplacementsToMerge.plist

#  This wipes the default substitution list on the running system and creates a new blank one.
#  (Don't run this while booted from the System you WANT to restore FROM, or you'll lose your shortcuts!)

/usr/libexec/PlistBuddy -c "Delete NSUserReplacementItems" ~/Library/Preferences/.GlobalPreferences.plist
/usr/libexec/PlistBuddy -c "Add NSUserReplacementItems array" ~/Library/Preferences/.GlobalPreferences.plist

#  This will "install" the OLD rplacements you saved earlier to your new system.
/usr/libexec/PlistBuddy -c "Merge ~/oldTextReplacementsToMerge.plist NSUserReplacementItems" ~/Library/Preferences/.GlobalPreferences.plist

#  Just a little AppleScript that will open up "System Preferences" to "Language and text" to show you Your handiwork.  :-)
osascript <<EOF
tell application "System Preferences" to activate
tell application "System Events"
	tell process "System Preferences"
    	click menu item "Language & Text" of menu "View" of menu bar 1
		click radio button "Text"  of tab group 1 of window "Language & Text" 
	end tell
end tell
EOF
