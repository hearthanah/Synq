//
//  SearchResultsVC.swift
//  Synq
//
//  Created by Matthew Carpenter on 10/18/15.
//  Copyright © 2015 Group11. All rights reserved.
//

import UIKit

class SearchResultsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var listPage:SPTListPage? = nil
    var spotifyAuthenticator:SPTAuth? = nil
    
    let cellId:String = "SearchResultCellId"

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchResultsTableView: UITableView!
        
    @IBAction func searchBtnAction(sender: AnyObject) {
        let countryCode = "US"
        
        SPTSearch.performSearchWithQuery(searchTextField!.text, queryType: .QueryTypeTrack, accessToken: self.spotifyAuthenticator?.session.accessToken, market: countryCode) { (error, listPageObject) -> Void in
            let listPage:SPTListPage! = listPageObject as! SPTListPage!
            if listPage != nil {
                self.reloadTableViewWithNewListPage(listPage)
            }
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.searchResultsTableView.delegate = self
        self.searchResultsTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSongPreview" {
            
            // Get the destination view controller
            let songPreviewShow:SongPreviewVC = segue.destinationViewController as! SongPreviewVC
            
            let resultIndex = self.searchResultsTableView.indexPathForSelectedRow!.row
            
            let track:SPTPartialTrack = self.listPage!.items[resultIndex] as! SPTPartialTrack

            // Pass in the data model for the row selected
            songPreviewShow.track = track
            songPreviewShow.spotifyAuthenticator = spotifyAuthenticator
        }
    
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.listPage != nil) {
            if (self.listPage!.items != nil) {
                return self.listPage!.items!.count
            }
        }
        // if either of these is nil then return 0 since there is no data to display
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:SearchResultsTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! SearchResultsTableViewCell
        
        let track:SPTPartialTrack = self.listPage!.items[indexPath.row] as! SPTPartialTrack
        let artists:[SPTPartialArtist]! = track.artists as! [SPTPartialArtist]!
        let albumImageURL = track.album.largestCover.imageURL
        
        setImage(cell.imageView!, imageURL: albumImageURL)
        cell.trackLabel.text = track.name
        cell.artistLabel.text = getArtistsNames(artists)
        
        return cell
    }
    
    func reloadTableViewWithNewListPage(listPage: SPTListPage?) {
        self.listPage = listPage
        self.searchResultsTableView.reloadData()
    }
    
    func getArtistsNames(artists: [SPTPartialArtist]!) -> String {
        
        var artistsString:String = artists[0].name
        for (var i = 1; i < artists.count; i++) {
            artistsString += "; "
            artistsString += artists[i].name
        }
        return artistsString
 
    }
    
    // commented out some async threading b/c images were only showing up 
    // after tapping a cell with it turned on. Perhaps b/c table had already finished loading?
    func setImage(imageView: UIImageView, imageURL: NSURL!) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            let albumImageData = NSData(contentsOfURL: imageURL)
            // if there is an image then set it
            if (albumImageData != nil) {
//                dispatch_async(dispatch_get_main_queue()){
                    imageView.image = UIImage(data: albumImageData!)
//                }
            }
//        }
    }
    
}
