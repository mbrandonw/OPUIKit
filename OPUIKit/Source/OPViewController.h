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

@end
