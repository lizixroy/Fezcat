//
//  ButtonImage.m
//  Hoopster
//
//  Created by Zixuan Li on 7/8/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import "ButtonImage.h"

@implementation ButtonImage

+ (UIImage *)buttonImageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

@end
