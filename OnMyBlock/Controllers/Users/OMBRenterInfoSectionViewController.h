//
//  OMBRenterInfoSectionViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/10/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class AMBlurView;
@class OMBRenterInfoAddViewController;
@class OMBUser;

@interface OMBRenterInfoSectionViewController : OMBTableViewController
<UIActionSheetDelegate>
{
  UIButton *addButton;
  UIButton *addButtonMiddle;
  AMBlurView *bottomBlurView;
  UILabel *emptyLabel;
  OMBUser *user;
}

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) deleteModelObjectAtIndexPath: (NSIndexPath *) indexPath;
- (void) hideEmptyLabel: (BOOL) hide;
- (NSArray *) objects;
- (OMBRenterApplication *) renterApplication;
- (void) setEmptyLabelText: (NSString *) string;

@end
