//
//  OPNavigationBar.m
//  OPUIKit
//
//  Created by Brandon Williams on 12/19/10.
//  Copyright 2010 Opetopic. All rights reserved.
//

#import "OPNavigationBar.h"

#pragma mark Styling vars
static UIColor *OPNavigationBarDefaultColor;
static BOOL OPNavigationBarDefaultTranslucent;
#pragma mark -

@implementation OPNavigationBar

@synthesize barColor;

#pragma mark Styling methods
+(void) setDefaultColor:(UIColor*)color {
	OPNavigationBarDefaultColor = color;
}

+(void) setDefaultTranslucent:(BOOL)translucent {
	OPNavigationBarDefaultTranslucent = translucent;
}
#pragma mark -


#pragma mark Initialization methods
-(id) initWithCoder:(NSCoder *)aDecoder {
	if (! (self = [super initWithCoder:aDecoder]))
		return nil;
	
	barColor = OPNavigationBarDefaultColor;
	self.translucent = OPNavigationBarDefaultTranslucent;
	
	return self;
}
#pragma mark -


#pragma mark Drawing methods
-(void) drawRect:(CGRect)rect {
	
	if (self.barColor)
	{
		CGContextRef c = UIGraphicsGetCurrentContext();
		[self.barColor set];
		CGContextFillRect(c, rect);
	}
	else
		[super drawRect:rect];
}
#pragma mark -


#pragma mark Custom getters/setters
-(void) setBarColor:(UIColor *)c {
	barColor = c;
	[self setNeedsDisplay];
}
#pragma mark -


#pragma mark Overridden methods
-(void) setTintColor:(UIColor *)c {
	[super setTintColor:[self tintColor]];
}
#pragma mark -


@end
