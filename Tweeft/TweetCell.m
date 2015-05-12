//
//  TweetCell.m
//  Tweeft
//
//  Created by Juan Kou on 8/19/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import "TweetCell.h"
#import "NSString+StringSize.h"

@implementation TweetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self addUserNameLabel];
        [self addSeperator];
      
    }

    return self;
}

-(void)addUserThumbnailView {
    
    self.userThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
    self.userThumbnail.layer.cornerRadius = 25;
    self.userThumbnail.clipsToBounds = YES;
    [self.contentView addSubview:self.userThumbnail];
    
}

-(void)addUserNameLabel {
    
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 200, 20)];
    self.userNameLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:18];
    [self.contentView addSubview:self.userNameLabel];
    
}

-(void)addTextLabelForTweet:(Tweet *)tweet {
    
    self.tweetLabel = [[TTTAttributedLabel alloc] init];
    self.tweetLabel.font = [UIFont fontWithName:@"Avenir" size:16];
    self.tweetLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.tweetLabel.numberOfLines = 0;
    self.tweetLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.tweetLabel.userInteractionEnabled = YES;
    
    NSArray *keys = [[NSArray alloc] initWithObjects:(id)kCTForegroundColorAttributeName,(id)kCTUnderlineStyleAttributeName, nil];
    
    NSArray *objects;
    
    if (tweet.isRead) {
        
        objects = [[NSArray alloc] initWithObjects:[UIColor colorWithRed:0.184 green:0.506 blue:0.718 alpha:1],
                   [NSNumber numberWithInt:NSUnderlineStyleSingle], nil];
        
    } else {
        
        objects = [[NSArray alloc] initWithObjects:[UIColor colorWithRed:0.929 green:0.302 blue:0.384 alpha:1],
                   [NSNumber numberWithInt:NSUnderlineStyleSingle], nil];

    }
    
    NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    self.tweetLabel.linkAttributes = linkAttributes;
    [self.contentView addSubview:self.tweetLabel];
    
}


-(void)addRetweetButton {
    
    self.retweetButton = [[UIButton alloc] init];
    self.retweetImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 20, 12)];
    self.retweetImg.image = [UIImage imageNamed:@"retweet.png"];
    
    [self.retweetButton addSubview:self.retweetImg];
    [self.contentView addSubview:self.retweetButton];
    
   // self.retweetButton.backgroundColor = [UIColor redColor];
    

}


-(void)addLikeButton {
    
    self.likeButton = [[UIButton alloc] init];
    self.favoriteImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 15, 15)];
    self.favoriteImg.image = [UIImage imageNamed:@"like.png"];
    
    [self.likeButton addSubview:self.favoriteImg];
    [self.contentView addSubview:self.likeButton];
    
   // self.likeButton.backgroundColor = [UIColor blueColor];
}


-(void)addSeperator {
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    separator.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:separator];
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat leftPadding = 80;
    CGFloat rightPadding = 20;
    CGFloat width = screenWidth - leftPadding - rightPadding;
    CGFloat text_height = [NSString getStringSizeWithString:self.tweetLabel.text font:self.tweetLabel.font width:width].size.height;
    self.tweetLabel.frame = CGRectMake(80, 45, width, text_height + 5);
    
}

-(void)constructCellWithTweet:(Tweet *)tweet Cell:(TweetCell *)cell {
    
    [cell addTextLabelForTweet:tweet];
    [cell addUserThumbnailView];
    [cell addRetweetButton];
    [cell addLikeButton];
    cell.tweetLabel.text = tweet.text;
    cell.userNameLabel.text = tweet.user_name;
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat leftPadding = 80;
    CGFloat rightPadding = 20;
    CGFloat width = screenWidth - leftPadding - rightPadding;
    CGFloat text_height = [NSString getStringSizeWithString:self.tweetLabel.text font:self.tweetLabel.font width:width].size.height;
    
    if (tweet.media_url == nil) {
        
        cell.retweetButton.frame = CGRectMake(80, 55 + text_height,  40, 40);
        cell.likeButton.frame = CGRectMake(130, 53 + text_height, 40, 40);
        
    } else {
        
        self.media = [[UIImageView alloc] initWithFrame:CGRectMake(leftPadding, 55 + text_height, width, tweet.media_image_height * width / tweet.media_image_width)];
        [self.contentView addSubview:self.media];
        self.media.userInteractionEnabled = YES;
        cell.retweetButton.frame = CGRectMake(80, 75 + text_height + tweet.media_image_height * width / tweet.media_image_width, 35, 25);
        cell.likeButton.frame = CGRectMake(130, 73 + text_height + tweet.media_image_height * width / tweet.media_image_width, 40, 40);

    }
    
    if (tweet.favorited) {
        
        self.favoriteImg.image = [UIImage imageNamed:@"liked.png"];
    }
    
    if (tweet.retweeted) {
        
        self.retweetImg.image = [UIImage imageNamed:@"retweeted.png"];
    }

}

- (void)prepareForReuse {
    
    [self.media removeFromSuperview];
    self.media = nil;
    
    [self.userThumbnail removeFromSuperview];
    self.userThumbnail = nil;
    
    [self.tweetLabel removeFromSuperview];
    self.tweetLabel = nil;
    
    [self.retweetButton removeFromSuperview];
    self.retweetButton = nil;

    [self.likeButton removeFromSuperview];
    self.likeButton = nil;

}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
