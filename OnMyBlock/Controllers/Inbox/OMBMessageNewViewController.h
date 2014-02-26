//
//  OMBMessageNewViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBActivityView;
@class OMBMessageInputToolbar;
@class OMBResidence;

@interface OMBMessageNewViewController : OMBTableViewController
<UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UITextViewDelegate>
{
  OMBActivityView *activityView;
  OMBMessageInputToolbar *bottomToolbar;
  UIBarButtonItem *callBarButtonItem;
  BOOL isEditing;
  BOOL isFetching;
  NSTimeInterval lastFetched;
  OMBResidence *residence;
  NSTimer *timer;
  UITextField *toTextField;
  OMBUser *user;
}

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSUInteger maxPages;
@property (nonatomic, strong) NSArray *messages;

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;
- (id) initWithUser: (OMBUser *) object residence: (OMBResidence *) res;

@end
