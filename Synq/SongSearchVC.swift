//
//  SongSearchVC.swift
//  Synq
//
//  Created by Matthew Carpenter on 10/18/15.
//  Copyright © 2015 Group11. All rights reserved.
//

import UIKit

class SongSearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var spotifyAuthenticator:SPTAuth? = nil
    var listPage:SPTListPage? = nil
    var playlist: QueuedPlaylistDataModel? = nil
    let reuseIdentifier = "SongSearchCell"

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var queuedPlaylistTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.queuedPlaylistTableView.delegate = self
        self.queuedPlaylistTableView.dataSource = self
        
    }
    
    // Reload the table whenever the view appears, just incase the user is
    // navigating back to it
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.queuedPlaylistTableView.reloadData()
        
        self.navigationItem.title = "Search"
        let backBtn = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBtn
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if playlist != nil {
            return playlist!.count()
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as! SongSearchCell
        
        // Configure the cell...
        let trackInfoDict = playlist!.getInfoForTrackAtIndex(indexPath.row)
        cell.trackLabel.text = (trackInfoDict["trackName"] as! String)
        cell.artistLabel.text = (trackInfoDict["artistName"] as! String)
        cell.imageView?.image = (trackInfoDict["albumImage"] as! UIImage)
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowSearchResults") {
            let searchResultsVC:SearchResultsVC = segue.destinationViewController as! SearchResultsVC
            searchResultsVC.spotifyAuthenticator = self.spotifyAuthenticator
            
            let countryCode = "US"

            SPTSearch.performSearchWithQuery(searchTextField!.text, queryType: .QueryTypeTrack, accessToken: self.spotifyAuthenticator?.session.accessToken, market: countryCode) { (error, listPageObject) -> Void in
                let listPage:SPTListPage! = listPageObject as! SPTListPage!
                if listPage != nil {
                    searchResultsVC.reloadTableViewWithNewListPage(listPage)
                }
            }
            
            searchResultsVC.playlist = self.playlist
        }
    }

}
