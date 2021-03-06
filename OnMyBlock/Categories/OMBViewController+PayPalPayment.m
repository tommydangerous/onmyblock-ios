//
//  OMBViewController+PayPalPayment.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/4/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBViewController+PayPalPayment.h"

#import "OMBPayoutMethod.h"
#import "OMBUser.h"

@implementation OMBViewController (PayPalPayment)

#pragma mark - Methods

#pragma mark - Instance Methods

- (id) payPalPaymentViewControllerWithAmount: (CGFloat) amount
intent: (PayPalPaymentIntent) intent
shortDescription: (NSString *) shortDescription delegate: (id) delegate
{
  // Use these credentials for logging in and paying in SandBox
  // Email:    quazarventures@gmail.com
  // Password: onmyblock

  PayPalConfiguration *payPalConfiguration = [[PayPalConfiguration alloc] init];
  if ([[OMBUser currentUser] primaryPaymentPayoutMethod] &&
    [[[OMBUser currentUser] primaryPaymentPayoutMethod] isPayPal]) {
    payPalConfiguration.defaultUserEmail =
      [[OMBUser currentUser] primaryPaymentPayoutMethod].email;
  }
  if ([[[OMBUser currentUser] phoneString] length])
    payPalConfiguration.defaultUserPhoneNumber =
      [[OMBUser currentUser] phoneString];
  payPalConfiguration.acceptCreditCards = YES;
  payPalConfiguration.languageOrLocale  = @"en";
  payPalConfiguration.merchantName = @"OnMyBlock";
  payPalConfiguration.merchantUserAgreementURL = [NSURL URLWithString:
    @"https://onmyblock.com/terms-of-service"];
  payPalConfiguration.merchantPrivacyPolicyURL = [NSURL URLWithString:
    @"https://onmyblock.com/privacy-policy"];
  payPalConfiguration.rememberUser = YES;

  // [PayPalMobile preconnectWithEnvironment: PayPalEnvironmentSandbox];
  [PayPalMobile preconnectWithEnvironment: PayPalEnvironmentProduction];

  NSDecimalNumber *amt;
  if (__ENVIRONMENT__ == 1) {
    amt = [[NSDecimalNumber alloc] initWithString: @"0.01"];
  }
  else {
    amt = [[NSDecimalNumber alloc] initWithString:
      [NSString stringWithFormat: @"%0.2f", amount]];
  }

  // Create a PayPalPayment
  PayPalPayment *payment   = [[PayPalPayment alloc] init];
  payment.amount           = amt;
  payment.currencyCode     = @"USD";
  payment.intent           = intent;
  payment.shortDescription = shortDescription;

  // Check whether payment is processable.
  if (!payment.processable) {

  }

  id paymentViewController;
  // Sale
  if (intent == PayPalPaymentIntentSale) {
    paymentViewController =
      [[PayPalPaymentViewController alloc] initWithPayment: payment
        configuration: payPalConfiguration delegate: delegate];
  }
  // Authorize
  else if (intent == PayPalPaymentIntentAuthorize) {
    paymentViewController =
      [[PayPalFuturePaymentViewController alloc] initWithConfiguration:
        payPalConfiguration delegate: delegate];
  }

  return paymentViewController;
}

@end
