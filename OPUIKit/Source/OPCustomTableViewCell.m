//
//  OPCustomTableViewCell.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/26/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPCustomTableViewCell.h"

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
    [(OPCustomTableViewCell*)[self superview] drawContentView:rect highlighted:NO];
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
    [(OPCustomTableViewCell *)[self superview] drawContentView:rect highlighted:YES];
}

@end

@implementation OPCustomTableViewCell

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

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.hidden = YES;
    [self.contentView removeFromSuperview];
}

- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted {
    // subclasses should implement this
}

+(CGFloat) heightForObject:(id)object cellWidth:(CGFloat)width {
    return 44.0f;
}

+(CGFloat) heightForObject:(id)object cellWidth:(CGFloat)width isFirst:(BOOL)isFirst isLast:(BOOL)isLast {
    return [[self class] heightForObject:object cellWidth:width];
}

-(void) setFirstInSection:(BOOL)firstInSection {
    _firstInSection = firstInSection;
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

-(void) setLastInSection:(BOOL)lastInSection {
    _lastInSection = lastInSection;
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

-(void) setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

-(void) setObject:(id)object {
    _object = object;
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

@end
