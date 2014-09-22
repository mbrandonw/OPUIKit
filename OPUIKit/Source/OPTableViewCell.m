//
//  OPCustomTableViewCell.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/26/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPTableViewCell.h"
#import "OPExtensionKit.h"

@interface OPTableViewCell (/**/)
@property (nonatomic, strong) NSString *lastContentSizeCategory;
-(void) configureForCurrentContentSizeCategory;
+(void) configureForCurrentContentSizeCategory;
@end

@interface OPTableViewCellView : UIView
@end

@interface OPTableViewSelectedCellView : UIView
@end

@implementation OPTableViewCellView

-(id) initWithFrame:(CGRect)frame {
    if (! (self = [super initWithFrame:frame]))
        return nil;
    self.contentMode = UIViewContentModeRedraw;
    return self;
}

-(void) drawRect:(CGRect)rect {
  CGContextRef c = UIGraphicsGetCurrentContext();
  [[self.superview typedAs:[OPTableViewCell class]] drawContentView:rect context:c highlighted:NO];
  [[self.superview.superview typedAs:[OPTableViewCell class]] drawContentView:rect context:c highlighted:NO];
}

@end

@implementation OPTableViewSelectedCellView

-(id) initWithFrame:(CGRect)frame {
    if (! (self = [super initWithFrame:frame]))
        return nil;
    self.contentMode = UIViewContentModeRedraw;
    return self;
}

-(void) drawRect:(CGRect)rect {
  CGContextRef c = UIGraphicsGetCurrentContext();
  [[self.superview typedAs:[OPTableViewCell class]] drawContentView:rect context:c highlighted:YES];
  [[self.superview.superview typedAs:[OPTableViewCell class]] drawContentView:rect context:c highlighted:YES];
}

@end

@implementation OPTableViewCell

+(void) initialize {
  [super initialize];
  
  [[self class] configureForCurrentContentSizeCategory];
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (! (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    self.backgroundView = [[OPTableViewCellView alloc] initWithFrame:CGRectZero];
    self.backgroundView.opaque = YES;
    
    self.selectedBackgroundView.opaque = YES;
    self.selectedBackgroundView = [[OPTableViewSelectedCellView alloc] initWithFrame:CGRectZero];
    
    // apply stylings
    [[self styling] applyTo:self];

    if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(preferredContentSizeChanged:)
                                                     name:UIContentSizeCategoryDidChangeNotification
                                                   object:nil];
    }

    return self;
}

-(void) willMoveToSuperview:(UIView *)newSuperview {
  [self configureForCurrentContentSizeCategory];
}

-(void) dealloc {

    if ([UIApplication instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
}

- (void)setSelected:(BOOL)selected {
    [self.selectedBackgroundView setNeedsDisplay];
    
    if(!selected && self.selected) {
        [self.backgroundView setNeedsDisplay];
    }
    
    [super setSelected:selected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [self.selectedBackgroundView setNeedsDisplay];
    
    if(!selected && self.selected) {
        [self.backgroundView setNeedsDisplay];
    }
    
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted {
    [self.selectedBackgroundView setNeedsDisplay];
    
    if(!highlighted && self.highlighted) {
        [self.backgroundView setNeedsDisplay];
    }
    
    [super setHighlighted:highlighted];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [self.selectedBackgroundView setNeedsDisplay];
    
    if(!highlighted && self.highlighted) {
        [self.backgroundView setNeedsDisplay];
    }
    
    [super setHighlighted:highlighted animated:animated];
}

- (void)setFrame:(CGRect)f {
    [super setFrame:f];
    CGRect b = [self bounds];
    [self.backgroundView setFrame:b];
    [self.selectedBackgroundView setFrame:b];
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    [self.backgroundView setNeedsDisplay];
    
    if([self isHighlighted] || [self isSelected]) {
        [self.selectedBackgroundView setNeedsDisplay];
    }
}

- (void)setNeedsDisplayInRect:(CGRect)rect {
    [super setNeedsDisplayInRect:rect];
    [self.backgroundView setNeedsDisplayInRect:rect];
    
    if([self isHighlighted] || [self isSelected]) {
        [self.selectedBackgroundView setNeedsDisplayInRect:rect];
    }
}

- (void)drawContentView:(CGRect)rect context:(CGContextRef)c highlighted:(BOOL)highlighted {
  [self.backgroundColor set];
  CGContextFillRect(c, rect);
}

+(CGFloat) heightForCellWidth:(CGFloat)width isFirst:(BOOL)isFirst isLast:(BOOL)isLast {
  return 0.0f;
}

+(CGFloat) heightForObject:(id)object cellWidth:(CGFloat)width isFirst:(BOOL)isFirst isLast:(BOOL)isLast {
  return [[self class] heightForCellWidth:width isFirst:isFirst isLast:isLast];
}

+(CGFloat) estimatedHeightForCellWidth:(CGFloat)width isFirst:(BOOL)isFirst isLast:(BOOL)isLast {
  return 0.0f;
}

+(CGFloat) estimatedHeightForObject:(id)object cellWidth:(CGFloat)width isFirst:(BOOL)isFirst isLast:(BOOL)isLast {
  return [[self class] estimatedHeightForCellWidth:width isFirst:isFirst isLast:isLast];
}

-(void) setOdd:(BOOL)odd {
  self.even = !odd;
}

-(BOOL) isOdd {
  return !self.even;
}

-(void) setObject:(id)object {
  _object = object;
  [self configureForCurrentContentSizeCategory];
  [self setNeedsDisplayAndLayout];
  if ([self respondsToSelector:@selector(translatesAutoresizingMaskIntoConstraints)] && ! self.translatesAutoresizingMaskIntoConstraints) {
    [self setNeedsUpdateConstraints];
  }
}

-(void) setScrollRatio:(CGFloat)scrollRatio {
  _scrollRatio = MAX(0.0f, MIN(1.0f, scrollRatio));
}

-(void) preferredContentSizeChanged:(NSNotification*)notification {
  [[self class] configureForCurrentContentSizeCategory];
  [self configureForCurrentContentSizeCategory];
}

-(void) configureForContentSizeCategory:(NSString*)category {
}

+(void) configureForContentSizeCategory:(NSString*)category {
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
