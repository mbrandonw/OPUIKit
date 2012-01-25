//
//  OPTableViewCell.h
//  OPUIKit
//
//  Created by Brandon Williams on 1/25/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    OPTableViewCellImageURLLoadingTypeImmediate,
    OPTableViewCellImageURLLoadingTypeScrollStops,
} OPTableViewCellImageURLLoadingType;

typedef enum {
    OPTableViewCellImageURLLoadingAnimationNone,
    OPTableViewCellImageURLLoadingAnimationFade,
} OPTableViewCellImageURLLoadingAnimation;

@interface OPTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, assign) OPTableViewCellImageURLLoadingType imageURLLoadingType;
@property (nonatomic, assign) OPTableViewCellImageURLLoadingAnimation imageURLLoadingAnimation;

/**
 Subclasses should override this.
 */
-(void) drawContentView:(CGRect)rect highlighted:(BOOL)highlighted;

/**
 Do remote image loading here if you want. Called only on visible cells when scrolling stops.
 */
-(void) scrollingDidStop;

@end
