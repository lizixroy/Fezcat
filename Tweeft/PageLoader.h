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

@interface PageLoader : NSObject

/**
 *webviews that are loaded and ready to be displayed on view
 */
@property (nonatomic, strong) NSMutableArray *loadedWebviewQueue;
/**
 *url to be loaded when loadedWebviewQueue has space
 */
@property (nonatomic, strong) NSMutableArray *watingURLQueue;

- (id)initWithDummyViews:(NSArray *)dummyViews;

/**
 *add url to wating queue
 *@return void
 */
- (void)addURLtoWatingQueueWithURL:(NSURL *)url;

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
