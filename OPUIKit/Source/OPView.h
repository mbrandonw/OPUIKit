//
//  OPView.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/2/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPStyleProtocol.h"
#import "OPUIKitBlockDefinitions.h"
#import "OPViewController.h"

@interface OPView : UIView <OPStyleProtocol>

@property (nonatomic, weak) OPViewController *controller;

@property (nonatomic, strong) UIColor *blurTintColor;
-(void) setBlurStyle:(UIBarStyle)style;
-(void) removeBlurTintColor;

-(id) initWithDrawingBlock:(OPViewDrawingBlock)drawingBlock;
-(id) initWithFrame:(CGRect)rect drawingBlock:(OPViewDrawingBlock)drawingBlock;

-(void) configureForContentSizeCategory:(NSString*)category;
+(void) configureForContentSizeCategory:(NSString*)category;

@end
