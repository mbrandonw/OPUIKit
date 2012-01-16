//
//  OPViewController.h
//  OPUIKit
//
//  Created by Brandon Williams on 6/13/11.
//  Copyright 2011 Hashable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPStyle.h"

#if !defined(OP_VIEW_CONTROLLER_SIMULATE_MEMORY_WARNINGS)
#define OP_VIEW_CONTROLLER_SIMULATE_MEMORY_WARNINGS NO
#endif

@interface OPViewController : UIViewController <OPStyleProtocol>

@end
