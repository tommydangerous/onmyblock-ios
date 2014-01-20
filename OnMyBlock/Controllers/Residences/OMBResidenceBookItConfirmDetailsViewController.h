//
//  OMBResidenceBookItConfirmDetailsViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBCenteredImageView;
@class OMBOffer;
@class OMBResidence;

@interface OMBResidenceBookItConfirmDetailsViewController : 
  OMBTableViewController
<UIAlertViewDelegate, UIScrollViewDelegate, UITextFieldDelegate>
{
  UILabel *currentOfferLabel;
  CGFloat deposit;
  BOOL hasOfferValue;
  UILabel *daysLabel;
  UILabel *hoursLabel;
  BOOL isShowingPriceBreakdown;
  UILabel *minutesLabel;
  OMBOffer *offer;
  OMBResidence *residence;
  OMBCenteredImageView *residenceImageView;
  UIBarButtonItem *reviewBarButton;
  UILabel *secondsLabel;
  UIButton *submitOfferButton;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

@end
