//
//  PageLoader.m
//  Tweeft
//
//  Created by Zixuan Li on 8/18/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import "PageLoader.h"
#import "LoadedObject.h"
#import "NotificationConstants.h"
#import "DeviceAndModelTool.h"

//test
#import "TestWebView.h"

@interface PageLoader()

//number of live webviews. including those being downloaded
@property (nonatomic, assign) NSUInteger currentLivePageCount;
//indicator of whether there is page for user to view
@property (nonatomic, assign) BOOL pageAvailable;
//indicator of how many pages being loaded
@property (nonatomic, assign) NSUInteger loadingPageNumber;

@end

@implementation PageLoader

#pragma mark - Delegate

- (id)init {
    
    self = [super init];
    if (self) {
        
        self.currentLivePageCount = 0;
        
    }
    
    return self;
    
}

- (NSMutableArray *)loadedWebviewQueue {
    
    if (_loadedWebviewQueue == nil) {
        
        _loadedWebviewQueue = [[NSMutableArray alloc] init];
        
    }
    
    return _loadedWebviewQueue;
    
}

- (NSMutableArray *)watingURLQueue {
    
    if (_watingURLQueue == nil) {
        
        _watingURLQueue = [[NSMutableArray alloc] init];
        
    }
    
    return _watingURLQueue;
    
}


/**
 * aynchronously load html of a website
 *@return void
 */
- (void)loadPageWithURL:(NSURL *)url {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:startLoadingPage object:nil];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    CGFloat webViewHeight = [[[UIApplication sharedApplication] keyWindow] frame].size.height;
    webViewHeight -= 40;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    TestWebView *webView = [[TestWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, webViewHeight)];
    //load web content asynchronously.
    [webView loadRequest:request];
    [self.loadedWebviewQueue addObject:webView];
    
    NSLog(@"Now there are %lu pages in queue", (unsigned long)self.loadedWebviewQueue.count);
    
    if (!self.pageAvailable) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:pageDidBecomeAvailable object:nil];
        self.pageAvailable = YES;
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:didFinishLoadingPage object:nil];
    
}

- (void)addURLtoWatingQueueWithURL:(NSURL *)url {
    
    if (self.currentLivePageCount < MAX_LIVE_WEB_VIEW) {
        
        //space available kick off loading
        self.currentLivePageCount++;
        [self loadPageWithURL:url];
        [self tryLoadMorePage];
        
    } else {
        
        //add to wating queue
        [self.watingURLQueue addObject:url];
        
    }
    
}

- (UIWebView *)nextPage {
    
    if (self.loadedWebviewQueue.count == 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:pageDidBecomeUnavailable object:nil];
        self.pageAvailable = NO;
        [self tryLoadMorePage];
        return nil;
        
    } else if (self.loadedWebviewQueue.count == 1) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:pageDidBecomeUnavailable object:nil];
        
        [self.loadedWebviewQueue removeObjectAtIndex:0];
        self.currentLivePageCount--;
        self.pageAvailable = NO;
        [self tryLoadMorePage];
        return nil;
        
    } else {
        
        [self.loadedWebviewQueue removeObjectAtIndex:0];
        self.currentLivePageCount--;
        [self tryLoadMorePage];
        return self.loadedWebviewQueue.firstObject;
        
    }
    
}

- (void)releaseCachedPages {
    
    int i;
    for (i = 0; i < self.loadedWebviewQueue.count; i++) {
        
        UIWebView *webview = [self.loadedWebviewQueue objectAtIndex:i];
        NSURL *url = webview.request.URL;
        [self.watingURLQueue insertObject:url atIndex:0];
        
    }
    
    //release all cached web views
    NSMutableArray *urlsToBeDeleted = [[NSMutableArray alloc] init];
    for (i = 0; i < self.loadedWebviewQueue.count; i++) {
        
        [urlsToBeDeleted addObject:[self.loadedWebviewQueue objectAtIndex:i]];
        self.currentLivePageCount--;
        
    }
    
    [self.loadedWebviewQueue removeObjectsInArray:urlsToBeDeleted];
    self.pageAvailable = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:pageDidBecomeUnavailable object:nil];
    
}

- (void)removeCachedPages {
    
    self.loadedWebviewQueue = nil;
    self.watingURLQueue = nil;
    self.currentLivePageCount = 0;
    self.pageAvailable = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:pageDidBecomeUnavailable object:nil];
    
}

- (NSUInteger)totalCachedPageNumber {
    
    return self.currentLivePageCount + self.watingURLQueue.count;
    
}

#pragma mark - internal helpers

/**
 *try to load new website if wating queue is not empty
 *@return void
 */
- (void)tryLoadMorePage {
    
    if (self.watingURLQueue.count > 0 && self.currentLivePageCount < MAX_LIVE_WEB_VIEW) {
        
        NSUInteger empty_slot = MAX_LIVE_WEB_VIEW - self.currentLivePageCount;
        
        for (int i = 0; i < empty_slot; i++) {
            
            if (self.watingURLQueue.count > 0) {
                
                NSURL *url = self.watingURLQueue.firstObject;
                self.currentLivePageCount++;
                [self loadPageWithURL:url];
                [self.watingURLQueue removeObjectAtIndex:0];
                
            }
            
        }
        
    }
    
}

/**
 *current loaded webview count
 *@return NSUInteger
 */
- (NSUInteger)currentLoadedPagesCount {
    return self.loadedWebviewQueue.count;
}

@end