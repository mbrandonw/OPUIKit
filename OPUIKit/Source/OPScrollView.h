//
//  OPScrollView.h
//  Kickstarter
//
//  Created by Brandon Williams on 10/27/13.
//  Copyright (c) 2013 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPScrollViewController.h"

@interface OPScrollView : UIScrollView

@property (nonatomic, weak) OPScrollViewController *viewController;

/**
 Set to YES if you want to have a root subview inside the scrollview
 which contains all other subviews. Can be useful when wanting to
 use autolayout in a scrollview, e.g. constraints against the 
 scrollview can get wonky.
 */
@property (nonatomic, assign) BOOL usesContentView;
@property (nonatomic, readonly, strong) UIView *contentView;

-(void) configureForContentSizeCategory:(NSString*)category;
+(void) configureForContentSizeCategory:(NSString*)category;

@end
