//
//  OMBOfferAcceptedView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOfferAcceptedView.h"

#import "NSString+Extensions.h"
#import "OMBAppDelegate.h"
#import "OMBCenteredImageView.h"
#import "OMBNavigationController.h"
#import "OMBOffer.h"
#import "OMBOfferInquiryViewController.h"
#import "OMBResidence.h"
#import "OMBUser.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"
#import "UIImageView+WebCache.h"

@interface OMBOfferAcceptedView ()
{
  UIDynamicAnimator *animatorLeft;
  UIDynamicAnimator *animatorRight;
  UIButton *cancelButton;
  UIButton *confirmButton;
  UIView *fadedBackground;
  OMBCenteredImageView *leftImageView;
  UILabel *middleLabel;
  OMBOffer *offer;
  OMBCenteredImageView *rightImageView;
  UILabel *topLabel;
}

@end

@implementation OMBOfferAcceptedView

#pragma mark - Initializer

- (id) initWithOffer: (OMBOffer *) object
{
  if (!(self = [super init])) return nil;

  offer = object;

  animatorLeft  = [[UIDynamicAnimator alloc] initWithReferenceView: self];
  animatorRight = [[UIDynamicAnimator alloc] initWithReferenceView: self];

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat padding      = 20.0f;
  CGFloat standardHeight = 44.0f;

  CGFloat spacing = screenHeight * 0.08f;

  self.frame = screen;

  // Faded background
  fadedBackground = [UIView new];
  fadedBackground.alpha = 0.0f;
  fadedBackground.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.85f];
  fadedBackground.frame = screen;
  [self addSubview: fadedBackground];

  CGFloat imageSize = (screenWidth - (padding * 3)) * 0.5f;

  CGFloat buttonHeight = 58.0f;
  // Cancel button
  cancelButton = [UIButton new];
  cancelButton.alpha = 0.0f;
  cancelButton.clipsToBounds = YES;
  cancelButton.frame = CGRectMake(padding,
    screenHeight - (buttonHeight + padding), imageSize, buttonHeight);
  cancelButton.layer.borderColor = [UIColor grayMedium].CGColor;
  cancelButton.layer.borderWidth = 1.0f;
  cancelButton.layer.cornerRadius = cancelButton.frame.size.height * 0.5f;
  cancelButton.tag = 0;
  cancelButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 18];
  [cancelButton addTarget: self action: @selector(buttonSelected:)
    forControlEvents: UIControlEventTouchUpInside];
  [cancelButton setBackgroundImage: [UIImage imageWithColor:
    [UIColor grayMediumAlpha: 0.8f]] forState: UIControlStateHighlighted];
  [cancelButton setTitle: @"Review Later" forState: UIControlStateNormal];
  [cancelButton setTitleColor: [UIColor grayMedium]
    forState: UIControlStateNormal];
  [cancelButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateHighlighted];
  [self addSubview: cancelButton];

  // Confirm button
  confirmButton = [UIButton new];
  confirmButton.alpha = cancelButton.alpha;
  confirmButton.clipsToBounds = cancelButton.clipsToBounds;
  confirmButton.frame = CGRectMake(
    cancelButton.frame.origin.x + cancelButton.frame.size.width + padding,
      cancelButton.frame.origin.y, cancelButton.frame.size.width,
        cancelButton.frame.size.height);
  confirmButton.layer.borderColor = [UIColor blue].CGColor;
  confirmButton.layer.borderWidth = 1.0f;
  confirmButton.layer.cornerRadius = cancelButton.layer.cornerRadius;
  confirmButton.tag = 1;
  confirmButton.titleLabel.font = cancelButton.titleLabel.font;
  [confirmButton addTarget: self action: @selector(buttonSelected:)
    forControlEvents: UIControlEventTouchUpInside];
  [confirmButton setBackgroundImage: [UIImage imageWithColor:
    [UIColor blueAlpha: 0.8f]] forState: UIControlStateHighlighted];
  [confirmButton setTitle: @"Review Now" forState: UIControlStateNormal];
  [confirmButton setTitleColor: [UIColor blue]
    forState: UIControlStateNormal];
  [confirmButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateHighlighted];
  [self addSubview: confirmButton];

  // Residence Image
  leftImageView = [[OMBCenteredImageView alloc] init];
  leftImageView.frame = CGRectMake(-1 * (screenWidth + imageSize),
    ((cancelButton.frame.origin.y + padding) - imageSize) * 0.5f,
      imageSize, imageSize);
  if (offer.residence.coverPhoto)
    leftImageView.image = offer.residence.coverPhoto;
  else {
    __weak typeof(leftImageView) weakLeftImageView = leftImageView;
    [offer.residence downloadCoverPhotoWithCompletion: ^(NSError *error) {
      [weakLeftImageView.imageView setImageWithURL:
        offer.residence.coverPhotoURL placeholderImage: nil
          options: SDWebImageRetryFailed completed:
            ^(UIImage *img, NSError *error, SDImageCacheType cacheType) {
              if (!error && img) {
                leftImageView.image = img;
              }
            }
          ];
    }];
  }
  leftImageView.layer.cornerRadius = imageSize * 0.5f;
  [self addSubview: leftImageView];

  // User Image
  rightImageView = [[OMBCenteredImageView alloc] init];
  rightImageView.frame = CGRectMake(screenWidth * 2,
    leftImageView.frame.origin.y, leftImageView.frame.size.width,
      leftImageView.frame.size.height);
  if (offer.user.image)
    rightImageView.image = offer.user.image;
  else {
    [offer.user downloadImageFromImageURLWithCompletion: ^(NSError *error) {
      rightImageView.image = offer.user.image;
    }];
  }
  rightImageView.layer.cornerRadius = leftImageView.layer.cornerRadius;
  [self addSubview: rightImageView];

  // Top Label
  topLabel = [UILabel new];
  topLabel.alpha = cancelButton.alpha;
  topLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 29];
  topLabel.frame = CGRectMake(0.0f,
    leftImageView.frame.origin.y - (standardHeight + spacing),
      screenWidth, standardHeight);
  topLabel.text = @"Offer Accepted!";
  topLabel.textAlignment = NSTextAlignmentCenter;
  topLabel.textColor = [UIColor whiteColor];
  [self addSubview: topLabel];

  // Middle label
  middleLabel = [UILabel new];
  middleLabel.alpha = cancelButton.alpha;
  middleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
  middleLabel.numberOfLines = 0;
  NSString *string = [NSString stringWithFormat:
    @"Your offer for %@ has been accepted.",
      [offer.residence.address capitalizedString]];
  NSAttributedString *aString = [string attributedStringWithFont:
    middleLabel.font lineHeight: 27.0f];
  middleLabel.attributedText = aString;
  middleLabel.textAlignment = topLabel.textAlignment;
  middleLabel.textColor = topLabel.textColor;
  CGRect middleLabelRect = [middleLabel.attributedText boundingRectWithSize:
    CGSizeMake(screenWidth - (padding * 2), 9999)
      options: NSStringDrawingUsesLineFragmentOrigin context: nil];
  middleLabel.frame = CGRectMake(padding,
    leftImageView.frame.origin.y + leftImageView.frame.size.height + spacing,
      screenWidth - (padding * 2), middleLabelRect.size.height);
  [self addSubview: middleLabel];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) buttonSelected: (UIButton *) button
{
  OMBAppDelegate *appDelegate = (OMBAppDelegate *)
    [UIApplication sharedApplication].delegate;
  // Review Now
  if (button.tag == 1) {
    [appDelegate.container showHomebaseRenter];
    [appDelegate.container.homebaseRenterNavigationController
      pushViewController: [[OMBOfferInquiryViewController alloc] initWithOffer:
        offer] animated: YES];
  }
  // [appDelegate.container hideOfferAcceptedView];
  [self hide];
}

- (void) hide
{
  [UIView animateWithDuration: 0.25f animations: ^{
    self.alpha = 0.0f;
  } completion: ^(BOOL finished) {
    [self removeFromSuperview];
  }];
}

- (void) show
{
  [[[UIApplication sharedApplication] keyWindow] addSubview: self];

  fadedBackground.alpha = 1.0f;

  [animatorLeft removeAllBehaviors];
  [animatorRight removeAllBehaviors];

  CGPoint topPoint =
    CGPointMake(self.frame.size.width * 0.5f, 0.0f);
  CGPoint bottomPoint =
    CGPointMake(self.frame.size.width * 0.5f, self.frame.size.height);
  UICollisionBehavior *collisionBehaviorLeft =
    [[UICollisionBehavior alloc] initWithItems: @[leftImageView]];
  [collisionBehaviorLeft addBoundaryWithIdentifier: @"barrier"
    fromPoint: topPoint toPoint: bottomPoint];
  [animatorLeft addBehavior: collisionBehaviorLeft];

  UICollisionBehavior *collisionBehaviorRight =
    [[UICollisionBehavior alloc] initWithItems: @[rightImageView]];
  [collisionBehaviorRight addBoundaryWithIdentifier: @"barrier"
    fromPoint: topPoint toPoint: bottomPoint];
  [animatorRight addBehavior: collisionBehaviorRight];

  UIGravityBehavior *leftGravityBehavior =
    [[UIGravityBehavior alloc] initWithItems: @[leftImageView]];
  leftGravityBehavior.gravityDirection = CGVectorMake(2.0f, 0.0f);
  [animatorLeft addBehavior: leftGravityBehavior];

  UIGravityBehavior *rightGravityBehavior =
    [[UIGravityBehavior alloc] initWithItems: @[rightImageView]];
  rightGravityBehavior.gravityDirection = CGVectorMake(-2.0f, 0.0f);
  [animatorRight addBehavior: rightGravityBehavior];

  [UIView animateWithDuration: 1.0f animations: ^{
    cancelButton.alpha = confirmButton.alpha =
      middleLabel.alpha = topLabel.alpha = 1.0f;
  }];
}

@end
