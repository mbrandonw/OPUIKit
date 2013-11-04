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

/**
 Data detectors in UITextView can be pretty buggy and crashy. This method
 tries to replicate its functionality to the best of our abilities.
 */
-(void) setAttributedTextWithPlainText:(NSString*)plainText
                         dataDetectors:(UIDataDetectorTypes)dataDetectorTypes
                     defaultAttributes:(NSDictionary*)defaultAttributes
                        linkAttributes:(NSDictionary*)linkAttributes;

@end
