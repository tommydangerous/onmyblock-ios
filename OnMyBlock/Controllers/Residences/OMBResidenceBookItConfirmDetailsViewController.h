//
//  OMBResidenceBookItConfirmDetailsViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBCenteredImageView;
@class OMBResidence;

@interface OMBResidenceBookItConfirmDetailsViewController : 
  OMBTableViewController
<UIScrollViewDelegate, UITextFieldDelegate>
{
  CGFloat deposit;
  CGFloat offer;

  UILabel *currentOfferLabel;
  BOOL hasOfferValue;
  UILabel *daysLabel;
  UILabel *hoursLabel;
  BOOL isShowingPriceBreakdown;
  UILabel *minutesLabel;
  OMBResidence *residence;
  OMBCenteredImageView *residenceImageView;
  UIBarButtonItem *reviewBarButton;
  UILabel *secondsLabel;
  UIButton *submitOfferButton;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

@end
