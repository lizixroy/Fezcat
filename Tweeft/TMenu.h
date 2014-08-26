//
//  TMenu.h
//  Tweeft
//
//  Created by Zixuan Li on 8/19/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PageLoader;
@interface TMenu : NSObject

@property (nonatomic, strong) UIWindow *window;

- (id)initWithCurrentURL:(NSURL *)url pageLoader:(PageLoader *)pageLoader;

- (void)showMenu;

@end
