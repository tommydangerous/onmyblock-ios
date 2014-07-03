//
//  OMBImageTwoTextFieldCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 7/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBImageTwoTextFieldCell.h"

#import "OMBCenteredImageView.h"
#import "OMBGradientView.h"
#import "OMBViewController.h"
#import "UIImage+Resize.h"

@implementation OMBImageTwoTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
  if(!(self = [super initWithStyle:style
      reuseIdentifier:reuseIdentifier]))
    return nil;
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  gradientView = [OMBGradientView new];
  gradientView.colors = @[
    [UIColor colorWithWhite: 0.0f alpha: 0.0f],
    [UIColor colorWithWhite: 0.0f alpha: 0.6f]
  ];
  [self.contentView addSubview:gradientView];
  
  _userImage = [OMBCenteredImageView new];
  [self.contentView addSubview: _userImage];
  
  cameraImageView = [UIImageView new];
  [_userImage addSubview: cameraImageView];
  
  tapView = [UIView new];
  [self.contentView addSubview:tapView];
  
  _firstIconImageView = [UIImageView new];
  _firstIconImageView.alpha = .3f;
  [self.contentView addSubview:_firstIconImageView];
  
  _firstTextField = [[TextFieldPadding alloc] init];
  _firstTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  _firstTextField.font = [UIFont normalTextFont];
  // added reduntant default keyboard, just in case there are
  // conflicts with other UITableView cells
  _firstTextField.keyboardType = UIKeyboardTypeDefault;
  _firstTextField.returnKeyType = UIReturnKeyDone;
  _firstTextField.textColor = [UIColor textColor];
  [self.contentView addSubview: _firstTextField];
  
  // Separator like default UITablewViewCellSeparator
  separatorTextfield = [UILabel new];
  separatorTextfield.backgroundColor = [UIColor grayLight];
  [self.contentView addSubview:separatorTextfield];
  
  _secondIconImageView = [UIImageView new];
  _secondIconImageView.alpha = .3f;
  [self.contentView addSubview:_secondIconImageView];
  
  _secondTextField = [[TextFieldPadding alloc] init];
  _secondTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  _secondTextField.font = _firstTextField.font;
  _secondTextField.keyboardType = UIKeyboardTypeDefault;
  _secondTextField.returnKeyType = UIReturnKeyDone;
  _secondTextField.textColor = _firstTextField.textColor;
  [self.contentView addSubview: _secondTextField];
  
  return self;
  
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat)heightForCell
{
  return 2 * OMBStandardButtonHeight;
}

#pragma mark - Instance Methods

- (void)addGestureToImage:(UIGestureRecognizer *)gesture
{
  [tapView addGestureRecognizer:gesture];
}

- (void)setupWithImage:(UIImage *)image
{
  
  float padding  = 15.f;
  CGFloat height = [OMBImageTwoTextFieldCell heightForCell];
  CGFloat width  = self.frame.size.width;

  // User image
  CGFloat widthImage = height * .8f;
  _userImage.frame = CGRectMake((height - widthImage) * .5f,
    (height - widthImage) * .5f, widthImage, widthImage);
  _userImage.layer.cornerRadius = _userImage.frame.size.width * 0.5f;
  // Use same frame, to show camera option
  // when there is no photo
  gradientView.frame = _userImage.frame;
  gradientView.layer.cornerRadius = _userImage.layer.cornerRadius;
  tapView.frame = gradientView.frame;
  tapView.layer.cornerRadius = gradientView.layer.cornerRadius;
  
  // Camera Icon
  CGFloat cameraSize = 28.0f;
  cameraImageView.frame = CGRectMake(
    (_userImage.frame.size.width - cameraSize) * .5f,
      (_userImage.frame.size.height - cameraSize) * .5f,
        cameraSize, cameraSize);
  cameraImageView.image = [UIImage image:
    [UIImage imageNamed: @"camera_icon.png"] size: cameraImageView.bounds.size];
  
  // Icons
  CGFloat widthIcon = height * .25f;
  _firstIconImageView.frame = CGRectMake(_userImage.frame.origin.x +
    _userImage.frame.size.width + padding, widthIcon * .5f,
      widthIcon, widthIcon);
  
  _secondIconImageView.frame = CGRectMake(_firstIconImageView.frame.origin.x,
    height * .5f + widthIcon * .5f, widthIcon, widthIcon);
  
  // First TextField
  float originX = _firstIconImageView.frame.origin.x +
    _firstIconImageView.frame.size.width + padding;
  
  _firstTextField.frame = CGRectMake(originX, 0.0f,
    width - originX, height * .5f);
  
  // Separator
  separatorTextfield.frame = CGRectMake(_firstIconImageView.frame.origin.x,
    _firstTextField.frame.origin.y + _firstTextField.frame.size.height,
      width - _firstIconImageView.frame.origin.x, .5f);
  
  // Second TextField
  _secondTextField.frame = CGRectMake(_firstTextField.frame.origin.x,
    separatorTextfield.frame.origin.y + separatorTextfield.frame.size.height,
      _firstTextField.frame.size.width, _firstTextField.frame.size.height);
  
}

@end
