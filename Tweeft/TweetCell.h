//
//  TweetCell.h
//  Tweeft
//
//  Created by Juan Kou on 8/19/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "Tweet.h"

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) UIImageView *userThumbnail;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) TTTAttributedLabel *tweetLabel;
@property (nonatomic, strong) UIImageView *media;
@property (nonatomic, strong) NSString *media_url;
@property (nonatomic, strong) UIButton *retweetButton;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIImageView *retweetImg;
@property (nonatomic, strong) UIImageView *favoriteImg;

-(void)addUserThumbnailView;
-(void)addTextLabel;

-(void)constructCellWithTweet:(Tweet *)tweet Cell:(TweetCell *)cell;
@end
