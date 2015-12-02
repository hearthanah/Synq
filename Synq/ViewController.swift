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
    
    let playlistBaseURL = "https://polar-waters-5870.herokuapp.com"
    let playlistName:String = "testPL1"

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
    
    @IBAction func joinPlaylistBtnAction(sender: AnyObject) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.hideButton.layer.zPosition = 1
        self.hideButtonLogin.layer.zPosition = -1
        
    }
    
    // SPTAuthViewDelegate protocol methods
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        setupSpotifyPlayer()
        loginWithSpotifySession(session)
    }
    
    // TODO: - display login failures in the UI?
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        print("login cancelled")
    }
    
    // TODO: - display login failures in the UI?
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        print("login failed")
        print(error)
    }
    
    // SPTAudioStreamingPlaybackDelegate protocol methods
    
    private
    
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
        let postNameParam = "name=" + self.playlistName
        
        let requestURLString = self.playlistBaseURL + "/create"
        let requestURL = NSURL(string: requestURLString)
        
        
        let request = NSMutableURLRequest(URL: requestURL!)
        request.HTTPMethod = "POST"
        
        request.HTTPBody = postNameParam.dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if (error != nil) {
                print("An error occured when creating the playlist: \n")
                print(error)
            } 
        }
        task.resume()

    }
        
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowActiveSongVC") {
            let activeSongVC:ActiveSongVC = segue.destinationViewController as! ActiveSongVC
            
            activeSongVC.player = self.player
            activeSongVC.spotifyAuthenticator = self.spotifyAuthenticator
            
            createRemotePlaylist()
        }
    }

}




