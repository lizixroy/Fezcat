//
//  DeviceAndModelTool.m
//  Mallocu
//
//  Created by Zixuan Li on 3/24/14.
//  Copyright (c) 2014 TangenBox. All rights reserved.
//

#import "DeviceAndModelTool.h"

@implementation DeviceAndModelTool

+ (CGFloat)deviceHeight {
    
    if (IS_IPHONE_5) {
        
        return 568;
        
    } else  {

        return 480;
        
    }
    
}

@end
