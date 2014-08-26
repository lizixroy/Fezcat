//
//  TestViewController.m
//  Tweeft
//
//  Created by Juan Kou on 8/19/14.
//  Copyright (c) 2014 Mallocu. All rights reserved.
//

#import "TimelineViewController.h"
#import "TwitterManager.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "NotificationConstants.h"
#import "NSString+StringSize.h"
#import "PageLoader.h"
#import "Tweet.h"
#import "URBMediaFocusViewController.h"
#import "BottomCell.h"
#import "WalkthroughViewController.h"
#import "TTutorial.h"
#import "LoadingView.h"
#import "PlaceholderView.h"
#import "DefaultManager.h"


typedef void (^ImageCompletionBlock)(UIImage *);

typedef enum ScorllDirection {
    
    DirectionUp,
    DirectionDown,
    
} Scroll_direction;

@interface TimelineViewController ()

@property (nonatomic, strong) TwitterManager *twiterManager;
@property (nonatomic, strong) NSMutableArray *allTweets;
@property (nonatomic, strong) UILabel *cachedPageCounter;
@property (nonatomic, strong) URBMediaFocusViewController *mediaFocusController;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic) BOOL isLoading;
@property (nonatomic) Scroll_direction scrollDirection;
@property (nonatomic) NSInteger lastContentOffset;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) TTutorial *tutorial;
@property (nonatomic, strong) LoadingView *loadingView;
@property (nonatomic, strong) PlaceholderView *placeholder;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIAlertView *actionFailedAlert;



@end

@implementation TimelineViewController

//minimum value in order to load past tweet
const int MIN_POST_NUMBER_TO_LOAD_PAST_TWEET = 30;

//offset for loading past tweet
const int LOAD_PAST_TWEET_MARGIN = 4000;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Tweeft";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.961 green:0.973 blue:0.980 alpha:1];
    
    //scroll to top button (Because iOS seems to fail to provide way to scroll to top a tableview that is embedded)
    UIButton *scrollToTopButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 10, 100, 30)];
    [scrollToTopButton addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:scrollToTopButton];
    
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    UIImageView *settingButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [settingButtonView setImage:[UIImage imageNamed:@"menu_button.png"]];
    [settingButton addSubview:settingButtonView];
    [settingButton addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.navigationBar addSubview:settingButton];
    
    //register cell
    [self.tableView registerClass:[TweetCell class] forCellReuseIdentifier:@"tweetCell"];
    
    
    //notifitaion listener
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSyncOldTweets)
                                                 name:didSyncOldTweets
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSyncNewTweets)
                                                 name:didSyncNewTweets
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFailSynsTweets)
                                                 name:didFailSynsTweets
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFailSyncOldTweets)
                                                 name:didFailSyncOldTweets
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFailSynsTweetsNotFirstTime)
                                                 name:didFailSynsTweetsNotFirstTime
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGoToNextPage)
                                                 name:didGoToNextPage
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willLogOut)
                                                 name:willLogOut
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeUnavailable)
                                                 name:pageDidBecomeUnavailable
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFailLikeTweet)
                                                 name:didFailLikeTweet
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFailRetweet)
                                                 name:didFailRetweet
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFailUndoRetweet)
                                                 name:didFailUndoRetweet
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFailUnLikeTweet)
                                                 name:didFailUnLikeTweet
                                               object:nil];
    
    self.allTweets = [[NSMutableArray alloc] init];
    
    [self addCachedPagesCounter];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self action:@selector(loadNewTweets) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.loadingView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    DefaultManager *defaultManager = [[DefaultManager alloc] init];
    
    if ([defaultManager isLoggedIn]) {
        
        [[TwitterManager sharedObject] fetchNewTweets];
        
    }
    
    self.isLoading = NO;

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    DefaultManager *defaultManager = [[DefaultManager alloc] init];
    if (![defaultManager isTutorialShowed]) {
        
        self.tutorial = [[TTutorial alloc] initWithTutorialType:TTutorial_URL];
        [self.tutorial show];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.allTweets.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        Tweet *tweet = [self.allTweets objectAtIndex:indexPath.row];
    
        [cell constructCellWithTweet:tweet Cell:cell];
        cell.tweetLabel.delegate = self;
        [cell.retweetButton addTarget:self action:@selector(retweet:) forControlEvents:UIControlEventTouchUpInside];
        [cell.likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];


    
        //load user thumbnail
        if (![self.twiterManager.cachedThumbnail  objectForKey:tweet.user_name]) {
            
            [self fetchImageWithURL:[NSURL URLWithString:tweet.user_thumbnail_url]
                    completionBlock:^(UIImage *image) {
                        
                        if (image != nil) {
                            
                            [self.twiterManager.cachedThumbnail setObject:image forKey:tweet.user_name];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                TweetCell *cell = (TweetCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                                cell.userThumbnail.image = image;
                                
                            });
                            
                        }
                        
                    }];
            
            
        } else {
            
            cell.userThumbnail.image = [self.twiterManager.cachedThumbnail objectForKey:tweet.user_name];
            
        }
        
        //load media
        if (tweet.media_url != nil) {
            
            cell.media_url = tweet.media_url;
            
            [cell addMediaView];
            cell.media.frame = CGRectMake(80, tweet.text_height + 5 + 50, 230, tweet.media_image_height * 230 / tweet.media_image_width);
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomImg:)];
            tap.numberOfTapsRequired = 1;
            
            [cell.media addGestureRecognizer:tap];
            
            if (![self.twiterManager.cachedMedia  objectForKey:tweet.media_url]) {
                
                [self fetchImageWithURL:[NSURL URLWithString:tweet.media_url]
                        completionBlock:^(UIImage *image) {
                            
                            if (image != nil) {
                            
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                     [self.twiterManager.cachedMedia setObject:image forKey:tweet.media_url];
                  
                                    TweetCell *cell = (TweetCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                                    cell.media.image = image;
                                    
                                });
                                
                            }
                            
                        }];
            } else {
                
                cell.media.image = [self.twiterManager.cachedMedia objectForKey:tweet.media_url];
                
            }
            
        }
        
        return cell;

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //get tweet    
    Tweet *tweet = [self.allTweets objectAtIndex:indexPath.row];
    
    if (tweet.media_url != nil) {
        
        return 105 + tweet.text_height + tweet.media_image_height * 230 / tweet.media_image_width;
        
    } else {
        
        return 90 + tweet.text_height;

    }

}

#pragma mark - notification handlers


-(void)didFailSyncOldTweets {
    
    self.isLoading = NO;
}

-(void)didFailSynsTweets {
    
    [self.loadingView removeFromSuperview];
    [self.view addSubview:self.placeholder];
    [self.refreshControl endRefreshing];
}

-(void)didFailSynsTweetsNotFirstTime {
    
    [self.refreshControl endRefreshing];
}


-(void)didFailLikeTweet {
    
    TweetCell *cell = (TweetCell *)[self.tableView cellForRowAtIndexPath:self.indexPath];
    cell.favoriteImg.image = [UIImage imageNamed:@"like.png"];
    [self.actionFailedAlert show];
    Tweet *tweet = [self.allTweets objectAtIndex:self.indexPath.row];
    tweet.favorited = NO;
}

-(void)didFailUnLikeTweet {
    
    TweetCell *cell = (TweetCell *)[self.tableView cellForRowAtIndexPath:self.indexPath];
    cell.favoriteImg.image = [UIImage imageNamed:@"liked.png"];
    [self.actionFailedAlert show];
    Tweet *tweet = [self.allTweets objectAtIndex:self.indexPath.row];
    tweet.favorited = YES;


}

-(void)didFailRetweet {
    
    TweetCell *cell = (TweetCell *)[self.tableView cellForRowAtIndexPath:self.indexPath];
    cell.retweetImg.image = [UIImage imageNamed:@"retweet.png"];
    [self.actionFailedAlert show];
    Tweet *tweet = [self.allTweets objectAtIndex:self.indexPath.row];
    tweet.retweeted = NO;


}

-(void)didFailUndoRetweet {
    
    TweetCell *cell = (TweetCell *)[self.tableView cellForRowAtIndexPath:self.indexPath];
    cell.retweetImg.image = [UIImage imageNamed:@"retweeted.png"];
    [self.actionFailedAlert show];
    Tweet *tweet = [self.allTweets objectAtIndex:self.indexPath.row];
    tweet.retweeted = YES;


}



- (void)didSyncNewTweets {
    
    [self.loadingView removeFromSuperview];
    [self.placeholder removeFromSuperview];
    
    int index = 0;
    
    for (Tweet *tweet in self.twiterManager.tweets) {
        
        [self.allTweets insertObject:tweet atIndex:index];
        index++;
    }
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
}

- (void)didSyncOldTweets {

    self.isLoading = NO;
    
    for (Tweet *tweet in self.twiterManager.tweets) {
        
        if (![tweet.tweet_id isEqualToString: self.twiterManager.oldestTweetId]) {
            
            [self.allTweets addObject:tweet];
        }

    }


    [self.tableView reloadData];
    
    [self.placeholder removeFromSuperview];
}

- (void)didGoToNextPage {
    
    if (self.pageLoader.totalCachedPageNumber == 0) {
        
        self.cachedPageCounter.text = @"";
        
    } else {
        
        self.cachedPageCounter.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.pageLoader totalCachedPageNumber]];
        
    }
    
}

- (void)willLogOut {
    
    [self.pageLoader removeCachedPages];
    self.cachedPageCounter.text = @"";
    self.allTweets = nil;
    [self.tableView reloadData];
    
}

- (void)didBecomeUnavailable {
    
    self.cachedPageCounter.text = @"";
    
}

- (void)addCachedPagesCounter {
    
    self.cachedPageCounter = [[UILabel alloc] initWithFrame:CGRectMake(250, 15, 50, 20)];
    self.cachedPageCounter.textColor = [UIColor whiteColor];
    self.cachedPageCounter.font = [UIFont fontWithName:@"Avenir-Roman" size:15];
    self.cachedPageCounter.textAlignment = NSTextAlignmentRight;
    [self.navigationController.navigationBar addSubview:self.cachedPageCounter];
    
}

#pragma mark - helpers
- (void)fetchImageWithURL:(NSURL *)url completionBlock:(ImageCompletionBlock)completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        
        //cache image
        completionBlock(image);
        
    });
}

-(void)zoomImg:(UIGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:self.view];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    TweetCell *cell = (TweetCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.media.image != nil) {
        
        [self.mediaFocusController showImage:cell.media.image fromView:cell.media];
    }
    
}
    
/**
 *loading past posts from server.
 *@return void
 */

- (void)loadingOldTweets {
    
    self.isLoading = YES;
    [self.twiterManager resetOldestTweetId:self.allTweets];
    [self.twiterManager fetchOldTweets];

}
    
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
        
    //get direction of the scroll
    if (self.lastContentOffset > scrollView.contentOffset.y)
        self.scrollDirection = DirectionUp;
    else if (self.lastContentOffset < scrollView.contentOffset.y)
        self.scrollDirection = DirectionDown;
    
    self.lastContentOffset = scrollView.contentOffset.y;
    
    //try to load the past tweets
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - scrollView.contentOffset.y <= LOAD_PAST_TWEET_MARGIN) {
        
        if (self.allTweets.count >= MIN_POST_NUMBER_TO_LOAD_PAST_TWEET) {
            
            if (self.scrollDirection == DirectionDown) {
                
                if (!self.isLoading) {
                    
                        [self loadingOldTweets];
                    
                }
                
            }
            
        }
        
    }
        
}

- (void)loadNewTweets {
    
    [self.refreshControl beginRefreshing];
    [self.twiterManager fetchNewTweets];

}

-(void)like:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    self.indexPath = indexPath;
    NSLog(@"%ld", (long)indexPath.row);
    Tweet *tweet = [self.allTweets objectAtIndex:indexPath.row];
    
    if (!tweet.favorited) {
        
        [self.twiterManager like:tweet.tweet_id];
        TweetCell *cell = (TweetCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.favoriteImg.image = [UIImage imageNamed:@"liked.png"];
        tweet.favorited = YES;
    
    } else {
        //undo favorite
        
        [self.twiterManager unlike:tweet.tweet_id];
        TweetCell *cell = (TweetCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.favoriteImg.image = [UIImage imageNamed:@"like.png"];
        tweet.favorited = NO;
    }
    
}

- (void)retweet:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    self.indexPath = indexPath;
    NSLog(@"%ld", (long)indexPath.row);
    Tweet *tweet = [self.allTweets objectAtIndex:indexPath.row];
    
    if (!tweet.retweeted) {
        
        [self.twiterManager retweet:tweet];
        TweetCell *cell = (TweetCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.retweetImg.image = [UIImage imageNamed:@"retweeted.png"];
        tweet.retweeted = YES;
        
    } else {
        
        [self.twiterManager undoretweet:tweet.retweet_id];
        TweetCell *cell = (TweetCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.retweetImg.image = [UIImage imageNamed:@"retweet.png"];
        tweet.retweeted = NO;
    }
    
}

#pragma mark - lazy instantiation
-(UIAlertView *)actionFailedAlert {
    
    if (_actionFailedAlert == nil) {
        
        _actionFailedAlert = [[ UIAlertView alloc] initWithTitle:@"Opps..." message:@"Something is wrong. Please check your network connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    }
    
    return  _actionFailedAlert;
}

- (LoadingView *)loadingView {
    
    if (_loadingView == nil) {
        
        _loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
        
    }
    
    return _loadingView;
    
}

- (PlaceholderView *)placeholder {
    
    if (_placeholder == nil) {
        
        _placeholder = [[PlaceholderView alloc] initWithFrame:self.view.bounds];
        
    }
    
    return _placeholder;
    
}


-(NSMutableArray *)allTweets {
    
    if (_allTweets == nil) {
        
        _allTweets = [[NSMutableArray alloc] init];
    }
    
    return _allTweets;
}

- (TwitterManager *)twiterManager {
    
    if (_twiterManager == nil) {
        
        _twiterManager = [TwitterManager sharedObject];
        
    }
    
    return _twiterManager;
    
}

- (URBMediaFocusViewController *)mediaFocusController {
    
    if (_mediaFocusController == nil) {
        
        _mediaFocusController = [[URBMediaFocusViewController alloc] init];
    }
    
    return  _mediaFocusController;
}

- (void)scrollToTop {
    
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

- (void)showActionSheet {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Log out"
                                                    otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
    
}

#pragma mark - delegate methods
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    DefaultManager *defaultManager = [[DefaultManager alloc] init];
    if (![defaultManager isTutorialShowed]) {
        
        self.tutorial = [[TTutorial alloc] initWithTutorialType:TTutorial_main];
        [self.tutorial show];
        [defaultManager setTutorialIsShowed:YES];
        
    }
    
    [self.pageLoader addURLtoWatingQueueWithURL:url];
    self.cachedPageCounter.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.pageLoader.totalCachedPageNumber];
    NSLog(@"URL selected is %@", url);
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        [[TwitterManager sharedObject] logout];
        WalkthroughViewController *walkthroughViewController = [[WalkthroughViewController alloc] init];
        [self.parentViewController presentViewController:walkthroughViewController animated:YES completion:nil];
        
    }
    
}
@end
