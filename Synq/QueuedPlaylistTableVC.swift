//
//  QueuedPlaylistTableVC.swift
//  Synq
//
//  Created by Matthew Carpenter on 10/18/15.
//  Copyright © 2015 Group11. All rights reserved.
//

import UIKit

class QueuedPlaylistTableVC: UITableViewController {
    
    var playlist: QueuedPlaylistDataModel? = nil
    var newTrack: SPTPartialTrack? = nil
    var spotifyAuthenticator: SPTAuth? = nil
    var albumImage: UIImage? = nil
    let reuseIdentifier: String = "QueuedCell"
    
    let indexOfActiveSongVC: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (newTrack != nil) {
            
            var trackImage = UIImage()
            if ( self.albumImage != nil ) {
                trackImage = self.albumImage!
            }
            playlist?.pushNewTrack(newTrack!, trackImage: trackImage)
            
            self.tableView.reloadData()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Queued Playlist"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if playlist != nil {
            return playlist!.count()
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as! QueuedPlaylistTableViewCell

        // Configure the cell...
        let trackInfoDict = playlist!.getInfoForTrackAtIndex(indexPath.row)
        cell.trackLabel.text = (trackInfoDict["trackName"] as! String)
        cell.artistLabel.text = (trackInfoDict["artistName"] as! String)
        cell.imageView?.image = (trackInfoDict["albumImage"] as! UIImage)
        
        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "QueuedToSongInfo") {
            // Get the destination view controller
            let songInfoVC:SongInfoVC = segue.destinationViewController as! SongInfoVC
            
            let resultIndex = self.tableView.indexPathForSelectedRow!.row
            
            // Pass in the data model for the row selected
            let trackInfoDict = playlist!.getInfoForTrackAtIndex(resultIndex)
            songInfoVC.track = (trackInfoDict["trackName"] as! String)
            songInfoVC.artist = (trackInfoDict["artistName"] as! String)
            songInfoVC.imageV = (trackInfoDict["albumImage"] as! UIImage)
            
        }
    }

    


}
