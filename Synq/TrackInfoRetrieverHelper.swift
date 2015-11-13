//
//  TrackInfoRetrieverHelper.swift
//  Synq
//
//  Created by Matthew Carpenter on 11/10/15.
//  Copyright © 2015 cs378. All rights reserved.
//
// This class contains helper functions for pulling a track's info used by
// most of the other classes using the Spotify IOS SDK

import Foundation

class TrackInfoRetrieverHelper {
    // MARK: - Class Methods
    
    class func getTrackInfoForURI (trackURI: NSURL!, accessToken: String!) -> [String: AnyObject] {
        let countryCode = "US" // as per ISO 3166-1
        
        var trackName: String = String()
        var artistsNames: String = String()
        var albumImageURL: NSURL! = NSURL!()
        
        SPTTrack.trackWithURI(trackURI, accessToken: accessToken, market: countryCode)  { (error , trackObject) -> Void in
            let track:SPTTrack! = trackObject as! SPTTrack!

            if (track != nil) {
                // set the track label
                trackName = track!.name
                
                // set the artist label
                let artists:[SPTPartialArtist]! = track!.artists as! [SPTPartialArtist]!
                
                artistsNames = getArtistsNames(artists)
                
                // set the album image URL so that the user can get it async if they want
                albumImageURL = track.album.largestCover.imageURL
                
            } else {
                print("nil track in getTrackInfoForURI in TrackInfoRetrieverHelper:")
                print(error)
            }
        }
                
        let trackInfoDict = ["trackName": trackName, "artistsNames": artistsNames, "albumImageURL": albumImageURL]
        
        return trackInfoDict
    }


    
    class func setImageAsync(imageView: UIImageView, imageURL: NSURL!) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            
            let albumImageData = NSData(contentsOfURL: imageURL)
            // if there is an image then set it
            if (albumImageData != nil) {
                dispatch_async(dispatch_get_main_queue()){
                    imageView.image = UIImage(data: albumImageData!)
                }
            }
        }
    }
    
    class func setImageSync(imageView: UIImageView, imageURL: NSURL!) {
        let albumImageData = NSData(contentsOfURL: imageURL)
        // if there is na image then set it
        if (albumImageData != nil) {
            imageView.image = UIImage(data: albumImageData!)
        }
    }
    
    // MARK: - Private functions
    class func getArtistsNames(artists: [SPTPartialArtist]!) -> String {
        
        var artistsString:String = artists[0].name
        for (var i = 1; i < artists.count; i++) {
            artistsString += "; "
            artistsString += artists[i].name
        }
        return artistsString
        
    }

}