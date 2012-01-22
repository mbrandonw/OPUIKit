//
//  OPBackBarButtonItem.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/22/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPBackBarButtonItem.h"
#import "OPStyle.h"

@implementation OPBackBarButtonItem

-(id) init {
    if (! (self = [super init]))
        return nil;
    
    // a default inset for back buttons so that the title is centered in the main button body (i.e. without the point)
    self.button.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 4.0f, 0.0f, 0.0f);
    
    // apply styles
    [[[self class] styling] applyTo:self];
    
    return self;
}

@end
