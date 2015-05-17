//
//  AppDelegate.m
//  Tweeft
//
//  Created by Zixuan Li on 8/18/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import "AppDelegate.h"
#import "PocketAPI.h"
#import "WalkthroughViewController.h"
#import "TwitterManager.h"
#import "DefaultManager.h"
#import "NotificationConstants.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[PocketAPI sharedAPI] setConsumerKey:@"31160-6f0085e8ae7296b4b152f1b2"];    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName:[UIFont fontWithName:@"Avenir" size:22],
                                                           NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    DefaultManager *defaultManager = [[DefaultManager alloc] init];
    
    //check whether user is logged in
    if (!defaultManager.isLoggedIn) {
        
        [self.window makeKeyAndVisible];
        WalkthroughViewController *wtvc = [[WalkthroughViewController alloc] init];
        [self.window.rootViewController presentViewController:wtvc animated:NO completion:nil];
        
    } else {
        
        //check whether logged in Twitter account is still valid
        if ([[TwitterManager sharedObject] stillLoggedIn]) {
            
            //valid. set account
            [[TwitterManager sharedObject] updateAccount];
            
        } else {
            
            //account is not valid. log out.
            [[TwitterManager sharedObject] logout];
            
            [self.window makeKeyAndVisible];
            WalkthroughViewController *wtvc = [[WalkthroughViewController alloc] init];
            [self.window.rootViewController presentViewController:wtvc animated:NO completion:nil];
            
            
        }
        
    }
    
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if ([[PocketAPI sharedAPI] handleOpenURL:url]) {
        
    } else {
        
    }
    
    return YES;
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DefaultManager *defaultManager = [[DefaultManager alloc] init];
    if ([defaultManager isLoggedIn]) {
        [[TwitterManager sharedObject] fetchNewTweets];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    DefaultManager *defaultManager = [[DefaultManager alloc] init];
    if ([defaultManager isLoggedIn]) {
    
        if (![[TwitterManager sharedObject] stillLoggedIn]) {
            
            [[TwitterManager sharedObject] logout];

            WalkthroughViewController *wtvc = [[WalkthroughViewController alloc] init];
            [self.window.rootViewController presentViewController:wtvc animated:NO completion:nil];
            
        }
        
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AppDidEnterBackground object:nil];
    
}

@end
