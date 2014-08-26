//
//  TestWebView.m
//  Tweeft
//
//  Created by Zixuan Li on 8/19/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import "TestWebView.h"

@implementation TestWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    
    NSLog(@"I am being dealloced");
    
}

@end
