//
//  TestViewController.h
//  Tweeft
//
//  Created by Juan Kou on 8/19/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "TweetCell.h"

@class PageLoader;

@interface TimelineViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, TTTAttributedLabelDelegate, UIActionSheetDelegate, TweetCellDelegate>

@property (nonatomic, strong) PageLoader* pageLoader;

@end
