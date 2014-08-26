//
//  NSString+StringSize.h
//  BlockAndMultiThreding
//
//  Created by Zixuan Li on 11/28/13.
//  Copyright (c) 2013 TangenBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringSize)

+ (CGRect)getStringSizeWithString:(NSString *)string font:(UIFont *)font width:(float)width;

@end
