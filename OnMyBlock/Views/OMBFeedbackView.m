//
//  OMBFeedbackView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 5/2/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBFeedbackView.h"

#import "NSString+Extensions.h"
#import "OMBAlertViewBlur.h"
#import "OMBAppDelegate.h"
#import "OMBBlurView.h"
#import "OMBCloseButtonView.h"
#import "OMBFeedbackSendEmailConnection.h"
#import "OMBTextFieldToolbar.h"
#import "OMBUser.h"
#import "OMBViewController.h"
#import "OMBViewControllerContainer.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"

@interface OMBFeedbackView () <UITextFieldDelegate, UITextViewDelegate>
{
  UIDynamicAnimator *animator;
  OMBBlurView *backgroundBlurView;
  UIView *bodyView;
  OMBCloseButtonView *closeButtonView;
  UITextView *contentTextView;
  UILabel *contentTextViewPlaceholder;
  TextFieldPadding *emailTextField;
  BOOL isInOriginalLocation;
  UIDynamicItemBehavior *itemBehavior;
  UIGravityBehavior *gravityBehavior;
  UILabel *headerLabel;
  UIButton *sendButton;
  OMBAlertViewBlur *successAlertView;
  OMBTextFieldToolbar *textFieldToolbar;
}

@end

@implementation OMBFeedbackView

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  CGFloat padding = OMBPadding * 0.75f;

  backgroundBlurView = [[OMBBlurView alloc] initWithFrame: self.frame];
  backgroundBlurView.blurRadius = 20.0f;
  backgroundBlurView.tintColor  = [UIColor colorWithWhite: 0.0f alpha: 0.3f];
  [self addSubview: backgroundBlurView];

  // Close button view
  CGFloat closeButtonSize = 30.0f;
  CGRect closeButtonRect  = CGRectMake(self.frame.size.width -
    (closeButtonSize + padding), padding * 1.5f,
      closeButtonSize, closeButtonSize);
  closeButtonView =
    [[OMBCloseButtonView alloc] initWithFrame: closeButtonRect
      color: [UIColor colorWithWhite: 1.0f alpha: 0.8f]];
  [closeButtonView.closeButton addTarget: self action: @selector(close)
    forControlEvents: UIControlEventTouchUpInside];
  [self addSubview: closeButtonView];

  CGFloat bodyViewHeight = self.frame.size.height * 0.5f;
  bodyView = [UIView new];
  bodyView.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.8f];
  bodyView.frame = CGRectMake(padding,
    (self.frame.size.height - bodyViewHeight) * 0.5f,
      self.frame.size.width - (padding * 2), bodyViewHeight);
  bodyView.layer.cornerRadius = 2.0f;
  [self addSubview: bodyView];

  CGFloat headerLabelHeight = 22.0f;
  headerLabel = [UILabel new];
  headerLabel.font = [UIFont normalTextFont];
  headerLabel.frame = CGRectMake(bodyView.frame.origin.x,
    bodyView.frame.origin.y - (headerLabelHeight + (padding * 2)),
      bodyView.frame.size.width, headerLabelHeight);
  headerLabel.text = @"Your feedback is super important";
  headerLabel.textAlignment = NSTextAlignmentCenter;
  headerLabel.textColor = [UIColor whiteColor];
  [self addSubview: headerLabel];

  // Text field toolbar
  textFieldToolbar = [[OMBTextFieldToolbar alloc] initWithFrame:
    CGRectMake(0.0f, 0.0f, self.frame.size.width, OMBStandardHeight)];
  textFieldToolbar.cancelBarButtonItem.action = @selector(cancel);
  textFieldToolbar.cancelBarButtonItem.target = self;
  textFieldToolbar.doneBarButtonItem.action   = @selector(done);
  textFieldToolbar.doneBarButtonItem.target   = self;

  // Email text field
  emailTextField                 = [[TextFieldPadding alloc] init];
  emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  emailTextField.backgroundColor = [UIColor whiteColor];
  emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  emailTextField.delegate        = self;
  emailTextField.font            = [UIFont normalTextFont];
  emailTextField.frame           = CGRectMake(padding, padding,
    (bodyView.frame.size.width - (padding * 2)), OMBStandardHeight);
  emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
  emailTextField.paddingX     = OMBPadding * 0.5f;
  emailTextField.placeholderColor = [UIColor grayMedium];
  emailTextField.placeholder   = @"Email address";
  emailTextField.returnKeyType = UIReturnKeyNext;
  emailTextField.textColor     = [UIColor textColor];
  [bodyView addSubview: emailTextField];

  // Text view
  CGFloat contentTextViewOriginY = emailTextField.frame.origin.y +
    emailTextField.frame.size.height + (padding * 0.5f);
  CGFloat contentTextViewHeight = bodyView.frame.size.height -
    (contentTextViewOriginY + padding);
  UIView *holder = [UIView new];
  holder.backgroundColor = [UIColor whiteColor];
  holder.frame = CGRectMake(emailTextField.frame.origin.x,
    contentTextViewOriginY, emailTextField.frame.size.width,
      contentTextViewHeight);
  [bodyView addSubview: holder];
  CGFloat contentPadding = OMBPadding * 0.25f;
  contentTextView = [UITextView new];
  contentTextView.alwaysBounceHorizontal = NO;
  contentTextView.autocorrectionType = UITextAutocorrectionTypeYes;
  contentTextView.contentInset = UIEdgeInsetsZero;
  contentTextView.delegate = self;
  contentTextView.font = emailTextField.font;
  contentTextView.frame = CGRectMake(contentPadding, contentPadding,
    holder.frame.size.width - (contentPadding * 2),
      holder.frame.size.height - (contentPadding * 2));
  contentTextView.inputAccessoryView = textFieldToolbar;
  contentTextView.showsHorizontalScrollIndicator = NO;
  contentTextView.textColor = emailTextField.textColor;
  contentTextView.contentSize = CGSizeMake(
    contentTextView.frame.size.height, contentTextView.contentSize.height);
  [holder addSubview: contentTextView];

  // Text view placeholder
  contentTextViewPlaceholder = [UILabel new];
  contentTextViewPlaceholder.font = contentTextView.font;
  contentTextViewPlaceholder.frame = CGRectMake(5.0f, 8.0f,
    contentTextView.frame.size.width, 20.0f);
  contentTextViewPlaceholder.text = @"New features, bugs, or thoughts?";
  contentTextViewPlaceholder.textColor = emailTextField.placeholderColor;
  [contentTextView addSubview: contentTextViewPlaceholder];

  // Send button
  sendButton = [UIButton new];
  sendButton.backgroundColor = [UIColor blue];
  sendButton.clipsToBounds = YES;
  sendButton.hidden = YES;
  sendButton.frame = CGRectMake(bodyView.frame.origin.x,
    self.frame.size.height - (OMBStandardButtonHeight + padding),
      bodyView.frame.size.width, OMBStandardButtonHeight);
  sendButton.layer.cornerRadius = OMBCornerRadius;
  sendButton.titleLabel.font = [UIFont mediumTextFontBold];
  [sendButton addTarget: self action: @selector(send)
    forControlEvents: UIControlEventTouchUpInside];
  [sendButton setBackgroundImage:
    [UIImage imageWithColor: [UIColor blueHighlighted]]
      forState: UIControlStateHighlighted];
  [sendButton setTitle: @"Send Feedback" forState: UIControlStateNormal];
  [sendButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [self addSubview: sendButton];

  // Success alert view
  successAlertView = [[OMBAlertViewBlur alloc] init];

  animator = [[UIDynamicAnimator alloc] initWithReferenceView: self];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
  textField.inputAccessoryView = textFieldToolbar;
  [self adjustViewsToOriginal: YES completion: nil];
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [contentTextView becomeFirstResponder];
  return NO;
}

#pragma mark - Protocol UITextViewDelegate

- (void) textViewDidBeginEditing: (UITextView *) textView
{
  textView.inputAccessoryView = textFieldToolbar;
  [self adjustViewsToOriginal: NO completion: nil];
}

- (void) textViewDidChange: (UITextView *) textView
{
  if ([[textView.text stripWhiteSpace] length]) {
    contentTextViewPlaceholder.hidden = YES;
    sendButton.hidden = NO;
  }
  else {
    contentTextViewPlaceholder.hidden = NO;
    sendButton.hidden = YES;
  }
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) adjustViewsToOriginal: (BOOL) original
completion: (void (^)(void)) block
{
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    CGFloat height = 0.0f;
    // Original origin y for body view
    CGFloat originalY =
      (self.frame.size.height - bodyView.frame.size.height) * 0.5f;
    // Move it back to original location
    if (original && !isInOriginalLocation) {
      height = originalY - bodyView.frame.origin.y;
      isInOriginalLocation = YES;
    }
    // Move everything up
    else if (!original && isInOriginalLocation) {
      CGFloat bottomOfBodyViewY = originalY + bodyView.frame.size.height;
      CGFloat topOfKeyboardY = self.frame.size.height -
        (textFieldToolbar.frame.size.height + OMBKeyboardHeight);
      height = topOfKeyboardY - bottomOfBodyViewY;
      isInOriginalLocation = NO;
    }
    if (height != 0.0f) {
      for (UIView *v in @[closeButtonView, headerLabel, bodyView]) {
        CGRect rect    = v.frame;
        rect.origin.y += height;
        v.frame        = rect;
      }
    }
  } completion: ^(BOOL finished) {
    if (finished) {
      if (block)
        block();
    }
  }];
}

- (void) alertConfirm
{
  [successAlertView close];
  [self close];
}

- (void) cancel
{
  [self endEditing: YES];
  [self adjustViewsToOriginal: YES completion: nil];
}

- (void) close
{
  [self cancel];
  [self adjustViewsToOriginal: YES completion: ^{
    [self closeAnimation];
  }];

  [self trackEventForAction: @"close"];
}

- (void) closeAnimation
{
  // Falling motion
  gravityBehavior = [[UIGravityBehavior alloc] initWithItems: @[bodyView]];
  gravityBehavior.gravityDirection = CGVectorMake(0, 10.0f);
  // Tilting
  itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems: @[bodyView]];
  CGFloat velocity = M_PI_2;
  if (arc4random_uniform(100) % 2)
    velocity *= -1;
  [itemBehavior addAngularVelocity: velocity forItem: bodyView];
  // Add animators
  [animator addBehavior: gravityBehavior];
  [animator addBehavior: itemBehavior];

  [UIView animateWithDuration: OMBStandardDuration * 0.5f animations: ^{
    closeButtonView.alpha = headerLabel.alpha = sendButton.alpha = 0.0f;
  }];
  [UIView animateWithDuration: OMBStandardDuration delay: OMBStandardDuration
    options: UIViewAnimationOptionCurveEaseIn animations: ^{
      self.alpha = 0.0f;
    } completion: ^(BOOL finished) {
      if (finished) {
        emailTextField.text = contentTextView.text = @"";
        contentTextViewPlaceholder.hidden = NO;
        [self removeFromSuperview];
      }
    }];
}

- (void) done
{
  [self cancel];
}

- (void) send
{
  NSString *content = [contentTextView.text stripWhiteSpace];
  if ([content length]) {
    OMBAppDelegate *appDelegate = (OMBAppDelegate *)
      [UIApplication sharedApplication].delegate;
    NSDictionary *userInfo = @{};
    if ([[OMBUser currentUser] loggedIn]) {
      userInfo = @{
        @"about": [OMBUser currentUser].about ? 
          [OMBUser currentUser].about : @"",
        @"email": [OMBUser currentUser].email ?
          [OMBUser currentUser].email : @"",
        @"first_name": [OMBUser currentUser].firstName ? 
          [OMBUser currentUser].firstName : @"",
        @"id": @([OMBUser currentUser].uid) ? 
          @([OMBUser currentUser].uid) : @0,
        @"landlord_type": [OMBUser currentUser].landlordType ?
          [OMBUser currentUser].landlordType : @"",
        @"last_name": [OMBUser currentUser].lastName ? 
          [OMBUser currentUser].lastName : @"",
        @"phone": [OMBUser currentUser].phone ? 
          [OMBUser currentUser].phone : @"",
        @"school": [OMBUser currentUser].school ? 
          [OMBUser currentUser].school : @"",
        @"user_type": [OMBUser currentUser].userType ?
          [OMBUser currentUser].userType : @""
      };
    }
    OMBFeedbackSendEmailConnection *conn =
      [[OMBFeedbackSendEmailConnection alloc] initWithEmail:
        emailTextField.text content: content userInfo: userInfo];
    conn.completionBlock = ^(NSError *error) {
      if (error) {
        [appDelegate.container showAlertViewWithError: error];
      }
      else {
        [UIView animateWithDuration: OMBStandardDuration animations: ^{
          bodyView.alpha = closeButtonView.alpha = headerLabel.alpha =
            sendButton.alpha = 0.0f;
        } completion: ^(BOOL finished) {
          [successAlertView addTargetForConfirmButton: self
            action: @selector(alertConfirm)];
          [successAlertView setMessage:
            @"Thank you very much for your feedback. "
            @"We greatly appreciate it."];
          [successAlertView setTitle: @"Feedback Sent"];
          [successAlertView showInView: [UIView new] withDetails: NO];
          [successAlertView hideCloseButton];
          [successAlertView hideQuestionButton];
          [successAlertView setConfirmButtonTitle: @"Okay"];
          [successAlertView showOnlyConfirmButton];
        }];

      }
      [appDelegate.container stopSpinningFullScreen];
    };
    [conn start];
    [appDelegate.container startSpinningFullScreen];
  }

  [self trackEventForAction: @"send"];
}

- (void) showInView: (UIView *) inView
{
  [backgroundBlurView refreshWithView: inView];
  // Remove animators
  [animator removeBehavior: gravityBehavior];
  [animator removeBehavior: itemBehavior];
  // Reset everything
  self.alpha             = 0.0f;
  bodyView.alpha         = 1.0f;
  bodyView.transform     = CGAffineTransformIdentity;
  closeButtonView.alpha  = 0.0f;
  headerLabel.alpha      = 0.0f;
  isInOriginalLocation   = YES;
  sendButton.alpha       = 1.0f;
  sendButton.hidden      = YES;
  if ([[OMBUser currentUser] loggedIn])
    emailTextField.text = [OMBUser currentUser].email;
  else
    emailTextField.text = @"";
  [[[UIApplication sharedApplication] keyWindow] addSubview: self];

  // Place the body view below the screen
  CGFloat bodyViewHeight = bodyView.frame.size.height;
  CGFloat frameHeight    = self.frame.size.height;
  bodyView.frame = CGRectMake(
    (self.frame.size.width - bodyView.frame.size.width) * 0.5f,
      frameHeight, bodyView.frame.size.width, bodyViewHeight);
  // Animate bounce
  CGFloat bounceDistance = frameHeight * 0.05f;
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    self.alpha            = 1.0f;
    closeButtonView.alpha = 1.0f;
    headerLabel.alpha     = 1.0f;
    CGRect rect    = bodyView.frame;
    rect.origin.y  = (frameHeight - (bodyViewHeight + bounceDistance)) * 0.5f;
    bodyView.frame = rect;
  } completion: ^(BOOL finished) {
    if (finished) {
      [UIView animateWithDuration: 0.15f animations: ^{
        // Bounce down
        CGRect rect   = bodyView.frame;
        rect.origin.y = (frameHeight - (bodyViewHeight -
          (bounceDistance * 0.5))) * 0.5f;
        bodyView.frame = rect;
      } completion: ^(BOOL finished) {
        if (finished) {
          [UIView animateWithDuration: 0.05f animations: ^{
            // Animate to center
            CGRect rect     = bodyView.frame;
            rect.origin.y   = (frameHeight - bodyViewHeight) * 0.5f;
            bodyView.frame = rect;
          }];
        }
      }];
    }
  }];

  [self trackEventForAction: @"show"];
}

- (void) trackEventForAction: (NSString *) action
{
  NSString *label;
  if ([[OMBUser currentUser] loggedIn]){
    label = @"signed_in";
  }
  else {
    label = @"signed_out";
  }
  [[Mixpanel sharedInstance] track: @"Feedback" properties: @{
    @"action": action,
    @"status": label
  }];

  // id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  // [tracker send: [[GAIDictionaryBuilder createEventWithCategory: @"Feedback"
  //   action: action label: label value: @1] build]];
}

@end
