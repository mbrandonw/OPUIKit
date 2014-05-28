//
//  OPView.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/2/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPUIKitBlockDefinitions.h"
#import "OPStyleProtocol.h"

@interface OPView : UIView <OPStyleProtocol>

@property (nonatomic, weak) UIViewController *viewController;

-(instancetype) initWithViewController:(UIViewController*)viewController;
-(instancetype) initWithFrame:(CGRect)frame viewController:(UIViewController*)viewController;

-(void) configureForContentSizeCategory:(NSString*)category;
+(void) configureForContentSizeCategory:(NSString*)category;

@end
