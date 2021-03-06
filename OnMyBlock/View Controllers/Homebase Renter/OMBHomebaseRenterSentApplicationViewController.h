//
//  OMBHomebaseRenterSentApplicationViewController.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 6/2/14.
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
typedef NS_ENUM(NSInteger, OMBSentApplicationSection) {
  OMBSentApplicationSectionOffer
};
// Rows in the offer section in the offer table
typedef NS_ENUM(NSInteger, OMBSentApplicationSectionRow) {
  OMBSentApplicationSectionRowResidence,
  OMBSentApplicationSectionRowDates,
  OMBSentApplicationSectionRowSpacingBelowDates,
  OMBSentApplicationSectionRowOffer,
  OMBSentApplicationSectionRowSecurityDeposit,
  OMBSentApplicationSectionRowRememberDetail,
  //OMBOfferInquirySectionOfferSpacingBelowTotal,
  OMBSentApplicationSectionRowNotes
};

@interface OMBHomebaseRenterSentApplicationViewController : OMBViewController
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
  NSDateFormatter *dateFormatter1;
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

#pragma mark - Initializer

- (id) initWithOffer: (OMBOffer *) object;

// Tables
@property (nonatomic, strong) UITableView *offerTableView;
@property (nonatomic, strong) UITableView *profileTableView;

@end
