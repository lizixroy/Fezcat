//
//  NotificationConstants.h
//  Tweeft
//
//  Created by Zixuan Li on 8/19/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationConstants : NSObject

extern NSString *pageDidBecomeAvailable;
extern NSString *pageDidBecomeUnavailable;
extern NSString *startLoadingPage;
extern NSString *didFinishLoadingPage;
extern NSString *didSyncTweets;
extern NSString *didSyncOldTweets;
extern NSString *didSyncNewTweets;
extern NSString *didGoToNextPage;
extern NSString *didFindMultipleAccounts;
extern NSString *didLogIn;
extern NSString *willLogOut;

extern NSString *didFailSynsTweets;
extern NSString *didFailSynsTweetsNotFirstTime;
extern NSString *didFailSyncOldTweets;

extern NSString *didFailLikeTweet;
extern NSString *didFailUnLikeTweet;
extern NSString *didFailRetweet;
extern NSString *didFailUndoRetweet;

@end
