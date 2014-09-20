//
//  UIView+OPBreakpoints.m
//  Kickstarter
//
//  Created by Brandon Williams on 1/6/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "UIView+OPBreakpoints.h"
#import "UIView+__OPCellView.h"
@import ObjectiveC;

@interface UIView (OPBreakpoints_Private)
@property (nonatomic, strong, readwrite) NSMutableArray *breakpoints;
@property (nonatomic, strong) NSMutableDictionary *breakpointHandlers;
@end

#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation UIView (OPBreakpoints)

-(void) setBreakpoints:(NSArray *)breakpoints {
  objc_setAssociatedObject(self, @selector(breakpoints), breakpoints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableArray*) breakpoints {
  NSMutableArray *retVal = objc_getAssociatedObject(self, @selector(breakpoints));
  if (! retVal) {
    self.breakpoints = retVal = [NSMutableArray new];
  }
  return retVal;
}

-(void) setBreakpointHandlers:(NSMutableDictionary *)breakpointHandlers {
  objc_setAssociatedObject(self, @selector(breakpointHandlers), breakpointHandlers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableDictionary*) breakpointHandlers {
  NSMutableDictionary *retVal = objc_getAssociatedObject(self, @selector(breakpointHandlers));
  if (! retVal) {
    self.breakpointHandlers = retVal = [NSMutableDictionary new];
  }
  return retVal;
}

-(void) addBreakpoint:(CGFloat)point {
  [self addBreakpoint:point handler:nil];
}

-(void) addBreakpoint:(CGFloat)point handler:(void(^)(id, OPBreakpointTriggerType))handler {
  [self.breakpoints addObject:@(point)];
  if (handler) {
    self.breakpointHandlers[@(point)] = handler;
  }
}

-(void) watchBreakpointsForCurrentWidth:(CGFloat)currentWidth previousWidth:(CGFloat)previousWidth {

  for (NSNumber *breakpointNumber in self.breakpoints) {
    CGFloat breakpoint = [breakpointNumber floatValue];
    if ((previousWidth < breakpoint && currentWidth > breakpoint) ||
        (previousWidth > breakpoint && currentWidth < breakpoint) ||
        (previousWidth != currentWidth && (previousWidth == breakpoint || currentWidth == breakpoint))) {

      if ([self.class respondsToSelector:@selector(configureForContentSizeCategory:)]) {
        [self.class configureForContentSizeCategory:nil];
      }
      if ([self respondsToSelector:@selector(configureForContentSizeCategory:)]) {
        [self configureForContentSizeCategory:nil];
      }

      if ([self respondsToSelector:@selector(breakpointTriggered:)]) {
        [self breakpointTriggered:breakpoint];
      }

      void(^handler)(id, OPBreakpointTriggerType) = self.breakpointHandlers[breakpointNumber];
      if (handler) {
        handler(self, currentWidth == breakpoint ? OPBreakpointTriggerTypeEqual : currentWidth > breakpoint ? OPBreakpointTriggerTypeGreaterThan : OPBreakpointTriggerTypeLessThan);
      }
    }
  }
}

@end
