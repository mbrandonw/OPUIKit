//
//  __OPTableViewCell.h
//  Kickstarter
//
//  Created by Brandon Williams on 1/3/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface __OPTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UIView *cellView;

-(id) initWithViewClass:(Class)viewClass reuseIdentifier:(NSString *)reuseIdentifier;

@end
