//
//  OPNavigationBar.h
//  OPUIKit
//
//  Created by Brandon Williams on 12/19/10.
//  Copyright 2010 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPStyle.h"

@interface OPNavigationBar : UINavigationBar <OPStyleProtocol>

@property (nonatomic, assign) BOOL shadowHidden;
-(void) setShadowHidden:(BOOL)hidden animated:(BOOL)animated;

@end
