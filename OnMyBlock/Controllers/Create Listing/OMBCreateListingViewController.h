//
//  OMBCreateListingViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class OMBCreateListingPropertyTypeView;

@interface OMBCreateListingViewController : OMBViewController
<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
  UIBarButtonItem *backBarButtonItem;
  UIBarButtonItem *cancelBarButtonItem;
  UIBarButtonItem *nextBarButtonItem;
  UIView *progressBar;
  UILabel *questionLabel;
  UILabel *stepLabel;
  int stepNumber;

  // Step 1
  UIScrollView *propertyTypeScrollView;
  NSArray *propertyTypeViewArray;
  OMBCreateListingPropertyTypeView *housePropertyTypeView;
  OMBCreateListingPropertyTypeView *subletPropertyTypeView;
  OMBCreateListingPropertyTypeView *apartmentPropertyTypeView;
}

@end
