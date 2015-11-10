//
//  QueuedPlalistDataModel.swift
//  Synq
//
//  Created by Matthew Carpenter on 11/10/15.
//  Copyright © 2015 cs378. All rights reserved.
//

import Foundation

class QueuedPlalistDataModel {
    // MARK: - Properties
    
    private var trackInfoArr:[TrackInfo]
    
    // MARK: - Methods
    
    // returns an dictionary with the track's info accessable as AnyObject
    // type values by a string key
    func getTrackInfoForTrackAtIndex(index: Int) -> [String: AnyObject] {
        return ["error": "Need to implement getInfoForTrackAtIndex in QueuedPlaylistDataModel"]
    }
    
    // MARK: - Initializers
    
    init() {
        self.trackInfoArr = [TrackInfo]()
    }
}