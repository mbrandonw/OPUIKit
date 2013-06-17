//
//  OPCustomTableViewCell.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/26/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPTableViewCell.h"
#import "OPExtensionKit.h"

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

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (! (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    self.backgroundView = [[OPTableViewCellView alloc] initWithFrame:CGRectZero];
    self.backgroundView.opaque = YES;
    
    self.selectedBackgroundView.opaque = YES;
    self.selectedBackgroundView = [[OPTableViewSelectedCellView alloc] initWithFrame:CGRectZero];
    
    // apply stylings
    [[self styling] applyTo:self];
    
    return self;
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

+(CGFloat) heightForObject:(id)object cellWidth:(CGFloat)width {
    return 44.0f;
}

+(CGFloat) heightForObject:(id)object cellWidth:(CGFloat)width isFirst:(BOOL)isFirst isLast:(BOOL)isLast {
    return [[self class] heightForObject:object cellWidth:width];
}

-(void) setOdd:(BOOL)odd {
  self.even = !odd;
}

-(BOOL) isOdd {
  return !self.even;
}

-(void) setObject:(id)object {
  _object = object;
  [self setNeedsDisplay];
  [self setNeedsLayout];
  if ([self respondsToSelector:@selector(setNeedsUpdateConstraints)]) {
    [self setNeedsUpdateConstraints];
  }
}

@end
