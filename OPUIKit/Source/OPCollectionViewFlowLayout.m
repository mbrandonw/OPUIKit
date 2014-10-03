//
//  OPCollectionViewFlowLayout.m
//  Kickstarter
//
//  Created by Brandon Williams on 1/14/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import "OPCollectionViewFlowLayout.h"

@implementation OPCollectionViewFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
  NSArray* attributesToReturn = [super layoutAttributesForElementsInRect:rect];
  for (UICollectionViewLayoutAttributes* attributes in attributesToReturn) {
    if (nil == attributes.representedElementKind) {
      NSIndexPath* indexPath = attributes.indexPath;
      attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
    }
  }
  return attributesToReturn;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes* currentItemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];

  UIEdgeInsets sectionInset = [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout sectionInset];
  if (indexPath.item == 0) {
    CGRect frame = currentItemAttributes.frame;
    frame.origin.y = sectionInset.top;
    currentItemAttributes.frame = frame;
    return currentItemAttributes;
  }

  NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
  CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
  CGFloat previousFrameRightPoint = previousFrame.origin.y + previousFrame.size.height + 0.0f;
  CGRect currentFrame = currentItemAttributes.frame;
  CGRect strecthedCurrentFrame = CGRectMake(currentFrame.origin.x,
                                            0,
                                            currentFrame.size.width,
                                            self.collectionView.frame.size.height
                                            );
  if (!CGRectIntersectsRect(previousFrame, strecthedCurrentFrame)) {
    CGRect frame = currentItemAttributes.frame;
    frame.origin.y = frame.origin.y = sectionInset.top;
    currentItemAttributes.frame = frame;
    return currentItemAttributes;
  }
  CGRect frame = currentItemAttributes.frame;
  frame.origin.y = previousFrameRightPoint;
  currentItemAttributes.frame = frame;
  
  return currentItemAttributes;
}

@end
