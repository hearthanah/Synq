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
Pair Programming:
-Finalized the queueing setup for adding song from the search result.
-We are using segues between all views to pass along the playlist. This will later be replaced by CoreData model.
-The Queued playlist Table View Controllers now displays all the list in the playlist
-Song Preview shows all the song data based off of the search results.
-Fixed the track info and queued playlist data model, to work without having to querying the Spotify API.
Hanah Luong:
-Layout setup
-Button hiding when such options are not available until the user does specific steps. Ex. Login comes before the user is able to create a new playlist.
-Segues between the SearhResult and showSongPreview
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
-Wrote QueuedPlaylistDataModel, TrackInfo, TrackInfoRetrieverHelper classes

Differences: (from App Idea Paper)
Don't have a synchronized playlist. Instead we implemented a basis for the song queueing. This keeps data of the track URI, track name, artist, and image. From here we will be able to play the tracks using the Track URI, but the persistant player needs to be implemented.


RELEASE: tba
