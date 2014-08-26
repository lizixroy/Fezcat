//
//  NotificationConstants.m
//  Tweeft
//
//  Created by Zixuan Li on 8/19/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import "NotificationConstants.h"

@implementation NotificationConstants

NSString *pageDidBecomeAvailable = @"pageDidBecomeAvailable";
NSString *pageDidBecomeUnavailable = @"pageDidBecomeUnavailable";
NSString *startLoadingPage = @"startLoadingPage";
NSString *didFinishLoadingPage = @"didFinishLoadingPage";
NSString *didSyncTweets =@"didSyncTweets";
NSString *didSyncOldTweets = @"didSyncOldTweets";
NSString *didSyncNewTweets =@"didSyncNewTweets";
NSString *didGoToNextPage  = @"didGoToNextPage";
NSString *didFindMultipleAccounts = @"didFindMultipleAccounts";
NSString *didLogIn = @"didLogIn";
NSString *willLogOut = @"willLogOut";

NSString *didFailSynsTweets = @"didFailSynsTweets";
NSString *didFailSynsTweetsNotFirstTime = @"didFailSynsTweetsNotFirstTime";
NSString *didFailSyncOldTweets = @"didFailSynsOldTweets";

NSString *didFailLikeTweet = @"didFailLikeTweet";
NSString *didFailUnLikeTweet = @"didFailUnLikeTweet";
NSString *didFailRetweet = @"didFailRetweet";
NSString *didFailUndoRetweet = @"didFailUndoRetweet";
@end
