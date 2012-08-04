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
 Do remote image loading here if you want. Called only on visible cells when scrolling stops.
 */
-(void) scrollingDidStop;

@end
