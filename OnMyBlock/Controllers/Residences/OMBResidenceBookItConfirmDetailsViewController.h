//
//  OMBResidenceBookItConfirmDetailsViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"
#import "MNCalendarView.h"

@class LEffectLabel;
@class OMBAlertView;
@class OMBAlertViewBlur;
@class OMBCenteredImageView;
@class OMBHelpPopUpView;
@class OMBOffer;
@class OMBResidence;
@class OMBResidenceBookItCalendarCell;
@class OMBResidenceConfirmDetailsDatesCell;

typedef NS_ENUM(NSInteger, OMBResidenceBookItConfirmDetailsSection) {
  OMBResidenceBookItConfirmDetailsSectionPlaceOffer,
  OMBResidenceBookItConfirmDetailsSectionDates,
  OMBResidenceBookItConfirmDetailsSectionPriceBreakdown,
  OMBResidenceBookItConfirmDetailsSectionPayoutMethods,
  OMBResidenceBookItConfirmDetailsSectionMonthlySchedule,
  OMBResidenceBookItConfirmDetailsSectionRenterProfile,
  OMBResidenceBookItConfirmDetailsSectionSubmitOfferNotes,
  OMBResidenceBookItConfirmDetailsSectionSpacing
};

// Sections
// Dates
typedef NS_ENUM(NSInteger, OMBResidenceBookItConfirmDetailsSectionDatesRows) {
  OMBResidenceBookItConfirmDetailsSectionDatesRowsMoveInMoveOut,
  OMBResidenceBookItConfirmDetailsSectionDatesRowsCalendar
};

@interface OMBResidenceBookItConfirmDetailsViewController :
OMBTableViewController
<UIAlertViewDelegate, UIScrollViewDelegate, UITextFieldDelegate,
UITextViewDelegate, MNCalendarViewDelegate>
{
  OMBAlertView *alert;
  OMBAlertViewBlur *alertBlur;
  UIView *backView;
  UILabel *bedBathLabel;
  UILabel *currentOfferLabel;
  NSDateFormatter *dateFormatter1;
  CGFloat deposit;
  BOOL hasOfferValue;
  UILabel *daysLabel;
  LEffectLabel *effectLabel;
  OMBHelpPopUpView *helpPopUpView;
  UILabel *hoursLabel;
  UIBarButtonItem *infoBarButtonItem;
  BOOL isAddingAPersonalNote;
  BOOL isEditing;
  BOOL isShowingPriceBreakdown;
  BOOL isShowingMoveInCalendar;
  BOOL isShowingMoveOutCalendar;
  BOOL isLandlordPreferredDate;
  UILabel *leaseMonthsLabel;
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
  // calendar
  NSIndexPath *selectedIndexPath;
}

#pragma mark - Initializer

- (OMBResidenceBookItCalendarCell *) calendarCell;
- (OMBResidenceConfirmDetailsDatesCell *) datesCell;
- (id) initWithResidence: (OMBResidence *) object;

@end