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
    let reuseIdentifier = "QueuedCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (newTrack != nil) {
            var trackImage = UIImage()
            if ( self.albumImage != nil ) {
                trackImage = self.albumImage!
            }

            playlist?.pushNewTrack(newTrack!, trackImage: trackImage)
            
            self.tableView.reloadData()
        } else {
            print("nil track", newTrack)
        }
        
        if (playlist == nil) {
            print("nil playlist")
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        print("track info dict", trackInfoDict)

        return cell
    }


}
