//
//  OMBAlertViewBlur.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/4/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBAlertViewBlur.h"

#import "NSString+Extensions.h"
#import "OMBActivityView.h"
#import "OMBBlurView.h"
#import "OMBCloseButtonView.h"
#import "OMBViewController.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"

@implementation OMBAlertViewBlur

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat padding      = OMBPadding;
  CGFloat standardHeight = OMBStandardHeight;

  self.frame = screen;

  _backgroundBlurView = [[OMBBlurView alloc] initWithFrame: self.frame];
  _backgroundBlurView.alpha      = 0.0f;
  _backgroundBlurView.blurRadius = 20.0f;
  _backgroundBlurView.tintColor  = [UIColor colorWithWhite: 0.0f alpha: 0.3f];
  [self addSubview: _backgroundBlurView];

  closeButton = [UIButton new];
  closeButton.frame = CGRectMake((screenWidth - standardHeight) * 0.5f, 
    screenHeight - (standardHeight + padding), standardHeight, standardHeight);
  closeButton.layer.borderColor = [UIColor whiteColor].CGColor;
  closeButton.layer.borderWidth = 1.0f;
  closeButton.layer.cornerRadius = closeButton.frame.size.height * 0.5f;
  [closeButton addTarget: self action: @selector(close)
    forControlEvents: UIControlEventTouchUpInside];
  [_backgroundBlurView addSubview: closeButton];

  CGFloat xSize = closeButton.frame.size.width * 0.5f;
  closeButtonView = 
    [[OMBCloseButtonView alloc] initWithFrame: 
      CGRectMake((screenWidth - xSize) * 0.5f,
        closeButton.frame.origin.y + 
        (closeButton.frame.size.height - xSize) * 0.5f,
          xSize, xSize) color: [UIColor whiteColor]];
  [_backgroundBlurView insertSubview: closeButtonView 
    belowSubview: closeButton];

  alertView = [UIView new];
  alertView.frame = CGRectMake(padding, padding, screenWidth - (padding * 2),
    screenHeight - (padding * 2));
  alertView.backgroundColor = [UIColor whiteColor];
  alertView.layer.cornerRadius = 2.0f;
  [self addSubview: alertView];

  titleLabel = [UILabel new];
  titleLabel.font = [UIFont mediumLargeTextFont];
  titleLabel.text = @"Respond Now";
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.textColor = [UIColor textColor];
  [alertView addSubview: titleLabel];

  messageLabel = [UILabel new];
  messageLabel.font = [UIFont normalTextFont];
  messageLabel.numberOfLines = 0;
  messageLabel.textColor = [UIColor textColor];
  [alertView addSubview: messageLabel];

  buttonView = [UIView new];
  buttonView.frame = CGRectMake(0.0f, 0.0f, screenWidth - (padding * 2),
    OMBStandardButtonHeight);
  [alertView addSubview: buttonView];
  UIView *topBorder = [UIView new];
  topBorder.backgroundColor = [UIColor grayLight];
  topBorder.frame = CGRectMake(0.0f, 0.0f, buttonView.frame.size.width, 1.0);
  [buttonView addSubview: topBorder];
  middleBorder = [UIView new];
  middleBorder.backgroundColor = topBorder.backgroundColor;
  middleBorder.frame = CGRectMake((buttonView.frame.size.width - 1.0f) * 0.5f,
    0.0f, 1.0f, buttonView.frame.size.height);
  [buttonView addSubview: middleBorder];

  cancelButton = [UIButton new];
  cancelButton.titleLabel.font = [UIFont mediumTextFontBold];
  [cancelButton setTitle: @"Cancel" forState: UIControlStateNormal];
  [cancelButton setTitleColor: [UIColor grayMedium] 
    forState: UIControlStateNormal];
  [buttonView addSubview: cancelButton];

  confirmButton = [UIButton new];
  confirmButton.titleLabel.font = cancelButton.titleLabel.font;
  [confirmButton setTitle: @"Confirm" forState: UIControlStateNormal];
  [confirmButton setTitleColor: [UIColor blue] 
    forState: UIControlStateNormal];
  [buttonView addSubview: confirmButton];

  questionButton = [UIButton new];
  questionButton.frame = CGRectMake(0.0f, 0.0f, padding, padding);
  questionButton.titleLabel.font = [UIFont smallTextFontBold];
  questionButton.layer.borderColor = [UIColor blue].CGColor;
  questionButton.layer.borderWidth = 1.0f;
  questionButton.layer.cornerRadius = questionButton.frame.size.height * 0.5f;
  [questionButton addTarget: self action: @selector(questionButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [questionButton setTitle: @"i" forState: UIControlStateNormal];
  [questionButton setTitleColor: [UIColor blue] forState: UIControlStateNormal];
  [alertView addSubview: questionButton];

  questionDetailsView = [UIView new];
  questionDetailsView.backgroundColor = [UIColor grayUltraLight];
  questionDetailsView.frame = CGRectMake(0.0f, 0.0f, 
    buttonView.frame.size.width, 0.0f);
  [alertView addSubview: questionDetailsView];
  UIView *topBorder2 = [UIView new];
  topBorder2.backgroundColor = topBorder.backgroundColor;
  topBorder2.frame = topBorder.frame;
  [questionDetailsView addSubview: topBorder2];
  questionDetailsLabel = [UILabel new];
  questionDetailsLabel.alpha = 0.0f;
  questionDetailsLabel.font = [UIFont normalTextFont];
  questionDetailsLabel.numberOfLines = 0;
  questionDetailsLabel.textColor = [UIColor grayMedium];
  [questionDetailsView addSubview: questionDetailsLabel];

  _animator = [[UIDynamicAnimator alloc] initWithReferenceView: self];

  activityView = [[OMBActivityView alloc] init];
  [self addSubview: activityView];

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

- (void) addTargetForCancelButton: (id) target action: (SEL) action 
{
  [self addTarget: target action: action forButton: cancelButton];
}

- (void) addTargetForConfirmButton: (id) target action: (SEL) action
{
  [self addTarget: target action: action forButton: confirmButton];
}

- (void) animateChangeOfContent
{
  [self updateFrames];
  [UIView animateWithDuration: 0.1f animations: ^{
    alertView.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
  } completion: ^(BOOL finished) {
    if (finished) {
      [UIView animateWithDuration: 0.1f animations: ^{
        alertView.transform = CGAffineTransformIdentity;
      }];
    }
  }];
}

- (void) close
{
  // Gravity
  _gravityBehavior = 
    [[UIGravityBehavior alloc] initWithItems: @[alertView]];
  _gravityBehavior.gravityDirection = CGVectorMake(0, 10);
  // Item
  _itemBehavior = 
    [[UIDynamicItemBehavior alloc] initWithItems: @[alertView]];
  CGFloat velocity = M_PI_2;
  if (arc4random_uniform(100) % 2) {
    velocity *= -1;
  }
  [_itemBehavior addAngularVelocity: velocity forItem: alertView];
  // Add animators
  [_animator addBehavior: _gravityBehavior];
  [_animator addBehavior: _itemBehavior];

  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    _backgroundBlurView.alpha = 0.0f;
  } completion: ^(BOOL finished) {
    if (finished) {
      isShowingQuestionDetails = NO;
      questionDetailsLabel.alpha = 0.0f;
      [self removeFromSuperview];
      self.alpha = 1.0f;
    }
  }];
}

- (void) hideCloseButton
{
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    closeButton.alpha     = 0.0f;
    closeButtonView.alpha = 0.0f;
  } completion: ^(BOOL finished) {
    if (finished) {
      closeButton.hidden     = YES;
      closeButtonView.hidden = YES;
    }
  }];
}

- (void) hideQuestionButton
{
  questionButton.hidden = YES;
}

- (void) questionButtonSelected
{
  isShowingQuestionDetails = YES;
  
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    questionDetailsLabel.alpha = 1.0f;
    [self updateFrames];
  }];
}

- (void) resetQuestionDetails
{
  isShowingQuestionDetails = NO;
  questionDetailsView.frame = CGRectMake(questionDetailsView.frame.origin.x,
    questionDetailsView.frame.origin.y, questionDetailsView.frame.size.width,
      0.0f);
  questionDetailsLabel.alpha = 0.0f;
  questionDetailsLabel.attributedText = nil;
}

- (void) setCancelButtonTitle: (NSString *) string
{
  [cancelButton setTitle: string forState: UIControlStateNormal];
}

- (void) setConfirmButtonTitle: (NSString *) string
{
  [confirmButton setTitle: string forState: UIControlStateNormal];
}

- (void) setQuestionDetails: (NSString *) string
{
  questionButton.hidden = NO;
  questionDetailsLabel.attributedText = [string attributedStringWithFont: 
    questionDetailsLabel.font lineHeight: 22.0f];
}

- (void) setMessage: (NSString *) string
{
  messageLabel.attributedText = [string attributedStringWithFont: 
    messageLabel.font lineHeight: 22.0f];
}

- (void) setTitle: (NSString *) string
{
  titleLabel.text = string;
}

- (void) showBothButtons
{
  cancelButton.hidden = confirmButton.hidden = NO;
  middleBorder.hidden = NO;

  cancelButton.frame = CGRectMake(0.0f, 0.0f, 
    buttonView.frame.size.width * 0.5f, buttonView.frame.size.height);
  confirmButton.frame = CGRectMake(
    cancelButton.frame.origin.x + cancelButton.frame.size.width, 0.0f,
      cancelButton.frame.size.width, cancelButton.frame.size.height);
}

- (void) showCloseButton
{
  closeButton.hidden     = NO;
  closeButtonView.hidden = NO;
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    closeButton.alpha     = 1.0f;
    closeButtonView.alpha = 1.0f;
  }];
}

- (void) showInView: (UIView *) view withDetails:(BOOL) show
{
  [_backgroundBlurView refreshWithView: view];

  [[[UIApplication sharedApplication] keyWindow] addSubview: self];

  CGRect screen = [[UIScreen mainScreen] bounds];

  // Remove animators
  [_animator removeBehavior: _gravityBehavior];
  [_animator removeBehavior: _itemBehavior];

  alertView.transform = CGAffineTransformIdentity;
  if(show){
    questionDetailsLabel.alpha = 1.0f;
    isShowingQuestionDetails = YES;
  }
  [self updateFrames];

  [self showBothButtons];

  closeButton.alpha      = 1.0f;
  closeButtonView.alpha  = 1.0f;
  closeButton.hidden     = NO;
  closeButtonView.hidden = NO;

  // Place the alert at the top of the screen
  alertView.frame = CGRectMake(
    (screen.size.width - alertView.frame.size.width) * 0.5f,
      -1 * alertView.frame.size.height, alertView.frame.size.width, 
        alertView.frame.size.height);

  CGFloat bounceDistance = screen.size.height * 0.05f;

  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    _backgroundBlurView.alpha = 1.0f;
    // Animate a little down more
    CGRect rect = alertView.frame;
    rect.origin.y = (screen.size.height - 
      (alertView.frame.size.height - bounceDistance)) * 0.5f;
    alertView.frame = rect;
  } completion: ^(BOOL finished) {
    if (finished) {
      [UIView animateWithDuration: 0.15f animations: ^{
        // Bounce up
        CGRect rect = alertView.frame;
        rect.origin.y = (screen.size.height - 
          (alertView.frame.size.height + (bounceDistance * 0.5))) * 0.5f;
        alertView.frame = rect;
      } completion: ^(BOOL finished) {
        [UIView animateWithDuration: 0.05f animations: ^{
          // Animate to center
          CGRect rect = alertView.frame;
          rect.origin.y = (screen.size.height - 
            alertView.frame.size.height) * 0.5f;
          alertView.frame = rect;
        }];
      }];
    }
  }];
}

- (void) showOnlyConfirmButton
{
  cancelButton.hidden = YES;
  confirmButton.hidden = !cancelButton.hidden;
  middleBorder.hidden = YES;
  confirmButton.frame = CGRectMake(0.0f, 0.0f,
    buttonView.frame.size.width, cancelButton.frame.size.height);
}

- (void) startSpinning
{
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    alertView.alpha = 0.0f;
  }];
  [activityView startSpinning];
  [self hideCloseButton];
}

- (void) stopSpinning
{
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    alertView.alpha = 1.0f;
  }];
  [activityView stopSpinning];
}

- (void) updateFrames
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  // CGFloat screenWidth  = screen.size.width;
  CGFloat padding      = OMBPadding;
  // CGFloat standardHeight = OMBStandardHeight;

  // Alert view
  // Question button
  questionButton.frame = CGRectMake(alertView.frame.size.width - 
    (questionButton.frame.size.width + (padding * 0.5f)), padding * 0.5f,
      questionButton.frame.size.width, questionButton.frame.size.height);
  // Title
  titleLabel.frame = CGRectMake(padding, padding, 
    alertView.frame.size.width - (padding * 2), 33.0f);
  // Message
  CGRect messageRect = [messageLabel.attributedText boundingRectWithSize:
    CGSizeMake(titleLabel.frame.size.width, 9999) 
      options: NSStringDrawingUsesLineFragmentOrigin context: nil];
  messageLabel.frame = CGRectMake(titleLabel.frame.origin.x,
    titleLabel.frame.origin.y + titleLabel.frame.size.height,
      titleLabel.frame.size.width, messageRect.size.height + padding + padding);
  messageLabel.textAlignment = titleLabel.textAlignment;

  // Question
  CGRect questionRect = 
    [questionDetailsLabel.attributedText boundingRectWithSize:
      CGSizeMake(alertView.frame.size.width - (padding * 2), 9999) 
        options: NSStringDrawingUsesLineFragmentOrigin context: nil];
  questionDetailsView.frame = CGRectMake(questionDetailsView.frame.origin.x,
    messageLabel.frame.origin.y + messageLabel.frame.size.height,
      questionDetailsView.frame.size.width, 
        questionRect.size.height + (padding * 2));
  questionDetailsLabel.frame = CGRectMake(padding, padding,
    questionRect.size.width, questionRect.size.height);

  if (!isShowingQuestionDetails) {
    questionDetailsView.frame = CGRectMake(questionDetailsView.frame.origin.x,
      questionDetailsView.frame.origin.y,
        questionDetailsView.frame.size.width, 0.0f);
  }

  // Buttons
  buttonView.frame = CGRectMake(0.0f, 
    questionDetailsView.frame.origin.y + questionDetailsView.frame.size.height, 
      buttonView.frame.size.width, buttonView.frame.size.height);

  // Alert view position and height
  CGFloat alertViewHeight = 
    buttonView.frame.origin.y + buttonView.frame.size.height;
  alertView.frame = CGRectMake(alertView.frame.origin.x,
    (screenHeight - alertViewHeight) * 0.5f,
      alertView.frame.size.width, alertViewHeight);
}

@end
