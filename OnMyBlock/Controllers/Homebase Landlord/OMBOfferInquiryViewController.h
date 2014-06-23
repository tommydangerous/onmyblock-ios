//
//  OMBOfferInquiryViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

#import "PayPalMobile.h"

@class LEffectLabel;
@class OMBActivityView;
@class OMBAlertView;
@class OMBAlertViewBlur;
@class OMBCenteredImageView;
@class OMBGradientView;
@class OMBOffer;

// Sections in the offer table
typedef NS_ENUM(NSInteger, OMBOfferInquirySection) {
  OMBOfferInquirySectionOffer
};
// Rows in the offer section in the offer table
typedef NS_ENUM(NSInteger, OMBOfferInquirySectionOfferRow) {
  OMBOfferInquirySectionOfferRowResidence,
  OMBOfferInquirySectionOfferRowDates,
  OMBOfferInquirySectionOfferSpacingBelowDates,
  OMBOfferInquirySectionOfferRowPriceBreakdown,
  OMBOfferInquirySectionOfferRowOffer,
  OMBOfferInquirySectionOfferRowSecurityDeposit,
  OMBOfferInquirySectionOfferRowDownPayment,
  OMBOfferInquirySectionOfferRowRemainingPayment,
  OMBOfferInquirySectionOfferRowTotal,
  OMBOfferInquirySectionOfferRowRememberDetail,
  //OMBOfferInquirySectionOfferSpacingBelowTotal,
  OMBOfferInquirySectionOfferRowNotes
};

@interface OMBOfferInquiryViewController : OMBViewController
<PayPalPaymentDelegate, UIScrollViewDelegate, UITableViewDataSource,
UITableViewDelegate>
{
  BOOL accepted;
  BOOL acceptedConfirmed;
  OMBActivityView *activityView;
  OMBAlertView *alert;
  OMBAlertViewBlur *alertBlur;
  UIView *backView;
  CGFloat backViewOffsetY;
  UIView *buttonsView;
  BOOL cameFromSettingUpPayoutMethods;
  BOOL charging;
  UIButton *contactButton;
  NSTimer *countdownTimer;
  UILabel *countDownTimerLabel;
  NSDateFormatter *dateFormatter;
  BOOL didCancelVenmoAppFromWebView;
  LEffectLabel *effectLabel;
  BOOL firstTimeAlert;
  OMBGradientView *gradient;
  NSArray *legalQuestions;
  OMBOffer *offer;
  UIButton *offerButton;
  int previouslySelectedIndex;
  UIButton *profileButton;
  NSString *rememberDetails;
  UIButton *respondButton;
  UIView *respondView;
  int selectedSegmentIndex;
  CGSize sizeForOfferNotes;
  CGSize sizeForRememberDetails;
  OMBCenteredImageView *userImageView;
}

@property (nonatomic, strong) UITableView *offerTableView;
@property (nonatomic, strong) UITableView *profileTableView;

#pragma mark - Initializer

- (id) initWithOffer: (OMBOffer *) object;

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (void) hideCountdownAndRespondButton;

@end
