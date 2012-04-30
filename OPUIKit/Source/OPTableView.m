//
//  OPTableView.m
//  Kickstarter
//
//  Created by Brandon Williams on 4/27/12.
//  Copyright (c) 2012 Kickstarter. All rights reserved.
//

#import "OPTableView.h"
#import <objc/runtime.h>

@interface OPTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) NSObject<UITableViewDataSource> *theDataSource;
@property (nonatomic, weak) NSObject<OPTableViewDelegate> *theDelegate;
@property (nonatomic, assign) BOOL dataSourceIsSelf;
@property (nonatomic, assign) BOOL delegateIsSelf;

@property (nonatomic, strong) NSIndexPath *snappedIndexPath;
@property (nonatomic, assign) CGPoint contentOffsetDelta;
@end

@implementation OPTableView

@synthesize horizontal = _horizontal;
@synthesize snapToRows = _snapToRows;
@synthesize theDataSource = _theDataSource;
@synthesize theDelegate = _theDelegate;
@synthesize dataSourceIsSelf = _dataSourceIsSelf;
@synthesize delegateIsSelf = _delegateIsSelf;
@synthesize snappedIndexPath = _snappedIndexPath;
@synthesize contentOffsetDelta = _contentOffsetDelta;

-(id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (! (self = [super initWithFrame:frame style:style]))
        return nil;
    
    self.snappedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    return self;
}

-(void) setHorizontal:(BOOL)horizontal {
    _horizontal = horizontal;
    
    if (horizontal)
    {
        CGRect frame = self.frame;
        self.transform = CGAffineTransformMakeRotation(-M_PI / 2.0f);
        self.frame = frame;
    }
    else
    {
        CGRect frame = self.frame;
        self.transform = CGAffineTransformIdentity;
        self.frame = frame;
    }
}

#pragma mark -
#pragma mark UITableView methods
#pragma mark -

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.theDataSource tableView:tableView numberOfRowsInSection:section];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.theDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (cell && self.horizontal)
        cell.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
    
    return cell;
}

#pragma mark -
#pragma mark UIScrollView methods
#pragma mark -

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    static CGPoint previousOffset;
    self.contentOffsetDelta = CGPointMake(self.contentOffset.x - previousOffset.x, self.contentOffset.y - previousOffset.y);
    previousOffset = self.contentOffset;
    
    // pass message to the delegate
    if ([self.theDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [self.theDelegate scrollViewDidScroll:scrollView];
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (self.snapToRows)
    {
        dispatch_async(dispatch_get_current_queue(), ^{
            
            if (self.contentOffset.y < 0.0f)
                return ;
            else if (self.contentOffset.y > self.contentSize.height - self.frame.size.height)
                return ;
            
            UITableViewCell *firstCell = [[self visibleCells] objectAtIndex:0];
            UITableViewCell *secondCell = [[self visibleCells] lastObject];
            CGFloat top = firstCell.frame.origin.y - self.contentOffset.y;
            CGFloat bottom = top + firstCell.frame.size.height;
            
            if (self.contentOffsetDelta.y > 0 && ((top < -firstCell.frame.size.height/5.0f) || (self.contentOffsetDelta.y >= 10.0f)))
                self.snappedIndexPath = [[self indexPathsForVisibleRows] lastObject];
            else if (self.contentOffsetDelta.y < 0 && ((bottom > secondCell.frame.size.height/5.0f) || (self.contentOffsetDelta.y <= -10.0f)))
                self.snappedIndexPath = [[self indexPathsForVisibleRows] objectAtIndex:0];
            
            if ([self.theDelegate respondsToSelector:@selector(tableView:willSnapToIndexPath:)])
                [self.theDelegate tableView:self willSnapToIndexPath:self.snappedIndexPath];
            
            [self scrollToRowAtIndexPath:self.snappedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            if ([self.theDelegate respondsToSelector:@selector(tableView:didSnapToIndexPath:)])
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                    [self.theDelegate tableView:self didSnapToIndexPath:self.snappedIndexPath];
                });
            }
            
        });
    }
    
    // pass message to the delegate
    if ([self.theDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [self.theDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

-(void) scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    self.snappedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    // pass message to the delegate
    if ([self.theDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
        [self.theDelegate scrollViewDidScrollToTop:scrollView];
}

#pragma mark -
#pragma mark UITableView overridden methods
#pragma mark -

-(void) scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    [super scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    self.snappedIndexPath = indexPath;
}

#pragma mark -
#pragma mark NSObject overridden methods
#pragma mark -

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector])
        return [super respondsToSelector:aSelector];
    
    struct objc_method_description dataSourceMethod = protocol_getMethodDescription(@protocol(UITableViewDataSource), aSelector, NO, YES);
    if (! _dataSourceIsSelf && dataSourceMethod.name != nil && [_theDataSource respondsToSelector:aSelector])
        return YES;
    
    struct objc_method_description delegateMethod = protocol_getMethodDescription(@protocol(UITableViewDelegate), aSelector, NO, YES);
    if (! _delegateIsSelf && delegateMethod.name != nil && [_theDelegate respondsToSelector:aSelector])
        return YES;
    
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([super methodSignatureForSelector:aSelector])
        return [super methodSignatureForSelector:aSelector];
    
    struct objc_method_description dataSourceMethod = protocol_getMethodDescription(@protocol(UITableViewDataSource), aSelector, NO, YES);
    if (dataSourceMethod.name != nil && [_theDataSource methodSignatureForSelector:aSelector])
        return [_theDataSource methodSignatureForSelector:aSelector];
    
    struct objc_method_description delegateMethod = protocol_getMethodDescription(@protocol(UITableViewDelegate), aSelector, NO, YES);
    if (delegateMethod.name != nil && [_theDelegate methodSignatureForSelector:aSelector])
        return [_theDelegate methodSignatureForSelector:aSelector];
    
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL selector = [anInvocation selector];
    struct objc_method_description dataSourceMethod = protocol_getMethodDescription(@protocol(UITableViewDataSource), selector, NO, YES);
    struct objc_method_description delegateMethod = protocol_getMethodDescription(@protocol(UITableViewDelegate), selector, NO, YES);
    
    if (dataSourceMethod.name != nil && [self.theDataSource respondsToSelector:selector])
        [anInvocation invokeWithTarget:self.theDataSource];
    else if (delegateMethod.name != nil && [self.theDelegate respondsToSelector:selector])
        [anInvocation invokeWithTarget:self.theDelegate];
    else
        [super forwardInvocation:anInvocation];
}

#pragma mark -
#pragma mark Delegate / data source methods
#pragma mark -

-(id<OPTableViewDelegate>) delegate {
    return self.theDelegate;
}

-(void) setDelegate:(id<OPTableViewDelegate>)delegate {
    self.theDelegate = delegate;
    self.delegateIsSelf = (id)delegate == (id)self;
    [super setDelegate:self];
}

-(void) setDataSource:(id<UITableViewDataSource>)dataSource {
    self.theDataSource = dataSource;
    self.dataSourceIsSelf = dataSource == self;
    [super setDataSource:self];
}

@end
