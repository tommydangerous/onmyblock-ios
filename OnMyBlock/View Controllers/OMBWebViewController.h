//
//  OMBWebViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/10/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@interface OMBWebViewController : OMBViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) close;
- (void) showCloseBarButtonItem;

@end
