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
    
    // MARK: - Methods
    
    // returns an dictionary with the track's info accessable as AnyObject
    // type values by a string key
    func getInfoForTrackAtIndex(index: Int) -> [String: AnyObject] {
        return trackInfoArr[index].getTrackInfo()
    }
    
    func pushNewTrack(track: SPTPartialTrack, trackImage: UIImage) {
        self.trackInfoArr.append(TrackInfo(track: track, trackImage: trackImage))
    }
    
    // TODO: - Implement removeTrackInfoAtIndex in QueuedPlaylistDataModel
    func removeTrackInfoAtIndex(index: Int) {
        self.trackInfoArr.removeAtIndex(index)
    }
    
    // TODO: - Implement popPlayedTrack in QueuedPlaylistDataModel
    func popPlayedTrack() {
        self.trackInfoArr.removeFirst()
    }
    
    func count() -> Int {
        return self.trackInfoArr.count
    }
    
    // MARK: - Initializers
    
    init() {
        self.trackInfoArr = [TrackInfo]()
    }
}