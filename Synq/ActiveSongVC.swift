//
//  ActiveSongVC.swift
//  Synq
//
//  Created by Matthew Carpenter on 10/18/15.
//  Copyright © 2015 Group11. All rights reserved.
//

import UIKit

class ActiveSongVC: UIViewController, SPTAudioStreamingPlaybackDelegate {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playBtnLabel: UILabel!
    @IBOutlet weak var playlistIdentifier: UILabel!
    
    let playlistBaseURL = "https://polar-waters-5870.herokuapp.com"
    let playlistName:String = "testPL2"
    var versionStr:NSString = NSString()

    
    
    @IBAction func unwindToActiveSongVC(segue: UIStoryboardSegue) {
    }
    
    @IBAction func vetoBtnAction(sender: AnyObject) {
        // stop the player so that removing the song works properly
        player!.stop(nil)
    }
    
    @IBAction func addBtnAction(sender: AnyObject) {
        if playlist?.count() == 0 {
            // Playlist is empty, so go to the InitialSearchVC to tell the user how to add a song
            performSegueWithIdentifier("ShowInitialSearch", sender: self)
        } else {
            // Playlist is not empty, so display current playlist when searching
            performSegueWithIdentifier("ShowSongSearch", sender: self)
        }
    }
    
    let isHostPhone: Bool = true

    var player:SPTAudioStreamingController? = nil
    var spotifyAuthenticator:SPTAuth? = nil
    let playlist:QueuedPlaylistDataModel? = QueuedPlaylistDataModel()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        playlist!.setSongVC(self)
        
        playBtnLabel.text = "Pause"

        if player != nil {
            player?.playbackDelegate = self
        }
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        // When the view loads, and the playlist has been created start polling for updates
        self.pollForUpdates()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if playlist!.count() != 0 {
            let currentTrackURI = playlist!.getURIForCurrentTrack()
            updateImageAndLabelsForTrackURI(currentTrackURI, imageView: self.image, artistLabel: self.artistLabel, trackLabel: self.trackLabel)
        } else {
            self.image.image = UIImage()
            self.artistLabel.text = "No song in queue"
            self.trackLabel.text = "No song in queue"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // When the track changes, get the album image, track name, and artist name for the new track
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangeToTrack trackMetadata: [NSObject : AnyObject]!) {
        if player!.currentTrackURI != nil {
            updateImageAndLabelsForTrackURI(player!.currentTrackURI, imageView: self.image, artistLabel: self.artistLabel, trackLabel: self.trackLabel)
        }
        //print("CHANGED TRACK")
    }
    
    // When the track stops start playing the next track
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: NSURL!) {
        let spotifyURI:NSURL! = playlist!.getURIForNextTrack()
        if (spotifyURI == nil) {
            // if there isn't another track to be played inform the user
            self.image.image = UIImage()
            self.artistLabel.text = "No song in queue"
            self.trackLabel.text = "No song in queue"
        } else {
            changeToSongWithURI(spotifyURI)
        }
    }
    
    func changeToSongWithURI(uri: NSURL!) {
        // only the host phone should be playing music
        if (isHostPhone) {
            self.player?.playURIs([uri], withOptions: nil, callback: nil)
        }
        
        // All phones need to update the image and labels
        updateImageAndLabelsForTrackURI(uri, imageView: self.image, artistLabel: self.artistLabel, trackLabel: self.trackLabel)
    }
    
    func updateImageAndLabelsForTrackURI(trackURI: NSURL!, imageView: UIImageView!, artistLabel: UILabel!, trackLabel: UILabel! ) {
        if trackURI != nil {
            let countryCode = "US" // as per ISO 3166-1
            
            SPTTrack.trackWithURI(trackURI, accessToken: self.spotifyAuthenticator?.session.accessToken, market: countryCode) { (error , trackObject) -> Void in
                let track:SPTTrack! = trackObject as! SPTTrack!
                
                if (track != nil) {
                    // set the track label
                    trackLabel!.text = track!.name
                    
                    // set the artist label
                    let artists:[SPTPartialArtist]! = track!.artists as! [SPTPartialArtist]!
                    
                    artistLabel!.text = self.getArtistsNames(artists)
                    
                    // set the album image
                    let imageURL = track.album.largestCover.imageURL
                    
                    self.setImage(imageView, imageURL: imageURL)
                    
                } else {
                    print("In updateImageAndLabelsForTrackURI in ActiveSongVC:")
                    print(error)
                }
            }
        }
    }
    
    func setImage(imageView: UIImageView, imageURL: NSURL!) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            
            let albumImageData = NSData(contentsOfURL: imageURL)
            // if there is an image then set it
            if (albumImageData != nil) {
                dispatch_async(dispatch_get_main_queue()){
                    imageView.image = UIImage(data: albumImageData!)
                }
            }
        }
    }
    
    
    @IBAction func setPlaySatus(sender: AnyObject) {
    
        if (self.player?.isPlaying == true) {
            
            self.player?.setIsPlaying(false, callback: nil)
            playBtnLabel.text = "Play"
        }else{

            self.player?.setIsPlaying(true, callback: nil)
            playBtnLabel.text = "Pause"
            
        }
    }

    
    func getArtistsNames(artists: [SPTPartialArtist]!) -> String {
        
        var artistsString:String = artists[0].name
        for (var i = 1; i < artists.count; i++) {
            artistsString += "; "
            artistsString += artists[i].name
        }
        return artistsString
        
    }
    
    func pollForUpdates() {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            while (true) {
                //check the version number
                let requestURLString = self.playlistBaseURL + "/version?name=" + self.playlistName
                let requestURL = NSURL(string: requestURLString)
                
                let versionSession = NSURLSession.sharedSession()
                let checkVersion = versionSession.dataTaskWithURL(requestURL!) { (data, response, error) -> Void in
                    if (error != nil) {
                        print("An error occured when checking the version number: \n")
                        print(error)
                    } else {
                        do {
                            // get the result
                            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                            if jsonResult != nil {
                                if let date = jsonResult!["date"] as? NSString {
                                    if self.versionStr != date {
                                        self.versionStr = date
                                        // Playlist has been updated so pull it
                                        let requestURLString = self.playlistBaseURL + "/playlist?name=" + self.playlistName
                                        let requestURL = NSURL(string: requestURLString)
                                        
                                        let playlistSession = NSURLSession.sharedSession()
                                        let playlistTask = playlistSession.dataTaskWithURL(requestURL!) { (data, response, error) -> Void in
                                            if (error != nil) {
                                                print("An error occured when trying to update the playlist: \n")
                                                print(error)
                                            } else {
                                                do {
                                                    // get the result
                                                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                                                    if jsonResult != nil {
                                                        if let tracks = jsonResult!["tracks"] as? NSArray {
                                                            for (var i = 0; i < tracks.count; i++){
                                                                //print ("track" , i)
                                                                //print (tracks[i])
                                                                if let trackDict = tracks[i] as? NSDictionary {
                                                                    let trackURI = trackDict["uri"] as! String
                                                                    let vetoCount = trackDict["veto_count"] as! Int
                                                                    
                                                                    self.playlist?.addTrackFromURI(trackURI, vetoCount: vetoCount, accessToken: self.spotifyAuthenticator?.session.accessToken)
                                                                }
                                                            }
                                                        }
                                                    }
                                                } catch {
                                                    print("error converting json for playlist")
                                                }
                                            }
                                        }
                                        playlistTask.resume()
                                    }
                                }
                            }
                        } catch {
                            print("error converting JSON for version")
                        }
                    }
                    
                }
                checkVersion.resume()
                // wait 4 seconds before checking again
                sleep(4)
            }
        }
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "ShowSongSearch") {
            let songSearchVC:SongSearchVC = segue.destinationViewController as! SongSearchVC
            
            songSearchVC.spotifyAuthenticator = self.spotifyAuthenticator
            songSearchVC.playlist = self.playlist
        } else if (segue.identifier == "ShowQueuedPlaylistFromActiveSong") {
            let queuedPlaylistTVC: QueuedPlaylistTableVC = segue.destinationViewController as! QueuedPlaylistTableVC
            
            queuedPlaylistTVC.playlist = self.playlist
        } else if (segue.identifier == "ShowInitialSearch") {
            let initialSearchVC:InitialSearchVC = segue.destinationViewController as! InitialSearchVC
            
            initialSearchVC.spotifyAuthenticator = self.spotifyAuthenticator
            initialSearchVC.playlist = self.playlist
        }
    }

}
