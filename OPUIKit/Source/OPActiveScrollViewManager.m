//
//  OPActiveScrollViewManager.m
//  Kickstarter
//
//  Created by Brandon Williams on 1/27/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import "OPActiveScrollViewManager.h"
#import "OPMacros.h"

NSString* const OPActiveScrollViewManagerBecameActive = @"OPActiveScrollViewManagerBecameActive";
NSString* const OPActiveScrollViewManagerResignedActive = @"OPActiveScrollViewManagerResignedActive";

@implementation OPActiveScrollViewManager {
    NSUInteger count;
}

OP_SYNTHESIZE_SINGLETON_FOR_CLASS(OPActiveScrollViewManager, sharedManager);

-(void) addActiveScrollView {
    count++;
    if (count == 1)
        [[NSNotificationCenter defaultCenter] postNotificationName:OPActiveScrollViewManagerBecameActive object:nil];
}

-(void) removeActiveScrollView {
    if (count == 1)
        [[NSNotificationCenter defaultCenter] postNotificationName:OPActiveScrollViewManagerResignedActive object:nil];
    count = count > 0 ? count-1 : 0;
}

-(BOOL) hasActiveScrollView {
    return count > 0;
}

@end
