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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
