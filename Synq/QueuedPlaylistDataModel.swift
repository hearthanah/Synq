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
        
        let wasEmpty = trackInfoArr.isEmpty
        
        self.trackInfoArr.append(TrackInfo(track: track, trackImage: trackImage))
        
        // if the playlist was empty when adding the track restart the player with the new song
        if wasEmpty {
            let uri = getURIForCurrentTrack()
            songVC!.changeToSongWithURI(uri)
        }
    }
    
    func removeTrackInfoAtIndex(index: Int) {
        self.trackInfoArr.removeAtIndex(index)
    }
    
    private func popPlayedTrack() {
        self.trackInfoArr.removeFirst()
    }
    
    func count() -> Int {
        return self.trackInfoArr.count
    }
    
    // MARK: - Initializers
    
    init() {
        self.songVC = nil
        self.trackInfoArr = [TrackInfo]()
    }
}