//
//  OMBFinishListingDescriptionViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/28/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingSectionViewController.h"

@class AMBlurView;

@interface OMBFinishListingDescriptionViewController : 
  OMBFinishListingSectionViewController
<UITextViewDelegate>
{
  UILabel *characterCountLabel;
  AMBlurView *characterCountView;
  UITextView *descriptionTextView;
  int maxCharacters;
  UILabel *placeholderLabel;
  NSString *placeholderString;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setTextForDescriptionView;
- (void) updateCharacterCount;

@end
