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

@interface OMBMessageNewViewController : OMBTableViewController
<UITextFieldDelegate, UITextViewDelegate>
{
  OMBActivityView *activityView;
  OMBMessageInputToolbar *bottomToolbar;
  UITextField *toTextField;
  OMBUser *user;
}

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;

@end
