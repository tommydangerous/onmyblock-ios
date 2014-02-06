//
//  OMBMessageDetailViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class OMBMessage;
@class OMBMessageInputToolbar;

@interface OMBMessageDetailViewController : OMBViewController
<UICollectionViewDataSource, UICollectionViewDelegate, 
  UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITextViewDelegate>
{
  OMBMessageInputToolbar *bottomToolbar;
  UIBarButtonItem *contactBarButtonItem;
  UIToolbar *contactToolbar;
  BOOL isEditing;
  UIBarButtonItem *phoneBarButtonItem;
  CGPoint startingPoint;
  OMBUser *user;
}

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) BOOL fetching;
@property (nonatomic) NSInteger maxPages;
@property (nonatomic, strong) NSArray *messages;

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) send;

@end
