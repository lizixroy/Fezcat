//
//  Tweet.h
//  Tweeft
//
//  Created by Juan Kou on 8/19/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *tweet_id;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *user_thumbnail_url;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *screen_name;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSUInteger *retweet_count;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic) NSUInteger media_image_width;
@property (nonatomic) NSUInteger media_image_height;
@property (nonatomic) NSString *media_url;
@property (nonatomic) NSString *retweet_id;
@property (nonatomic) BOOL isRead;

@end
