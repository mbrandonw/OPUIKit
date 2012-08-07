//
//  OPRevealableViewController.h
//  Kickstarter
//
//  Created by Brandon Williams on 8/7/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPStyle.h"

@interface OPRevealableViewController : UIViewController <OPStyleProtocol>

@property (nonatomic, strong) UIViewController *masterViewController;
@property (nonatomic, strong) UIViewController *detailViewController;

@property (nonatomic, assign) CGFloat detailWidth;
@property (nonatomic, assign, getter = isDetailHidden) BOOL detailHidden;

-(void) setDetailHidden:(BOOL)detailHidden animated:(BOOL)animated;

@end

@interface UIViewController (OPRevealableViewController)
@property (nonatomic, readonly) OPRevealableViewController *revealableViewController;
@end