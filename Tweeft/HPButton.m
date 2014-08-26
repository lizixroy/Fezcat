//
//  HPButton.m
//  Hoopster
//
//  Created by Zixuan Li on 7/15/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import "HPButton.h"
#import "ButtonImage.h"

@implementation HPButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithNormalColor:(UIColor *)normalColor hightlightedColor:(UIColor *)hightedColor frame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIImage *normalImage = [ButtonImage buttonImageWithColor:normalColor];
        UIImage *highlightedImage = [ButtonImage buttonImageWithColor:hightedColor];
        
        [self setBackgroundImage:normalImage forState:UIControlStateNormal];
        [self setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
        
    }
    
    return self;
    
}

@end
