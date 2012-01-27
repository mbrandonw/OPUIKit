//
//  OPActiveScrollViewManager.h
//  Kickstarter
//
//  Created by Brandon Williams on 1/27/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const OPActiveScrollViewManagerBecameActive;
extern NSString* const OPActiveScrollViewManagerResignedActive;

@interface OPActiveScrollViewManager : NSObject

+(id) sharedManager;

-(void) addActiveScrollView;
-(void) removeActiveScrollView;

-(BOOL) hasActiveScrollView;

@end
