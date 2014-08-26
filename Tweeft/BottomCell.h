//
//  BottomCell.h
//  BlockAndMultiThreding
//
//  Created by Zixuan Li on 1/16/14.
//  Copyright (c) 2014 TangenBox. All rights reserved.
//

#import <UIKit/UIKit.h>

//height of bottom cell
enum {
    
    HEIGHT_BOTTOM_CELL = 50,
    
};

@interface BottomCell : UITableViewCell

/**
 *add loading indicator to cell
 *@return void
 */
- (void)addIndicator;

/**
 *remove loading indicator from cell
 *@return void
 */
- (void)removeIndicator;

/**
 *add label says all posts has been loaded
 *@return void
 */
- (void)addAllLoadedLabel;


@end
