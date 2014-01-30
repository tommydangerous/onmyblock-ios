//
//  OMBStudentOrLandlordView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/28/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBStudentOrLandlordView.h"

#import "AMBlurView.h"
#import "OMBBlurView.h"
#import "OMBCloseButtonView.h"
#import "OMBOrView.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"
#import "UIImage+NegativeImage.h"

@implementation OMBStudentOrLandlordView

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat padding = 20.0f;
  CGFloat standardHeight = 44.0f;

  self.alpha = 0.0f;
  self.frame = screen;

  blurView = [[OMBBlurView alloc] initWithFrame: self.frame];
  blurView.blurRadius = 10.0f;
  blurView.tintColor = [UIColor colorWithWhite: 0.0f alpha: 0.0f];
  [self addSubview: blurView];

  CGFloat boxHeight = screenHeight * 0.5f;
  CGFloat boxWidth = screenWidth - (padding * 2);
  boxView = [[AMBlurView alloc] init];
  boxView.frame = CGRectMake(padding, (screenHeight - boxHeight) * 0.5f,
    boxWidth, boxHeight);
  boxView.layer.cornerRadius = 5.0f;
  [self addSubview: boxView];

  CGFloat originX = padding;
  // I am a...
  UILabel *label1 = [UILabel new];
  label1.font = [UIFont mediumTextFont];
  label1.frame = CGRectMake(originX, padding, 
    boxView.frame.size.width - (padding * 2), standardHeight);
  label1.text = @"I am a";
  label1.textAlignment = NSTextAlignmentCenter;
  label1.textColor = [UIColor textColor];
  [boxView addSubview: label1];

  CGFloat buttonHeight = padding + 18.0f + padding;
  CGFloat buttonWidth  = boxView.frame.size.width - (originX * 2); 
  // Student button
  _studentButton = [UIButton new];
  _studentButton.backgroundColor = [UIColor blue];
  _studentButton.clipsToBounds = YES;
  _studentButton.frame = CGRectMake(originX,
    label1.frame.origin.y + label1.frame.size.height + padding,
      buttonWidth, buttonHeight);
  _studentButton.layer.borderColor = [UIColor textColor].CGColor;
  _studentButton.layer.borderWidth = 0.0f;
  _studentButton.layer.cornerRadius = 5.0f;
  _studentButton.titleLabel.font = [UIFont mediumTextFontBold];
  [_studentButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blueHighlighted]] 
      forState: UIControlStateHighlighted];
  [_studentButton setTitle: @"Student" 
    forState: UIControlStateNormal];
  [_studentButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateNormal];
  [boxView addSubview: _studentButton];
  CGFloat imageSize = buttonHeight - padding;
  // _studentButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, imageSize,
  //   0.0f, 0.0f);
  UIImageView *studentImageView = [UIImageView new];
  studentImageView.frame = CGRectMake(padding * 0.5f,
    (buttonHeight - imageSize) * 0.5f, imageSize, imageSize);
  // Resize it or it gets pixelated
  CGSize size = CGSizeMake(imageSize, imageSize);
  studentImageView.image = [UIImage image: 
    [[UIImage imageNamed: @"student_icon.png"] negativeImage] size: size];
  [_studentButton addSubview: studentImageView];

  // OR
  CGRect orViewRect = CGRectMake(originX,
    _studentButton.frame.origin.y + _studentButton.frame.size.height + padding,
      buttonWidth, standardHeight);
  OMBOrView *orView = [[OMBOrView alloc] initWithFrame: orViewRect
    color: label1.textColor];
  [orView setLabelBold: NO];
  [boxView addSubview: orView];

  // Landlord button
  _landlordButton = [UIButton new];
  _landlordButton.backgroundColor = _studentButton.backgroundColor;
  _landlordButton.clipsToBounds = _studentButton.clipsToBounds;
  _landlordButton.frame = CGRectMake(_studentButton.frame.origin.x,
    orView.frame.origin.y + orView.frame.size.height + padding,
      buttonWidth, buttonHeight);
  _landlordButton.layer.borderColor = _studentButton.layer.borderColor;
  _landlordButton.layer.borderWidth = _studentButton.layer.borderWidth;
  _landlordButton.layer.cornerRadius = _studentButton.layer.cornerRadius;
  _landlordButton.titleLabel.font = _studentButton.titleLabel.font;
  [_landlordButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blueHighlighted]] 
      forState: UIControlStateHighlighted];
  [_landlordButton setTitle: @"Landlord" 
    forState: UIControlStateNormal];
  [_landlordButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateNormal];
  [boxView addSubview: _landlordButton];
  _landlordButton.titleEdgeInsets = _studentButton.titleEdgeInsets;
  UIImageView *landlordImageView = [UIImageView new];
  landlordImageView.frame = studentImageView.frame;
  // Resize it or it gets pixelated
  landlordImageView.image = [UIImage image: 
    [[UIImage imageNamed: @"landlord_sign_up_icon.png"] negativeImage] 
      size: size];
  [_landlordButton addSubview: landlordImageView];

  // Resize the boxView frame
  CGRect newRect = boxView.frame;
  newRect.size.height = _landlordButton.frame.origin.y + 
    _landlordButton.frame.size.height + padding + padding;
  newRect.origin.y = (self.frame.size.height - newRect.size.height) * 0.5f;
  boxView.frame = newRect;

  // Close button
  CGFloat closeButtonPadding = padding * 0.5f;
  CGFloat closeButtonViewHeight = 26.0f;
  CGFloat closeButtonViewWidth  = closeButtonViewHeight;
  CGRect closeButtonRect = CGRectMake(self.frame.size.width - 
    (closeButtonViewWidth + closeButtonPadding), 
      padding + closeButtonPadding, closeButtonViewWidth, 
        closeButtonViewHeight);
  _closeButtonView = [[OMBCloseButtonView alloc] initWithFrame:
    closeButtonRect color: [UIColor whiteColor]];
  [_closeButtonView.closeButton addTarget: self action: @selector(hide)
    forControlEvents: UIControlEventTouchUpInside];
  [self addSubview: _closeButtonView];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) hide
{
  [UIView animateWithDuration: 0.25f animations: ^{
    self.alpha = 0.0f;
  }];
}

- (void) showFromView: (UIView *) view
{
  [blurView refreshWithView: view];
  [UIView animateWithDuration: 0.25f animations: ^{
    self.alpha = 1.0f;
  }];
}

@end
