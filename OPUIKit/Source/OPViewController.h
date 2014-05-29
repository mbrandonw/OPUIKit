//
//  OPViewController.h
//  OPUIKit
//
//  Created by Brandon Williams on 6/13/11.
//  Copyright 2011 Hashable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPStyle.h"

extern const struct OPViewControllerNotifications {
	__unsafe_unretained NSString *loadView;
	__unsafe_unretained NSString *viewDidLoad;
	__unsafe_unretained NSString *viewWillAppear;
	__unsafe_unretained NSString *viewDidAppear;
	__unsafe_unretained NSString *viewWillDisappear;
	__unsafe_unretained NSString *viewDidDisappear;
} OPViewControllerNotifications;

@interface OPViewController : UIViewController <OPStyleProtocol>

/**
 Called when the preferred content size is changed in user's settings.
 */
-(void) preferredContentSizeChanged:(NSNotification*)notification;

/**
 Called at certain key times when the controller might need to respond
 to content size, e.g. viewWillAppear, when preferred size changes, just before
 view layout, etc. It is only called when the preferred content size has
 changed since the last time it was called.
 */
-(void) configureForContentSizeCategory:(NSString*)category;

/**
 Same as `-configureForContentSizeCategory:` except called only when
 the class initializes and when the preferred content size changes.
 This method is called before the corresponding instance method.
 */
+(void) configureForContentSizeCategory:(NSString*)category;

@end

/**
 Many view-related methods called on the controller will be
 forwarded to the view.
 */
@interface UIView (OPViewController)
-(void) viewWillAppear:(BOOL)animated;
-(void) viewDidAppear:(BOOL)animated;
-(void) viewWillDisappear:(BOOL)animated;
-(void) viewDidDisappear:(BOOL)animated;
-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
@end
