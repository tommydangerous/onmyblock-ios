//
//  OMBWebViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/10/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBWebViewController.h"

#import "UIImage+Resize.h"
#import "UIColor+Extensions.h"

@implementation OMBWebViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view = [[UIView alloc] initWithFrame: screen];

  _webView = [[UIWebView alloc] initWithFrame: self.view.frame];
  _webView.delegate = self;
  _webView.frame = CGRectMake(0.0f, 0.0f, screen.size.width,
    screen.size.height - 44.0f);
  _webView.scalesPageToFit = YES;
  [self.view addSubview: _webView];

  UIToolbar *toolbar = [[UIToolbar alloc] init];
  toolbar.translucent = YES;
  toolbar.frame = CGRectMake(0.0f, _webView.frame.size.height, 
    screen.size.width, 44.0f);
  toolbar.tintColor = [UIColor blue];
  [self.view addSubview: toolbar];

  UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage: 
    [UIImage image: [UIImage imageNamed: @"arrow_left.png"] 
      size: CGSizeMake(20, 20)] style: UIBarButtonItemStylePlain 
        target: _webView action: @selector(goBack)];
  UIBarButtonItem *forwardBarButtonItem = 
    [[UIBarButtonItem alloc] initWithImage: 
      [UIImage image: [UIImage imageNamed: @"arrow_right.png"] 
        size: CGSizeMake(20, 20)] style: UIBarButtonItemStylePlain 
          target: _webView action: @selector(goForward)];
  UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
    UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
  toolbar.items = @[backBarButtonItem, space, forwardBarButtonItem];
}

#pragma mark - Protocol

#pragma mark - Protocol UIWebViewDelegate

- (void) webViewDidFinishLoad: (UIWebView *) webView
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) webViewDidStartLoad: (UIWebView *) webView
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

@end
