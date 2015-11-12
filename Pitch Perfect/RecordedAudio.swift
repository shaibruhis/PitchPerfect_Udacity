//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Shai Bruhis on 11/7/15.
//  Copyright © 2015 Shai Bruhis. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(fileUrl url: NSURL, fileTitle title:String) {
        filePathUrl = url
        self.title = title
    }
}