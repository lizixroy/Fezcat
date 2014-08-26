//
//  NSString+StringSize.m
//  BlockAndMultiThreding
//
//  Created by Zixuan Li on 11/28/13.
//  Copyright (c) 2013 TangenBox. All rights reserved.
//

#import "NSString+StringSize.h"

@implementation NSString (StringSize)

+ (CGRect)getStringSizeWithString:(NSString *)string font:(UIFont *)font width:(float)width {
    
    NSDictionary *nameDictionary = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGRect frame = [string boundingRectWithSize:CGSizeMake(width, 0.0) options: NSStringDrawingUsesLineFragmentOrigin attributes:nameDictionary context:nil];
    
    return frame;
}

@end
