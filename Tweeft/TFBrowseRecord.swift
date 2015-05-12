//
//  TFBrowseRecord.swift
//  Tweeft
//
//  Created by Zixuan Li on 5/11/15.
//  Copyright (c) 2015 Mallocu. All rights reserved.
//

import RealmSwift

class TFBrowseRecord: Object {
    
    dynamic var user_id: NSString?
    dynamic var sharerName: NSString?
    dynamic var viewCount: Int = 0
    
}
