//
//  OPPDFView.h
//  Kickstarter
//
//  Created by Brandon Williams on 2/10/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPView.h"

@interface OPPDFView : OPView

-(void) loadPDFAtPath:(NSString*)path;

@end
