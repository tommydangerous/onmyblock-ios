//
//  OMBFinishListingDescriptionViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/28/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingDescriptionViewController.h"

#import "AMBlurView.h"
#import "NSString+Extensions.h"
#import "OMBResidence.h"
#import "OMBResidenceUpdateConnection.h"
#import "UIColor+Extensions.h"

@implementation OMBFinishListingDescriptionViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super initWithResidence: object])) return nil;

  maxCharacters     = 50;
  placeholderString = @"A brief description of your awesome place.";

  self.screenName = self.title = @"Description";
  tagSection = OMBFinishListingSectionDescription;

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.navigationItem.rightBarButtonItem = saveBarButtonItem;

  CGRect screen = [[UIScreen mainScreen] bounds];

  CGFloat originY = 20.0f + 44.0f;
  CGFloat padding = 10.0f;

  characterCountView = [[AMBlurView alloc] init];
  characterCountView.blurTintColor = [UIColor grayUltraLight];
  characterCountView.frame = CGRectMake(0.0f, 0.0f,
    screen.size.width, 44.0f);

  characterCountLabel = [UILabel new];
  characterCountLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  characterCountLabel.frame = CGRectMake(20.0f, 0.0f,
    characterCountView.frame.size.width - (20.0f * 2), 
      characterCountView.frame.size.height);
  characterCountLabel.textAlignment = NSTextAlignmentRight;
  characterCountLabel.textColor = [UIColor grayMedium];
  [characterCountView addSubview: characterCountLabel];

  descriptionTextView = [UITextView new];
  descriptionTextView.autocorrectionType = UITextAutocorrectionTypeYes;
  descriptionTextView.delegate = self;
  descriptionTextView.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 15];
  descriptionTextView.frame = CGRectMake(padding, originY + padding, 
    screen.size.width - (padding * 2), 
      screen.size.height - (originY + padding + 
      padding + characterCountView.frame.size.height + 216.0f));
  descriptionTextView.inputAccessoryView = characterCountView;
  descriptionTextView.textColor = [UIColor textColor];
  [self.view addSubview: descriptionTextView];

  placeholderLabel = [UILabel new];
  placeholderLabel.font = descriptionTextView.font;
  placeholderLabel.frame = CGRectMake(5.0f, 8.0f, 
    descriptionTextView.frame.size.width, 20.0f);
  placeholderLabel.textColor = [UIColor grayLight];
  [descriptionTextView addSubview: placeholderLabel];
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];
  [descriptionTextView becomeFirstResponder];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  [self updateCharacterCount];

  placeholderLabel.text = placeholderString;

  [self setTextForDescriptionView];

  [self textViewDidChange: descriptionTextView];
}

#pragma mark - Protocol

#pragma mark - Protocol UITextViewDelegate

- (void) textViewDidChange: (UITextView *) textView
{
  if ([[textView.text stripWhiteSpace] length]) {
    placeholderLabel.hidden   = YES;
    saveBarButtonItem.enabled = YES;
  }
  else {
    placeholderLabel.hidden   = NO;
    saveBarButtonItem.enabled = NO;
  }
  [self updateCharacterCount];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) save
{
  if ([self wordsRemaining] < 0)
    return;
  
  residence.description = descriptionTextView.text;

  OMBResidenceUpdateConnection *conn = 
    [[OMBResidenceUpdateConnection alloc] initWithResidence: residence 
      attributes: @[@"description"]];
  [conn start];

  [self nextSection];
}

- (void) setTextForDescriptionView
{
  if ([residence.description length])
    descriptionTextView.text = residence.description;
}

- (void) updateCharacterCount
{
  NSInteger number = [self wordsRemaining];

  if ([[descriptionTextView.text stripWhiteSpace] length] == 0)
    number = maxCharacters;
  characterCountLabel.text = [NSString stringWithFormat: 
    @"%i words left", number];

  if (number < 0)
    characterCountLabel.textColor = [UIColor red];
  else
    characterCountLabel.textColor = [UIColor grayMedium];
}

- (NSInteger) wordsRemaining
{
  NSArray *words = 
    [descriptionTextView.text componentsSeparatedByCharactersInSet: 
      [NSCharacterSet whitespaceAndNewlineCharacterSet]];
  words = [words filteredArrayUsingPredicate: [NSPredicate predicateWithBlock:
    ^BOOL (id evaluatedObject, NSDictionary *bindings) {
      NSString *word = (NSString *) evaluatedObject;
      return [[word stripWhiteSpace] length] ? YES : NO;
    }]
  ];

  return maxCharacters - [words count];
}

@end
