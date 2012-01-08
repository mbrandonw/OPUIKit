//
//  OPTextView.h
//  OPUIKit
//
//  Created by Brandon Williams on 10/10/11.
//  Copyright 2011 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPTextView : UITextView <UITextViewDelegate>

@property (nonatomic, strong, readonly) UILabel *placeholderLabel;

@end
