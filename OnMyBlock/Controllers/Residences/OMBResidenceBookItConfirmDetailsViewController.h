//
//  OMBResidenceBookItConfirmDetailsViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBAlertView;
@class OMBCenteredImageView;
@class OMBOffer;
@class OMBResidence;

@interface OMBResidenceBookItConfirmDetailsViewController : 
  OMBTableViewController
<UIAlertViewDelegate, UIScrollViewDelegate, UITextFieldDelegate, 
  UITextViewDelegate>
{
  OMBAlertView *alert;
  UIView *backView;
  UILabel *bedBathLabel;
  UILabel *currentOfferLabel;
  CGFloat deposit;
  BOOL hasOfferValue;
  UILabel *daysLabel;
  UIBarButtonItem *doneBarButtonItem;
  UILabel *hoursLabel;
  BOOL isAddingAPersonalNote;
  BOOL isEditing;
  BOOL isShowingPriceBreakdown;
  UILabel *minutesLabel;
  OMBOffer *offer;
  NSString *personalNote;
  UITextView *personalNoteTextView;
  UILabel *personalNoteTextViewPlaceholder;
  UILabel *rentLabel;
  OMBResidence *residence;
  OMBCenteredImageView *residenceImageView;
  UIBarButtonItem *reviewBarButton;
  UILabel *secondsLabel;
  UIButton *submitOfferButton;
  NSAttributedString *submitOfferNotes;
  CGSize submitOfferNotesSize;
  UILabel *titleLabel;
  NSString *totalPriceNotes;
  CGSize totalPriceNotesSize;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

@end
