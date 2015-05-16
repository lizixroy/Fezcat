//
//  TTutorial.m
//  Tweeft
//
//  Created by Zixuan Li on 8/24/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import "TTutorial.h"
#import "DeviceAndModelTool.h"

@interface TTutorial()

@property (nonatomic, assign) TTutorialType type;

@end

@implementation TTutorial

- (id)initWithTutorialType:(TTutorialType)type {
    
    self = [super init];
    if (self) {
        
        _type = type;
        _window = [[UIWindow alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] frame]];
        
    }
    
    return self;
    
}

- (void)show {
    
    [self.window setWindowLevel:UIWindowLevelAlert];
    [self.window makeKeyAndVisible];
    [self configureTutorial];
    [self addButton];
    
}

- (void)showMainTutorialAlert {
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Thanks for trying out Fezcat" message:@"Informative tweets come with embedded with URLs. Click one." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:action];
    
}

- (void)showLoadingTutorialAlert {
    
    
}

- (void)dismiss {
    
    self.window = nil;
    
}

- (void)configureTutorial {
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.4;
    [self.window addSubview:backgroundView];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (self.type == TTutorial_main) {
        
        
        if (IS_IPHONE_5) {
            
            [imageView setImage:[UIImage imageNamed:@"tutorial_main.png"]];
            
        } else {
            
            [imageView setImage:[UIImage imageNamed:@"tutorial_main_small.png"]];
            
        }
        
        [self.window addSubview:imageView];
        
    } else if (self.type == TTutorial_URL) {
        
        if (IS_IPHONE_5) {
            
            [imageView setImage:[UIImage imageNamed:@"tutorial_url.png"]];
            
        } else {
            
            [imageView setImage:[UIImage imageNamed:@"tutorial_url_small"]];
            
        }
        
        [self.window addSubview:imageView];
        
    }
    
}

- (void)addButton {
    
    UIButton *button;
    
    if (IS_IPHONE_5) {
    
        button = [[UIButton alloc] initWithFrame:CGRectMake(30, 500, 260, 40)];
        
    } else {
        
        button = [[UIButton alloc] initWithFrame:CGRectMake(30, 410, 260, 40)];

    }
    
    button.backgroundColor = [UIColor colorWithRed:0.275 green:0.557 blue:0.898 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 260, 30)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Avenir-Roman" size:18];
    label.textAlignment = NSTextAlignmentCenter;
    
    if (self.type == TTutorial_URL) {
        
        label.text = @"OK";
        
    } else {
        
        label.text = @"Enjoy";
        
    }
    
    [button addSubview:label];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [self.window addSubview:button];
    
}


@end
