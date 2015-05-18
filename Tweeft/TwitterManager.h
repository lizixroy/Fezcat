//
//  TwitterManager.h
//  TwitterIntegration
//
//  Created by Juan Kou on 8/7/14.
//  Copyright (c) 2014 JUANKOU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "NotificationConstants.h"
#import <Twitter/Twitter.h>
#import "Tweet.h"
#import "NSString+StringSize.h"

@interface TwitterManager : NSObject

@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) NSMutableDictionary *cachedThumbnail;
@property (nonatomic, strong) NSMutableDictionary *cachedMedia;
@property (nonatomic, strong) NSString *newestTweetId;
@property (nonatomic, strong) NSString *oldestTweetId;
@property (nonatomic, strong) ACAccount *account;

/**
 * sign in user
 *@return void
 */
- (void)signin;

/**
 * when multiple account available. sign in with chosen one
 *@return void
 */
- (void)signinWithAccount:(ACAccount *)account;

/**
 * log out current account
 *@return void
 */
- (void)logout;

/**
 *fetch new tweets of logged in account
 *@return void
 */
- (void)fetchNewTweets;

/**
 *fetch previous tweets of logged in account
 *@return void
 */
- (void)fetchOldTweets;

/**
 *reset oldest tweet id for next fetch
 *@return void
 */
- (void)resetOldestTweetId:(NSArray *)allTweets;

/**
 *retweet a tweet
 *@return void
 */
- (void)retweet:(Tweet *)tweetId;

/**
 *favorite a tweet
 *@return void
 */
- (void)like:(NSString *)tweetId;

/**
 *unfavorite a tweet
 *@return void
 */
- (void)unlike:(NSString *)tweetId;

/**
 *undo retweet when probelms occure
 *@return void
 */
- (void)undoretweet:(NSString *)retweetId;

/**
 *set logged in user when app relaunches
 *@return void
 */
- (void)updateAccount;

/**
 * check whether active Twitter account is still logged in on device.
 * @return BOOL
 */
- (BOOL)stillLoggedIn;

/**
 * singleton
 * @return TwitterManager
 */
+ (TwitterManager *)sharedObject;

/**
 * clean all the cached resoueces to release memory back to the system
 */
- (void)cleanCacheExceptForUrls:(NSMutableArray *)urls names:(NSMutableArray *)names;

@end
