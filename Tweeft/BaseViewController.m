//
//  BaseViewController.m
//  Tweeft
//
//  Created by Zixuan Li on 8/18/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import "BaseViewController.h"
#import "DeviceAndModelTool.h"
#import "WebPageViewController.h"
#import "TimelineViewController.h"
#import "PageLoader.h"
#import "NotificationConstants.h"

#define HANDLE_HEIGHT 40
#define HANDLE_WIDTH 20

@interface BaseViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

//handle
@property (nonatomic, strong) UIImageView *handle;
@property (nonatomic, assign) BOOL canScroll;
// need dummy views to start loading web views
@property (nonatomic, strong) NSMutableArray *dummyViews;

@end

@implementation BaseViewController

- (void)setCanScroll:(BOOL)canScroll {
    
    if (canScroll) {
        
        self.scrollView.scrollEnabled = YES;
        
    } else {
    
        self.scrollView.scrollEnabled = NO;
        
    }
    
    _canScroll = canScroll;
    
}

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
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.scrollView.contentSize = CGSizeMake(screenWidth * 2, screenHeight);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;

    [self.scrollView setShowsHorizontalScrollIndicator:NO];

    [self.view addSubview:self.scrollView];
    
    [self addViewControllers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleBecomeAvailable)
                                                 name:pageDidBecomeAvailable
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pageDidBecomeUnavailable)
                                                 name:pageDidBecomeUnavailable
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleBecomeLoading)
                                                 name:startLoadingPage
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleBecomeAvailable)
                                                 name:didFinishLoadingPage
                                               object:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)addViewControllers {
    
    TimelineViewController *tvc = [[TimelineViewController alloc] init];
    WebPageViewController *wpvc = [[WebPageViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tvc];
    navController.navigationBar.barTintColor = [UIColor colorWithRed:0.929 green:0.302 blue:0.384 alpha:1];//[UIColor redColor];
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    navController.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    wpvc.view.frame = CGRectMake(screenWidth, 0, screenWidth, screenHeight);
    
    [self.scrollView addSubview:navController.view];
    [self.scrollView addSubview:wpvc.view];
    
    [navController willMoveToParentViewController:self];
    [wpvc willMoveToParentViewController:self];
    
    [self addChildViewController:navController];
    [self addChildViewController:wpvc];
    
    [navController didMoveToParentViewController:self];
    [wpvc didMoveToParentViewController:self];
    
    [self createDummyViews];
    
    PageLoader *pageLoader = [[PageLoader alloc] initWithDummyViews:self.dummyViews];
    tvc.pageLoader = pageLoader;
    wpvc.pageLoader = pageLoader;
    
    [self addHandle];
    
}

- (void)createDummyViews {
    
    self.dummyViews = [[NSMutableArray alloc] init];
    CGFloat unreachableX = -1000;
    CGFloat unreachableY = -1000;
    for (int i = 0; i < 5; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(unreachableX, unreachableY, 1, 1)];
        [self.view addSubview:view];
        self.dummyViews[i] = view;
        
    }
    
}


- (void)addHandle {
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    self.handle = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - HANDLE_WIDTH, 400, HANDLE_WIDTH, HANDLE_HEIGHT)];
    
    [self.handle setImage:[UIImage imageNamed:@"handle_original.png"]];
    [self.scrollView addSubview:self.handle];
    self.canScroll = NO;
}

/**
 *make handle view changes to normal unavailable status
 *@return void
 */
- (void)handleBecomeUnavailable {
    
    self.canScroll = NO;
    [self.handle setImage:[UIImage imageNamed:@"handle_unavailable.png"]];

}

/**
 *make handle view changes to loading status
 *@return void
 */
- (void)handleBecomeLoading {
    
    [self.handle setImage:[UIImage imageNamed:@"handle_loading.png"]];

}

/**
 *make handle view changes to available status 
 *@return void
 */
- (void)handleBecomeAvailable {
    
    self.canScroll = YES;
    [self.handle setImage:[UIImage imageNamed:@"handle_available.png"]];
    
}

#pragma mark - Delegation method
- (void)pageDidBecomeUnavailable {
    
    //scroll back to tweets view controller
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        [self handleBecomeUnavailable];
//        
//    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    //release loaded pages
    
    
}

@end
