//
//  OPImageView.m
//  OPUIKit
//
//  Created by Brandon Williams on 2/10/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "OPImageView.h"
#import "OPCache.h"

@interface OPImageView (/**/)
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *cacheName;
@end

@implementation OPImageView

@synthesize animation = _animation;
@synthesize imageURL = _imageURL;
@synthesize cacheName = _cacheName;

-(void) loadImageURL:(NSString*)url {
    [self loadImageURL:url placeholder:nil];
}

-(void) loadImageURL:(NSString*)url placeholder:(UIImage*)placeholder {
    [self loadImageURL:url placeholder:placeholder processing:nil cacheName:@""];
}

-(void) loadImageURL:(NSString*)url placeholder:(UIImage*)placeholder processing:(UIImage*(^)(UIImage *image))processing cacheName:(NSString*)cacheName {
    
    [[OPCache sharedCache] cancelFetchForURL:self.imageURL cacheName:self.cacheName];
    
    self.imageURL = url;
    self.cacheName = cacheName;
    self.image = placeholder;
    
    [[OPCache sharedCache] fetchImageForURL:url cacheName:cacheName processing:processing completion:^(UIImage *image, BOOL fromCache) {
        
        self.image = image;
        [self setNeedsLayout];
        
        if (! fromCache && image && self.animation == OPImageViewURLLoadedAnimationFade)
        {
            self.alpha = 0.0f;
            [UIView animateWithDuration:0.3f animations:^{
                self.alpha = 1.0f;
            }];
        }
    }];
}

@end
