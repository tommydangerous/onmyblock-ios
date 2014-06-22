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
  // Paid
  if ([self isPaid]) {
    self.title = @"Payment Completed";
  }
  // Accepted
  else if ([self isAccepted])  {
    self.title = @"Accepted - Payment Required";
  }
  // Cancelled
  else if ([self isCancelled]) {
    self.title = @"Application Cancelled";
  }
  // Declined
  else if ([self isDeclined]) {
    self.title = @"Application Declined";
  }
  // Pending
  else {
    self.title = @"Waiting for Landlord Response";
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
  // Paid
  if ([self isPaid]) {
    rememberDetails = 
      @"You have successfully paid and you are now ready to move in.";
  }
  // Accepted
  else if ([self isAccepted]) {
    // This should show a timer
    rememberDetails =
      @"Your application has been accepted. "
      @"You now have to sign the lease and pay the first month’s "
      @"rent & security deposit.";
  }
  // Cancelled
  else if ([self isCancelled]) {
    rememberDetails =
      @"You have cancelled this application.";
  }
  // Declined
  else if ([self isDeclined]) {
    rememberDetails = 
      @"Your application has been declined.";
  }
  // Pending
  else {
    rememberDetails =
      @"Waiting for landlord to respond.";
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

- (OMBUser *) user
{
  return [OMBUser currentUser];
}

@end
