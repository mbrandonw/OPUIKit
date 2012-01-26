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

@property (nonatomic, assign) OPTableViewCellImageURLLoadingType imageURLLoadingType;
@property (nonatomic, assign) OPTableViewCellImageURLLoadingAnimation imageURLLoadingAnimation;

/**
 Do remote image loading here if you want. Called only on visible cells when scrolling stops.
 */
-(void) scrollingDidStop;

-(void) loadImageURL:(NSString*)url;
-(void) loadImageURL:(NSString*)url placeholder:(UIImage*)placeholder;
-(void) loadImageURL:(NSString*)url placeholder:(UIImage*)placeholder processing:(UIImage*(^)(UIImage *image))processing cacheName:(NSString*)cacheName;


@end
