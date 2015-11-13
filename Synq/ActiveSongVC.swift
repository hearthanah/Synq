//
//  ActiveSongVC.swift
//  Synq
//
//  Created by Matthew Carpenter on 10/18/15.
//  Copyright © 2015 Group11. All rights reserved.
//

import UIKit

class ActiveSongVC: UIViewController, SPTAudioStreamingPlaybackDelegate{
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBAction func unwindToActiveSongVC(segue: UIStoryboardSegue) {
    }

    var player:SPTAudioStreamingController? = nil
    var spotifyAuthenticator:SPTAuth? = nil
    let playlist:QueuedPlaylistDataModel = QueuedPlaylistDataModel()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Make sure that when the view loads the info for the current track is displayed
        if player != nil {
            if player!.currentTrackURI != nil {
                updateImageAndLabelsForTrackURI(player!.currentTrackURI, imageView: self.image, artistLabel: self.artistLabel, trackLabel: self.trackLabel)
            }
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
    }

    
    func updateImageAndLabelsForTrackURI(trackURI: NSURL!, imageView: UIImageView!, artistLabel: UILabel!, trackLabel: UILabel! ) {
        if player!.currentTrackURI != nil {
            let currentTrackURI = player!.currentTrackURI
            let countryCode = "US" // as per ISO 3166-1
            
            SPTTrack.trackWithURI(currentTrackURI, accessToken: self.spotifyAuthenticator?.session.accessToken, market: countryCode) { (error , trackObject) -> Void in
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
    
    func getArtistsNames(artists: [SPTPartialArtist]!) -> String {
        
        var artistsString:String = artists[0].name
        for (var i = 1; i < artists.count; i++) {
            artistsString += "; "
            artistsString += artists[i].name
        }
        return artistsString
        
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
        }
    }

}
