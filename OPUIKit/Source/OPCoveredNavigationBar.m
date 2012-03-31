//
//  OPCoveredNavigationBar.m
//  Kickstarter
//
//  Created by Brandon Williams on 3/30/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import "OPCoveredNavigationBar.h"
#import "OPExtensionKit.h"
#import "OPUIKit.h"

@implementation OPCoveredNavigationBar

@synthesize titleControl = _titleControl;

-(id) initWithCoder:(NSCoder *)aDecoder {
    if (! (self = [super initWithCoder:aDecoder]))
        return nil;
    
    self.titleControl = [[OPControl alloc] initWithFrame:CGRectMake(self.width*0.25f, 0.0f, self.width*0.5f, self.height)];
    self.titleControl.autoresizingMask = UIViewAutoresizingFlexibleSize;
    [self addSubview:self.titleControl];
    
    [[[self class] styling] applyTo:self];
    
    return self;
}

@end
