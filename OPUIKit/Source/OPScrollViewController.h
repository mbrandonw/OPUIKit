//
//  OPScrollViewController.h
//  OPUIKit
//
//  Created by Brandon Williams on 5/6/13.
//  Copyright (c) 2013 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPViewController.h"

@interface OPScrollViewController : OPViewController <UIScrollViewDelegate>

@property (nonatomic, strong, readonly) UIScrollView *scrollView;

@end

/**
 UIScrollViewDelegate methods are forwarded to the scrollView.
 */
@interface UIScrollView (OPScrollViewController) <UIScrollViewDelegate>
@end
