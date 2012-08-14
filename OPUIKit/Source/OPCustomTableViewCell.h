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
 OPTableViewController instances will use this method to automatically layout 
 cell heights.
 */
+(CGFloat) heightForObject:(id)object cellWidth:(CGFloat)width;

@end
