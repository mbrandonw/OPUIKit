//
//  OPView.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/2/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPView.h"
#import "OPStyle.h"
#import "OPGradient.h"
#import "UIColor+Opetopic.h"
#import "NSDictionary+Opetopic.h"
#import "UIBezierPath+Opetopic.h"

static NSInteger drawingBlocksContext;

@interface OPView (/**/)
-(void) __init;

@property (nonatomic, strong) NSString *lastContentSizeCategory;
-(void) configureForCurrentContentSizeCategory;
+(void) configureForCurrentContentSizeCategory;

@end

@implementation OPView

@synthesize drawingBlocks = _drawingBlocks;

#pragma mark -
#pragma mark Object lifecycle
#pragma mark -

+(void) initialize {
  [[self class] configureForCurrentContentSizeCategory];
}

-(instancetype) initWithViewController:(UIViewController*)viewController {
  return [self initWithFrame:CGRectZero viewController:viewController];
}

-(instancetype) initWithFrame:(CGRect)frame viewController:(UIViewController*)viewController {
  self.viewController = viewController;

  if (! (self = [self initWithFrame:frame])) {
    return nil;
  }

  return self;
}

-(id) initWithDrawingBlock:(OPViewDrawingBlock)drawingBlock {
  if (! (self = [self initWithFrame:CGRectZero])) {
    return nil;
  }

  [self.drawingBlocks addObject:drawingBlock];

  return self;
}

-(id) initWithFrame:(CGRect)rect drawingBlock:(OPViewDrawingBlock)drawingBlock {
  if (! (self = [self initWithFrame:rect])) {
    return nil;
  }

  [self.drawingBlocks addObject:drawingBlock];

  return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
  if (! (self = [super initWithCoder:aDecoder])) {
    return nil;
  }

  [self __init];

  return self;
}

-(id) initWithFrame:(CGRect)frame {
  if (! (self = [super initWithFrame:frame])) {
    return nil;
  }

  [self __init];

  return self;
}

-(void) __init {
  self.drawingBlocks = [NSMutableArray new];
  [self addObserver:self forKeyPath:@"drawingBlocks" options:0 context:&drawingBlocksContext];
  [[[self class] styling] applyTo:self];

  if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
  }
}

-(void) dealloc {
  [self removeObserver:self forKeyPath:@"drawingBlocks" context:&drawingBlocksContext];

  if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
  }
}

#pragma mark -
#pragma mark View events
#pragma mark -

-(void) willMoveToSuperview:(UIView *)newSuperview {
  [self configureForCurrentContentSizeCategory];
}

#pragma mark -
#pragma mark Drawing and layout
#pragma mark -

-(void) drawRect:(CGRect)rect {
  [super drawRect:rect];

  CGContextRef c = UIGraphicsGetCurrentContext();
  for (OPViewDrawingBlock block in self.drawingBlocks) {
    block(self, rect, c);
  }
}

#pragma mark -
#pragma mark KVO
#pragma mark -

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if (context == &drawingBlocksContext) {
    [self setNeedsDisplay];
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

#pragma mark -
#pragma mark Drawing blocks
#pragma mark -

-(void) setDrawingBlocks:(NSMutableArray *)drawingBlocks {
  _drawingBlocks = drawingBlocks;
  [self setNeedsDisplay];
}

-(void) insertObject:(OPViewDrawingBlock)block inDrawingBlocksAtIndex:(NSUInteger)index {
  [_drawingBlocks insertObject:block atIndex:index];
  [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Preferred content size methods
#pragma mark -

-(void) configureForContentSizeCategory:(NSString*)category {
}

+(void) configureForContentSizeCategory:(NSString*)category {
}

#pragma mark -
#pragma mark Notification methods
#pragma mark -

-(void) preferredContentSizeChanged:(NSNotification*)notification {
  [[self class] configureForCurrentContentSizeCategory];
  [self configureForCurrentContentSizeCategory];
}

#pragma mark -
#pragma mark Private methods
#pragma mark -

-(void) configureForCurrentContentSizeCategory {
  NSString *currentContentSizeCategory = nil;

  if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
    currentContentSizeCategory = [[UIApplication sharedApplication] preferredContentSizeCategory];
  }

  if (! currentContentSizeCategory || ! [self.lastContentSizeCategory isEqualToString:currentContentSizeCategory]) {
    self.lastContentSizeCategory = currentContentSizeCategory ?: @"";
    [self configureForContentSizeCategory:currentContentSizeCategory];
  }
}

+(void) configureForCurrentContentSizeCategory {
  static NSMutableDictionary *lastContentSizeCategoryByClass = nil;
  lastContentSizeCategoryByClass = lastContentSizeCategoryByClass ?: [NSMutableDictionary new];

  NSString *classString = NSStringFromClass(self.class);
  NSString *currentContentSizeCategory = nil;
  NSString *lastContentSizeCategory = lastContentSizeCategoryByClass[classString];

  if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
    currentContentSizeCategory = [[UIApplication sharedApplication] preferredContentSizeCategory];
  }

  if (! currentContentSizeCategory || ! [lastContentSizeCategory isEqualToString:currentContentSizeCategory]) {
    lastContentSizeCategoryByClass[classString] = currentContentSizeCategory ?: @"";
    [[self class] configureForContentSizeCategory:currentContentSizeCategory];
  }
}

@end
