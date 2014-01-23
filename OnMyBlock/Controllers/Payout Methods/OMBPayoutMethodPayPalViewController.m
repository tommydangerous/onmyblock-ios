//
//  OMBPayoutMethodPayPalViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/11/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPayoutMethodPayPalViewController.h"

#import "NSString+Extensions.h"
#import "OMBNavigationController.h"
#import "OMBPayoutMethod.h"
#import "OMBPayPalVerifyMobilePaymentConnection.h"
#import "OMBViewControllerContainer.h"
#import "OMBWebViewController.h"
#import "TextFieldPadding.h"

@implementation OMBPayoutMethodPayPalViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = @"Payout Method PayPal";
  self.title      = @"Payout";

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillShow:)
      name: UIKeyboardWillShowNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillHide:)
      name: UIKeyboardWillHideNotification object: nil];

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

  emailTextField = [[TextFieldPadding alloc] init];
  emailTextField.alpha = 0.0f;
  emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  emailTextField.backgroundColor = [UIColor whiteColor];
  emailTextField.delegate = self;
  emailTextField.enablesReturnKeyAutomatically = YES;
  emailTextField.font = self.connectButton.titleLabel.font;
  emailTextField.frame = self.connectButton.frame;
  emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
  emailTextField.layer.borderColor = [UIColor blue].CGColor;
  emailTextField.layer.borderWidth = 1.0f;
  emailTextField.layer.cornerRadius = self.connectButton.layer.cornerRadius;
  emailTextField.paddingX = emailTextField.frame.origin.x;
  emailTextField.placeholderColor = [UIColor grayLight];
  emailTextField.placeholder = @"Email address";
  emailTextField.returnKeyType = UIReturnKeyDone;
  emailTextField.textColor = [UIColor textColor];
  [self.view addSubview: emailTextField];
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

#pragma mark - Protocol UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet 
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  if (buttonIndex == 0 || buttonIndex == 1) {
    // Deposit
    if (buttonIndex == 0) {
      deposit = YES;
    }
    // Payment
    else if (buttonIndex == 1) {
      deposit = NO;
    }
    [self showEmail];
  }
}

#pragma mark - Protocol UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - Protocol UIWebViewDelegate

- (void) webViewDidFinishLoad: (UIWebView *) webView
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) webViewDidStartLoad: (UIWebView *) webView
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
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
    @"AetqKxBgNs-WXu7L7mhq_kpihxGdOUSo0mgLppw0wvTw_pCdP6n3ANLYt4X6";
  NSString *receiverEmail = @"tommydangerouss-facilitator@gmail.com";
  // Start out working with the test environment! 
  // When you are ready, remove this line to switch to live.
  [PayPalPaymentViewController setEnvironment: PayPalEnvironmentSandbox];

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

- (void) keyboardWillHide: (NSNotification *) notification
{
  NSTimeInterval duration = [[notification.userInfo objectForKey: 
    UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat originY = 20 + 44 + (screen.size.height - 
    (20 + 44 + emailTextField.frame.size.height + 216)) * 0.5f;
  CGFloat difference = self.connectButton.frame.origin.y - originY;
  [UIView animateWithDuration: duration animations: ^{
    CGRect nameRect = self.nameLabel.frame;
    nameRect.origin.y += difference;
    self.nameLabel.frame = nameRect;

    CGRect detail1Rect = self.detailLabel1.frame;
    detail1Rect.origin.y += difference;
    self.detailLabel1.frame = detail1Rect;

    CGRect detail2Rect = self.detailLabel2.frame;
    detail2Rect.origin.y += difference;
    self.detailLabel2.frame = detail2Rect;

    CGRect emailRect = emailTextField.frame;
    emailRect.origin.y = self.connectButton.frame.origin.y;
    emailTextField.frame = emailRect;
  }];
}

- (void) keyboardWillShow: (NSNotification *) notification
{
  NSTimeInterval duration = [[notification.userInfo objectForKey: 
    UIKeyboardAnimationDurationUserInfoKey] doubleValue];

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat originY = 20 + 44 + (screen.size.height - 
    (20 + 44 + emailTextField.frame.size.height + 216)) * 0.5f;
  CGFloat difference = emailTextField.frame.origin.y - originY;
  [UIView animateWithDuration: duration animations: ^{
    CGRect nameRect = self.nameLabel.frame;
    nameRect.origin.y -= difference;
    self.nameLabel.frame = nameRect;

    CGRect detail1Rect = self.detailLabel1.frame;
    detail1Rect.origin.y -= difference;
    self.detailLabel1.frame = detail1Rect;

    CGRect detail2Rect = self.detailLabel2.frame;
    detail2Rect.origin.y -= difference;
    self.detailLabel2.frame = detail2Rect;

    CGRect emailRect = emailTextField.frame;
    emailRect.origin.y = originY;
    emailTextField.frame = emailRect;
  }];
}

- (void) showEmail
{
  CGRect screen = [[UIScreen mainScreen] bounds];

  [self.signUpButton removeTarget: self action: @selector(signUpButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [self.signUpButton addTarget: self action: @selector(submit)
    forControlEvents: UIControlEventTouchUpInside];
  [self.signUpButton setTitle: @"Submit" forState: UIControlStateNormal];
  [self.signUpButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blueHighlighted]] 
      forState: UIControlStateHighlighted];

  [UIView animateWithDuration: 0.25f animations: ^{
    // Text
    self.detailLabel1.text = @"What email address is associated with";
    self.detailLabel2.text = @"your existing PayPal account?";
    self.detailLabel3.text = @"";
    // Connect button
    self.connectButton.alpha = 0.0f;
    // Email text field
    emailTextField.alpha = 1.0f;
    // Sign up button
    self.signUpButton.backgroundColor = [UIColor blue];
    CGRect rect = self.signUpButton.frame;
    rect.origin.y = screen.size.height - (rect.size.height + rect.origin.x);
    self.signUpButton.frame = rect;
  }];
}

- (void) signUpButtonSelected
{
  NSString *string = @"http://paypal.com/signup";
  NSURL *url = [NSURL URLWithString: 
    [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
  NSURLRequest *request = [NSURLRequest requestWithURL: url];
  webViewController = [[OMBWebViewController alloc] init];
  webViewController.webView.delegate = self;
  webViewController.title = @"PayPal Sign Up";
  [webViewController.webView loadRequest: request];
  [webViewController showCloseBarButtonItem];
  [self presentViewController: 
    [[OMBNavigationController alloc] initWithRootViewController: 
      webViewController] animated: YES completion: nil];
}

- (void) submit
{
  if ([[emailTextField.text stripWhiteSpace] length]) {
    [[OMBUser currentUser] createPayoutMethodWithDictionary: @{
      @"active":      [NSNumber numberWithBool: YES], 
      @"deposit":     [NSNumber numberWithBool: deposit],
      @"email":       [emailTextField.text stripWhiteSpace],
      @"payoutType":  @"paypal",
      @"primary":     [NSNumber numberWithBool: YES]
    } withCompletion: ^(NSError *error) {
      OMBPayoutMethod *payoutMethod;
      if (deposit)
        payoutMethod = [[OMBUser currentUser] primaryDepositPayoutMethod];
      else
        payoutMethod = [[OMBUser currentUser] primaryPaymentPayoutMethod];
      if (payoutMethod && 
        [[payoutMethod.payoutType lowercaseString] isEqualToString: @"paypal"] 
          && payoutMethod.uid > 0) {
        [self.navigationController popToRootViewControllerAnimated: YES];
      }
      else {
        [self showAlertViewWithError: error];
      }
      [[self appDelegate].container stopSpinning];
    }];
    [[self appDelegate].container startSpinning];
  }
}

- (void) verifyCompletedPayment: (PayPalPayment *) completedPayment
{
 [[[OMBPayPalVerifyMobilePaymentConnection alloc] initWithPaymentConfirmation: 
    completedPayment.confirmation] start]; 
  NSLog(@"VERIFY COMPLETED PAYMENT: %@", completedPayment.confirmation);
}

@end
