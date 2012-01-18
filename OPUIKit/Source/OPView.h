//
//  OPView.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/2/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPStyleProtocol.h"

@interface OPView : UIView <OPStyleProtocol>

@property (nonatomic, copy) NSMutableArray *drawingBlocks;

@end
