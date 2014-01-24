//
//  OMBAlertView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBAlertView.h"

#import "AMBlurView.h"
#import "NSString+Extensions.h"
#import "UIColor+Extensions.h"

@implementation OMBAlertView

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  // CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat padding      = 20.0f;
  // CGFloat standardHeight = 44.0f;

  self.frame = screen;

  // Faded background
  fadedBackground = [UIView new];
  fadedBackground.alpha = 0.0f;
  fadedBackground.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.5f];
  fadedBackground.frame = screen;
  [self addSubview: fadedBackground];

  // CGFloat alertHeight = screenHeight * 0.5f;
  CGFloat alertWidth  = screenWidth * 0.8f;
  alert = [[AMBlurView alloc] init];
  alert.frame = CGRectMake((screenWidth - alertWidth) * 0.5, 
    0.0f, alertWidth, 0.0f);
  alert.layer.cornerRadius = 5.0f;
  [fadedBackground addSubview: alert];

  // Alert title
  _alertTitle = [UILabel new];
  _alertTitle.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 18];
  _alertTitle.frame = CGRectMake(padding, padding, 
    alert.frame.size.width - (padding * 2), 0.0f);
  _alertTitle.numberOfLines = 0;
  _alertTitle.textAlignment = NSTextAlignmentCenter;
  _alertTitle.textColor = [UIColor textColor];
  [alert addSubview: _alertTitle];

  // Alert message
  _alertMessage = [UILabel new];
  _alertMessage.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  _alertMessage.numberOfLines = 0;
  CGRect alertMessageRect = [_alertMessage.text boundingRectWithSize:
    CGSizeMake(_alertTitle.frame.size.width, 9999) font: _alertMessage.font];
  _alertMessage.frame = CGRectMake(_alertTitle.frame.origin.x,
    _alertTitle.frame.origin.y + 
      _alertTitle.frame.size.height + (padding * 0.5),
        _alertTitle.frame.size.width, alertMessageRect.size.height);
  _alertMessage.textAlignment = NSTextAlignmentCenter;
  _alertMessage.textColor = [UIColor textColor];
  [alert addSubview: _alertMessage];

  // Alert buttons view
  alertButtonsView = [UIView new];
  alertButtonsView.frame = CGRectMake(0.0f, 
    _alertMessage.frame.origin.y + _alertMessage.frame.size.height + padding,
      alert.frame.size.width, 44.0f);
  [alert addSubview: alertButtonsView];
  UIView *alertButtonsViewTopBorder = [UIView new];
  alertButtonsViewTopBorder.backgroundColor = [UIColor grayMedium];
  alertButtonsViewTopBorder.frame = CGRectMake(0.0f, 0.0f, 
    alertButtonsView.frame.size.width, 0.5f);
  [alertButtonsView addSubview: alertButtonsViewTopBorder];
  // Middle border
  alertButtonsViewMiddleBorder = [UIView new];
  alertButtonsViewMiddleBorder.backgroundColor = 
    alertButtonsViewTopBorder.backgroundColor;
  alertButtonsViewMiddleBorder.frame = CGRectMake(
    (alertButtonsView.frame.size.width - 0.5f) * 0.5, 0.0f, 
      0.5f, alertButtonsView.frame.size.height);
  [alertButtonsView addSubview: alertButtonsViewMiddleBorder];

  CGFloat alertButtonWidth = alertButtonsView.frame.size.width * 0.5f;
  // Alert confirm
  _alertConfirm = [UIButton new];
  _alertConfirm.frame = CGRectMake(alertButtonWidth, 0.0f, alertButtonWidth,
    alertButtonsView.frame.size.height);
  _alertConfirm.titleLabel.font = _alertTitle.font;
  [_alertConfirm setTitleColor: [UIColor blue] forState: UIControlStateNormal];
  [alertButtonsView addSubview: _alertConfirm];

  // Alert cancel
  _alertCancel = [UIButton new];
  _alertCancel.frame = CGRectMake(0.0f, 0.0f, alertButtonWidth,
    alertButtonsView.frame.size.height);
  _alertCancel.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 18];
  [_alertCancel setTitleColor: [UIColor blue] forState: UIControlStateNormal];
  [alertButtonsView addSubview: _alertCancel];

  _animator = [[UIDynamicAnimator alloc] initWithReferenceView: self];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addTarget: (id) target action: (SEL) action 
forButton: (UIButton *) button
{
  [button removeTarget: target action: nil 
    forControlEvents: UIControlEventTouchUpInside];
  [button addTarget: target action: action 
    forControlEvents: UIControlEventTouchUpInside];
}

- (void) animateChangeOfContent
{
  [self resizeFrames];
  [UIView animateWithDuration: 0.1f animations: ^{
    alert.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
  } completion: ^(BOOL finished) {
    [UIView animateWithDuration: 0.1f animations: ^{
      alert.transform = CGAffineTransformIdentity;
    }];
  }];
}

- (void) hideAlert
{
  // Remove animators
  // [_animator removeBehavior: _collisionBehavior];
  // [_animator removeBehavior: _elasticityBehavior];
  // [_animator removeBehavior: _gravityBehavior];
  // [_animator removeBehavior: _snapBehavior];

  // Must give it a background or the blur goes away and it is black
  alert.alpha = 0.9f;
  alert.backgroundColor = [UIColor whiteColor];

  // Gravity
  _gravityBehavior = 
    [[UIGravityBehavior alloc] initWithItems: @[alert]];
  _gravityBehavior.gravityDirection = CGVectorMake(0, 10);
  // Item
  _itemBehavior = 
    [[UIDynamicItemBehavior alloc] initWithItems: @[alert]];
  CGFloat velocity = M_PI_2;
  if (arc4random_uniform(100) % 2) {
    velocity *= -1;
  }
  [_itemBehavior addAngularVelocity: velocity forItem: alert];
  // Add animators
  [_animator addBehavior: _gravityBehavior];
  [_animator addBehavior: _itemBehavior];

  [UIView animateWithDuration: 0.15f delay: 0.25f 
    options: UIViewAnimationOptionCurveLinear animations: ^{
      fadedBackground.alpha = 0.0f;
    } completion: ^(BOOL finished) {
      [self removeFromSuperview];
    }
  ];

  [UIView animateWithDuration: 0.25f delay: 0.0f 
    options: UIViewAnimationOptionCurveLinear animations: ^{
    // CGRect rect = alert.frame;
    // rect.origin.y = fadedBackground.frame.size.height;
    // alert.frame = rect;
    } completion: ^(BOOL finished) {
    }
  ];
}

- (void) onlyShowOneButton: (UIButton *) button
{
  if (button == _alertCancel)
    _alertConfirm.hidden = YES;
  else if (button == _alertConfirm)
    _alertCancel.hidden = YES;
  alertButtonsViewMiddleBorder.hidden = YES;
  button.frame = CGRectMake(0.0f, 0.0f, alertButtonsView.frame.size.width,
    button.frame.size.height);
}

- (void) resizeFrames
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat padding = 20.0f;

  CGRect alertTitleRect = [_alertTitle.text boundingRectWithSize:
    CGSizeMake(_alertTitle.frame.size.width, 9999) font: _alertTitle.font];
  _alertTitle.frame = CGRectMake(padding, padding, 
    alert.frame.size.width - (padding * 2), alertTitleRect.size.height);

  CGRect alertMessageRect = [_alertMessage.text boundingRectWithSize:
    CGSizeMake(_alertTitle.frame.size.width, 9999) font: _alertMessage.font];
  _alertMessage.frame = CGRectMake(_alertTitle.frame.origin.x,
    _alertTitle.frame.origin.y + _alertTitle.frame.size.height + 
    (padding * 0.5),
      _alertTitle.frame.size.width, alertMessageRect.size.height);

  alertButtonsView.frame = CGRectMake(0.0f, 
    _alertMessage.frame.origin.y + _alertMessage.frame.size.height + padding,
      alert.frame.size.width, 44.0f);

  CGFloat alertHeight = screenHeight * 0.5f;
  // Resize alert height
  alertHeight = alertButtonsView.frame.origin.y + 
    alertButtonsView.frame.size.height;
  alert.frame = CGRectMake(alert.frame.origin.x, 
    (screenHeight - alertHeight) * 0.5f, alert.frame.size.width, alertHeight);
}

- (void) showAlert
{
  [[[UIApplication sharedApplication] keyWindow] addSubview: self];

  CGRect screen = [[UIScreen mainScreen] bounds];

  // Remove animators
  [_animator removeBehavior: _gravityBehavior];
  [_animator removeBehavior: _itemBehavior];

  // Put the blur back
  alert.alpha = 1.0f;
  alert.backgroundColor = [UIColor clearColor];
  alert.transform = CGAffineTransformIdentity;

  [self resizeFrames];

  // Place the alert at the top of the screen
  alert.frame = CGRectMake((screen.size.width - alert.frame.size.width) * 0.5,
    -1 * alert.frame.size.height, alert.frame.size.width, 
      alert.frame.size.height);

  CGFloat bounceDistance = screen.size.height * 0.05f;

  [UIView animateWithDuration: 0.15f animations: ^{
    fadedBackground.alpha = 1.0f;
  } completion: ^(BOOL finished) {
    [UIView animateWithDuration: 0.15f animations: ^{
      // Animate a little down more
      CGRect rect = alert.frame;
      rect.origin.y = (screen.size.height - 
        (alert.frame.size.height - bounceDistance)) * 0.5f;
      alert.frame = rect;

      // Snap
      // Snap the button in the middle
      // _snapBehavior = [[UISnapBehavior alloc] initWithItem: alert 
      //   snapToPoint: 
      //     [UIApplication sharedApplication].delegate.window.center];
      // // We decrease the damping so the view has a little less spring.
      // _snapBehavior.damping = 0.0f;
      // // Add animator
      // [_animator addBehavior: _snapBehavior];

      // Bounces
      // _collisionBehavior = [[UICollisionBehavior alloc] initWithItems: 
      //   @[alert]];
      // _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
      // [_animator addBehavior: _collisionBehavior];

      // Gravity
      // _gravityBehavior = 
      //   [[UIGravityBehavior alloc] initWithItems: @[alert]];
      // _gravityBehavior.gravityDirection = CGVectorMake(0, 10);
      // [_animator addBehavior: _gravityBehavior];

      // More bouncing
      // _elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems: 
      //   @[alert]];
      // _elasticityBehavior.elasticity = 0.7f;
      // [_animator addBehavior: _elasticityBehavior];
    } completion: ^(BOOL finished) {
      [UIView animateWithDuration: 0.10f animations: ^{
        // Bounce up
        CGRect rect = alert.frame;
        rect.origin.y = (screen.size.height - 
          (alert.frame.size.height + (bounceDistance * 0.5))) * 0.5f;
        alert.frame = rect;
      } completion: ^(BOOL finished) {
        [UIView animateWithDuration: 0.05f animations: ^{
          // Animate to center
          CGRect rect = alert.frame;
          rect.origin.y = (screen.size.height - alert.frame.size.height) * 0.5f;
          alert.frame = rect;
        }];
      }];
    }];
  }];
}

- (void) showBothButtons
{
  _alertConfirm.hidden = NO;
  _alertCancel.hidden  = NO;
  alertButtonsViewMiddleBorder.hidden = NO;
  _alertCancel.frame = CGRectMake(0.0f, 0.0f,
    alertButtonsView.frame.size.width * 0.5f, _alertCancel.frame.size.height);
  _alertConfirm.frame = CGRectMake(_alertCancel.frame.size.width,
    _alertCancel.frame.origin.y, _alertCancel.frame.size.width,
      _alertCancel.frame.size.height);
}

@end
