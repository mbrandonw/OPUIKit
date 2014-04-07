//
//  UIView+__OPCellView.h
//  Kickstarter
//
//  Created by Brandon Williams on 1/3/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class __OPCellView;

@interface UIView (__OPCellView)

/**
 Subclasses should *NOT* override these getters/setters.
 */
@property (nonatomic, strong) id cellObject;
@property (nonatomic, assign) BOOL cellRowIsFirst;
@property (nonatomic, assign) BOOL cellRowIsLast;
@property (nonatomic, assign) BOOL cellRowIsEven;
@property (nonatomic, assign) BOOL cellSectionIsFirst;
@property (nonatomic, assign) BOOL cellSectionIsLast;
@property (nonatomic, assign) BOOL cellSectionIsEven;
@property (nonatomic, strong) NSIndexPath *cellIndexPath;
@property (nonatomic, assign) BOOL cellIsSelected;
@property (nonatomic, assign) BOOL cellIsHighlighted;

/**
 @b Optional: Subclasses can implement this method to bypass calculating
 cell size based on autolayout.
 */
-(CGSize) cellSize;

/**
 @b Optional: Subclasses can implement this method to provide a quick
 estimation of the size of the cell.
 */
+(CGSize) estimatedCellSize;

/**
 Performs a layout and then returns the size of the view.
 */
-(CGSize) cellSizeWithAutolayout;

/**
 Performs a layout, and then returns the small size containing
 all visible subviews. Visiable in this sense means hidden=NO
 and alpha>0.
 */
-(CGSize) cellSizeWithManualLayout;

/**
 Subclasses can implement these methods. They are all optional.
 */
-(BOOL) cellCanSelect;
-(BOOL) cellDidSelect;

/**
 Called when the object representing the cell changes. Optional.
 */
-(void) cellObjectChanged;

/**
 Implement this to do any last minute work just before the cell
 is displayed, e.g. loading images. Optional.
 */
-(void) cellWillDisplay;

/**
 @b Optional: Called when the cell is about to be reused.
 */
-(void) prepareForReuse;

/**
 */
-(void) configureForContentSizeCategory:(NSString*)contentSize;

@end
