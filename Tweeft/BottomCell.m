//
//  BottomCell.m
//  BlockAndMultiThreding
//
//  Created by Zixuan Li on 1/16/14.
//  Copyright (c) 2014 TangenBox. All rights reserved.
//

#import "BottomCell.h"

@interface BottomCell()

@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UILabel *allLoadedLabel;

@end

@implementation BottomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor colorWithRed:0.9255 green:0.9412 blue:0.9451 alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}

- (void)addIndicator {
    
    [self.contentView addSubview:self.indicator];
    [self.indicator startAnimating];
    
}

- (void)removeIndicator {
    
    [self.indicator stopAnimating];
    [self.indicator removeFromSuperview];
    
}

- (void)addAllLoadedLabel {
    
    const CGFloat X_MARGIN = 10;
    const CGFloat Y_MARGIN = 10;
    const CGFloat WIDTH = 300;
    const CGFloat HEIGHT = 30;
    
    self.allLoadedLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_MARGIN, Y_MARGIN, WIDTH, HEIGHT)];
    self.allLoadedLabel.font = [UIFont fontWithName:@"Carme" size:15];
    self.allLoadedLabel.textColor = [UIColor grayColor];
    self.allLoadedLabel.textAlignment = NSTextAlignmentCenter;
    self.allLoadedLabel.text = @"All posts loaded";
    [self.contentView addSubview:self.allLoadedLabel];
    
}


#pragma mark - Lazy instantiation
-(UIActivityIndicatorView *)indicator {
    
    if (_indicator == nil) {
        
        const CGFloat HORIZONTAL_MID_POINT = [UIScreen mainScreen].bounds.size.width / 2;
        const CGFloat Y_INDICATOR = 10;
        
         _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
         _indicator.frame = CGRectMake(HORIZONTAL_MID_POINT - _indicator.bounds.size.width / 2, Y_INDICATOR, _indicator.bounds.size.width, _indicator.bounds.size.height);
        
    }
    
    return _indicator;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
