//
//  QueuedPlalistDataModel.swift
//  Synq
//
//  Created by Matthew Carpenter on 11/10/15.
//  Copyright © 2015 cs378. All rights reserved.
//

import Foundation

class QueuedPlaylistDataModel {
    // MARK: - Properties
    
    private var trackInfoArr:[TrackInfo]
    private var songVC: ActiveSongVC?
    let playlistBaseURL = "http://localhost:3000"
    let playlistName:String = "testPL1"

    
    // MARK: - Methods
    
    func setSongVC (songVC: ActiveSongVC) {
        self.songVC = songVC
    }
    
    // returns an dictionary with the track's info accessable as AnyObject
    // type values by a string key
    // Key value types
    //    "trackURI": NSURL!
    //    "trackName": String
    //    "artistNames": String
    //    "albumImage": UIImage
    func getInfoForTrackAtIndex(index: Int) -> [String: AnyObject] {
        return trackInfoArr[index].getTrackInfo()
    }
    
    // Returns a NSURL? containing the URI for the current track, or nil if the queue is empty
    func getURIForCurrentTrack() -> NSURL? {
        if (!trackInfoArr.isEmpty) {
            let trackInfoDict = getInfoForTrackAtIndex(0)
            return trackInfoDict["trackURI"] as! NSURL!
        }
        return nil
    }
    
    // Returns a NSURL? containing the URI for the next track, or nil if the queue is empty after popping
    func getURIForNextTrack() -> NSURL? {
        
        // if there are no songs left then queue is empty
        if (trackInfoArr.isEmpty) {
            return nil
        } else {
            // remove the song that was just played and check to see if the queue is now empty
            self.popPlayedTrack()
            if (trackInfoArr.isEmpty) {
                return nil
            } else {
                // there is a track left over, so return its uri
                let trackInfoDict = getInfoForTrackAtIndex(0)
                return trackInfoDict["trackURI"] as! NSURL!
            }
        }
    }
    
    func pushNewTrack(track: SPTPartialTrack, trackImage: UIImage) {
        
        if (trackWithURI(track.uri) != nil) {
            return
        }
        
        let wasEmpty = trackInfoArr.isEmpty
        //print("pushing, was empty?", wasEmpty, TrackInfo(track: track, trackImage: trackImage))
        self.trackInfoArr.append(TrackInfo(track: track, trackImage: trackImage))
        
        // if the playlist was empty when adding the track restart the player with the new song
        if wasEmpty {
            let uri = getURIForCurrentTrack()
            songVC!.changeToSongWithURI(uri)
        }
        
        var requestURLString = self.playlistBaseURL + "/add?name=" + self.playlistName
        let uriParam = "&track_uri=" + String(track.uri)
        requestURLString += uriParam
        
        let requestURL = NSURL(string: requestURLString)
        
        let request = NSMutableURLRequest(URL: requestURL!)
        request.HTTPMethod = "PATCH"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if (error != nil) {
                print("An error occured when creating the playlist: \n")
                print(error)
            }
        }
        task.resume()
    }
    
    func removeTrackInfoAtIndex(index: Int) {
        self.trackInfoArr.removeAtIndex(index)
    }
    
    func count() -> Int {
        return self.trackInfoArr.count
    }

    func clearAllTracks() {
        trackInfoArr.removeAll()
        print("done clearing")
    }
    
    // used for adding tracks remotely
    func addTrackFromURI(trackURI: String, vetoCount: Int, accessToken: String!) {
        
        let convertedURI: NSURL! = NSURL(string: trackURI)

        if (trackWithURI(convertedURI) != nil) {
            print("same track with uri", convertedURI)
            return
        }
        
        let countryCode = "US" // as per ISO 3166-1
        var albumImageURL: NSURL! = NSURL!()
        
        SPTTrack.trackWithURI(convertedURI, accessToken: accessToken, market: countryCode)  { (error , trackObject) -> Void in
            let track:SPTTrack! = trackObject as! SPTTrack!
            
            if (track != nil) {
                // get the image, then make the TrackInfo object
                albumImageURL = track.album.largestCover.imageURL
                let albumImageData = NSData(contentsOfURL: albumImageURL)
                
                var albumImageObject = UIImage()
                if (albumImageData != nil) {
                    albumImageObject = UIImage(data: albumImageData!)!
                }
                let trackPartial = track as SPTPartialTrack
                self.pushNewTrack(trackPartial, trackImage: albumImageObject)
                
            } else {
                print("nil track in getTrackInfoForURI in TrackInfoRetrieverHelper:")
                print(error)
            }
        }
    }
    
    private func trackWithURI(compareURI: NSURL!) -> TrackInfo? {
        var sameTrack: TrackInfo? = nil
        for track in trackInfoArr {
            if ( (track.getTrackInfo()["trackURI"] as! NSURL!) == compareURI) {
                sameTrack = track
            }
        }
        return sameTrack
    }
    
    private func popPlayedTrack() {
        let requestURLString = self.playlistBaseURL + "/remove?name=" + self.playlistName
        let requestURL = NSURL(string: requestURLString)
        
        let request = NSMutableURLRequest(URL: requestURL!)
        request.HTTPMethod = "PATCH"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if (error != nil) {
                print("An error occured when creating the playlist: \n")
                print(error)
            }
        }
        task.resume()

        self.trackInfoArr.removeFirst()
        
        
    }
    
    
    // MARK: - Initializers
    
    init() {
        self.songVC = nil
        self.trackInfoArr = [TrackInfo]()
    }
}