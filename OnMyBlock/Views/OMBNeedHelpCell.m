//
//  OMBNeedHelpCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 8/18/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBNeedHelpCell.h"

#import "OMBBlurView.h"
#import "OMBMapViewController.h"
#import "UIFont+OnMyBlock.h"

@interface OMBNeedHelpCell()
{
  UIButton *callButton;
}
@end

@implementation OMBNeedHelpCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
  if(!(self = [super initWithStyle:style
      reuseIdentifier:reuseIdentifier]))
    return nil;
  
  self.backgroundColor = UIColor.blackColor;
  self.clipsToBounds = YES;
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  CGRect screen = [UIScreen mainScreen].bounds;
  float height  = screen.size.height * PropertyInfoViewImageHeightPercentage;
  
  float padding = 20.f;
  float originY = (height - (40.f + 35.f)) * .5f;
  
  backgroundView = [OMBBlurView new];
  backgroundView.imageView.clipsToBounds = YES;
  backgroundView.contentMode = UIViewContentModeScaleToFill;
  backgroundView.frame = CGRectMake(0.0f,
    0.0f, screen.size.width, height);
  [self.contentView addSubview:backgroundView];

  tintView = [[UIView alloc] initWithFrame:backgroundView.bounds];
  tintView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
  [backgroundView addSubview:tintView];
  
  _titleLabel       = [UILabel new];
  _titleLabel.font  = [UIFont largeTextFontBold];
  _titleLabel.frame = CGRectMake(padding, originY,
    screen.size.width - 2 * padding, 40.f);
  _titleLabel.textAlignment = NSTextAlignmentCenter;
  _titleLabel.textColor = UIColor.whiteColor;
  [self.contentView addSubview:_titleLabel];
  
  _secondLabel       = [UILabel new];
  _secondLabel.font  = [UIFont mediumTextFont];
  _secondLabel.frame = CGRectMake(
    (screen.size.width - 130.f) * .5f,
      _titleLabel.frame.origin.y +
        _titleLabel.frame.size.height,
          130.f, 35.f);
  _secondLabel.textAlignment = NSTextAlignmentCenter;
  _secondLabel.textColor = [UIColor textColor];
  [self.contentView addSubview:_secondLabel];
  
  UIView *borderView = [UIView new];
  borderView.frame = CGRectMake(0.0f,
    height - 2.f, screen.size.width, 2.f);
  borderView.backgroundColor = [UIColor grayDarkAlpha:0.4];
  [self.contentView addSubview:borderView];

  CGFloat callButtonWidth = CGRectGetWidth(screen) * 0.4;
  callButton                    = [[UIButton alloc] init];
  callButton.frame = CGRectMake(
    (CGRectGetWidth(backgroundView.frame) - callButtonWidth) * 0.5,
    (CGRectGetHeight(backgroundView.frame) - callButtonWidth) * 0.5,
    callButtonWidth, callButtonWidth
  );
  callButton.layer.borderColor      = [UIColor whiteColor].CGColor;
  callButton.layer.borderWidth      = 2;
  callButton.layer.cornerRadius     = CGRectGetWidth(callButton.frame) * 0.5;
  callButton.titleLabel.font        = [UIFont mediumLargeTextFontBold];
  callButton.userInteractionEnabled = NO;
  [callButton setTitle:@"Call us" forState:UIControlStateNormal];
  [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public Method

- (void)addCallButton
{
  [self.contentView addSubview:callButton];
  [[NSRunLoop currentRunLoop] addTimer:[NSTimer timerWithTimeInterval:1.3
    target:self selector:@selector(animateCallButton) userInfo:nil repeats:YES] 
      forMode:NSRunLoopCommonModes];
}

- (void)disableTintView
{
  tintView.hidden = YES;
}

- (void)setBackgroundImage:(NSString *)nameImage withBlur:(BOOL)blur;
{
  backgroundView.blurRadius = blur ? 12.f : 0.0f;
  [backgroundView refreshWithImage: [UIImage imageNamed: nameImage]];
}

#pragma mark - Private Method

- (void)animateCallButton
{
  [UIView animateWithDuration:OMBStandardDuration animations:^{
      callButton.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished){
      if (finished) {
        [UIView animateWithDuration:OMBStandardDuration * 0.5 animations:^{
          callButton.transform = CGAffineTransformIdentity;
        } completion:nil];
      }
    }
  ];
}

@end
