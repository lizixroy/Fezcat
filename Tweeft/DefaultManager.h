//
//  DefaultManager.h
//  Tweeft
//
//  Created by Zixuan Li on 8/24/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultManager : NSObject

- (void)setLoggedInAccountIdentifier:(NSString *)identifier;
- (void)setLoggedIn:(BOOL)isLoggedIn;

/**
 *set value to indicate whether tutorial is showed
 *@return NSString
 **/
- (void)setTutorialIsShowed:(BOOL)isTutorialShowed;


/**
 *get current logged in account identifier
 *@return NSString
 */
- (NSString *)loggedInAccountIdentifier;

/**
 *check whether user is logged in
 *@return void
 */
- (BOOL)isLoggedIn;

/**
 *check whether tutorial is showed 
 *@return void
 */
- (BOOL)isTutorialShowed;

@end
