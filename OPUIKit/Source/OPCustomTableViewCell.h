//
//  OPCustomTableViewCell.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/26/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPStyle.h"

@interface OPCustomTableViewCell : UITableViewCell <OPStyleProtocol>

/**
 Subclasses should override this.
 */
-(void) drawContentView:(CGRect)rect highlighted:(BOOL)highlighted;

/**
 Determines if this cell is the first/last in it's section.
 */
@property (nonatomic, assign, getter = isFirstInSection) BOOL firstInSection;
@property (nonatomic, assign, getter = isLastInSection) BOOL lastInSection;

/**
 OPTableViewController instances will use this method to automatically layout 
 cell heights.
 */
+(CGFloat) heightForObject:(id)object cellWidth:(CGFloat)width;
+(CGFloat) heightForObject:(id)object cellWidth:(CGFloat)width isFirst:(BOOL)isFirst isLast:(BOOL)isLast;

/**
 OPTableViewController instances will assign this object from what it pulls
 from the -tableView:objectForRowAtIndexPath: method.
 */
@property (nonatomic, strong) id object;

@end
