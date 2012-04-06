//
//  OPTableViewCell.m
//  OPUIKit
//
//  Created by Brandon Williams on 1/25/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPTableViewCell.h"
#import "OPCache.h"

@interface OPTableViewCell (/**/)
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) UIImage *placeholder;
@property (nonatomic, copy) UIImage*(^processing)(UIImage *image);
@property (nonatomic, strong) NSString *cacheName;
-(void) immediateLoadImageURL:(NSString*)url placeholder:(UIImage*)placeholder processing:(UIImage*(^)(UIImage *image))processing cacheName:(NSString*)cacheName;
@end

@implementation OPTableViewCell

@synthesize imageURL = _imageURL;
@synthesize imageURLLoadingType = _imageURLLoadingType;
@synthesize imageURLLoadingAnimation = _imageURLLoadingAnimation;
@synthesize cacheName = _cacheName;
@synthesize processing = _processing;
@synthesize placeholder = _placeholder;

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (! (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    self.imageURLLoadingAnimation = OPTableViewCellImageURLLoadingAnimationNone;
    self.imageURLLoadingType = OPTableViewCellImageURLLoadingTypeScrollStops;
    
    return self;
}

-(void) scrollingDidStop {
    
    if (self.imageURL && self.imageURLLoadingType == OPTableViewCellImageURLLoadingTypeScrollStops)
    {
        [self immediateLoadImageURL:self.imageURL placeholder:self.placeholder processing:self.processing cacheName:self.cacheName];
    }
}

-(void) loadImageURL:(NSString*)url {
    [self loadImageURL:url placeholder:nil];
}

-(void) loadImageURL:(NSString*)url placeholder:(UIImage*)placeholder {
    [self loadImageURL:url placeholder:placeholder processing:nil cacheName:@""];
}

-(void) loadImageURL:(NSString*)url placeholder:(UIImage*)placeholder processing:(UIImage*(^)(UIImage *image))processing cacheName:(NSString*)cacheName {
    
    [[OPCache sharedCache] cancelFetchForURL:self.imageURL cacheName:self.cacheName];
    
    self.imageURL = url;
    self.placeholder = placeholder;
    self.processing = processing;
    self.cacheName = cacheName;
    
    if (self.imageURLLoadingType == OPTableViewCellImageURLLoadingTypeImmediate)
    {
        [self immediateLoadImageURL:url placeholder:placeholder processing:processing cacheName:cacheName];
    }
    else
    {
        UIImage *cachedImage = [(OPCache*)[OPCache sharedCache] cachedImageForURL:url cacheName:cacheName];
        if (cachedImage)
            self.imageView.image = cachedImage;
        else
            self.imageView.image = placeholder;
        
        [self setNeedsLayout];
    }
}

-(void) immediateLoadImageURL:(NSString*)url placeholder:(UIImage*)placeholder processing:(UIImage*(^)(UIImage *image))processing cacheName:(NSString*)cacheName {
    
    self.imageView.image = placeholder;
    
    [[OPCache sharedCache] fetchImageForURL:url cacheName:cacheName processing:processing completion:^(UIImage *image, BOOL fromCache) {
        
        self.imageView.image = image;
        [self setNeedsLayout];
        
        if (! fromCache && image && self.imageURLLoadingAnimation == OPTableViewCellImageURLLoadingAnimationFade)
        {
            self.imageView.alpha = 0.0f;
            [UIView animateWithDuration:0.3f animations:^{
                self.imageView.alpha = 1.0f;
            }];
        }
    }];
}

@end
