//
//  TrackInfo.swift
//  Synq
//
//  Created by Matthew Carpenter on 11/10/15.
//  Copyright © 2015 cs378. All rights reserved.
//

import Foundation

class TrackInfo {
    // MARK: - Properties
    private let trackURI: NSURL!
    private let trackName: String
    private let artistNames: String
    private var albumImage: UIImage
    
    // MARK: - Methods
    func getTrackInfo()  -> [String: AnyObject] {
        let trackInfoDict:[String: AnyObject] = ["trackURI": trackURI, "trackName": trackName, "artistName": artistNames, "albumImage": albumImage]
        
        return trackInfoDict
    }
    
    // MARK: - Initializers
    init(track: SPTPartialTrack, trackImage: UIImage) {
        self.trackURI = track.playableUri
        
        self.trackName = track.name
        self.artistNames = TrackInfoRetrieverHelper.getArtistsNames(track.artists as! [SPTArtist]!)
        self.albumImage = trackImage
        
    }
}