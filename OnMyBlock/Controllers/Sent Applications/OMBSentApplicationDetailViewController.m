//
//  OMBSentApplicationDetailViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 6/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBSentApplicationDetailViewController.h"

// Categories
#import "NSString+Extensions.h"
// Models
#import "OMBResidence.h"
#import "OMBSentApplication.h"
// View controllers
#import "OMBMessageDetailViewController.h"

@interface OMBSentApplicationDetailViewController ()
{
  OMBSentApplication *sentApplication;
}

@end

@implementation OMBSentApplicationDetailViewController

#pragma mark - Initializer

- (id) initWithSentApplication: (OMBSentApplication *) object
{
  if (!(self = [super init])) return nil;

  sentApplication = object;

  // Title
  switch ([sentApplication status]) {
    case OMBSentApplicationStatusPaid: {
      self.title = @"Payment Completed";
      break;  
    }
    case OMBSentApplicationStatusAccepted: {
      self.title = @"Accepted - Payment Required";
      break;
    }
    case OMBSentApplicationStatusDeclined: {
      self.title = @"Application Declined";
      break;
    }
    case OMBSentApplicationStatusCancelled: {
      self.title = @"Application Cancelled";
      break;
    }
    default: {
      self.title = @"Waiting for Landlord Response";
      break;
    }
  }

  return self;
}

#pragma mark - Override

#pragma mark - UIViewController

- (void) loadView
{
  [super loadView];

  [offerButton setTitle: @"Details" forState: UIControlStateNormal];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  [self updateRespondView];
}

#pragma mark - OMBOfferInquiryViewController

- (NSTimeInterval) moveInDate
{
  return sentApplication.moveInDate;
}

- (NSTimeInterval) moveOutDate
{
  return sentApplication.moveOutDate;
}

- (NSInteger) numberOfMonthsBetweenMovingDates
{
  return [sentApplication numberOfMonthsBetweenMovingDates];
}

- (BOOL) isAccepted
{
  return sentApplication.accepted;
}

- (BOOL) isCancelled
{
  return sentApplication.cancelled;
}

- (BOOL) isDeclined
{
  return sentApplication.declined;
}

- (BOOL) isPaid
{
  return sentApplication.paid;
}

- (CGFloat) rentAmount
{
  return sentApplication.residence.minRent;
}

- (OMBResidence *) residence
{
  return sentApplication.residence;
}

- (void) setupSizeForRememberDetails
{
  switch ([sentApplication status]) {
    case OMBSentApplicationStatusPaid: {
      rememberDetails = 
        @"You have successfully paid and you are now ready to move in.";
      break;  
    }
    case OMBSentApplicationStatusAccepted: {
      rememberDetails =
        @"Your application has been accepted. "
        @"You now have to sign the lease and pay the first month’s "
        @"rent & security deposit.";
      break;
    }
    case OMBSentApplicationStatusDeclined: {
      rememberDetails = 
        @"Your application has been declined.";
      break;
    }
    case OMBSentApplicationStatusCancelled: {
      rememberDetails =
        @"You have cancelled this application.";
      break;
    }
    default: {
      rememberDetails =
        @"Waiting for landlord to respond.";
      break;
    }
  }
  sizeForRememberDetails = [rememberDetails boundingRectWithSize:
    CGSizeMake(CGRectGetWidth(self.offerTableView.frame) - (OMBPadding * 2), 
      9999.f) font: [UIFont smallTextFont]].size;
}

- (void) showContact
{
  if (sentApplication.residence) {
    if (sentApplication.residence.user) {
      [self.navigationController pushViewController:
        [[OMBMessageDetailViewController alloc] initWithUser:
          sentApplication.residence.user] animated: YES];
    }
    else {
      [self.navigationController pushViewController:
        [[OMBMessageDetailViewController alloc] initWithResidence:
          sentApplication.residence] animated: YES];
    }
  }
}

- (void) updateRespondView
{
  switch ([sentApplication status]) {
    case OMBSentApplicationStatusPaid: {
      [self hideCountdownAndRespondButton];
      break;  
    }
    case OMBSentApplicationStatusAccepted: {
      #warning Pay Now
      break;
    }
    case OMBSentApplicationStatusDeclined: {
      [self hideCountdownAndRespondButton];
      break;
    }
    case OMBSentApplicationStatusCancelled: {
      [self hideCountdownAndRespondButton];
      break;
    }
    default: {
      #warning Cancel
      break;
    }
  }
}

- (OMBUser *) user
{
  return [OMBUser currentUser];
}

@end
