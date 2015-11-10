# Synq
Synq, an iOS music player application. In the works.

** as a note to our selves
Here is where we got the resource to bypass Transport Security Exceptions
http://ste.vn/2015/06/10/configuring-app-transport-security-ios-9-osx-10-11/


INSTRUCTIONS TO RUN SPOTIFY TOKEN
$ gem install sinatra

$ ruby spotify_token_swap.rb

*you might need these:
  $ gem install bundle
  
  $ bundle install

$ ruby spotify_token_swap.rb

You will need to revert the simulator and iOS to a previous version. I reverted to 8.4 and this current implementation works best in an iphone 6 simulator.

ALPHA: Our application connects with spotify, plays one designated song and show cases the album art as well as track and artist name. 

BETA: 
Contributions:
Matthew Carpenter:
-Copied storyboard view controllers and classes I had made from a previous commit that had been
written over and placed them into the current storyboard.
-Set up the ActiveSongVC to display the album image, track name and artist name of the 
currently playing song by requesting track data using SPTTrack. Did the same for new songs
as they begin.
-Implemented search functionality for SongSearchVC, which uses the 
reloadTableViewWithNewListPage method to pass the listPage to the SearchResultsVC 
(since SPTSearch uses a callback which occurs after the SearchResultsVC has loaded)
-Implemented the searchResultsTableView and its custom SearchResultsTableViewCells
in the SearchResultsVC to display the album image, track name, and artist name for each
of the track items returned by SPTSearch
-Implemented searching in the SearchResultsVC

Differences: (from App Idea Paper)

TODO FOR BETA:

-SongPreviewVC displaying track information (Should be the same as ActiveSongVC,
just with uri from the search item)

-Creation of a queued song list data model that will store songs (i.e. URI's)
-Adding "songs" (i.e. URIs) to the queuedSongListDataModel from the SongPreviewVC
-Implementing queuedPlaylistTableViews for the QueuedPlaylistTableVC and SongSearchVC

-Setting up the back button of the QueuedPlaylistTableVC to always go back to the ActiveSongVC
(poping back multiple scenes at once if coming from the SongPreviewVC)

-Clean up the login screen (get rid of song info & have the button for creating a
playlist fade in after logging in)
    -Should the navigation controller be moved to after the login screen?

-Set up some way of synchronizing playlists across multiple users
-Add another button to the login screen for accessing another user's (host phone's)
playlist instead of creating your own after logging in (using some sort of playlist ID)

-Figure out how to integrate the spotify token server into the app, or run it remotely


RELEASE: tba
