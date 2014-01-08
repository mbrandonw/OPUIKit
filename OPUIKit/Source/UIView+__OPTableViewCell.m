//
//  UIView+__OPTableViewCell.m
//  Kickstarter
//
//  Created by Brandon Williams on 1/3/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "UIView+__OPTableViewCell.h"
#import "__OPTableViewCell.h"
#import <objc/runtime.h>

#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation UIView (__OPTableViewCell)

-(void) setCellObject:(id)cellObject {
  objc_setAssociatedObject(self, @selector(cellObject), cellObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  if ([self respondsToSelector:@selector(cellObjectChanged)]) {
    [self cellObjectChanged];
  }

  for (UIView *subview in self.subviews) {
    subview.cellObject = cellObject;
  }

  [self setNeedsDisplay];
  [self setNeedsLayout];
  [self setNeedsUpdateConstraints];
}

-(id) cellObject {
  return objc_getAssociatedObject(self, @selector(cellObject));
}

#pragma mark -
#pragma mark Row methods
#pragma mark -

-(void) setCellRowIsFirst:(BOOL)cellRowIsFirst {
  objc_setAssociatedObject(self, @selector(cellRowIsFirst), @(cellRowIsFirst), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) cellRowIsFirst {
  return [objc_getAssociatedObject(self, @selector(cellRowIsFirst)) boolValue];
}

-(void) setCellRowIsLast:(BOOL)cellRowIsLast {
  objc_setAssociatedObject(self, @selector(cellRowIsLast), @(cellRowIsLast), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) cellRowIsLast {
  return [objc_getAssociatedObject(self, @selector(cellRowIsLast)) boolValue];
}

-(void) setCellRowIsEven:(BOOL)cellRowIsEven {
  objc_setAssociatedObject(self, @selector(cellRowIsEven), @(cellRowIsEven), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) cellRowIsEven {
  return [objc_getAssociatedObject(self, @selector(cellRowIsEven)) boolValue];
}

#pragma mark -
#pragma mark Section methods
#pragma mark -

-(void) setCellSectionIsFirst:(BOOL)cellSectionIsFirst {
  objc_setAssociatedObject(self, @selector(cellSectionIsFirst), @(cellSectionIsFirst), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) cellSectionIsFirst {
  return [objc_getAssociatedObject(self, @selector(cellSectionIsFirst)) boolValue];
}

-(void) setCellSectionIsLast:(BOOL)cellSectionIsLast {
  objc_setAssociatedObject(self, @selector(cellSectionIsLast), @(cellSectionIsLast), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) cellSectionIsLast {
  return [objc_getAssociatedObject(self, @selector(cellSectionIsLast)) boolValue];
}

-(void) setCellSectionIsEven:(BOOL)cellSectionIsEven {
  objc_setAssociatedObject(self, @selector(cellSectionIsEven), @(cellSectionIsEven), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) cellSectionIsEven {
  return [objc_getAssociatedObject(self, @selector(cellSectionIsEven)) boolValue];
}

#pragma mark -
#pragma mark Index path methods
#pragma mark -

-(void) setCellIndexPath:(NSIndexPath *)cellIndexPath {
  objc_setAssociatedObject(self, @selector(cellIndexPath), cellIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSIndexPath*) cellIndexPath {
  return objc_getAssociatedObject(self, @selector(cellIndexPath));
}

#pragma mark -
#pragma mark Table cell methods
#pragma mark -

-(void) setTableCellView:(__OPTableViewCell *)tableCellView {
  objc_setAssociatedObject(self, @selector(tableCellView), tableCellView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(__OPTableViewCell*) tableCellView {
  return objc_getAssociatedObject(self, @selector(tableCellView));
}

#pragma mark -
#pragma mark Cell size methods
#pragma mark -

-(CGSize) cellSizeWithAutolayout {
  [self layoutIfNeeded];
  CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
  return (CGSize){
    ceilf(size.width),
    ceilf(size.height)
  };
}

-(CGSize) cellSizeWithManualLayout {
  [self layoutIfNeeded];
  CGFloat height = 0;
  for (UIView *subview in self.subviews) {
    if (subview.alpha > 0.0f && !subview.hidden) {
      height = MAX(height, subview.bottom);
    }
  }
  return (CGSize){
    self.bounds.size.width,
    ceilf(height)
  };
}

@end
