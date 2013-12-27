//
//  OMBMessageNewViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBMessageInputToolbar;

@interface OMBMessageNewViewController : OMBTableViewController
<UITextFieldDelegate, UITextViewDelegate>
{
  OMBMessageInputToolbar *bottomToolbar;
  UITextField *toTextField;
}

@end
