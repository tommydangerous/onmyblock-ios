//
//  OMBRenterInfoAddViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@interface OMBRenterInfoAddViewController : OMBTableViewController
<UITextFieldDelegate>
{
  BOOL isEditing;
  UIToolbar *textFieldToolbar;
}

@end
