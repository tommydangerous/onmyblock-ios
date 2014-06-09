//
//  OMBRenterInfoSectionViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/10/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class AMBlurView;
@class OMBApplyResidenceViewController;
@class OMBActivityViewFullScreen;
@class OMBRenterInfoAddViewController;
@class OMBUser;

@interface OMBRenterInfoSectionViewController : OMBTableViewController
<UIActionSheetDelegate>
{
  OMBActivityViewFullScreen *activityViewFullScreen;
  UIButton *addButton;
  UIButton *addButtonMiddle;
  AMBlurView *bottomBlurView;
  UILabel *emptyLabel;
  OMBUser *user;
  NSString *key;
  int tagSection;
}

@property (nonatomic, weak) OMBApplyResidenceViewController *delegate;

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;

#pragma mark - Methods

#pragma mark - Class Methods

//+ (int) incompleteSections;
//+ (int) lastIncompleteSection;
+ (NSMutableDictionary *) renterapplicationUserDefaults;

#pragma mark - Instance Methods

- (void) deleteModelObjectAtIndexPath: (NSIndexPath *) indexPath;
- (void) fetchObjectsForResourceName: (NSString *) resourceName;
- (void) hideEmptyLabel: (BOOL) hide;
- (NSArray *) objects;
- (OMBRenterApplication *) renterApplication;
- (void) setEmptyLabelText: (NSString *) string;
- (void) startSpinning;
- (void) stopSpinning;

@end
