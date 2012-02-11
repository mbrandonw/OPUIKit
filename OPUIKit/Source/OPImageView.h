//
//  OPImageView.h
//  Kickstarter
//
//  Created by Brandon Williams on 2/10/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPImageView : UIImageView

-(void) loadImageURL:(NSString*)url;
-(void) loadImageURL:(NSString*)url placeholder:(UIImage*)placeholder;
-(void) loadImageURL:(NSString*)url placeholder:(UIImage*)placeholder processing:(UIImage*(^)(UIImage *image))processing cacheName:(NSString*)cacheName;

@end
