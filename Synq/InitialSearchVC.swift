//
//  InitialSearchVC.swift
//  Synq
//
//  Created by Matthew Carpenter on 11/30/15.
//  Copyright © 2015 cs378. All rights reserved.
//

import UIKit

class InitialSearchVC: UIViewController, UITextFieldDelegate {
    
    var spotifyAuthenticator:SPTAuth? = nil
    var playlist: QueuedPlaylistDataModel? = nil

    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }


    // MARK: - Navigation
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
