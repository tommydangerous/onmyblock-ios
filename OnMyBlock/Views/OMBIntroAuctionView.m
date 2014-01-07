//
//  OMBIntroAuctionView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBIntroAuctionView.h"

#import "OMBBedroomView.h"
#import "UIColor+Extensions.h"

@implementation OMBIntroAuctionView

@synthesize cameraFlash     = _cameraFlash;
@synthesize iphoneScreen    = _iphoneScreen;
@synthesize iphoneImageView = _iphoneImageView;
@synthesize iphoneView      = _iphoneView;

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  float screenHeight = screen.size.height;
  float screenWidth  = screen.size.width;

  self.clipsToBounds = YES;
  self.frame = screen;

  float bedroomView1Height = screenWidth * 0.8;
  float bedroomView1Width  = screenWidth * 0.8;
  OMBBedroomView *bedroomView1 = [[OMBBedroomView alloc] initWithFrame:
    CGRectMake(10, ((screenHeight - bedroomView1Height) * 0.4), 
      bedroomView1Width, bedroomView1Height)];
  [self addSubview: bedroomView1];

  UIImage *iphoneImage = [UIImage imageNamed: @"iphone_5s_image.png"];
  float iphoneImageHeight = iphoneImage.size.height;
  float iphoneImageWidth  = iphoneImage.size.width;

  float iphoneImageViewWidth  = screenWidth * 0.4;
  float iphoneImageViewHeight = 
    iphoneImageViewWidth * (iphoneImageHeight / iphoneImageWidth);

  _iphoneView = [[UIView alloc] init];
  _iphoneView.frame = CGRectMake((screenWidth - (iphoneImageViewWidth + 10)), 
    screenHeight, iphoneImageViewWidth, iphoneImageViewHeight);

  float cameraFlashHeight = screenWidth * 0.7;
  float cameraFlashWidth  = cameraFlashHeight;
  _cameraFlash = [[UIImageView alloc] init];
  _cameraFlash.alpha = 0;
  _cameraFlash.frame = CGRectMake((-1 * (cameraFlashWidth * 0.45)), 
    ((-1 * (cameraFlashHeight * 0.45))), cameraFlashHeight, cameraFlashWidth);
  _cameraFlash.image = [UIImage imageNamed: @"camera_flash_image.png"];
  [_iphoneView addSubview: _cameraFlash];

  [self addSubview: _iphoneView];

  _iphoneImageView = [[UIImageView alloc] init];
  _iphoneImageView.frame = CGRectMake(0, 0, _iphoneView.frame.size.width,
    _iphoneView.frame.size.height);
  _iphoneImageView.image = iphoneImage;
  [_iphoneView addSubview: _iphoneImageView];

  // Image native dimensions 362 x 759
  float iphoneScreenHeight = (514 / 759.0) * iphoneImageViewHeight;
  float iphoneScreenWidth = (302 / 362.0) * iphoneImageViewWidth;
  float iphoneOriginX = (30 / 362.0) * iphoneImageViewWidth;
  float iphoneOriginY = (135 / 759.0) * iphoneImageViewHeight;
  _iphoneScreen = [[UIView alloc] init];
  _iphoneScreen.alpha = 0.0;
  _iphoneScreen.backgroundColor = [UIColor backgroundColor];
  _iphoneScreen.clipsToBounds = YES;
  _iphoneScreen.frame = CGRectMake(iphoneOriginX, iphoneOriginY,
    iphoneScreenWidth, iphoneScreenHeight);
  _iphoneScreen.layer.borderColor = [UIColor grayDark].CGColor;
  _iphoneScreen.layer.borderWidth = 1.0;
  [_iphoneView addSubview: _iphoneScreen];

  float bedroomView2Height = _iphoneScreen.frame.size.width * (0.8 / 0.8);
  float bedroomView2Width  = _iphoneScreen.frame.size.width;
  OMBBedroomView *bedroomView2 = [[OMBBedroomView alloc] initWithFrame:
    CGRectMake(
      ((_iphoneScreen.frame.size.width - bedroomView2Width) * 0.5), 
        ((_iphoneScreen.frame.size.height - bedroomView2Height) * 0.5), 
          bedroomView2Width, bedroomView2Height)];
  [_iphoneScreen addSubview: bedroomView2];

  UILabel *uploadingLabel = [[UILabel alloc] init];
  uploadingLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 13];
  uploadingLabel.frame = CGRectMake(0, 
    (_iphoneScreen.frame.size.height - (20 * 1.5)), 
      _iphoneScreen.frame.size.width, 20);
  uploadingLabel.text = @"Uploading...";
  uploadingLabel.textAlignment = NSTextAlignmentCenter;
  uploadingLabel.textColor = [UIColor textColor];
  [_iphoneScreen addSubview: uploadingLabel];

  UILabel *label1 = [[UILabel alloc] init];
  label1.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 22];
  label1.frame = CGRectMake(0, (screenHeight - (33 * 4)),
    screenWidth, 33);
  label1.text = @"Auction your place";
  label1.textAlignment = NSTextAlignmentCenter;
  label1.textColor = [UIColor textColor];
  [self addSubview: label1];

  UILabel *label2 = [[UILabel alloc] init];
  label2.font = label1.font;
  label2.frame = CGRectMake(label1.frame.origin.x,
    (label1.frame.origin.y + label1.frame.size.height),
      label1.frame.size.width, label1.frame.size.height);
  label2.text = @"to students";
  label2.textAlignment = label1.textAlignment;
  label2.textColor = label1.textColor;
  [self addSubview: label2];

  return self;
}

@end
