//
//  LibraryAPI.swift
//  Emotions
//
//  Created by Jide O on 11/19/16.
//  Copyright © 2016 Bevi Mobile. All rights reserved.
//

import Foundation

private let _sharedInstance: LibraryAPI = LibraryAPI()

class LibraryAPI: NSObject {
    var cameraType: CameraType
    
    class func sharedInstance() -> LibraryAPI {
        return _sharedInstance
    }
    
    override init() {
        cameraType = .Front
        super.init()
    }
    
    func getCameraType() -> CameraType {
        return cameraType
    }
}
