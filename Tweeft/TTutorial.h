//
//  TTutorial.h
//  Tweeft
//
//  Created by Zixuan Li on 8/24/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TTutorialType) {
    
    TTutorial_URL,
    TTutorial_main,
    
};

@interface TTutorial : NSObject

@property (nonatomic, strong) UIWindow *window;

- (id)initWithTutorialType:(TTutorialType)type;

- (void)show;

@end
