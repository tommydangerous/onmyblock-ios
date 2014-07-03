//
//  OMBFinishListingTitleDescriptionViewController.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 7/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingSectionViewController.h"

@interface OMBFinishListingTitleDescriptionViewController :
  OMBFinishListingSectionViewController
<UITextFieldDelegate>
{
  UIToolbar *textFieldToolbar;
  NSMutableDictionary *valueDictionary;
}

@end
