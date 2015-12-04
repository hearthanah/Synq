//
//  ViewController.swift
//  Synq
//
//  Created by Hanah Luong on 10/19/15.
//  Copyright © 2015 cs378. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SPTAuthViewDelegate, SPTAudioStreamingPlaybackDelegate {
    
    let kClientID = "4158c76252d8498687bd983aca90a2bc"
    let kCallbackURL = "synq-app-login://callback"
    let kTokenSwapURL = "https://young-tundra-9211.herokuapp.com/swap"
    let kTokenRefreshURL = "https://young-tundra-9211.herokuapp.com/refresh"
    let playlistBaseURL = "https://limitless-wildwood-7949.herokuapp.com"
    var playlistName = ""
    var isValidName: Bool? = nil

    @IBOutlet weak var hideButton: UIView!
    @IBOutlet weak var hideButtonLogin: UIView!
    
    var player: SPTAudioStreamingController?
    let spotifyAuthenticator = SPTAuth.defaultInstance()
    
    
    @IBAction func loginWithSpotify(sender: AnyObject) {
        spotifyAuthenticator.clientID = kClientID
        spotifyAuthenticator.requestedScopes = [SPTAuthStreamingScope]
        spotifyAuthenticator.redirectURL = NSURL(string: kCallbackURL)
        spotifyAuthenticator.tokenSwapURL = NSURL(string: kTokenSwapURL)
        spotifyAuthenticator.tokenRefreshURL = NSURL(string: kTokenRefreshURL)
        
        let spotifyAuthenticationViewController = SPTAuthViewController.authenticationViewController()
        spotifyAuthenticationViewController.delegate = self
        spotifyAuthenticationViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        spotifyAuthenticationViewController.definesPresentationContext = true
        presentViewController(spotifyAuthenticationViewController, animated: false, completion: nil)
    }
    
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var playlistTextField: UITextField!
    
    @IBAction func createPlaylistBtnAction(sender: AnyObject) {
        // make sure the user actually input a name
        if (playlistTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "") {
            errorLabel.text = "Please input a name for the playlist"
        } else {
            // check to see if there is already a playlist for this name
            checkPlaylistName(playlistTextField.text!)
            
            if (self.isValidName == true) {
                // there is a playlist with the same name, so set the label to say that
                errorLabel.text = "There is already a playlist with that name"
            } else {
                // there is no playlist, so set the name and segue (which will create the playlist)
                playlistName = playlistTextField.text!
                performSegueWithIdentifier("CreatePlaylist", sender: self)
            }
        }
    }
    
    @IBAction func joinPlaylistBtnAction(sender: AnyObject) {
        //segue ID: JoinPlaylist
        // make sure the user actually input a name
        if (playlistTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "") {
            errorLabel.text = "Please input a name for the playlist"
        } else {
            // check to see if there is already a playlist for this name
            checkPlaylistName(playlistTextField.text!)
            
            if (self.isValidName == true) {
                // there is a playlist with that name, so join it
                playlistName = playlistTextField.text!
                performSegueWithIdentifier("JoinPlaylist", sender: self)
            } else {
                // there is no playlist, so set the error label to say that
                errorLabel.text = "There is no playlist with that name"
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.hideButton.layer.zPosition = 1
        self.hideButtonLogin.layer.zPosition = -1
        errorLabel.text = ""
        
    }
    
    // SPTAuthViewDelegate protocol methods
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        setupSpotifyPlayer()
        loginWithSpotifySession(session)
    }
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        print("login cancelled")
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        print("login failed")
        print(error)
    }
    
    // SPTAudioStreamingPlaybackDelegate protocol methods
    
    private
    
    // Checks to see if there is a playlist in the DB with the given name
    // Blocks until a response fromt the server is retrieved
    func checkPlaylistName(name: String) {

        self.isValidName = nil
        
        // Try checking the "version" of the playlist, to see if it exists
        let requestURLString = self.playlistBaseURL + "/version?name=" + name
        let requestURL = NSURL(string: requestURLString)
        
        let versionSession = NSURLSession.sharedSession()
        let checkVersion = versionSession.dataTaskWithURL(requestURL!) { (data, response, error) -> Void in
            if (error != nil) {
                print("error checking playlist name")
                self.isValidName = false
            } else {
                do {
                    // get the result
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    if jsonResult != nil {
                        self.isValidName = true
                    }
                } catch {
                        self.isValidName = false
                }
            }
        }
        checkVersion.resume()
        
        // Wait until the checkVersion task finishes before returning
        while (self.isValidName == nil) {
            sleep(1)
        }

    }
    
    func setupSpotifyPlayer() {
        player = SPTAudioStreamingController(clientId: spotifyAuthenticator.clientID) // can also use kClientID; they're the same value
        player!.playbackDelegate = self
        player!.diskCache = SPTDiskCache(capacity: 1024 * 1024 * 64)
    }
    
    func loginWithSpotifySession(session: SPTSession) {
        player!.loginWithSession(session, callback: { (error: NSError!) in
            if error != nil {
                print("Couldn't login with session: \(error)")
                return
            }
            
            self.hideButton.layer.zPosition = -1
            self.hideButtonLogin.layer.zPosition = 1
            
            self.useLoggedInPermissions()
        })
    }
    
    func useLoggedInPermissions() {
    }
    
    // get the album image, track name, and artist name for the track that's playing
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangeToTrack trackMetadata: [NSObject : AnyObject]!) {

    }
    
    func updateImageAndLabels(trackMetadata: [NSObject : AnyObject]!, imageView: UIImageView!, artistLabel: UILabel!, trackLabel: UILabel! ) {
        if player!.currentTrackURI != nil {
            // get the uri of the album for the track that just got switched to
            let uri = NSURL(string: (trackMetadata["SPTAudioStreamingMetadataAlbumURI"] as! String))
            
            artistLabel.text = (trackMetadata["SPTAudioStreamingMetadataArtistName"] as! String)
            trackLabel.text = (trackMetadata["SPTAudioStreamingMetadataTrackName"] as! String)
            
            
            SPTAlbum.albumWithURI(uri, accessToken: spotifyAuthenticator.session.accessToken, market: nil, callback:{ (error, album) -> Void in
                
                let imageURL = album!.largestCover!.imageURL
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
                    
                    let albumImageData = NSData(contentsOfURL: imageURL)
                    // if there is an image then set it
                    if (albumImageData != nil) {
                        dispatch_async(dispatch_get_main_queue()){
                            imageView.image = UIImage(data: albumImageData!)
                        }
                    }
                }
            })
        }
    }
    
    func createRemotePlaylist() {
        let nameParam = "name=" + self.playlistName
        
        let requestURLString = self.playlistBaseURL + "/create"
        let requestURL = NSURL(string: requestURLString)
        
        let request = NSMutableURLRequest(URL: requestURL!)
        request.HTTPMethod = "POST"
        
        request.HTTPBody = nameParam.dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if (error != nil) {
                print("An error occured when creating the playlist: \n")
                print(error)
            } else {
                // now that the playlist has been created increment it's usernum
                self.joinPlaylist()
            }
        }
        task.resume()

    }
    
    // Increments the usernum of the playlist (for vetoing)
    func joinPlaylist() {
        let nameParam = "?name=" + self.playlistName
        var patchURLString = self.playlistBaseURL + "/join"
        patchURLString += nameParam
        
        let patchURL = NSURL(string: patchURLString)
        let patchRequest = NSMutableURLRequest(URL: patchURL!)
        patchRequest.HTTPMethod = "PATCH"
        
        let patchSession = NSURLSession.sharedSession()
        let patchTask = patchSession.dataTaskWithRequest(patchRequest) { (data, response, error) -> Void in
            if (error != nil) {
                print("An error occured when updating the usernum")
                print(error)
            }
        }
        patchTask.resume()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "CreatePlaylist") {
            let activeSongVC:ActiveSongVC = segue.destinationViewController as! ActiveSongVC
            
            activeSongVC.player = self.player
            activeSongVC.spotifyAuthenticator = self.spotifyAuthenticator
            activeSongVC.playlistName = playlistName
            activeSongVC.isHostPhone = true
            
            createRemotePlaylist()
            
        } else if (segue.identifier == "JoinPlaylist") {
            let activeSongVC:ActiveSongVC = segue.destinationViewController as! ActiveSongVC
            
            activeSongVC.player = self.player
            activeSongVC.spotifyAuthenticator = self.spotifyAuthenticator
            activeSongVC.playlistName = playlistName
            activeSongVC.isHostPhone = false
            // The playlist already exists, so join the playlist
            self.joinPlaylist()
        }
    }

}




