//
//  OMBFinishListingDescriptionViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/28/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingSectionViewController.h"

@interface OMBFinishListingDescriptionViewController : 
  OMBFinishListingSectionViewController
<UITextViewDelegate>
{
  UITextView *descriptionTextView;
}

@end
