//
//  OMBPaymentMethodVenmoViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/11/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPayoutMethodVenmoViewController.h"

#import "NSString+Extensions.h"
#import "OMBAuthenticationVenmoConnection.h"
#import "OMBNavigationController.h"
#import "OMBWebViewController.h"

@implementation OMBPayoutMethodVenmoViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = @"Payout Method Venmo";
  self.title      = @"Payout";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.nameLabel.text = @"Venmo";
  self.nameLabel.textColor = [UIColor venmoBlue];

  self.detailLabel1.text = @"Venmo is an online processing service";
  self.detailLabel2.text = @"that allows you to pay and receive";
  self.detailLabel3.text = @"payments from OnMyBlock.";

  self.connectButton.backgroundColor = [UIColor venmoBlue];
  [self.connectButton addTarget: self action: @selector(connectButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [self.connectButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor venmoBlueDark]]
      forState: UIControlStateHighlighted];
  [self.connectButton setTitle: @"I have a Venmo account"
    forState: UIControlStateNormal];
  [self.signUpButton setTitle: @"Sign up for Venmo"
    forState: UIControlStateNormal];
}

#pragma mark - Protocol

#pragma mark - Protocol UIWebViewDelegate

- (BOOL) webView: (UIWebView *) webView 
shouldStartLoadWithRequest: (NSURLRequest *) request 
navigationType: (UIWebViewNavigationType) navigationType
{
  NSString *absoluteString = [request URL].absoluteString;
  if ([absoluteString rangeOfString: @"authentications/venmo"].location 
    != NSNotFound) {
    // {
    //   code = 84c1d3ebd7eaed3eda3dedabf8908044;
    // }
    NSString *code = [[absoluteString dictionaryFromString] objectForKey: 
      @"code"];
    OMBAuthenticationVenmoConnection *connection = 
      [[OMBAuthenticationVenmoConnection alloc] initWithCode: code];
    [connection start];
    [webViewController close];
    return NO;
  }
  return YES;
}

- (void) webViewDidFinishLoad: (UIWebView *) webView
{
  NSLog(@"WEB VIEW DID FINISH LOAD");
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) webViewDidStartLoad: (UIWebView *) webView
{
  NSLog(@"WEB VIEW DID START LOAD");
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) connectButtonSelected1
{
  VenmoTransaction *venmoTransaction = [[VenmoTransaction alloc] init];
  venmoTransaction.type   = VenmoTransactionTypePay;
  venmoTransaction.amount = [NSDecimalNumber decimalNumberWithString: @"0.01"];
  venmoTransaction.note   = @"OMB Test";
  venmoTransaction.toUserHandle = @"tommy@onmyblock.com";

  OMBAppDelegate *appDelegate = (OMBAppDelegate *) 
    [UIApplication sharedApplication].delegate;

  VenmoViewController *venmoViewController = 
    [appDelegate.venmoClient viewControllerWithTransaction: venmoTransaction];
  if (venmoViewController) {
    [self presentViewController: venmoViewController animated: YES
      completion: nil];
  }
}

- (void) connectButtonSelected
{
  NSString *string = [NSString stringWithFormat: 
    @"https://api.venmo.com/oauth/authorize?"
    @"client_id=%@&"
    @"scope=make_payments&"
    @"response_type=%@",
    @"1522",
    @"code"
  ];
  NSURL *url = [NSURL URLWithString: 
    [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
  NSURLRequest *request = [NSURLRequest requestWithURL: url];
  webViewController = [[OMBWebViewController alloc] init];
  webViewController.webView.delegate = self;
  webViewController.title = @"Venmo Authentication";
  [webViewController.webView loadRequest: request];
  [webViewController showCloseBarButtonItem];
  [self presentViewController: 
    [[OMBNavigationController alloc] initWithRootViewController: 
      webViewController] animated: YES completion: nil];
}

@end
