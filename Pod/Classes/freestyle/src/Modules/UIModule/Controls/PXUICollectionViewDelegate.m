/*
 * Copyright 2012-present Pixate, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
//  PXUICollectionViewDelegate.m
//  Pixate
//
//  Modified by Anton Matosov on 12/30/15.
//  Created by Paul Colton on 12/2/13.
//  Copyright (c) 2013 Pixate, Inc. All rights reserved.
//

#import "PXUICollectionViewDelegate.h"
#import "PXProxy.h"
#import "PXStyleUtils.h"

#import "UIView+PXStyling.h"
#import "UIView+PXStyling-Private.h"
#import "PXStylingMacros.h"
#import "PXUICollectionViewCell.h"
#import "UICollectionViewCell+STKStyling.h"

@implementation CGSizeWithFlag

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isSet = NO;
    }
    return self;
}

-(void)setSize:(CGSize)itemSize
{
    self.isSet = YES;
    self->_size = itemSize;
}

@end


@implementation PXUICollectionViewDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemSize = [[CGSizeWithFlag alloc] init];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

/// This is required protocol method, so keep it as simple forward
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [((PXProxy *)collectionView.dataSource).baseObject collectionView:collectionView numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id baseObject = collectionView.dataSource;
    if([baseObject isProxy])
    {
        baseObject = ((PXProxy *)baseObject).baseObject;
    }
    
    // Make sure the base object has implemented the call
    if(![baseObject respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)])
    {
        return nil;
    }

    UICollectionViewCell *cell = [baseObject collectionView:collectionView cellForItemAtIndexPath:indexPath];

    // See if we got a cell
    if(!cell)
    {
        return nil;
    }

    cell.pxStyleParent = collectionView;

    [PXStyleUtils setItemIndex:indexPath forObject:cell];

    // This will call update styles if styling is still enabled
    cell.styleMode = PXStylingNormal;

    [PXStyleUtils setItemIndex:nil forObject:cell];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Set a default value of UICollectionViewFlowLayout (per apple docs)
    CGSize itemSize = CGSizeMake(50, 50);

    id baseObject = collectionView.delegate;

    if([baseObject isProxy])
    {
        baseObject = ((PXProxy *) collectionView.delegate).baseObject;
    }

    // See if the base object implemented this call and if so, get the output
    if([baseObject respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)])
    {
        itemSize = [baseObject collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    else // Otherwise, let's see if we're a flow layout, if not, we won't know how to get the item size
    {
        if([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]])
        {
            UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
            itemSize = flowLayout.itemSize;
        }
    }

    // Returns the users size if set or what we found (or default)
    return self.itemSize.isSet ? self.itemSize.size : itemSize;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if (aSelector == @selector(collectionView:layout:sizeForItemAtIndexPath:) &&
        !self.itemSize.isSet)
    {
        id baseObject = self.collectionView.delegate;
        if ([baseObject isProxy])
        {
            baseObject = ((PXProxy*)baseObject).baseObject;
        }
        if (![baseObject respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)])
        {
            return NO;
        }
    }
    return [super respondsToSelector:aSelector];
}

@end
