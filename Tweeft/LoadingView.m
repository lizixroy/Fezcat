//
//  LoadingView.m
//  BlockAndMultiThreding
//
//  Created by Zixuan Li on 2/6/14.
//  Copyright (c) 2014 TangenBox. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:1];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        indicator.frame = CGRectMake(160 - indicator.bounds.size.width / 2, 60, indicator.frame.size.height, indicator.frame.size.width);
        
        [indicator startAnimating];
        
        [self addSubview:indicator];
        
    }
    
    return self;
}

@end
