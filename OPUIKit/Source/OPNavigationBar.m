//
//  OPNavigationBar.m
//  OPUIKit
//
//  Created by Brandon Williams on 12/19/10.
//  Copyright 2010 Opetopic. All rights reserved.
//

#import "OPNavigationBar.h"
#import "OPExtensionKit.h"
#import "UIImage+Opetopic.h"
#import "UIColor+Opetopic.h"
#import "OPGradient.h"
#import "OPGradientView.h"
#import "UIView+Opetopic.h"
#import "OPBarButtonItem.h"

@interface OPNavigationBar (/**/)
@property (nonatomic, strong) OPGradientView *shadowView;
@property (nonatomic, strong) UIView *visibleStatusView;
@property (nonatomic, strong) UIView *statusViewContainer;

-(void) showStatusView:(UIView*)statusView;
-(void) showStatusView:(UIView*)statusView hideAfter:(NSTimeInterval)hideAfter;
-(void) showStatusView:(UIView*)statusView hideAfter:(NSTimeInterval)hideAfter completion:(void(^)(void))completion;
-(void) hideStatusView;
-(void) hideStatusView:(void(^)(void))completion;

@end

@implementation OPNavigationBar

// Supported OPStyle storage
@synthesize backgroundImage = _backgroundImage;
@synthesize shadowHeight = _shadowHeight;
@synthesize shadowColors = _shadowColors;
@synthesize gradientAmount = _gradientAmount;
@synthesize glossAmount = _glossAmount;
@synthesize glossOffset = _glossOffset;
@synthesize translucent = _translucent;
@synthesize navigationBarDrawingBlock = _navigationBarDrawingBlock;

#pragma mark -
#pragma mark Object lifecycle
#pragma mark -

-(id) initWithCoder:(NSCoder *)aDecoder {
	if (! (self = [super initWithCoder:aDecoder]))
		return nil;
    
    self.clipsToBounds = NO;
	
    self.shadowView = [[OPGradientView alloc] initWithFrame:CGRectMake(0.0f, self.height, self.width, self.shadowHeight)];
    self.shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.shadowView.gradientLayer.startPoint = CGPointMake(0.5f, 1.0f);
    self.shadowView.gradientLayer.endPoint = CGPointMake(0.5f, 0.0);
    [self addSubview:self.shadowView];
    
    // apply stylings
    [[[self class] styling] applyTo:self];
    
    // pass the background color to the tint color so that default bar button items inherit some of the styling
    if (self.backgroundColor)
        self.tintColor = self.backgroundColor;
    
	return self;
}

#pragma mark -
#pragma mark Drawing methods
#pragma mark -

-(void) drawRect:(CGRect)rect {
    BOOL shouldCallSuper = YES;
    CGContextRef c = UIGraphicsGetCurrentContext();
	
    // draw background images & colors
    if (self.backgroundImage)
    {
        shouldCallSuper = NO;
        
        // figure out if we need to draw a stretchable image or a pattern image
        if ([self.backgroundImage isStretchableImage])
            [self.backgroundImage drawInRect:rect];
        else
            [self.backgroundImage drawAsPatternInRect:rect];
    }
    if (self.backgroundColor)
    {
        shouldCallSuper = NO;
        
        if (self.gradientAmount > 0.0f) {
            [[OPGradient gradientWithColors:@[[self.backgroundColor lighten:self.gradientAmount], 
                                             self.backgroundColor, 
                                             [self.backgroundColor darken:self.gradientAmount]]] fillRectLinearly:rect];
        }
    }
    
    // apply gloss over everything
    if (self.glossAmount)
    {
        shouldCallSuper = NO;
        [$WAf(1.0f,self.glossAmount) set];
        CGContextFillRect(c, CGRectMake(0.0f, 0.0f, rect.size.width, roundf(rect.size.height/2.0f + self.glossOffset)));
    }
    
    // apply additional block based drawing
    if (self.navigationBarDrawingBlock)
    {
        shouldCallSuper = NO;
        self.navigationBarDrawingBlock(self, rect, c);
    }
    
    if (shouldCallSuper)
        [super drawRect:rect];
}

-(void) layoutSubviews {
    [super layoutSubviews];
    self.shadowView.frame = CGRectMake(0.0f, self.height, self.width, self.shadowView.height);
    
    if ([self.topItem.rightBarButtonItem isKindOfClass:[OPBarButtonItem class]] && [(OPBarButtonItem*)self.topItem.rightBarButtonItem isFlush])
    {
        self.topItem.rightBarButtonItem.customView.right = self.width;
        self.topItem.rightBarButtonItem.customView.height = self.height;
    }
    if ([self.topItem.leftBarButtonItem isKindOfClass:[OPBarButtonItem class]] && [(OPBarButtonItem*)self.topItem.leftBarButtonItem isFlush])
    {
        self.topItem.leftBarButtonItem.customView.left = 0.0f;
        self.topItem.leftBarButtonItem.customView.height = self.height;
    }
}

#pragma mark -
#pragma mark Custom getters/setters
#pragma mark -

-(void) setShadowHeight:(CGFloat)shadowHeight {
    _shadowHeight = shadowHeight;
    self.shadowView.height = shadowHeight;
    [self setShadowHidden:(shadowHeight == 0.0f)];
    [self setNeedsLayout];
}

-(void) setShadowColors:(NSArray *)shadowColors {
    _shadowColors = shadowColors;
    self.shadowView.gradientLayer.colors = shadowColors;
    [self setNeedsLayout];
}

-(void) setShadowHidden:(BOOL)hidden {
    [self setShadowHidden:hidden animated:NO];
}

-(void) setShadowHidden:(BOOL)hidden animated:(BOOL)animated {
    _shadowHeight = hidden;
    
    [UIView animateWithDuration:(0.3f * animated) animations:^{
        self.shadowView.alpha = hidden ? 0.0f : 1.0f;
    } completion:^(BOOL finished) {
        self.shadowView.hidden = hidden;
    }];
}

#pragma mark -
#pragma mark Status view methods
#pragma mark -

-(void) showStatusView:(UIView*)statusView {
    [self showStatusView:statusView hideAfter:4.0f];
}

-(void) showStatusView:(UIView*)statusView hideAfter:(NSTimeInterval)hideAfter {
    [self showStatusView:statusView hideAfter:hideAfter completion:nil];
}

-(void) showStatusView:(UIView*)statusView hideAfter:(NSTimeInterval)hideAfter completion:(void(^)(void))completion {
    
    if (statusView == self.visibleStatusView)
    {
        // do nothing
    }
    else
    {
        [self.visibleStatusView removeFromSuperview];
        self.visibleStatusView = statusView;
        statusView.width = self.width;
        
        self.statusViewContainer = self.statusViewContainer ?: [UIView new];
        [self addSubview:self.statusViewContainer];
        self.statusViewContainer.top = self.height;
        self.statusViewContainer.width = self.width;
        self.statusViewContainer.height = self.visibleStatusView.height;
        self.statusViewContainer.clipsToBounds = YES;
        
        statusView.left = 0.0f;
        statusView.bottom = 0.0f;
        [self.statusViewContainer addSubview:statusView];
        
        [UIView animateWithDuration:0.3f animations:^{
            statusView.top = 0.0f;
        } completion:^(BOOL finished) {
            [self performSelector:@selector(hideStatusView) withObject:nil afterDelay:hideAfter];
            if (completion)
                completion();
        }];
    }
}

-(void) hideStatusView {
    [self hideStatusView:nil];
}

-(void) hideStatusView:(void(^)(void))completion {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (self.visibleStatusView)
    {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.visibleStatusView.bottom = 0.0f;
        } completion:^(BOOL finished) {
            [self.visibleStatusView removeFromSuperview];
            self.visibleStatusView = nil;
            if (completion)
                completion();
        }];
    }
}

@end

@implementation UIViewController (OPNavigationBar)

-(void) showStatusView:(UIView*)statusView {
    [self showStatusView:statusView hideAfter:4.0f];
}

-(void) showStatusView:(UIView*)statusView hideAfter:(NSTimeInterval)hideAfter {
    [self showStatusView:statusView hideAfter:hideAfter completion:nil];
}

-(void) showStatusView:(UIView*)statusView hideAfter:(NSTimeInterval)hideAfter completion:(void(^)(void))completion {
    
    if ([self isViewVisible])
    {
        OPNavigationBar *navigationBar = (OPNavigationBar*)self.navigationController.navigationBar;
        if (! navigationBar && [self respondsToSelector:@selector(navigationBar)]) {
            navigationBar = (OPNavigationBar*)[(id)self navigationBar];
        }
        if ([navigationBar isKindOfClass:[OPNavigationBar class]])
        {
            [navigationBar showStatusView:statusView hideAfter:hideAfter completion:completion];
        }
    }
}

-(void) hideStatusView {
    [self hideStatusView:nil];
}

-(void) hideStatusView:(void(^)(void))completion {
    
    OPNavigationBar *navigationBar = (OPNavigationBar*)self.navigationController.navigationBar;
    if (! navigationBar && [self respondsToSelector:@selector(navigationBar)]) {
        navigationBar = (OPNavigationBar*)[(id)self navigationBar];
    }
    if ([navigationBar isKindOfClass:[OPNavigationBar class]])
    {
        [navigationBar hideStatusView:completion];
    }
}

@end
