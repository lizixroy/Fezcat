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
    
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(30, -200, 260, 300)];
    menuView.backgroundColor = [UIColor colorWithRed:0.271 green:0.231 blue:0.396 alpha:1];
    [self.window addSubview:menuView];
    
        UILabel *remaingNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 220, 80)];
    remaingNumberLabel.lineBreakMode = NSLineBreakByWordWrapping;
    remaingNumberLabel.numberOfLines = 0;
    remaingNumberLabel.textColor = [UIColor whiteColor];
    remaingNumberLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:22];
    remaingNumberLabel.textAlignment = NSTextAlignmentCenter;
    remaingNumberLabel.text = [NSString stringWithFormat:@"%lu more pages saved in queue", (unsigned long)self.remainingPageNumber];
    [menuView addSubview:remaingNumberLabel];
    
    //add buttons
    HPButton *pocketButton = [[HPButton alloc] initWithNormalColor:[UIColor colorWithRed:0.902 green:0.278 blue:0.388 alpha:1]
                                                 hightlightedColor:[UIColor colorWithRed:0.867 green:0.255 blue:0.310 alpha:1]
                                                             frame:CGRectMake(30, 110, 200, 40)];
    
    //pocketButton.layer.cornerRadius = 20;
    pocketButton.clipsToBounds = YES;
    UILabel *pocketButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    pocketButtonLabel.textAlignment = NSTextAlignmentCenter;
    pocketButtonLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:18];
    pocketButtonLabel.textColor = [UIColor whiteColor];
    pocketButtonLabel.text = @"Save to Pocket";
    [pocketButton addSubview:pocketButtonLabel];
    [pocketButton addTarget:self action:@selector(saveToPocket) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:pocketButton];
    
    HPButton *cleanButton = [[HPButton alloc] initWithNormalColor:[UIColor colorWithRed:0.902 green:0.278 blue:0.388 alpha:1]
                                                hightlightedColor:[UIColor colorWithRed:0.192 green:0.557 blue:0.855 alpha:1]
                                                            frame:CGRectMake(30, 170, 200, 40)];
    
    //cleanButton.layer.cornerRadius = 20;
    cleanButton.clipsToBounds = YES;

    UILabel *cleanButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    cleanButtonLabel.textAlignment = NSTextAlignmentCenter;
    cleanButtonLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:18];
    cleanButtonLabel.textColor = [UIColor whiteColor];
    cleanButtonLabel.text = @"Reset saved pages";
    [cleanButton addSubview:cleanButtonLabel];
    [cleanButton addTarget:self action:@selector(removeCachedPages) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:cleanButton];
    
    HPButton *cancelButton = [[HPButton alloc] initWithNormalColor:[UIColor colorWithRed:0.902 green:0.278 blue:0.388 alpha:1]
                                                 hightlightedColor:[UIColor colorWithRed:0.192 green:0.557 blue:0.855 alpha:1]
                                                             frame:CGRectMake(30, 230, 200, 40)];
                              
                              
    //cancelButton.layer.cornerRadius = 20;
    cancelButton.clipsToBounds = YES;

    UILabel *cancelButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    cancelButtonLabel.textAlignment = NSTextAlignmentCenter;
    cancelButtonLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:18];
    cancelButtonLabel.textColor = [UIColor whiteColor];
    cancelButtonLabel.text = @"Cancel";
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
        
                         menuView.frame = CGRectMake(30, 100, 260, 300);
                         self.backgroundView.alpha = 0.7;
        
                     } completion:nil];
    
}

- (void)dismissMenu {
    
    [UIView animateWithDuration:DISMISS_DURATION animations:^{
        
        self.backgroundView.alpha = 0.0;
        self.menuView.frame = CGRectMake(30, -300, 260, 300);
        
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
