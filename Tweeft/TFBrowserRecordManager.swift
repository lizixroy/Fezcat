//
//  TFBrowserRecordManager.swift
//  Tweeft
//
//  Created by Zixuan Li on 5/12/15.
//  Copyright (c) 2015 Mallocu. All rights reserved.
//

import RealmSwift

class TFBrowserRecordManager: NSObject {
    
    func createRecordWithTweeft(tweet: Tweet) {
        
        // check if record already exists
        let realm = Realm()
        let predicate = NSPredicate(format: "user_id = %@", tweet.user_id!)
        var result = realm.objects(TFBrowseRecord).filter(predicate)
        print(realm.path)
        
        if result.count > 0 {
            
            var record: TFBrowseRecord = result.first!
            realm.write {
                record.viewCount = record.viewCount + 1
            }
            
        } else {
            
            let record = TFBrowseRecord()
            if let user_id = tweet.user_id {
                record.user_id = user_id
            }
            
            if let user_name = tweet.user_name {
                record.sharerName = user_name
            }
            
            record.viewCount = 1
            realm.write {
                realm.add(record)
            }
            
        }
        
    }
    
}
