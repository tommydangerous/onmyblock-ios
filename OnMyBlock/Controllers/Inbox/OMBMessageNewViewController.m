//
//  OMBMessageNewViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMessageNewViewController.h"

#import "AMBlurView.h"
#import "NSString+Extensions.h"
#import "OMBActivityView.h"
#import "OMBMessage.h"
#import "OMBMessageCollectionViewCell.h"
#import "OMBMessageCreateConnection.h"
#import "OMBMessageInputToolbar.h"
#import "OMBResidence.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"

@interface OMBMessageNewViewController ()
{
	NSString *host;
}
@end

@implementation OMBMessageNewViewController

#pragma mark - Initializer

- (id) init
{
  return [self initWithUser: nil];
}

- (id) initWithUser: (OMBUser *) object
{
  return [self initWithUser: object residence: nil];
}

- (id) initWithUser: (OMBUser *) object residence: (OMBResidence *) res
{
  if (!(self = [super init])) return nil;

  residence = res;
  user      = object;
  
  host = (user.firstName.length && [user.firstName caseInsensitiveCompare:
    @"Land"] != NSOrderedSame) ?
  [NSString stringWithFormat:@" %@",[user.firstName capitalizedString]] :
  @"";
  
  self.screenName = self.title = 
    [NSString stringWithFormat: @"Contact%@", host];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view = [[UIView alloc] initWithFrame: screen];
  
  CGFloat padding = [OMBMessageCollectionViewCell paddingForCell];
  CGFloat toolbarHeight = 44.0f;

	self.navigationItem.leftBarButtonItem =
	[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain
									target: self action:@selector(cancel)];
	
	// if ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] ||
	// 	[[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"])
	// {	
	// }

  callBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Call" 
    style: UIBarButtonItemStylePlain target: self action: @selector(call)];
  self.navigationItem.rightBarButtonItem = callBarButtonItem;
	
  // To view
  AMBlurView *toView = [AMBlurView new];
  toView.frame = CGRectMake(0.0f, 20.0f + toolbarHeight, 
    screen.size.width, toolbarHeight);
  [self.view addSubview: toView];
  CALayer *bottomBorder = [CALayer layer];
  bottomBorder.backgroundColor = [UIColor grayLight].CGColor;
  bottomBorder.frame = CGRectMake(0.0f, toView.frame.size.height - 1.0f,
    toView.frame.size.width, 1.0f);
  [toView.layer addSublayer: bottomBorder];

  // To label
  UILabel *toLabel = [UILabel new];
  toLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  toLabel.text = @"To:";
  toLabel.textColor = [UIColor grayMedium];
  CGRect toLabelRect = [toLabel.text boundingRectWithSize: 
    CGSizeMake(screen.size.width, toolbarHeight) font: toLabel.font];
  toLabel.frame = CGRectMake(padding, 0.0f, toLabelRect.size.width,
    toolbarHeight);
  [toView addSubview: toLabel];

  // To text field
  toTextField = [UITextField new];
  toTextField.delegate = self;
  toTextField.font = toLabel.font;
  CGFloat toTextFieldOriginX = toLabel.frame.origin.x + 
    toLabel.frame.size.width + padding;
  toTextField.frame = CGRectMake(toTextFieldOriginX, toLabel.frame.origin.y, 
    toView.frame.size.width - (toTextFieldOriginX + padding), 
      toLabel.frame.size.height);
  toTextField.textColor = [UIColor blueDark];
  [toView addSubview: toTextField];

  // Bottom toolbar
  bottomToolbar = [[OMBMessageInputToolbar alloc] init];
  bottomToolbar.frame = CGRectMake(0.0f, 
    screen.size.height - (toolbarHeight + 216.0f), 
      screen.size.width, toolbarHeight);
  bottomToolbar.messageContentTextView.delegate = self;
  [self.view addSubview: bottomToolbar];

//  bottomToolbar.cameraBarButtonItem.action = @selector(addImage);
//  bottomToolbar.cameraBarButtonItem.target = self;
  bottomToolbar.sendBarButtonItem.action   = @selector(send);
  bottomToolbar.sendBarButtonItem.target   = self;

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(moveBottomToolbarUp:)
      name: UIKeyboardWillShowNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(moveBottomToolbarDown:)
      name: UIKeyboardWillHideNotification object: nil];

  // Activty spinner
  activityView = [[OMBActivityView alloc] init];
  [self.view addSubview: activityView];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  if (user) {
    toTextField.text = [user fullName];
    toTextField.userInteractionEnabled = NO;
	bottomToolbar.messageContentTextView.text = [NSString stringWithFormat:@"Hi%@, I’m very interested in your place.  When would be a good time for me to visit to check it out?  Thank you!", host];
	[self textViewDidChange:bottomToolbar.messageContentTextView];
    [bottomToolbar.messageContentTextView becomeFirstResponder];
  }
  else
    [toTextField becomeFirstResponder];

  if (user && user.phone && [user.phone length]) {
    callBarButtonItem.enabled = YES;
  }
  else {
    callBarButtonItem.enabled = NO;
  }
}

#pragma mark - Protocol

#pragma mark - Protocol UITextViewDelegate

- (void) textViewDidChange: (UITextView *) textView
{
  UIFont *sendFont = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  if ([[textView.text stripWhiteSpace] length]) {
    [bottomToolbar.sendBarButtonItem setTitleTextAttributes: @{
      NSFontAttributeName: sendFont,
      NSForegroundColorAttributeName: [UIColor blueDark]
    } forState: UIControlStateNormal];
  }
  else {
    [bottomToolbar.sendBarButtonItem setTitleTextAttributes: @{
      NSFontAttributeName: sendFont,
      NSForegroundColorAttributeName: [UIColor grayMedium]
    } forState: UIControlStateNormal];
  }
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat lineHeight = 20.0f;
  CGFloat padding = 
    bottomToolbar.messageContentTextView.textContainerInset.left;
  CGRect rect = [textView.text boundingRectWithSize: 
    CGSizeMake(bottomToolbar.messageContentTextView.frame.size.width - 
      (padding * 2), 200.0f) font: bottomToolbar.messageContentTextView.font];
  CGRect textViewRect = bottomToolbar.messageContentTextView.frame;
  if (rect.size.height > lineHeight) {
    textViewRect.size.height = padding + rect.size.height + padding;
  }
  else {
    textViewRect.size.height = padding + lineHeight + padding;
  }
  bottomToolbar.messageContentTextView.frame = textViewRect;

  CGRect toolbarRect = bottomToolbar.frame;
  toolbarRect.size.height = 
    bottomToolbar.messageContentTextView.frame.size.height + (44.0f - 32.0f);
  toolbarRect.origin.y = screen.size.height - 
    (toolbarRect.size.height + 216.0f);
  bottomToolbar.frame = toolbarRect;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addImage
{
  NSLog(@"ADD IMAGE");
}

- (void) call
{
	NSString *phone = [@"telprompt://" stringByAppendingString:user.phone];
	NSURL *url = [NSURL URLWithString:phone];
	[[UIApplication sharedApplication] openURL:url];
}

- (void) cancel
{
  [self.navigationController dismissViewControllerAnimated: YES
    completion: nil];
}

- (void) moveBottomToolbarDown: (NSNotification *) notification
{
  NSTimeInterval duration = [[notification.userInfo objectForKey: 
    UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [UIView animateWithDuration: duration delay: 0.0f 
    options: UIViewAnimationOptionCurveEaseOut animations: 
    ^{
      CGRect screen = [[UIScreen mainScreen] bounds];
      CGRect rect = bottomToolbar.frame;
      rect.origin.y = screen.size.height - bottomToolbar.frame.size.height;
      bottomToolbar.frame = rect;
    } 
    completion: nil
  ];
}

- (void) moveBottomToolbarUp: (NSNotification *) notification
{
  NSTimeInterval duration = [[notification.userInfo objectForKey: 
    UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [UIView animateWithDuration: duration delay: 0.0f 
    options: UIViewAnimationOptionCurveEaseOut animations: 
    ^{
      CGRect screen = [[UIScreen mainScreen] bounds];
      CGRect rect = bottomToolbar.frame;
      rect.origin.y = screen.size.height - 
        (bottomToolbar.frame.size.height + 216.0f);
      bottomToolbar.frame = rect;
    } 
    completion: nil
  ];
}

- (void) send
{
  // Use an activity view within the view controller if
  // view controller presented modally
  // [[self appDelegate].container startSpinning];

  OMBMessage *message = [[OMBMessage alloc] init];
  message.content   = bottomToolbar.messageContentTextView.text;
  message.createdAt = [[NSDate date] timeIntervalSince1970];
  message.recipient = user;
  message.sender    = [OMBUser currentUser];
  message.uid       = 9999 + arc4random_uniform(100);
  message.updatedAt = [[NSDate date] timeIntervalSince1970];

  if (residence && residence.uid)
    message.residenceUID = residence.uid;
  
  [message calculateSizeForMessageCell];
  
  CGRect rect = CGRectMake(0.0f, 20.f + 44.0f * 2 + 20.0f, message.sizeForMessageCell.width, message.sizeForMessageCell.height);
  OMBMessageCollectionViewCell *cell =
    [[OMBMessageCollectionViewCell alloc] initWithFrame:rect];
  [cell loadMessageData: message];
  [cell setupForLastMessageFromSameUser];
  [self.view insertSubview:cell belowSubview:activityView];
  bottomToolbar.hidden = YES;
  
  OMBMessageCreateConnection *conn =
    [[OMBMessageCreateConnection alloc] initWithMessage: message];
  conn.completionBlock = ^(NSError *error) {
    // [[self appDelegate].container stopSpinning];
    if (error) {
      [cell removeFromSuperview];
      bottomToolbar.hidden = NO;
      [self showAlertViewWithError: error];
    }
    else {
      [[OMBUser currentUser] addMessage: message];
      [self cancel];
    }
    [activityView stopSpinning];
  };
  [activityView startSpinning];
  [conn start];
}

@end
