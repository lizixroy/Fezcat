//
//  TwitterManager.m
//  TwitterIntegration
//
//  Created by Juan Kou on 8/7/14.
//  Copyright (c) 2014 JUANKOU. All rights reserved.
//

#import "TwitterManager.h"
#import "DefaultManager.h"

//number of tweets to load in a single API fetch
const NSUInteger LOAD_TWEET_BATCH_NUMBER = 40;

@interface TwitterManager()

@property (nonatomic) ACAccountStore *accountStore;

@end

@implementation TwitterManager

+ (TwitterManager *)sharedObject {
    
    static TwitterManager *__sharedObject;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedObject = [[TwitterManager alloc] init];
    });
    
    return __sharedObject;
    
}

- (void)signin {
    
    if ([self userHasAccessToTwitter]) {
        
        ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
            
            if (granted) {
                
                //fetch all accounts of user
                NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
                
                if (twitterAccounts.count > 1) {
                    
                    NSArray *accounts = [NSArray arrayWithArray:twitterAccounts];
                    [[NSNotificationCenter defaultCenter] postNotificationName:didFindMultipleAccounts
                                                                        object:nil
                                                                      userInfo:@{@"accounts" : accounts}];
                    
                } else {
                    
                    self.account = twitterAccounts.firstObject;
                    DefaultManager *defaultManager = [[DefaultManager alloc] init];
                    [defaultManager setLoggedInAccountIdentifier:self.account.identifier];
                    [defaultManager setLoggedIn:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:didLogIn object:nil];
                    
                }
                
            } else {
                
               //access denied
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self showAccessDeniedAlert];
                    
                    
                });
            }
            
        }];
        
        
    } else {
        
        //access denied
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showAccessDeniedAlert];
            
        });
        
    }
    
}

- (void)showAccessDeniedAlert {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot sign in with Twitter"
                                                    message:@"Please check your Twitter name/password and allow Fezcat to use your Twitter account in iOS system settings"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    
    [alert show];
    
}


- (void)signinWithAccount:(ACAccount *)account {
    
    NSLog(@"%@", account.identifier);
    
    self.account = account;
    DefaultManager *defaultManager = [[DefaultManager alloc] init];
    [defaultManager setLoggedInAccountIdentifier:self.account.identifier];
    [defaultManager setLoggedIn:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:didLogIn object:nil];
    
}

- (void)logout {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:willLogOut object:nil];
    
    DefaultManager *defaultManager = [[DefaultManager alloc] init];
    [defaultManager setLoggedInAccountIdentifier:nil];
    [defaultManager setLoggedIn:NO];
    self.oldestTweetId = nil;
    self.newestTweetId = nil;
    
}

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController
            isAvailableForServiceType:SLServiceTypeTwitter];
}



- (void)fetchNewTweets {
    
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType =
        [self.accountStore accountTypeWithAccountTypeIdentifier:
         ACAccountTypeIdentifierTwitter];
        
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                               @"/1.1/statuses/home_timeline.json"];
                 
                 NSDictionary *params;
                 
                 if ([self.newestTweetId isEqualToString:@"0"]) {
                     
                     params = @{@"screen_name" : self.account.username,
                                              @"include_rts" : @"1",
                                              @"count" : [NSString stringWithFormat:@"%lu", (unsigned long)LOAD_TWEET_BATCH_NUMBER]
                                              };
                     
                 } else {
                     
                     params = @{@"screen_name" : self.account.username,
                                              @"include_rts" : @"1",
                                              @"count" : [NSString stringWithFormat:@"%lu", (unsigned long)LOAD_TWEET_BATCH_NUMBER],
                                              @"since_id" : self.newestTweetId};
                     
                 }
        
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodGET
                                              URL:url
                                       parameters:params];
                 
                 //  Attach an account to the request
                 [request setAccount:self.account];
                 
                 //  Step 3:  Execute the request
                 [request performRequestWithHandler:
                  ^(NSData *responseData,
                    NSHTTPURLResponse *urlResponse,
                    NSError *error) {
                      
                      if (responseData) {
                          if (urlResponse.statusCode >= 200 &&
                              urlResponse.statusCode < 300) {
                              
                              NSError *jsonError;
                              NSArray *timelineData =
                              [NSJSONSerialization
                               JSONObjectWithData:responseData
                               options:NSJSONReadingAllowFragments error:&jsonError];
                              
                              if (timelineData) {
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      [self convertTweets:timelineData type:YES];
                                      
                                      [[NSNotificationCenter defaultCenter] postNotificationName:didSyncNewTweets object:nil];
                                      
                                      
                                  });
                                  
                              }
                              
                              else {
                                  // Our JSON deserialization went awry
                                  NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                              }
                          }
                          else {
                              
                              NSLog(@"The response status code is %ld",
                                    (long)urlResponse.statusCode);
                              // The server did not respond ... were we rate-limited?
                              if ([self.newestTweetId isEqualToString:@"0"]) {
                                  
                                  [[NSNotificationCenter defaultCenter] postNotificationName:didFailSynsTweets object:nil];
                                  
                              }
                          }
                      } else {
                          
                          //no response.
                          if ([self.newestTweetId isEqualToString:@"0"]) {
                              
                              [[NSNotificationCenter defaultCenter] postNotificationName:didFailSynsTweets object:nil];
                              
                          } else {
                              
                              [[NSNotificationCenter defaultCenter] postNotificationName:didFailSynsTweetsNotFirstTime object:nil];
                          }

                      }
                  }];
             }
             
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
             }
             
         }];
    }
    
}

- (void)fetchOldTweets {
    
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType =
        [self.accountStore accountTypeWithAccountTypeIdentifier:
         ACAccountTypeIdentifierTwitter];
        
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 
                 
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                               @"/1.1/statuses/home_timeline.json"];
                 NSDictionary *params = @{@"screen_name" : self.account.username,
                                          @"include_rts" : @"1",
                                          @"count" : [NSString stringWithFormat:@"%lu", (unsigned long)LOAD_TWEET_BATCH_NUMBER],
                                          @"max_id" : self.oldestTweetId};
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodGET
                                              URL:url
                                       parameters:params];
                 
                 //  Attach an account to the request
                 [request setAccount:self.account];
                 
                 //  Step 3:  Execute the request
                 [request performRequestWithHandler:
                  ^(NSData *responseData,
                    NSHTTPURLResponse *urlResponse,
                    NSError *error) {
                      
                      if (responseData) {
                          if (urlResponse.statusCode >= 200 &&
                              urlResponse.statusCode < 300) {
                              
                              NSError *jsonError;
                              NSArray *timelineData =
                              [NSJSONSerialization
                               JSONObjectWithData:responseData
                               options:NSJSONReadingAllowFragments error:&jsonError];
                              
                              if (timelineData) {
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      [self convertTweets:timelineData type:NO];
                
                                      [[NSNotificationCenter defaultCenter] postNotificationName:didSyncOldTweets object:nil];
                                      
                                      
                                  });
                                  
                              }
                              
                              else {
                                  // Our JSON deserialization went awry
                                  NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                                  [[NSNotificationCenter defaultCenter] postNotificationName:didFailSyncOldTweets object:nil];
                              }
                          }
                          else {
                              // The server did not respond ... were we rate-limited?
                              NSLog(@"The response status code is %ld",
                                    (long)urlResponse.statusCode);
                              [[NSNotificationCenter defaultCenter] postNotificationName:didFailSyncOldTweets object:nil];
                          }
                      } else {
                          
                           [[NSNotificationCenter defaultCenter] postNotificationName:didFailSyncOldTweets object:nil];
                      }
                  }];
             }
             
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
             }
             
         }];
    }
    
}


- (NSMutableDictionary *)cachedThumbnail {
    
    if (_cachedThumbnail == nil) {
        
        _cachedThumbnail = [[NSMutableDictionary alloc] init];
    }
    
    return _cachedThumbnail;
}

- (NSMutableDictionary *)cachedMedia {
    
    if (_cachedMedia == nil) {
        
        _cachedMedia = [[NSMutableDictionary alloc] init];
    }
    
    return _cachedMedia;
}

/**
 *convert JSON from Twitter API to Tweets objects
 *@param id responseObject
 *@return void
 */
- (void)convertTweets:(id)responseObject type:(BOOL)shouldSetNewestId {
    
    for (NSDictionary *d in responseObject) {
        NSLog(@"%@", d);
        break;
    }
    
    self.tweets = nil;
    
    NSAssert(responseObject != nil, @"Response object should not be nil");
    
    for (NSDictionary *tweetDictionary in responseObject) {
        
        Tweet *tweet = [[Tweet alloc] init];
        
        NSString *profile_image_url = [[tweetDictionary objectForKey:@"user"] objectForKey:@"profile_image_url"];
        profile_image_url = [profile_image_url stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
        tweet.user_thumbnail_url = profile_image_url;
        tweet.user_name = [[tweetDictionary objectForKey:@"user"] objectForKey:@"name"];
        tweet.user_id = [[tweetDictionary objectForKey:@"user"] objectForKey:@"id_str"];
        tweet.screen_name = [[tweetDictionary objectForKey:@"user"] objectForKey:@"screen_name"];
        tweet.text = [tweetDictionary objectForKey:@"text"];

        NSDictionary *retweetedStatus = [tweetDictionary objectForKey:@"retweeted_status"];
        if (retweetedStatus != nil) {
            
            NSString *untruncatedTweet = [retweetedStatus objectForKey:@"text"];
            NSString *screenName = [[retweetedStatus objectForKey:@"user"] objectForKey:@"screen_name"];
            NSString *text = [NSString stringWithFormat:@"RT @%@: %@", screenName, untruncatedTweet];
            tweet.text = text;
            
        }
        
        NSNumber *retweeted = [tweetDictionary objectForKey:@"retweeted"];
        if ([retweeted isEqualToNumber:[NSNumber numberWithInt:0]]) {
            
            tweet.retweeted = NO;
        } else {
            
            tweet.retweeted = YES;
        }
    
        
        NSNumber *favorited = [tweetDictionary objectForKey:@"favorited"];
        
        if ([favorited isEqualToNumber:[NSNumber numberWithInt:0]]) {
            
            tweet.favorited = NO;
        } else {
            
            tweet.favorited = YES;
        }
        
        
        if ([tweetDictionary objectForKey:@"entities"] != nil) {
            
            if ([[tweetDictionary objectForKey:@"entities"] objectForKey:@"media"] != nil) {
                
                NSArray *medias = [[tweetDictionary objectForKey:@"entities"] objectForKey:@"media"];
                NSDictionary *media =[medias objectAtIndex:0];
                tweet.media_url = [media objectForKey:@"media_url"];
                CGFloat height = [[[[media objectForKey:@"sizes"] objectForKey:@"medium"] objectForKey:@"h"] floatValue] ;
                CGFloat width = [[[[media objectForKey:@"sizes"] objectForKey:@"medium"] objectForKey:@"w"] floatValue] ;
                tweet.media_image_height = height;
                tweet.media_image_width = width;
                // remove the media url from text
                NSString *display_url = [media objectForKey:@"url"];
                tweet.text = [tweet.text stringByReplacingOccurrencesOfString:display_url withString:@""];
                
            }
            
        }
        
        tweet.tweet_id = [[tweetDictionary objectForKey:@"id"] stringValue];            
        [self.tweets addObject:tweet];
    }
    
    [self sortTweets];
    
    if (shouldSetNewestId) {
        
        [self setNewestTweetId];
    }

}

/**
 *Twitter API has trailing image URL. Trim this out
 *@return void
 */
- (NSString *)trimText:(NSString *)text fromIndex:(NSUInteger)index {
   
    NSString *trimedString = [text substringToIndex:index];
    return trimedString;
    
}

-(void)sortTweets {
    
    [self.tweets sortUsingComparator:^NSComparisonResult(Tweet * t1, Tweet *t2) {
        if ([t1.tweet_id intValue] < [t2.tweet_id intValue]) return NSOrderedDescending;
        else return NSOrderedAscending;
    }];
}

-(void)setNewestTweetId {
    
    if (self.tweets.count != 0) {
        
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tweet_id"
                                                     ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedArray;
        sortedArray = [self.tweets sortedArrayUsingDescriptors:sortDescriptors];
        
        Tweet *tweet = [sortedArray firstObject];
        self.newestTweetId =  tweet.tweet_id;
    }
    
}

-(void)resetOldestTweetId:(NSArray *)allTweets {
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tweet_id"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [allTweets sortedArrayUsingDescriptors:sortDescriptors];
    
    Tweet *tweet = [sortedArray firstObject];
    self.oldestTweetId =  tweet.tweet_id;
    
}

-(void)like:(NSString *)tweetId {
    
    NSDictionary *params = @{@"id" : tweetId
               };
    
    SLRequest *twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/favorites/create.json"] parameters:params];
    
    [twitterRequest setAccount:self.account];
    
    [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([urlResponse statusCode] == 429) {
                NSLog(@"Rate limit reached");
                return;
            }
            
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
                [[NSNotificationCenter defaultCenter] postNotificationName:didFailLikeTweet object:nil];
                
                return;
            }
            
            
        });
    }];

}

-(void)unlike:(NSString *)tweetId {
    
    NSDictionary *params = @{@"id" : tweetId
                             };
    
    SLRequest *twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/favorites/destroy.json"] parameters:params];
    
    [twitterRequest setAccount:self.account];
    
    [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([urlResponse statusCode] == 429) {
                NSLog(@"Rate limit reached");
                return;
            }
            
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
                [[NSNotificationCenter defaultCenter] postNotificationName:didFailUnLikeTweet object:nil];

                return;
            }
            
        });
    }];

}

-(void)retweet:(Tweet *)tweet {
    
    SLRequest *twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/%@.json",tweet.tweet_id]] parameters:nil];
    
    [twitterRequest setAccount:self.account];
    
    [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([urlResponse statusCode] == 429) {
                NSLog(@"Rate limit reached");
                return;
            }
            
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
                [[NSNotificationCenter defaultCenter] postNotificationName:didFailRetweet object:nil];

                return;
            }
            
            NSError *jsonError;
            NSDictionary *rewteet =
            [NSJSONSerialization
             JSONObjectWithData:responseData
             options:NSJSONReadingAllowFragments error:&jsonError];
            
            tweet.retweet_id = [rewteet objectForKey:@"id"];
        });
    }];
    
}

-(void)undoretweet:(NSString *)retweetId {
    
    SLRequest *twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/destroy/%@.json",retweetId]] parameters:nil];
    
    [twitterRequest setAccount:self.account];
    
    [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([urlResponse statusCode] == 429) {
                NSLog(@"Rate limit reached");
                return;
            }
            
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
                [[NSNotificationCenter defaultCenter] postNotificationName:didFailUndoRetweet object:nil];

                return;
            }
            
        });
    }];
    
}

- (void)updateAccount {
    
    ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
    DefaultManager *defaultManager = [[DefaultManager alloc] init];
    NSString *currentIdentifier = [defaultManager loggedInAccountIdentifier];
    
    for (ACAccount *account in twitterAccounts) {
        
        if ([account.identifier isEqualToString:currentIdentifier]) {
            
            self.account = account;
            
        }
        
    }
    
}

- (BOOL)stillLoggedIn {
    
    ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
    DefaultManager *defaultManager = [[DefaultManager alloc] init];
    NSString *currentAccountIdentifier = [defaultManager loggedInAccountIdentifier];
    
    if (currentAccountIdentifier != nil) {
    
        for (ACAccount *account in twitterAccounts) {
            
            if ([account.identifier isEqualToString:currentAccountIdentifier]) {
                return YES;
            }
            
        }
        
        return NO;
        
    } else {
        
        return NO;
        
    }
    
}

#pragma mark - lazy instantiation

- (NSMutableArray *)tweets {
    
    if (_tweets == nil) {
        
        _tweets = [[NSMutableArray alloc] init];
        
    }
    
    return _tweets;
}

- (ACAccountStore *)accountStore {
    
    if (_accountStore == nil) {
        
        _accountStore = [[ACAccountStore alloc] init];

    }
    
    return  _accountStore;
}

-(NSString *)oldestTweetId {
    
    if (_oldestTweetId == nil) {
        
        _oldestTweetId = @"0";
    }
    
    return _oldestTweetId;
}

-(NSString *)newestTweetId {
    
    if (_newestTweetId == nil) {
        
        _newestTweetId = @"0";
    }
    
    return _newestTweetId;
}

- (void)cleanCacheExceptForUrls:(NSMutableArray *)urls names:(NSMutableArray *)names {
    
    NSMutableDictionary *neededMedia = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *neededThumbnails = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in self.cachedMedia) {
        for (NSString *url in urls) {
            if ([key isEqualToString:url]) {
                [neededMedia setObject:[self.cachedMedia objectForKey:key] forKey:key];
                break;
            }
        }
    }
    
    for (NSString *key in self.cachedThumbnail) {
        for (NSString *name in names) {
            if ([key isEqualToString:name]) {
                [neededThumbnails setObject:[self.cachedThumbnail objectForKey:key] forKey:key];
                break;
            }
        }
    }
    
    [self.cachedMedia removeAllObjects];
    [self.cachedThumbnail removeAllObjects];
    
    self.cachedMedia = neededMedia;
    self.cachedThumbnail = neededThumbnails;
    
}

@end