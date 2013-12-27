//
//  OMBMessageDetailViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class OMBMessageInputToolbar;

@interface OMBMessageDetailViewController : OMBViewController
<UICollectionViewDataSource, UICollectionViewDelegate, 
  UICollectionViewDelegateFlowLayout, UITextViewDelegate>
{
  OMBMessageInputToolbar *bottomToolbar;
  UIBarButtonItem *contactBarButtonItem;
  UIToolbar *contactToolbar;
  UIBarButtonItem *doneBarButtonItem;
  NSArray *messages;
  OMBUser *user;
}

@property (nonatomic, strong) UICollectionView *collection;

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;

@end
