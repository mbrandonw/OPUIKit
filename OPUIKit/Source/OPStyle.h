//
//  OPStyle.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/16/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPStyleProtocol.h"

@interface OPStyle : NSObject <OPStyleProtocol>

@property (nonatomic, strong, readonly) NSMutableSet *editedProperties;

/**
 Apply this style object's properties to a target.
 */
-(void) applyTo:(id)target;

@end

@interface NSObject (OPStyle)

/**
 Returns the style object for this class.
 */
+(OPStyle*) styling;

/**
 Returns the style object for this object's class.
 */
-(OPStyle*) styling;

@end
