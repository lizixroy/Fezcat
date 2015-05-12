//
//  PlaceholderView.m
//  BlockAndMultiThreding
//
//  Created by Zixuan Li on 10/20/13.
//  Copyright (c) 2013 TangenBox. All rights reserved.
//

#import "PlaceholderView.h"

@interface PlaceholderView()
@end

@implementation PlaceholderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:1];
    
    if (self) {
                
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat thumbnailDimension = 80;
        CGFloat x = (screenWidth - 60) / 2;
        UIImageView *thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 100, 60, thumbnailDimension)];
        thumbnailView.image = [UIImage imageNamed:@"thumbnail03.png"];
        [self addSubview:thumbnailView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 170, screenWidth - 80, 100)];
        label.textColor = [UIColor colorWithRed:0.290 green:0.565 blue:0.886 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Avenir" size:18];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.text = @"Looks like something is wrong, please try again in a minute.";
        [self addSubview:label];
        self.backgroundColor = [UIColor colorWithRed:0.961 green:0.973 blue:0.980 alpha:1];//[UIColor whiteColor];
        
    }
    
    return self;
}


@end
