//
//  NSManagedObjectContext+OPUIKit.h
//  Kickstarter
//
//  Created by Brandon Williams on 1/27/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef enum {
    NSManagedObjectContextSaveFailed,
    NSManagedObjectContextSaveSuccessful,
    NSManagedObjectContextSaveDeferred,
} NSManagedObjectContextSaveType;

@interface NSManagedObjectContext (OPUIKit)

-(NSManagedObjectContextSaveType) OP_save;

@end
