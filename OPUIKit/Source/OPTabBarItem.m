//
//  OPTabBarItem.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/13/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPTabBarItem.h"
#import "UIView+Opetopic.h"
#import "OPTabBarItemBadge.h"
#import "NSString+Opetopic.h"

#define kUserDefaultsBadgeKey(title)    $strfmt(@"%@_%@", @"UserDefaultsBadgePrefix", title)

@interface OPTabBarItem (/**/)
@property (nonatomic, strong, readwrite) UIImageView *iconView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) OPTabBarItemBadge *badge;
@property (nonatomic, assign) BOOL valueNotChanged;
-(BOOL) iconViewIsHidden;
-(BOOL) titleLabelIsHidden;
@end

@implementation OPTabBarItem

@synthesize iconView = _iconView;
@synthesize iconViewInsets = _iconViewInsets;
@synthesize titleLabel = _titleLabel;
@synthesize titleLabelInsets = _titleLabelInsets;
@synthesize badge = _badge;
@synthesize rememberBadgeValue = _rememberBadgeValue;
@synthesize valueNotChanged = _valueNotChanged;

-(id) init {
    if (! (self = [super init]))
        return nil;
    
    // default UIView properties
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    // init iconView subview
    self.iconView = [UIImageView new];
    [self addSubview:_iconView];
    
    // init titleLabel subview
    self.titleLabel = [UILabel new];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:11.0f];
    self.titleLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    self.titleLabel.highlightedTextColor = [UIColor whiteColor];
    self.titleLabelInsets = UIEdgeInsetsMake(0.0f, 0.0f, 1.0f, 0.0f);
    [self addSubview:self.titleLabel];
    
    // init badge subview
    self.badge = [OPTabBarItemBadge new];
    [self addSubview:self.badge];
    
    // apply stylings
    [[[self class] styling] applyTo:self];
    
    return self;
}

-(id) initWithTitle:(NSString *)title {
    if (! (self = [self init]))
        return nil;
    
    self.titleLabel.text = title;
    
    // check if we should restore the previously saved badge value
    if (self.rememberBadgeValue)
        [self.badge setValue:[[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsBadgeKey(title)]];
    
    // observe changes in the badge value so that we can remember it
    [self.badge.valueLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    
    return self;
}

-(void) dealloc {
    [self.badge.valueLabel removeObserver:self forKeyPath:@"text"];
}

-(void) layoutSubviews {
    [super layoutSubviews];
    
    [self.iconView sizeToFit];
    [self.titleLabel sizeToFit];
    
    
    // layout the titleLabel if it isn't hidden
    if (! [self titleLabelIsHidden])
    {
        // center the label horizontally
        self.titleLabel.width = MIN(self.width, self.titleLabel.width);
        self.titleLabel.left = roundf(self.width/2.0f - self.titleLabel.width/2.0f);
        
        if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentCenter)
        {
            if ([self iconViewIsHidden])
                self.titleLabel.top = roundf(self.height/2.0f - self.titleLabel.height/2.0f);
            else
                self.titleLabel.bottom = self.height;
        }
        else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom)
        {
            self.titleLabel.bottom = self.height;
        }
        else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentTop)
        {
            self.titleLabel.top = 0.0f;
        }
    }
    
    
    // layout the iconView subview if it isn't hidden
    if (! [self iconViewIsHidden])
    {
        // center the icon view horizontally
        self.iconView.left = roundf(self.width/2.0f - self.iconView.width/2.0f);
        
        if ([self titleLabelIsHidden] || 
            self.contentVerticalAlignment == UIControlContentVerticalAlignmentCenter || 
            self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom)
        {
            self.iconView.top = roundf(self.height/2.0f - self.iconView.height/2.0f);
            if (! [self titleLabelIsHidden])
                self.iconView.top -= roundf(self.titleLabel.height/2.0f);
        }
        else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentTop)
        {
            self.iconView.top = roundf(self.height/2.0f - self.iconView.height/2.0f + self.titleLabel.height/2.0f);
        }
    }
    
    
    // apply insets
    self.iconView.left += self.iconViewInsets.left - self.iconViewInsets.right;
    self.iconView.top += self.iconViewInsets.top - self.iconViewInsets.bottom;
    self.titleLabel.left += self.titleLabelInsets.left - self.titleLabelInsets.right;
    self.titleLabel.top += self.titleLabelInsets.top - self.titleLabelInsets.bottom;
    
    
    // layout the badge view
    self.badge.frame = CGRectMake(floorf(self.width * self.badge.relativeCenter.x - self.badge.width/2.0f), 
                                  floorf(self.height * self.badge.relativeCenter.y - self.badge.height/2.0f), 
                                  self.badge.width, self.badge.height);
}

#pragma mark -
#pragma KVO methods
#pragma mark -

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    // check if it is the badge value that changed
    if (object == self.badge.valueLabel)
    {
        // record the badge value when it changes
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        if (newValue != [NSNull null])
            [[NSUserDefaults standardUserDefaults] setObject:newValue forKey:kUserDefaultsBadgeKey(self.titleLabel.text)];
        else
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsBadgeKey(self.titleLabel.text)];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark -
#pragma mark Overridden UIControl methods
#pragma mark -

-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    return [super beginTrackingWithTouch:touch withEvent:event];
}

-(void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    // tie the control's selected state to the selected state of the icon image and title label
    self.titleLabel.highlighted = self.iconView.highlighted = selected;
}

#pragma mark -
#pragma mark Private methods
#pragma mark -

-(BOOL) iconViewIsHidden {
    return self.iconView.hidden || self.iconView.image == nil;
}

-(BOOL) titleLabelIsHidden {
    return self.titleLabel.hidden || [self.titleLabel.text length] == 0;
}

@end
