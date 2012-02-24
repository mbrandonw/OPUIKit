//
//  OPVectorView.h
//  OPUIKit
//
//  Created by Brandon Williams on 2/21/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPVectorView : UIView

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, readonly) CGSize originalSize;

-(id) initWithVectorNamed:(NSString*)name;
-(id) initWithVectorAtPath:(NSString*)path;

@end
