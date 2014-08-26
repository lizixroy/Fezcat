//
//  DeviceAndModelTool.h
//  Mallocu
//
//  Created by Zixuan Li on 3/24/14.
//  Copyright (c) 2014 TangenBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceAndModelTool : NSObject

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

+ (CGFloat)deviceHeight;

@end
