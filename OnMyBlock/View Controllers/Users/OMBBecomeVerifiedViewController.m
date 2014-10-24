//
//  OMBBecomeVerifiedViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/29/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBBecomeVerifiedViewController.h"

#import "AMBlurView.h"
#import "LIALinkedInApplication.h"
#import "LIALinkedInHttpClient.h"
#import "OMBFacebookButton.h"
#import "OMBLinkedInButton.h"
#import "OMBRenterApplication.h"
#import "OMBUser.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"
#import "UIImage+NegativeImage.h"

@implementation OMBBecomeVerifiedViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super init])) return nil;

  headerLabelArray = @[
    @"Number of co-applicants?",
    @"Do you have a co-signer?",
    @"Work & School Summary"
  ];
  user = object;
  valueDictionary = [NSMutableDictionary dictionaryWithDictionary: @{
    @"coapplicantCount": [NSNumber numberWithInt: 
      user.renterApplication.coapplicantCount],
    @"hasCosigner": [NSNumber numberWithBool: 
      user.renterApplication.hasCosigner]
  }];

  self.screenName = @"Become Verified View Controller";
  self.title      = @"Become Verified";

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(facebookAuthenticationFinished:)
      name: OMBUserCreateAuthenticationForFacebookNotification object: nil];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.navigationItem.leftBarButtonItem = cancelBarButtonItem;

  CGRect screen        = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat padding      = OMBPadding;
  CGFloat standardHeight = OMBStandardHeight;
  CGFloat originY = padding + standardHeight;

  self.view = [[UIView alloc] initWithFrame: screen];

  // Progress
  UIView *progressBarBackground = [UIView new];
  progressBarBackground.backgroundColor = [UIColor grayVeryLight];
  progressBarBackground.frame = CGRectMake(0.0f, originY, screenWidth, padding);
  [self.view addSubview: progressBarBackground];

  progressBar = [UIView new];
  progressBar.backgroundColor = [UIColor blue];
  progressBar.frame = CGRectMake(0.0f, 0.0f, 0.0f, 
    progressBarBackground.frame.size.height);
  [progressBarBackground addSubview: progressBar];

  // Next
  nextView = [[AMBlurView alloc] init];
  nextView.blurTintColor = [UIColor blue];
  nextView.frame = CGRectMake(0.0f, screenHeight - OMBStandardButtonHeight,
    screenWidth, OMBStandardButtonHeight);
  [self.view addSubview: nextView];
  // Button
  nextButton = [UIButton new];
  nextButton.frame = CGRectMake(0.0f, 0.0f, nextView.frame.size.width,
    nextView.frame.size.height);
  nextButton.titleLabel.font = [UIFont mediumTextFontBold];
  [nextButton addTarget: self action: @selector(next)
    forControlEvents: UIControlEventTouchUpInside];
  [nextButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blueHighlighted]] 
      forState: UIControlStateHighlighted];
  [nextButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateNormal];
  [nextView addSubview: nextButton];

  scroll = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 
    screenWidth, screenHeight)];
  scroll.backgroundColor = [UIColor grayUltraLight];
  scroll.contentSize = CGSizeMake(scroll.frame.size.width * 3, 
    screenHeight - originY);
  scroll.scrollEnabled = NO;
  scroll.showsHorizontalScrollIndicator = NO;
  [self.view insertSubview: scroll belowSubview: progressBarBackground];

  CGFloat centerY = scroll.contentSize.height * 0.5f;

  // Co-applicants
  coapplicantsView = [[UIView alloc] init];
  coapplicantsView.frame = CGRectMake(0.0f, 0.0f, scroll.frame.size.width,
    scroll.frame.size.height);
  [scroll addSubview: coapplicantsView];
  CGFloat buttonWidth = OMBStandardButtonHeight;
  // Middle button
  valueLabel = [UILabel new];
  valueLabel.backgroundColor = [UIColor whiteColor];
  valueLabel.font = [UIFont mediumTextFontBold];
  valueLabel.frame = CGRectMake(padding + buttonWidth, 
    centerY - (buttonWidth * 0.5f),
      coapplicantsView.frame.size.width - ((padding * 2) + (buttonWidth * 2)), 
        buttonWidth);
  valueLabel.textAlignment = NSTextAlignmentCenter;
  valueLabel.textColor = [UIColor blueDark];
  [coapplicantsView addSubview: valueLabel];

  UIButton *minusButton = [UIButton new];
  minusButton.backgroundColor = valueLabel.backgroundColor;
  minusButton.frame = CGRectMake(padding, valueLabel.frame.origin.y,
    buttonWidth, buttonWidth);
  minusButton.layer.borderColor = [UIColor grayLight].CGColor;
  minusButton.layer.borderWidth = 1.0f;
  minusButton.titleLabel.font = [UIFont mediumTextFont];
  [minusButton addTarget: self action: @selector(minusButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [minusButton setTitle: @"-" forState: UIControlStateNormal];
  [minusButton setTitleColor: valueLabel.textColor 
    forState: UIControlStateNormal];
  [coapplicantsView addSubview: minusButton];

  UIButton *plusButton = [UIButton new];
  plusButton.backgroundColor = minusButton.backgroundColor;
  plusButton.frame = CGRectMake(coapplicantsView.frame.size.width - 
    (buttonWidth + padding), minusButton.frame.origin.y, 
      minusButton.frame.size.width, minusButton.frame.size.height);
  plusButton.layer.borderColor = minusButton.layer.borderColor;
  plusButton.layer.borderWidth = minusButton.layer.borderWidth;
  plusButton.titleLabel.font = minusButton.titleLabel.font;
  [plusButton addTarget: self action: @selector(plusButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [plusButton setTitle: @"+" forState: UIControlStateNormal];
  [plusButton setTitleColor: valueLabel.textColor 
    forState: UIControlStateNormal];
  [coapplicantsView addSubview: plusButton];

  // Top and bottom borders
  CALayer *topBorder = [CALayer layer];
  topBorder.backgroundColor = minusButton.layer.borderColor;
  topBorder.frame = CGRectMake(0.0f, 0.0f, valueLabel.frame.size.width, 1.0f);
  [valueLabel.layer addSublayer: topBorder];
  CALayer *bottomBorder = [CALayer layer];
  bottomBorder.backgroundColor = topBorder.backgroundColor;
  bottomBorder.frame = CGRectMake(topBorder.frame.origin.x,
    valueLabel.frame.size.height - topBorder.frame.size.height,
      topBorder.frame.size.width, topBorder.frame.size.height);
  [valueLabel.layer addSublayer: bottomBorder];

  // Co-signers
  cosignersView = [UIView new];
  cosignersView.frame = CGRectMake(scroll.frame.size.width * 1,
    coapplicantsView.frame.origin.y, coapplicantsView.frame.size.width,
      coapplicantsView.frame.size.height);
  [scroll addSubview: cosignersView];

  // Header label
  CGFloat centerHeaderY = (valueLabel.frame.origin.y - 
    (progressBarBackground.frame.origin.y + 
      progressBarBackground.frame.size.height)) - (OMBStandardHeight * 0.5f);
  headerLabel = [UILabel new];
  headerLabel.font = [UIFont mediumTextFont];
  headerLabel.frame = CGRectMake(padding, originY + centerHeaderY, 
    screenWidth - (padding * 2), OMBStandardHeight);
  headerLabel.textColor = [UIColor textColor];
  headerLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview: headerLabel];

  // No button
  CGFloat noButtonSize = OMBStandardHeight * 2;
  noButton = [UIButton new];
  noButton.frame = CGRectMake((cosignersView.frame.size.width - 
    (noButtonSize * 2)) / 3.0f, centerY - (noButtonSize * 0.5f), 
      noButtonSize, noButtonSize);
  noButton.layer.borderWidth = 1.0f;
  noButton.layer.cornerRadius = noButton.frame.size.width * 0.5f;
  noButton.titleLabel.font = [UIFont mediumTextFont];
  [noButton addTarget: self action: @selector(noButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [noButton setTitle: @"No" forState: UIControlStateNormal];
  [cosignersView addSubview: noButton];
  // Yes button
  yesButton = [UIButton new];
  yesButton.frame = CGRectMake(noButton.frame.origin.x + 
    noButton.frame.size.width + noButton.frame.origin.x, 
      noButton.frame.origin.y, noButton.frame.size.width, 
        noButton.frame.size.height);
  yesButton.layer.borderWidth = noButton.layer.borderWidth;
  yesButton.layer.cornerRadius = noButton.layer.cornerRadius;
  yesButton.titleLabel.font = noButton.titleLabel.font;
  [yesButton addTarget: self action: @selector(yesButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [yesButton setTitle: @"Yes" forState: UIControlStateNormal];
  
  [cosignersView addSubview: yesButton];

  // Authentication
  authenticationView = [UIView new];
  authenticationView.frame = CGRectMake(scroll.frame.size.width * 2,
    coapplicantsView.frame.origin.y, coapplicantsView.frame.size.width,
      coapplicantsView.frame.size.height);
  [scroll addSubview: authenticationView];

  // Facebook button
  CGSize authButtonSize = CGSizeMake(authenticationView.frame.size.width - 
    (padding * 2), OMBStandardButtonHeight);
  facebookButton = [[OMBFacebookButton alloc] initWithFrame: CGRectMake(padding,
    centerY - (authButtonSize.height * 0.5f), authButtonSize.width,
      authButtonSize.height)];
  facebookButton.layer.cornerRadius = 5.0f;
  facebookButton.titleLabel.font = [UIFont mediumTextFont];
  [facebookButton addTarget: self action: @selector(facebookButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [facebookButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [authenticationView addSubview: facebookButton];

  // LinkedIn button
  linkedInButton = [[OMBLinkedInButton alloc] initWithFrame: CGRectMake(
    facebookButton.frame.origin.x, facebookButton.frame.origin.y + 
      facebookButton.frame.size.height + padding, 
        facebookButton.frame.size.width, facebookButton.frame.size.height)];
  linkedInButton.layer.cornerRadius = facebookButton.layer.cornerRadius;
  linkedInButton.titleLabel.font = facebookButton.titleLabel.font;
  [linkedInButton addTarget: self action: @selector(linkedInButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [linkedInButton setTitleColor: [UIColor textColor]
    forState: UIControlStateNormal];
  [authenticationView addSubview: linkedInButton];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // Header label
  headerLabel.text = [headerLabelArray firstObject];

  // Next button
  [nextButton setTitle: @"Next" forState: UIControlStateNormal];

  // Co-applicants
  valueLabel.text = [NSString stringWithFormat: @"%i",
    [[valueDictionary objectForKey: @"coapplicantCount"] intValue]];

  // Co-signers
  [self resetCosignerButtons];
  if ([[valueDictionary objectForKey: @"hasCosigner"] intValue]) {
    [self yesButtonSelected];
  }
  else {
    [self noButtonSelected];
  }

  // Authentications
  [self updateFacebookButton];
  [self updateLinkedInButton];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) back
{
  stepNumber -= 1;
  [self updateBasedOnStepNumber];
}

- (void) cancel
{
  [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) facebookAuthenticationFinished: (NSNotification *) notification
{
  NSError *error = [notification.userInfo objectForKey: @"error"];
  if (!error) {
    user.renterApplication.facebookAuthenticated = YES;
    [user downloadImageFromImageURLWithCompletion: nil];
    [self updateFacebookButton];
  }
  else {
    [self showAlertViewWithError: error];
  }
  [[self appDelegate].container stopSpinning];
}

- (void) facebookButtonSelected
{
  [[self appDelegate].container startSpinning];
  [[self appDelegate] openSession];
}

- (void) linkedInButtonSelected
{
  LIALinkedInApplication *app = 
    [LIALinkedInApplication applicationWithRedirectURL: @"https://onmyblock.com"
      clientId: @"75zr1yumwx0wld" clientSecret: @"XNY3VsMzvdhyR1ej"
        state: @"DCEEFWF45453sdffef424" grantedAccess: @[@"r_fullprofile"]];
  linkedInClient = [LIALinkedInHttpClient clientForApplication: app 
    presentingViewController: self];
  [linkedInClient getAuthorizationCode: ^(NSString *code) {
    [linkedInClient getAccessToken: code success: 
      ^(NSDictionary *accessTokenData) {
        NSString *accessToken = [accessTokenData objectForKey: @"access_token"];
        [user createAuthenticationForLinkedInWithAccessToken:
          accessToken completion: ^(NSError *error) {
            if (!error) {
              user.renterApplication.linkedinAuthenticated = YES;
              [self updateLinkedInButton];
            }
            else {
              [self showAlertViewWithError: error];
            }
            [[self appDelegate].container stopSpinning];
          }
        ];
        [[self appDelegate].container startSpinning];
      }
    failure: ^(NSError *error) {
      [self showAlertViewWithError: error];
    }];
  } cancel: ^{
    NSLog(@"LINKEDIN CANCELED");
  } failure: ^(NSError *error) {
    [self showAlertViewWithError: error];
  }];
}

- (void) minusButtonSelected
{
  NSInteger value = [valueLabel.text intValue];
  value -= 1;
  if (value < 0)
    value = 0;
  [self setCoapplicantsValue: value];
}

- (void) next
{
  stepNumber += 1;
  [self updateBasedOnStepNumber];
}

- (void) noButtonSelected
{
  [self resetYesButton];

  noButton.backgroundColor = [UIColor blue];
  [noButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateNormal];

  [valueDictionary setObject: [NSNumber numberWithBool: NO]
    forKey: @"hasCosigner"];
}

- (void) plusButtonSelected
{
  NSInteger value = [valueLabel.text intValue];
  value += 1;
  [self setCoapplicantsValue: value];
}

- (void) resetCosignerButtons
{
  [self resetNoButton];
  [self resetYesButton];
}

- (void) resetNoButton
{
  // No
  noButton.backgroundColor   = [UIColor whiteColor];
  noButton.layer.borderColor = [UIColor blue].CGColor;
  [noButton setTitleColor: [UIColor blue] forState: UIControlStateNormal]; 
}

- (void) resetYesButton
{
  // Yes
  yesButton.backgroundColor   = noButton.backgroundColor;
  yesButton.layer.borderColor = [UIColor blue].CGColor;
  [yesButton setTitleColor: [UIColor blue] forState: UIControlStateNormal];
}

- (void) setCoapplicantsValue: (NSInteger) value
{
  valueLabel.text = [NSString stringWithFormat: @"%i", value];
  [valueDictionary setObject: [NSNumber numberWithInt: value] 
    forKey: @"coapplicantCount"];
}

- (void) updateBasedOnStepNumber
{
  // Step 0: Co-applicants
  // Step 1: Co-signers
  // Step 2: LinkedIn, Facebook
  if (stepNumber < OMBBecomeVerifiedStepCoapplicants)
    stepNumber = OMBBecomeVerifiedStepCoapplicants;

  // Progress
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGRect progressBarRect = progressBar.frame;
  progressBarRect.size.width = screen.size.width * (stepNumber / 3.0f);
  [UIView animateWithDuration: 0.25f animations: ^{
    // Progress
    progressBar.frame = progressBarRect;
    // Header label
    if (stepNumber <= OMBBecomeVerifiedStepAuthentication)
      headerLabel.text = [headerLabelArray objectAtIndex: stepNumber];
  }];

  // Buttons
  if (stepNumber > OMBBecomeVerifiedStepCoapplicants) {
    [self.navigationItem setLeftBarButtonItem: backBarButtonItem animated: YES];
    // Anything but LinkedIn, Facebook
    if (stepNumber < OMBBecomeVerifiedStepAuthentication) {
      [nextButton setTitle: @"Next" forState: UIControlStateNormal];
    }
    // LinkedIn, Facebook
    else {
      [nextButton setTitle: @"Finish" forState: UIControlStateNormal];
    }
  }
  else
    [self.navigationItem setLeftBarButtonItem: cancelBarButtonItem 
      animated: YES];

  // Save
  if (stepNumber > OMBBecomeVerifiedStepAuthentication) {
    [user.renterApplication updateWithDictionary: valueDictionary
      completion: ^(NSError *error) {
        if (!error) {
          [self cancel];
        }
        else {
          [self showAlertViewWithError: error];
        }
        [[self appDelegate].container stopSpinning];
      }
    ];
    [[self appDelegate].container startSpinning];
  }
  else {
    [scroll setContentOffset: 
      CGPointMake(scroll.frame.size.width * stepNumber, scroll.contentOffset.y)
        animated: YES];
  }
}

- (void) updateFacebookButton
{
  // Facebook
  if (user.renterApplication.facebookAuthenticated) {
    [facebookButton setTitle: @"Facebook Verified"
      forState: UIControlStateNormal];
  }
  else {
    [facebookButton setTitle: @"Verify using Facebook"
      forState: UIControlStateNormal];
  }
}

- (void) updateLinkedInButton
{
  // LinkedIn
  if (user.renterApplication.linkedinAuthenticated) {
    [linkedInButton setTitle: @"LinkedIn Verified"
      forState: UIControlStateNormal];
  }
  else {
    [linkedInButton setTitle: @"Verify using LinkedIn"
      forState: UIControlStateNormal];
  }
}

- (void) yesButtonSelected
{
  [self resetNoButton];

  yesButton.backgroundColor = [UIColor blue];
  [yesButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateNormal];

  [valueDictionary setObject: [NSNumber numberWithBool: YES]
    forKey: @"hasCosigner"];
}

@end
