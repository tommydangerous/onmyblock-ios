//
//  OMBSelectedPaymentMethodViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/11/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@class OMBWebViewController;

@interface OMBSelectedPayoutMethodViewController : OMBViewController
<UIActionSheetDelegate, UIWebViewDelegate>
{
  BOOL deposit;
  UIView *detailLabelView;
  UIActionSheet *sheet;
  OMBWebViewController *webViewController;
}

@property (nonatomic, strong) UIButton *connectButton;
@property (nonatomic, strong) UILabel *detailLabel1;
@property (nonatomic, strong) UILabel *detailLabel2;
@property (nonatomic, strong) UILabel *detailLabel3;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *signUpButton;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) connectButtonSelected;

@end
