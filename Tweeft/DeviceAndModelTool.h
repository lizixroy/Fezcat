//
//  DeviceAndModelTool.h
//  Mallocu
//
//  Created by Zixuan Li on 3/24/14.
//  Copyright (c) 2014 TangenBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceAndModelTool : NSObject

#define IS_IPHONE_6_PLUS ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )
#define IS_IPHONE_6      ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_5      ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_4      ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

+ (CGFloat)deviceHeight;

@end
