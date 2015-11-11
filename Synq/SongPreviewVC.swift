//
//  SongPreviewVC.swift
//  Synq
//
//  Created by Matthew Carpenter on 10/18/15.
//  Copyright © 2015 Group11. All rights reserved.
//

import UIKit

class SongPreviewVC: UIViewController {
    
    var track: SPTPartialTrack? = nil
    var spotifyAuthenticator:SPTAuth? = nil
    var playlist: QueuedPlaylistDataModel? = nil

    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.trackLabel.text = track?.name
        self.artistLabel.text = TrackInfoRetrieverHelper.getArtistsNames(track?.artists as! [SPTPartialArtist]!)
        
        let imageURL: NSURL! = track?.album.largestCover.imageURL
        TrackInfoRetrieverHelper.setImageAsync(self.image, imageURL: imageURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "ShowQueuedPlaylistFromSongPreview") {
            let queuedPlaylistTVC: QueuedPlaylistTableVC = segue.destinationViewController as! QueuedPlaylistTableVC
            
            queuedPlaylistTVC.newTrack = self.track
            queuedPlaylistTVC.spotifyAuthenticator = self.spotifyAuthenticator
            queuedPlaylistTVC.playlist = self.playlist
            queuedPlaylistTVC.albumImage = self.image.image
            
        }
    }

}
