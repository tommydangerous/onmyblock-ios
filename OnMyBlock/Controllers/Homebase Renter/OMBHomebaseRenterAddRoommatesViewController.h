//
//  OMBHomebaseRenterAddRoommatesViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class TextFieldPadding;

@interface OMBHomebaseRenterAddRoommatesViewController : OMBTableViewController
<UITextFieldDelegate>
{
  TextFieldPadding *searchTextField;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) searchFromContacts;
- (void) searchFromFacebook;
- (void) searchFromOnMyBlock;

@end
