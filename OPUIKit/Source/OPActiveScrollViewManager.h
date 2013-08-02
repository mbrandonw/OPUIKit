//
//  OPActiveScrollViewManager.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/27/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPMacros.h"

extern NSString* const OPActiveScrollViewManagerBecameActive;
extern NSString* const OPActiveScrollViewManagerResignedActive;

@interface OPActiveScrollViewManager : NSObject

OP_SINGLETON_HEADER_FOR(NSCache, sharedCache);

+(id) sharedManager;

-(void) addActiveScrollView;
-(void) removeActiveScrollView;

-(BOOL) hasActiveScrollView;

@end
