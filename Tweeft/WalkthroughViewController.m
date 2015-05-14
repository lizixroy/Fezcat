//
//  WalkthroughViewController.m
//  Tweeft
//
//  Created by Zixuan Li on 8/23/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import "WalkthroughViewController.h"
#import "DeviceAndModelTool.h"
#import "WalkthroughChildViewController.h"

@interface WalkthroughViewController ()

@property (strong, nonatomic) UIPageViewController *pageController;
@property (assign, nonatomic) NSInteger index;

@end

@implementation WalkthroughViewController

- (BOOL)prefersStatusBarHidden {return YES;}

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
    
    WalkthroughChildViewController *childVC = [[WalkthroughChildViewController alloc] init];
    childVC.index = 0;
    NSArray *viewControllers = [NSArray arrayWithObject:childVC];
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageController.dataSource = self;
    self.pageController.view.backgroundColor = [UIColor colorWithRed:0.980 green:0.353 blue:0.396 alpha:1];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.231 green:0.227 blue:0.396 alpha:1];
    pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    self.pageController.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);

    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(WalkthroughViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(WalkthroughViewController *)viewController index];
    if (index == 2) {
        return nil;
    }
    index++;
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    
    return 3;
    
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    
    return 3;
    
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    WalkthroughChildViewController *vc = [[WalkthroughChildViewController alloc] init];
    vc.index = index;
    return vc;
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end