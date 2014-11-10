//
//  OPCollectionViewController.h
//  Kickstarter
//
//  Created by Brandon Williams on 1/14/14.
//  Copyright (c) 2014 Kickstarter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPCollectionViewCell;
@class NSFetchedResultsController;

@protocol OPCollectionViewDataSource <UICollectionViewDataSource>
/**
 Returns the class of the UIView that represents the cell
 at the specified index path.
 */
-(Class) collectionView:(UICollectionView*)collectionView classForCellAtIndexPath:(NSIndexPath*)indexPath;

/**
 Returns the object that represents the cell at the
 specified index path.
 */
-(id) collectionView:(UICollectionView*)collectionView objectForCellAtIndexPath:(NSIndexPath*)indexPath;
@end

@protocol OPCollectionViewDelegate <UICollectionViewDelegate>
/**
 */
-(UIEdgeInsets) collectionView:(UICollectionView*)collectionView insetsForCellAtIndexPath:(NSIndexPath*)indexPath;

/**
 */
-(CGFloat) collectionView:(UICollectionView*)collectionView widthForCellAtIndexPath:(NSIndexPath*)indexPath;
@end

@interface OPCollectionViewController : UICollectionViewController <OPCollectionViewDataSource, OPCollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSFetchedResultsController *collectionResults;
@property (nonatomic, strong) NSMutableArray *collectionData;

/**
 A convenience method that simply removes all objects
 from subsets.
 */
-(void) clearCollectionData;

/**
 Any cell customization that needs to be done in the controller
 should be implemented here and not in cellForItemAtIndexPath.
 Implementations must call the super method.
 */
-(void) collectionView:(UICollectionView*)collectionView configureCellView:(UIView*)cellView atIndexPath:(NSIndexPath*)indexPath;

/**
 */
-(void) collectionView:(UICollectionView *)collectionView layoutCell:(OPCollectionViewCell*)cell;

/**
 Finds the index path of the object.
 */
-(NSIndexPath*) indexPathForObject:(id)object;

@end
