//
//  OMBPayoutMethodPayPalViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/11/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPayoutMethodPayPalViewController.h"

#import "OMBPayPalVerifyMobilePaymentConnection.h"

@implementation OMBPayoutMethodPayPalViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = @"Payout Method PayPal";
  self.title      = @"Payout";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.nameLabel.text      = @"PayPal";
  self.nameLabel.textColor = [UIColor paypalBlue];

  self.detailLabel1.text = @"PayPal is an online processing service";
  self.detailLabel2.text = @"that allows you to pay and receive";
  self.detailLabel3.text = @"payments from OnMyBlock.";

  self.connectButton.backgroundColor = [UIColor paypalBlue];
  [self.connectButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor paypalBlueLight]]
      forState: UIControlStateHighlighted];
  [self.connectButton setTitle: @"I have a PayPal account"
    forState: UIControlStateNormal];
  [self.signUpButton setTitle: @"Sign up for PayPal"
    forState: UIControlStateNormal];
}

#pragma mark - Protocol

#pragma mark - Protocol PayPalPaymentDelegate

- (void) payPalPaymentDidComplete: (PayPalPayment *) completedPayment
{
  // Payment was processed successfully; 
  // send to server for verification and fulfillment.
  [self verifyCompletedPayment: completedPayment];

  // Send the entire confirmation dictionary
  // NSData *confirmation = [NSJSONSerialization dataWithJSONObject:
  //   completedPayment.confirmation options: 0 error: nil];

  // Send confirmation to your server; 
  // your server should verify the proof of payment
  // and give the user their goods or services. 
  // If the server is not reachable, save the confirmation and try again later.

  // Dismiss the PayPalPaymentViewController.
  [self dismissViewControllerAnimated: YES completion: nil];

  NSLog(@"PAYPAL PAYMENT DID COMPLETE");
}

- (void) payPalPaymentDidCancel
{
  // The payment was canceled; dismiss the PayPalPaymentViewController.
  [self dismissViewControllerAnimated: YES completion: nil];
  NSLog(@"PAYPAL PAYMENT DID CANCEL");
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) connectButtonSelected
{
  // Create a PayPalPayment
  PayPalPayment *payment   = [[PayPalPayment alloc] init];
  payment.amount           = [[NSDecimalNumber alloc] initWithString: @"0.01"];
  payment.currencyCode     = @"USD";
  payment.shortDescription = @"OMB Test";
  // Check whether payment is processable.
  if (!payment.processable) {
    // If, for example, the amount was negative or 
    // the shortDescription was empty, then
    // this payment would not be processable. 
    // You would want to handle that here.
  }
  
  // Provide a payerId that uniquely identifies a user 
  // within the scope of your system, such as an email address or user ID.
  // NSString *aPayerId = [NSString stringWithFormat: @"user_%i",
  //   [OMBUser currentUser].uid];
  NSString *aPayerId = @"someone@gmail.com";
  // Create a PayPalPaymentViewController with the credentials and payerId, 
  // the PayPalPayment from the previous step, 
  // and a PayPalPaymentDelegate to handle the results.
  NSString *cliendId = 
    @"AYF4PhAsNUDPRLYpTmTqtoo04_n7rmum1Q1fgpmApKJOF_eTrtxajPEFDK4Y";
  NSString *receiverEmail = @"tommydangerouss@gmail.com";
  BOOL testing = NO;
  if (testing) {
    cliendId = @"AetqKxBgNs-WXu7L7mhq_kpihxGdOUSo0mgLppw0wvTw_pCdP6n3ANLYt4X6";
    receiverEmail = @"tommydangerouss-facilitator@gmail.com";
    // Start out working with the test environment! 
    // When you are ready, remove this line to switch to live.
    [PayPalPaymentViewController setEnvironment: PayPalEnvironmentSandbox];
  }

  PayPalPaymentViewController *paymentViewController = 
    [[PayPalPaymentViewController alloc] initWithClientId: cliendId 
      receiverEmail: receiverEmail
        payerId: aPayerId payment: payment delegate: self];
  // paymentViewController.defaultUserEmail = [OMBUser currentUser].email;
  // paymentViewController.defaultUserPhoneCountryCode = @"1";
  // paymentViewController.defaultUserPhoneNumber = [OMBUser currentUser].phone;

  // Will only support paying with PayPal, not with credit cards
  paymentViewController.hideCreditCardButton = YES;

  // This improves user experience
  // by preconnecting to PayPal to prepare the device for
  // processing payments
  // [PayPalPaymentViewController prepareForPaymentUsingClientId: cliendId];
  // Present the PayPalPaymentViewController.
  [self presentViewController: paymentViewController animated: YES 
    completion: nil];

  NSLog(@"CONNECT BUTTON SELECTED");
}

- (void) verifyCompletedPayment: (PayPalPayment *) completedPayment
{
 [[[OMBPayPalVerifyMobilePaymentConnection alloc] initWithPaymentConfirmation: 
    completedPayment.confirmation] start]; 
  NSLog(@"VERIFY COMPLETED PAYMENT: %@", completedPayment.confirmation);
}

@end
