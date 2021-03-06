//
//  PageLoader.h
//  Tweeft
//
//  Created by Zixuan Li on 8/18/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebKit/WebKit.h"

#define MAX_LIVE_WEB_VIEW 5
@class Tweet;

@interface PageLoader : NSObject

@property (nonatomic, strong) NSMutableArray *loadedWebviewQueue;
@property (nonatomic, strong) NSMutableArray *waitingURLQueue;
@property (nonatomic, strong) NSMutableArray *waitingTweetQueue;

/**
 * init with dummy views that are needed for loading web pages in the background
 * @param NSArray dummyViews - array of UIViews
 * @return PageLoader
 */
- (instancetype)initWithDummyViews:(NSArray *)dummyViews;

/**
 *add url to wating queue
 *@return void
 */
- (void)addURLtoWatingQueueWithURL:(NSURL *)url tweet:(Tweet *)tweet;

/**
 * get next webview instance from queue
 *@return UIWebView
 */
- (WKWebView *)nextPage;

/**
 *clean all cached pages to release memory. insert url of unviewed pages back to waiting queue
 *@return void
 */
- (void)releaseCachedPages;

/**
 *remove all cached pages
 *@return void
 */
- (void)removeCachedPages;

/**
 * number of all pages user cached. (numer of current live webviews + number of items in wating queue
 *@return NSUInteger
 */
- (NSUInteger)totalCachedPageNumber;

@end
