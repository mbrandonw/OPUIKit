//
//  UIView+OPBreakpoints.h
//  Kickstarter
//
//  Created by Brandon Williams on 1/6/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, OPBreakpointTriggerType) {
  OPBreakpointTriggerTypeLessThan,
  OPBreakpointTriggerTypeGreaterThan,
  OPBreakpointTriggerTypeEqual,
};

@interface UIView (OPBreakpoints)

@property (nonatomic, strong, readonly) NSArray *breakpoints;

/**
 Add a breakpoint to the view.
 */
-(void) addBreakpoint:(CGFloat)point;
-(void) addBreakpoint:(CGFloat)point handler:(void(^)(id self, OPBreakpointTriggerType type))handler;

/**
 Call this method from your view's setBounds: and
 setFrame: in order to subscribe to breakpoints.
 */
-(void) watchBreakpointsForCurrentWidth:(CGFloat)currentWidth previousWidth:(CGFloat)previousWidth;

/**
 Implement this method to be notified of breakpoints.
 */
-(void) breakpointTriggered:(CGFloat)point;

@end
