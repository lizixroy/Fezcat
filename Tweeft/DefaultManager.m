//
//  DefaultManager.m
//  Tweeft
//
//  Created by Zixuan Li on 8/24/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import "DefaultManager.h"

#define ACCOUNT_IDENTIFIER @"ACCOUNT_IDENTIFIER"
#define LOG_IN @"LOG_IN"
#define TUTORIAL_SHOWED @"TUTORIAL_SHOWED"

@implementation DefaultManager

- (void)setLoggedInAccountIdentifier:(NSString *)identifier {
    
    [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:ACCOUNT_IDENTIFIER];
    [self sync];
}

- (void)setLoggedIn:(BOOL)isLoggedIn {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isLoggedIn] forKey:LOG_IN];
    [self sync];
    
}

- (void)setTutorialIsShowed:(BOOL)isTutorialShowed {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isTutorialShowed] forKey:TUTORIAL_SHOWED];
    [self sync];
}

- (void)sync {
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString *)loggedInAccountIdentifier {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_IDENTIFIER];
    
}

- (BOOL)isLoggedIn {
    
    NSNumber *isLoggedIn = [[NSUserDefaults standardUserDefaults] objectForKey:LOG_IN];
    if (isLoggedIn == nil) {
        
        return NO;
        
    } else {
        
        return isLoggedIn.boolValue;
        
    }
    
}

- (BOOL)isTutorialShowed {
    
    NSNumber *isTutorialShowed = [[NSUserDefaults standardUserDefaults] objectForKey:TUTORIAL_SHOWED];
    if (isTutorialShowed == nil) {
        
        return NO;
        
    } else {
        
        return isTutorialShowed.boolValue;
        
    }
    
}

@end
