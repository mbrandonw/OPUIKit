//
//  OPDataDetectorLabel.h
//  OPUIKit
//
//  Created by Brandon Williams on 2/1/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

/**
 This class is heavily influenced by Craig Hockenberry's "Fancy Label",
 as seen here http://furbo.org/2008/10/07/fancy-uilabels/
 */

#import <UIKit/UIKit.h>
#import "OPStyleProtocol.h"

@class OPDataDetector;
@class OPDataDetectorLabel;

typedef void(^OPDataDetectorLabelEventHandler)(OPDataDetectorLabel *label, NSString *data, OPDataDetector *dataDetector);
typedef UIButton*(^OPDataDetectorLabelButtonGenerator)(OPDataDetectorLabel *label, OPDataDetector *dataDetector);

extern OPDataDetector *OPDataDetectorPhoneNumber;
extern OPDataDetector *OPDataDetectorEmailAddress;
extern OPDataDetector *OPDataDetectorLink;

@interface OPDataDetector : NSObject
@property (nonatomic, strong, readonly) NSRegularExpression *regex;
@property (nonatomic, strong, readonly) NSRegularExpression *userInfo;
-(id) initWithRegex:(NSRegularExpression*)regex userInfo:(id)userInfo;
@end

@interface OPDataDetectorLabel : UIView <OPStyleProtocol>

/**
 An array of OPDataDetector objects.
 */
@property (nonatomic, copy) NSArray *dataDetectors;

/**
 The UILabel this class wraps.
 */
@property (nonatomic, strong, readonly) UILabel *label;

/**
 Event handler for the label.
 */
@property (nonatomic, copy) OPDataDetectorLabelEventHandler eventHandler;

@property (nonatomic, copy) OPDataDetectorLabelButtonGenerator buttonGenerator;

/**
 */
@property (nonatomic, assign) BOOL dataDetectorsEnabled;

@end
