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
        
        self.backgroundColor = [UIColor whiteColor];
        
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 130, 240, 90)];
        _placeholderLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:20];
        _placeholderLabel.textColor = [UIColor colorWithRed:0.607843 green:0.607843 blue:0.607843 alpha:1];
        _placeholderLabel.textAlignment = NSTextAlignmentCenter;
        _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeholderLabel.numberOfLines = 0;
        [self addSubview:_placeholderLabel];
        
        
        _placeholderLabel.text = @"Opps.\n Something is wrong. Please check your network connection.";
        
        //add imageview
        _placeholderImageView = [[UIImageView alloc] init];
        _placeholderImageView.image = [UIImage imageNamed:@"bird.png"];
        _placeholderImageView.frame = CGRectMake(75, 100, 171, 125);
       
        
    }
    
    return self;
}




@end
