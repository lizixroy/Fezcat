//
//  WalkthroughChildViewController.m
//  Tweeft
//
//  Created by Zixuan Li on 8/23/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import "WalkthroughChildViewController.h"
#import "HPButton.h"
#import "TwitterManager.h"
#import "NotificationConstants.h"
#import "DeviceAndModelTool.h"

@interface WalkthroughChildViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *pageView;
@property (nonatomic, assign) BOOL timelineIsScrolling_vertical;
@property (nonatomic, assign) BOOL timelineIsScrolling_horizontal;
@property (nonatomic, strong) NSArray *accounts;

@end

@implementation WalkthroughChildViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.980 green:0.353 blue:0.396 alpha:1];
    [self populateContent];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (self.index == 1) {
        
        if (!self.timelineIsScrolling_horizontal) {
            
            self.timelineIsScrolling_horizontal = YES;
            [self scrollTimeLine_vertical];
            
        }
        
    } else if (self.index == 2) {
        
        if (!self.timelineIsScrolling_vertical) {
            
            self.timelineIsScrolling_vertical = YES;
            [self scrollTimeLine_horizontal];
            
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didFindMultipleAccounts:)
                                                     name:didFindMultipleAccounts
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didLogIn)
                                                     name:didLogIn
                                                   object:nil];

        
    } 
    
}

- (void)populateContent {
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    if (self.index == 0) {
        
        
        UIImageView *thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth - 80) / 2, 50, 80, 80)];
        thumbnailView.image = [UIImage imageNamed:@"walkthrough_thumbnail_a.png"];
        [self.view addSubview:thumbnailView];
        
        if (!IS_IPHONE_4) {
            
            UIImageView *loadingPageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth - 160) / 2, 150, 160, 285)];
            loadingPageView.image = [UIImage imageNamed:@"loading_page.png"];
            [self.view addSubview:loadingPageView];
            
        }

        UILabel *label;
        
        if (IS_IPHONE_4) {
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, screenWidth - 2 * 30, 50)];
            
        } else {
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(30, 480, screenWidth - 2 * 30, 50)];
            
        }
        
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Avenir" size:18];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.text = @"Loading wheel sucks right? How about we see it no more?";
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];

        
    } else if (self.index == 1) {
        
        UIImageView *thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth - 80) / 2, 50, 80, 80)];
        thumbnailView.image = [UIImage imageNamed:@"walkthrough_thumbnail_b.png"];
        [self.view addSubview:thumbnailView];
        
        if (!IS_IPHONE_4) {
            
            UIImageView *loadingPageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth - 224) / 2, 150, 224, 285)];
            loadingPageView.image = [UIImage imageNamed:@"multi_page.png"];
            [self.view addSubview:loadingPageView];
            
        }
        
        UILabel *label;
        if (IS_IPHONE_5) {
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(30, 450, screenWidth - 2 * 30, 80)];
            
        } else if (IS_IPHONE_4) {
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, screenWidth - 2 * 30, 80)];
            
        } else {
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(30, 480, screenWidth - 2 * 30, 80)];
            
        }
        
        
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Avenir" size:18];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.text = @"Tweeft loads your pages silently while you keep scrolling your timeline.";
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];

        
    } else if (self.index == 2) {
        
        UIImageView *thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth - 80) / 2, 50, 80, 80)];
        thumbnailView.image = [UIImage imageNamed:@"walkthrough_thumbnail_c.png"];
        [self.view addSubview:thumbnailView];
        
        UILabel *label;
        label = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, screenWidth - 2 * 30, 180)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Avenir" size:18];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.text = @"Many people, like you and I, are using Twitter as the primary source of news. It’s how we interprete and engage the world.\n\nTweeft makes this process far more continuous.";
        [self.view addSubview:label];
        
        HPButton *signInButton;
        
        if (IS_IPHONE_5) {
            
            signInButton = [[HPButton alloc] initWithNormalColor:[UIColor colorWithRed:0.298 green:0.667 blue:0.957 alpha:1]
                                               hightlightedColor:[UIColor colorWithRed:0.216 green:0.541 blue:0.800 alpha:1]
                                                           frame:CGRectMake(40, 400, (screenWidth - 40) / 2, 40)];
            
        } else {
            
            signInButton = [[HPButton alloc] initWithNormalColor:[UIColor colorWithRed:0.298 green:0.667 blue:0.957 alpha:1]
                                               hightlightedColor:[UIColor colorWithRed:0.216 green:0.541 blue:0.800 alpha:1]
                                                           frame:CGRectMake(40, 380, 240, 40)];
            
            
        }
        
        signInButton = [[HPButton alloc] initWithNormalColor:[UIColor colorWithRed:0.298 green:0.667 blue:0.957 alpha:1]
                                           hightlightedColor:[UIColor colorWithRed:0.216 green:0.541 blue:0.800 alpha:1]
                                                       frame:CGRectMake((screenWidth - 240) / 2, 400, 240, 40)];

        
        signInButton.layer.cornerRadius = 20;
        signInButton.clipsToBounds = YES;
        
        UIImageView *twitterLogoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 30, 25)];
        [twitterLogoView setImage:[UIImage imageNamed:@"twitter_logo.png"]];
        [signInButton addSubview:twitterLogoView];
        UILabel *signInLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 160, 30)];
        signInLabel.textColor = [UIColor whiteColor];
        signInLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:18];
        signInLabel.text = @"Sign in with Twitter";
        signInLabel.textAlignment = NSTextAlignmentLeft;
        [signInButton addSubview:signInLabel];
        [signInButton addTarget:self action:@selector(signInWithTwitter) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:signInButton];


        
    } else {
        
        UIImageView *loadingPagesView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 100, 140, 220)];
        [loadingPagesView setImage:[UIImage imageNamed:@"Loading_pages_2.png"]];
        [self.view addSubview:loadingPagesView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 280, 100)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Avenir-Roman" size:20];
        label.textColor = [UIColor whiteColor];
        label.text = @"Let's save time";
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        [self.view addSubview:label];
        
        HPButton *signInButton;
        
        if (IS_IPHONE_5) {
            
           signInButton = [[HPButton alloc] initWithNormalColor:[UIColor colorWithRed:0.298 green:0.667 blue:0.957 alpha:1]
                                              hightlightedColor:[UIColor colorWithRed:0.216 green:0.541 blue:0.800 alpha:1]
                                                          frame:CGRectMake(40, 400, 240, 40)];
            
        } else {
            
            signInButton = [[HPButton alloc] initWithNormalColor:[UIColor colorWithRed:0.298 green:0.667 blue:0.957 alpha:1]
                                               hightlightedColor:[UIColor colorWithRed:0.216 green:0.541 blue:0.800 alpha:1]
                                                           frame:CGRectMake(40, 380, 240, 40)];
            
            
        }
        
        signInButton.layer.cornerRadius = 20;
        signInButton.clipsToBounds = YES;
        
        UIImageView *twitterLogoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 30, 25)];
        [twitterLogoView setImage:[UIImage imageNamed:@"twitter_logo.png"]];
        [signInButton addSubview:twitterLogoView];
        
        UILabel *signInLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 160, 30)];
        signInLabel.textColor = [UIColor whiteColor];
        signInLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:18];
        signInLabel.text = @"Sign in with Twitter";
        signInLabel.textAlignment = NSTextAlignmentLeft;
        [signInButton addSubview:signInLabel];
        
        [signInButton addTarget:self action:@selector(signInWithTwitter) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:signInButton];
        
    }
    
}

- (void)addLoadingPages {
    
    UIImageView *loadingPagesView = [[UIImageView alloc] initWithFrame:CGRectMake(180, 155, 120, 190)];
    [loadingPagesView setImage:[UIImage imageNamed:@"Loading_pages.png"]];
    [self.view addSubview:loadingPagesView];
    
}

- (void)addIphoneCase {
    
    UIImageView *iPhoneCaseView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 150, 315)];
    [iPhoneCaseView setImage:[UIImage imageNamed:@"iphone_case.png"]];
    [self.view addSubview:iPhoneCaseView];
    
}

- (UIView *)createContentView {
    
    UIImageView *contentView = [[UIImageView alloc] init];
    [contentView setImage:[UIImage imageNamed:@"timeline.png"]];
    return contentView;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Animation

- (void)scrollTimeLine_vertical {
    
    [UIView animateWithDuration:15.0 animations:^{
        
        self.scrollView.contentOffset = CGPointMake(0, 1750);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:15.0 animations:^{
            
            self.scrollView.contentOffset = CGPointMake(0, 0);
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }];
    
}

- (void)scrollTimeLine_horizontal {
    
    [UIView animateWithDuration:1 animations:^{
        
        self.scrollView.contentOffset = CGPointMake(122, 0);
        
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:1 animations:^{
                
                self.scrollView.contentOffset = CGPointMake(0, 0);
                
            } completion:^(BOOL finished) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                });
                
            }];
            
        });
        
    }];
    
}

- (void)signInWithTwitter {
    
    NSLog(@"Signing in");    
    [[TwitterManager sharedObject] signin];
    
}

#pragma mark - Notification methods
- (void)didFindMultipleAccounts:(NSNotification *)notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *userInfo  = notification.userInfo;
        NSArray *accounts = [userInfo objectForKey:@"accounts"];
        self.accounts = accounts;
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        for (ACAccount *account in accounts) {
            
            [actionSheet addButtonWithTitle:account.username];
            
        }
                
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        
    });
    
    
}

- (void)didLogIn {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.parentViewController.parentViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
    });
    
}

#pragma mark - Delegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    ACAccount *account = [self.accounts objectAtIndex:buttonIndex];
    [[TwitterManager sharedObject] signinWithAccount:account];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end