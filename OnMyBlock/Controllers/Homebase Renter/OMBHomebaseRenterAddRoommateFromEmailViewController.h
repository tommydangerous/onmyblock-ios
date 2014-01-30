//
//  OMBHomebaseRenterAddRoommateFromEmailViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class TextFieldPadding;

@interface OMBHomebaseRenterAddRoommateFromEmailViewController : 
  OMBTableViewController
<UITextFieldDelegate, UITextViewDelegate>
{
  TextFieldPadding *emailTextField;
  UIBarButtonItem *inviteBarButtonItem;
  BOOL isEditing;
  UITextView *messageTextView;
}

@end
