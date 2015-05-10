//
//  WebPageViewController.m
//  Tweeft
//
//  Created by Zixuan Li on 8/18/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import "WebPageViewController.h"
#import "PageLoader.h"
#import "LoadedObject.h"
#import "NotificationConstants.h"
#import "TMenu.h"
#import "DeviceAndModelTool.h"

#define FOOOTER_HEIGHT 40
#define MENU_BUTTON_LEFT_PADDING 20

@interface WebPageViewController ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) UIView *placeholoderView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) TMenu *menu;

@end

@implementation WebPageViewController

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
    
    CGFloat webViewHeight = 568 - FOOOTER_HEIGHT;
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
//    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, webViewHeight)];
    [self.view addSubview:self.webView];
    self.webView.backgroundColor = [UIColor colorWithRed:0.961 green:0.973 blue:0.980 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pageDidBecomeAvailable)
                                                 name:pageDidBecomeAvailable
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pageDidBecomeUnavailable)
                                                 name:pageDidBecomeUnavailable
                                               object:nil];
    [self addHeader];
    [self addFooter];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    //release cached web pages
    [self.pageLoader releaseCachedPages];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Memory of your device is under pressure." message:@" Tweeft released all the cached pages and will reload them once you add new page" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)addHeader {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 64)];
    self.headerView.backgroundColor = [UIColor colorWithRed:0.212 green:0.235 blue:0.275 alpha:1];
    [self.view addSubview:self.headerView];
    
}

- (void)addFooter {
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat y = screenHeight - FOOOTER_HEIGHT;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, y, screenWidth, 40)];
    footer.backgroundColor = [UIColor colorWithRed:0.945 green:0.408 blue:0.471 alpha:1];
    [self.view addSubview:footer];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
    [nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *nextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 40, 20)];
    nextLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:18];
    nextLabel.textAlignment = NSTextAlignmentCenter;
    nextLabel.textColor = [UIColor whiteColor];
    nextLabel.text = @"Next";
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 10, 40, 40)];
    UIImageView *backButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 11, 21)];
    [backButtonView setImage:[UIImage imageNamed:@"back.png"]];
    [backButton addSubview:backButtonView];
    
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 10, 40, 40)];
    UIImageView *forwardButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 11, 21)];
    [forwardButtonView setImage:[UIImage imageNamed:@"forward.png"]];
    [forwardButton addSubview:forwardButtonView];
    
    [forwardButton addTarget:self action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat menuButtonWidth = 40;
    CGFloat menuButtonX = screenWidth - menuButtonWidth - MENU_BUTTON_LEFT_PADDING;
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(menuButtonX, 10, 40, 40)];
    UIImageView *menuButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 31, 6)];
    [menuButtonView setImage:[UIImage imageNamed:@"more.png"]];
    
    [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    [menuButton addSubview:menuButtonView];
    [nextButton addSubview:nextLabel];
    
    
    [footer addSubview:nextButton];
    [footer addSubview:backButton];
    [footer addSubview:forwardButton];
    [footer addSubview:menuButton];
    
}

#pragma mark - Buttons

- (void)next {

    UIWebView *nextWebView = [self.pageLoader nextPage];
    if (nextWebView != nil) {
        
        nextWebView.scalesPageToFit = YES;
        [self.view addSubview:nextWebView];
        [self.webView removeFromSuperview];
        self.webView = nil;
        self.webView = nextWebView;
        self.webView.scalesPageToFit = YES;
        self.webView.backgroundColor = [UIColor colorWithRed:0.961 green:0.973 blue:0.980 alpha:1];
        
    } else {
        
        [self.webView removeFromSuperview];
        self.webView = nil;
        [self pageDidBecomeUnavailable];
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:didGoToNextPage object:nil];
    
}

- (void)goBack {
    
    if (self.webView.canGoBack) {
        
        [self.webView goBack];
        
    }
    
}

- (void)goForward {
    
    if (self.webView.canGoForward) {
        
        [self.webView goForward];
        
    }
    
}

- (void)showMenu {
    
    if (self.pageLoader.totalCachedPageNumber > 0) {
    
        self.menu = [[TMenu alloc] initWithCurrentURL:self.webView.request.URL
                                           pageLoader:self.pageLoader];
        [self.menu showMenu];
        
    }

    
}

#pragma mark - Delegate methods
/**
 *called when there is web page is loaded and available for user to vieww
 *@return void
 */
- (void)pageDidBecomeAvailable {
    
    [self.placeholoderView removeFromSuperview];
    UIWebView *webView = self.pageLoader.loadedWebviewQueue.firstObject;
    [self.view addSubview:webView];
    self.webView = webView;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor colorWithRed:0.961 green:0.973 blue:0.980 alpha:1];
    
}

/**
 *called when last available page is deleted
 *@return void
 */
- (void)pageDidBecomeUnavailable {
    
    //house keeping might be needed here.
    [self.view addSubview:self.placeholoderView];
    
}

#pragma mark - Lazy instantiation
- (UIView *)placeholoderView {
    
    if (_placeholoderView == nil) {
        
        _placeholoderView = [[UIView alloc] initWithFrame:self.webView.frame];
        UIImage *placeholderImage = [UIImage imageNamed:@"background.png"];
        UIImageView *placeholderImageView = [[UIImageView alloc] initWithFrame:self.webView.frame];
        [placeholderImageView setImage:placeholderImage];
        [_placeholoderView addSubview:placeholderImageView];
        
    }
    
    return _placeholoderView;
}

@end
