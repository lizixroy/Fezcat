//
//  TMenu.m
//  Tweeft
//
//  Created by Zixuan Li on 8/19/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import "TMenu.h"
#import "HPButton.h"
#import "PocketAPI.h"
#import "PageLoader.h"

#define SHOW_DURATION 0.6f
#define SHOW_DAMPING 0.8f
#define SHOW_VELOCITY 0.8f
#define SHOW_DELAY 0.0f

#define DISMISS_DURATION 0.3f

@interface TMenu()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) NSUInteger remainingPageNumber;
@property (nonatomic, strong) PageLoader *pageLoader;

@end

@implementation TMenu

- (id)initWithCurrentURL:(NSURL *)url pageLoader:(PageLoader *)pageLoader {
    
    self = [super init];
    if (self) {
        
        _url = url;
        _remainingPageNumber = pageLoader.totalCachedPageNumber;
        _pageLoader = pageLoader;
        
    }
    
    return self;
    
}

- (void)showMenu {
    
    self.window = [[UIWindow alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] frame]];
    [self.window makeKeyAndVisible];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] frame]];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.0;
    self.backgroundView = backgroundView;
    
    [self.window addSubview:backgroundView];
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat x = (screenWidth - 260) / 2;
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(x, -200, 260, 400)];
    menuView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:menuView];
    
    UIImageView *thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake((260 - 100) / 2, 40, 100, 100)];
    thumbnailView.image = [UIImage imageNamed:@"thumbnail01.png"];
    [menuView addSubview:thumbnailView];
    
    //add buttons
    HPButton *pocketButton = [[HPButton alloc] initWithNormalColor:[UIColor clearColor]
                                                 hightlightedColor:[UIColor clearColor]
                                                             frame:CGRectMake(30, 180, 200, 40)];
    
    //pocketButton.layer.cornerRadius = 20;
    pocketButton.clipsToBounds = YES;
    UILabel *pocketButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    pocketButtonLabel.textAlignment = NSTextAlignmentCenter;
    pocketButtonLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:18];
    pocketButtonLabel.textColor = [UIColor colorWithRed:0.937 green:0.404 blue:0.475 alpha:1];
    pocketButtonLabel.text = @"Save to Pocket";
    [pocketButton addSubview:pocketButtonLabel];
    [pocketButton addTarget:self action:@selector(saveToPocket) forControlEvents:UIControlEventTouchUpInside];
    pocketButton.layer.cornerRadius = 20;
    pocketButton.clipsToBounds = YES;
    pocketButton.layer.borderWidth = 2;
    pocketButton.layer.borderColor = [[UIColor colorWithRed:0.937 green:0.404 blue:0.475 alpha:1] CGColor];
    [menuView addSubview:pocketButton];
    
    
    HPButton *cleanButton = [[HPButton alloc] initWithNormalColor:[UIColor clearColor]
                                                hightlightedColor:[UIColor clearColor]
                                                            frame:CGRectMake(30, 240, 200, 40)];
    
    //cleanButton.layer.cornerRadius = 20;
    cleanButton.clipsToBounds = YES;

    UILabel *cleanButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    cleanButtonLabel.textAlignment = NSTextAlignmentCenter;
    cleanButtonLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:18];
    cleanButtonLabel.textColor = [UIColor colorWithRed:0.937 green:0.404 blue:0.475 alpha:1];
    cleanButtonLabel.text = @"Reset saved pages";
    cleanButton.layer.cornerRadius = 20;
    cleanButton.clipsToBounds = YES;
    cleanButton.layer.borderWidth = 2;
    cleanButton.layer.borderColor = [[UIColor colorWithRed:0.937 green:0.404 blue:0.475 alpha:1] CGColor];
    
    [cleanButton addSubview:cleanButtonLabel];
    [cleanButton addTarget:self action:@selector(removeCachedPages) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:cleanButton];
    
    HPButton *cancelButton = [[HPButton alloc] initWithNormalColor:[UIColor clearColor]
                                                 hightlightedColor:[UIColor clearColor]
                                                             frame:CGRectMake(30, 300, 200, 40)];
                              
                              
    //cancelButton.layer.cornerRadius = 20;
    cancelButton.clipsToBounds = YES;

    UILabel *cancelButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    cancelButtonLabel.textAlignment = NSTextAlignmentCenter;
    cancelButtonLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:18];
    cancelButtonLabel.textColor = [UIColor colorWithRed:0.937 green:0.404 blue:0.475 alpha:1];
    cancelButtonLabel.text = @"Cancel";
    cancelButtonLabel.layer.borderColor = [[UIColor colorWithRed:0.937 green:0.404 blue:0.475 alpha:1] CGColor];
    cancelButtonLabel.layer.borderWidth = 2;
    cancelButtonLabel.layer.cornerRadius = 20;
    cancelButtonLabel.clipsToBounds = YES;
    
    [cancelButton addSubview:cancelButtonLabel];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:cancelButton];
    
    self.menuView = menuView;
    
    [UIView animateWithDuration:SHOW_DURATION
                          delay:SHOW_DELAY
         usingSpringWithDamping:SHOW_DAMPING
          initialSpringVelocity:SHOW_VELOCITY
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        
                         menuView.frame = CGRectMake(x, 100, 260, 400);
                         self.backgroundView.alpha = 0.7;
        
                     } completion:nil];
    
}

- (void)dismissMenu {
    
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat x = (screenWidth - 260) / 2;
    
    [UIView animateWithDuration:DISMISS_DURATION animations:^{
        
        self.backgroundView.alpha = 0.0;
        self.menuView.frame = CGRectMake(x, -400, 260, 400);
        
    } completion:^(BOOL finished) {
        
        self.window = nil;
        
    }];
    
}

#pragma mark - button actions
- (void)cancel {
    
    [self dismissMenu];
    
}

- (void)saveToPocket {
    
    [self dismissMenu];
    
    [[PocketAPI sharedAPI] saveURL:self.url
                           handler:^(PocketAPI *api, NSURL *url, NSError *error) {
    
                               if (error) {
                                
                                   [self showSavePocketFailureAlert];
                                   
                               } else {
                                   
                                   NSLog(@"Good");
                                   
                               }
    
                           }];
    
}

- (void)removeCachedPages {
    
    [self.pageLoader removeCachedPages];
    [self dismissMenu];
    
}

#pragma mark - Helpers
- (void)showSavePocketFailureAlert {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not save to Pocket"
                                                    message:@"Sorry, we failed to save your website to pocket"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    
}

@end
