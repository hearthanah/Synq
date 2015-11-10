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
    private let albumImage: UIImage
    
    // MARK: - Methods
    func getTrackInfo()  -> [String: AnyObject] {
        let trackInfoDict:[String: AnyObject] = ["trackURI": trackURI, "trackName": trackName, "artistNames": artistNames, "albumImage": albumImage]
        
        return trackInfoDict
    }
    
    // MARK: - Initializers
    init(trackURI: NSURL!) {
        self.trackURI = trackURI
        // TODO: use TrackInfoRetrieverHelper to pull the other info
        self.trackName = "NEED TO FINISH TRACKINFO INITIALIZER"
        self.artistNames = "NEED TO FINISH TRACKINFO INITIALIZER"
        self.albumImage = UIImage()
    }
}