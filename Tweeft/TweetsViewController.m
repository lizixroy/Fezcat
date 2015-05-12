//
//  ViewController.m
//  Tweeft
//
//  Created by Zixuan Li on 8/18/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import "TweetsViewController.h"
#import "PageLoader.h"
#import "TwitterManager.h"

@interface TweetsViewController ()

@end

@implementation TweetsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TwitterManager *tm = [[TwitterManager alloc] init];
    [tm signin];

	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *firstButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 280, 50)];
    firstButton.backgroundColor = [UIColor redColor];
    firstButton.tag = 0;
    
    UIButton *secondButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, 280, 50)];
    secondButton.backgroundColor = [UIColor blueColor];
    secondButton.tag = 1;
    
    UIButton *thirdButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 300, 280, 50)];
    thirdButton.backgroundColor = [UIColor yellowColor];
    thirdButton.tag = 2;
    
    [firstButton addTarget:self action:@selector(load:) forControlEvents:UIControlEventTouchUpInside];
    [secondButton addTarget:self action:@selector(load:) forControlEvents:UIControlEventTouchUpInside];
    [thirdButton addTarget:self action:@selector(load:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:firstButton];
    [self.view addSubview:secondButton];
    [self.view addSubview:thirdButton];

    
}

- (void)load:(id)sender {
 
    UIButton *button = (UIButton *)sender;
    
    switch (button.tag) {
        case 0:
            
        {
         
            NSURL *url = [NSURL URLWithString:@"http://nshipster.com"];
//            [self.pageLoader addURLtoWatingQueueWithURL:url];
            
        }
            break;
            
        case 1:
            
        {
            
            NSURL *url = [NSURL URLWithString:@"http://www.objc.io"];
//            [self.pageLoader addURLtoWatingQueueWithURL:url];
            
        }
            
            break;
            
        case 2:
            
        {
            
            NSURL *url = [NSURL URLWithString:@"http://apple.com"];
//            [self.pageLoader addURLtoWatingQueueWithURL:url];
            
        }
            
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
