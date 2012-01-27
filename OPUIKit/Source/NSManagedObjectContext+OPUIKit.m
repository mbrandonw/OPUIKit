//
//  NSManagedObjectContext+OPUIKit.m
//  Kickstarter
//
//  Created by Brandon Williams on 1/27/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import "NSManagedObjectContext+OPUIKit.h"
#import "OPActiveScrollViewManager.h"
#import "OPMacros.h"
#import <objc/runtime.h>

#define kHasDeferredSaveKey "HasDeferredSaveKey"

@interface NSManagedObjectContext (OPUIKit_Private)
@property (nonatomic, assign) BOOL hasDeferredSave;
-(BOOL) OP_privateSave;
@end

@implementation NSManagedObjectContext (OPUIKit)

-(void) setHasDeferredSave:(BOOL)hasDeferredSave {
    objc_setAssociatedObject(self, kHasDeferredSaveKey, [NSNumber numberWithBool:hasDeferredSave], OBJC_ASSOCIATION_RETAIN);
}

-(BOOL) hasDeferredSave {
    return [objc_getAssociatedObject(self, kHasDeferredSaveKey) boolValue];
}

-(NSManagedObjectContextSaveType) OP_save {
    
    // defer the save if there is an active scroll view
    if ([[OPActiveScrollViewManager sharedManager] hasActiveScrollView])
    {
        self.hasDeferredSave = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OP_privateSave) name:OPActiveScrollViewManagerResignedActive object:nil];
        return NSManagedObjectContextSaveDeferred;
    }
    
    return [self OP_privateSave] ? NSManagedObjectContextSaveSuccessful : NSManagedObjectContextSaveFailed;
}

-(BOOL) OP_privateSave {
    
    self.hasDeferredSave = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OPActiveScrollViewManagerResignedActive object:nil];
    
    BOOL saved = NO;
    @try {
        saved = [self save:NULL];
    } @catch (NSException *exception) {
		DLog(@"Problem saving: %@", (id)[exception userInfo] ?: (id)[exception reason]);
    }
    return saved;
}

@end
