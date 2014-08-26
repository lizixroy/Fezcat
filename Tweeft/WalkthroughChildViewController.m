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
        
    } else if (self.index == 3) {
        
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
    
    if (self.index == 0) {
        
        UIImageView *loadingPagesView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 130, 140, 220)];
        [loadingPagesView setImage:[UIImage imageNamed:@"Loading_pages.png"]];
        [self.view addSubview:loadingPagesView];
        
        if (!IS_IPHONE_5) {
            
            loadingPagesView.frame = CGRectMake(90, 70, 140, 220);
            
        }
        
        
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 122, 200)];
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        loadingLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15];
        loadingLabel.textColor = [UIColor darkGrayColor];
        loadingLabel.text = @"Loading...";
        loadingLabel.lineBreakMode = NSLineBreakByWordWrapping;
        loadingLabel.numberOfLines = 0;
        [self.scrollView addSubview:loadingLabel];
    
        
        UILabel *label;
        
        if (IS_IPHONE_5) {
            
            UILabel *upLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 280, 100)];
            upLabel.textAlignment = NSTextAlignmentCenter;
            upLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:20];
            upLabel.textColor = [UIColor whiteColor];
            upLabel.text = @"Many tweets have embedded links";
            upLabel.lineBreakMode = NSLineBreakByWordWrapping;
            upLabel.numberOfLines = 0;
            [self.view addSubview:upLabel];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(20, 370, 280, 100)];
            
        } else {
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(20, 320, 280, 100)];
            
        }
        
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Avenir-Roman" size:20];
        label.textColor = [UIColor whiteColor];
        label.text = @"We click links and stare at loading wheels";
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        [self.view addSubview:label];
        
    } else if (self.index == 1) {
        
        UIImageView *iPhoneCaseView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 70, 150, 315)];
        [iPhoneCaseView setImage:[UIImage imageNamed:@"iphone_case.png"]];
        
        if (!IS_IPHONE_5) {
            iPhoneCaseView.frame = CGRectMake(20, 40, 150, 315);
        }
        
        [self.view addSubview:iPhoneCaseView];
        
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(11, 43                                                                              , 130, 230)];
        scrollView.contentSize = CGSizeMake(130, 2500);
        scrollView.backgroundColor = [UIColor colorWithRed:0.141 green:0.608 blue:0.843 alpha:1];
        
        [iPhoneCaseView addSubview:scrollView];
        
        UIView *contentView = [self createContentView];
        UIView *contentView_b = [self createContentView];
        contentView.frame = CGRectMake(0, 0, 131, 1000);
        contentView_b.frame = CGRectMake(0, 1000, 131, 1000);
        
        [scrollView addSubview:contentView];
        [scrollView addSubview:contentView_b];
        self.scrollView = scrollView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 400, 300, 100)];
        
        if (!IS_IPHONE_5) {
            label.frame = CGRectMake(10, 350, 300, 100);
        }
        
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor  = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Avenir-Roman" size:20];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.text = @"Tweeft loads pages silently while you scrolling timeline";
        
        [self.view addSubview:label];
        [self addLoadingPages];
        
    } else if (self.index == 2) {
        
        [super viewDidLoad];
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = [UIColor colorWithRed:0.980 green:0.353 blue:0.396 alpha:1];
        
        UIImageView *iPhoneView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 100, 140, 300)];
        [iPhoneView setImage:[UIImage imageNamed:@"iphone_case.png"]];
        
        if (!IS_IPHONE_5) {
            iPhoneView.frame = CGRectMake(90, 40, 140, 300);
        }
        
        [self.view addSubview:iPhoneView];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 40, 122, 220)];
        scrollView.contentSize = CGSizeMake(191 * 2, 330);
        scrollView.backgroundColor = [UIColor blackColor];
        [iPhoneView addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIImageView *tweetView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 122, 220)];
        [tweetView setImage:[UIImage imageNamed:@"tweet.png"]];
        [self.scrollView addSubview:tweetView];
        
        self.pageView = [[UIView alloc] initWithFrame:CGRectMake(122, 0, 122, 220)];
        self.pageView.backgroundColor = [UIColor colorWithRed:0.141 green:0.608 blue:0.843 alpha:1];
        [self.scrollView addSubview:self.pageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 400, 280, 100)];
        
        if (!IS_IPHONE_5) {
            label.frame = CGRectMake(20, 350, 280, 100);
        }
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Avenir-Roman" size:20];
        label.textColor = [UIColor whiteColor];
        label.text = @"When pages ready swipe right to view them.";
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        [self.view addSubview:label];
        
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
        signInLabel.textAlignment = NSTextAlignmentCenter;
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
    
    //[self.parentViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
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