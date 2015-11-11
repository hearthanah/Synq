//
//  SongSearchVC.swift
//  Synq
//
//  Created by Matthew Carpenter on 10/18/15.
//  Copyright © 2015 Group11. All rights reserved.
//

import UIKit

class SongSearchVC: UIViewController {
    
    var spotifyAuthenticator:SPTAuth? = nil
    var listPage:SPTListPage? = nil
    var playlist: QueuedPlaylistDataModel? = nil

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var queuedPlaylistTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
