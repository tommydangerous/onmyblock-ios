//
//  OMBMapFilterViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/22/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "OMBMapFilterViewController.h"

#import "OMBListButton.h"
#import "OMBMapViewController.h"
#import "OMBNeighborhood.h"
#import "OMBNeighborhoodStore.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"

const int kPadding = 20;

@implementation OMBMapFilterViewController

@synthesize beds              = _beds;
@synthesize mapViewController = _mapViewController;
@synthesize neighborhood      = _neighborhood;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    self.edgesForExtendedLayout = 
      (UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight);
    self.title = @"Filter";
  }
  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view     = [[UIView alloc] initWithFrame: screen];
  UIFont *labelFont = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  UIFont *textFieldFont = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 15];

  // Navigation item
  // Left bar button item
  self.navigationItem.leftBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Cancel" 
      style: UIBarButtonItemStylePlain target: self action: @selector(cancel)];
  // Right bar button item
  self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Apply" 
      style: UIBarButtonItemStylePlain target: self action: @selector(apply)];
  // Hide views when tapping on the view 
  UITapGestureRecognizer *tapView =
    [[UITapGestureRecognizer alloc] initWithTarget: self
      action: @selector(hideDropdownLists)];
  [self.view addGestureRecognizer: tapView];

  // Neighborhood search
  // View
  neighborhoodView = [[UIView alloc] init];
  neighborhoodView.backgroundColor = [UIColor clearColor];
  neighborhoodView.frame = CGRectMake(kPadding, (kPadding * 0.5),
    (screen.size.width - (kPadding * 2)), (40 + 24 + kPadding));
  [self.view addSubview: neighborhoodView];
  // Label
  UILabel *neighborhoodLabel = [[UILabel alloc] init];
  neighborhoodLabel.backgroundColor = [UIColor clearColor];
  neighborhoodLabel.font = labelFont;
  neighborhoodLabel.frame = CGRectMake(0, 0, 
    neighborhoodView.frame.size.width, 40);
  neighborhoodLabel.text = @"Neighborhood";
  neighborhoodLabel.textColor = [UIColor textColor];
  [neighborhoodView addSubview: neighborhoodLabel];
  // Text field
  neighborhoodTextField = [[TextFieldPadding alloc] init];
  neighborhoodTextField.backgroundColor = [UIColor whiteColor];
  neighborhoodTextField.delegate = self;
  neighborhoodTextField.frame = CGRectMake(0, 
    (neighborhoodLabel.frame.origin.y + neighborhoodLabel.frame.size.height),
      (screen.size.width - (kPadding * 2)), (24 + kPadding));
  neighborhoodTextField.font     = textFieldFont;
  neighborhoodTextField.layer.borderColor = [UIColor grayLight].CGColor;
  neighborhoodTextField.layer.borderWidth = 0.5;
  neighborhoodTextField.layer.cornerRadius = 2;
  neighborhoodTextField.paddingX = kPadding * 0.5;
  neighborhoodTextField.paddingY = kPadding * 0.5;
  neighborhoodTextField.placeholder = @"Select a neighborhood";
  neighborhoodTextField.textColor = [UIColor textColor];
  [neighborhoodView addSubview: neighborhoodTextField];
  UITapGestureRecognizer *neighborhoodListGestureRecognizer = 
    [[UITapGestureRecognizer alloc] initWithTarget: self 
      action: @selector(showNeighborhoodList)];
  [neighborhoodTextField addGestureRecognizer: 
    neighborhoodListGestureRecognizer];

  // Beds
  // View
  bedsView = [[UIView alloc] init];
  bedsView.backgroundColor = [UIColor clearColor];
  bedsView.frame = CGRectMake(kPadding,
    (neighborhoodView.frame.origin.y + neighborhoodView.frame.size.height + 
      (kPadding * 0.5)),
        (screen.size.width - (kPadding * 2)), 
          neighborhoodView.frame.size.height);
  [self.view addSubview: bedsView];
  // Label
  UILabel *bedsLabel = [[UILabel alloc] init];
  bedsLabel.backgroundColor = [UIColor clearColor];
  bedsLabel.font = labelFont;
  bedsLabel.frame = CGRectMake(0, 0, 
    bedsView.frame.size.width, 40);
  bedsLabel.text = @"Beds";
  bedsLabel.textColor = [UIColor textColor];
  [bedsView addSubview: bedsLabel];
  // Buttons
  UIView *bedButtons = [[UIView alloc] init];
  bedButtons.backgroundColor = [UIColor whiteColor];
  bedButtons.frame = CGRectMake(0, 
    (bedsLabel.frame.origin.y + bedsLabel.frame.size.height),
      bedsView.frame.size.width, neighborhoodTextField.frame.size.height);
  // bedButtons.layer.borderColor = [UIColor grayLight].CGColor;
  // bedButtons.layer.borderWidth = 0.5;
  // bedButtons.layer.cornerRadius = 2;
  [bedsView addSubview: bedButtons];

  NSArray *bedValues = @[@"Studio", @"1", @"2", @"3", @"4+"];
  _beds = [NSMutableDictionary dictionaryWithObjects: @[@"", @"", @"", @"", @""]
    forKeys: bedValues];
  for (NSString *string in bedValues) {
    int index = [bedValues indexOfObject: string];
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(
      (index * (bedsView.frame.size.width / [bedValues count])), 0,
        (bedButtons.frame.size.width / [bedValues count]), 
            bedButtons.frame.size.height);
    button.titleLabel.font = textFieldFont;
    [button addTarget: self action: @selector(toggleBedButton:)
      forControlEvents: UIControlEventTouchUpInside];
    [button setTitle: string forState: UIControlStateNormal];
    [button setTitleColor: [UIColor textColor] forState: UIControlStateNormal];
    [bedButtons addSubview: button];
  }

  // Neighborhood list view
  float maxNeighborhoodListHeight = 
    (screen.size.height - (20 + 44 + 
      neighborhoodView.frame.origin.y + 
        neighborhoodTextField.frame.origin.y + kPadding));
  neighborhoodListView = [[UIScrollView alloc] init];
  neighborhoodListView.alpha = 0;
  neighborhoodListView.backgroundColor = [UIColor grayDarkAlpha: 0.9];
  neighborhoodListView.frame = CGRectMake(
    neighborhoodView.frame.origin.x, 
    (neighborhoodView.frame.origin.y + neighborhoodTextField.frame.origin.y), 
      neighborhoodTextField.frame.size.width, maxNeighborhoodListHeight);
  neighborhoodListView.layer.cornerRadius = 2.0;
  [self.view addSubview: neighborhoodListView];
  NSMutableArray *neighborhoodList = [NSMutableArray array];
  // Create buttons
  for (OMBNeighborhood *neighborhood in 
    [[OMBNeighborhoodStore sharedStore] sortedNeighborhoods]) {

    OMBListButton *button = [[OMBListButton alloc] init];
    button.backgroundColor = [UIColor clearColor];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    button.contentHorizontalAlignment = 
      UIControlContentHorizontalAlignmentLeft;
    button.neighborhood = neighborhood;
    button.titleLabel.font = textFieldFont;
    [button addTarget: self action: @selector(selectedNeighborhood:)
      forControlEvents: UIControlEventTouchUpInside];
    [button setTitle: [neighborhood nameTitle] forState:
      UIControlStateNormal];
    [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [button setTitleColor: [UIColor blue] forState: UIControlStateHighlighted];
    [neighborhoodList addObject: button];
  }
  // Add buttons to neighborhood list
  for (UIButton *button in neighborhoodList) {
    int index = [neighborhoodList indexOfObject: button];
    button.frame = CGRectMake(0, (index * (24 + kPadding)), 
      neighborhoodListView.frame.size.width, 
        neighborhoodTextField.frame.size.height);
    [neighborhoodListView addSubview: button];
    if (index != 0) {
      CALayer *borderTop = [CALayer layer];
      borderTop.backgroundColor = [UIColor backgroundColor].CGColor;
      borderTop.frame = CGRectMake(0, 0, 
        neighborhoodListView.frame.size.width, 0.5);
      [button.layer addSublayer: borderTop];
    }
  }
  neighborhoodListView.contentSize = CGSizeMake(
    neighborhoodListView.frame.size.width, 
      ([neighborhoodList count] * (24 + kPadding)));
  if (neighborhoodListView.contentSize.height < maxNeighborhoodListHeight) {
    CGRect neighborhoodListViewFrame = neighborhoodListView.frame;
    neighborhoodListViewFrame.size.height = 
      neighborhoodListView.contentSize.height;
    neighborhoodListView.frame = neighborhoodListViewFrame;
  }
}

#pragma mark - Protocol

#pragma mark - Protocol UITextFieldDelegate

- (BOOL) textFieldShouldBeginEditing: (UITextField *) textField
{
  return NO;
}

- (BOOL) textFieldShouldClear: (UITextField *) textField
{
  if (textField == neighborhoodTextField)
    _neighborhood = nil;
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) apply
{
  if (_neighborhood)
    [_mapViewController setMapViewRegion: _neighborhood.coordinate
      withMiles: 4];
    [_mapViewController refreshProperties];
  [self dismissViewController];
}

- (void) cancel
{
  [self dismissViewController];
}

- (void) dismissViewController
{
  [self dismissViewControllerAnimated: YES completion: ^{
    [self hideDropdownLists];
  }];
}

- (void) hideDropdownLists
{
  [UIView animateWithDuration: 0.15 animations: ^{
    neighborhoodListView.alpha = 0.0;
  }];
}

- (void) selectedNeighborhood: (OMBListButton *) button
{
  _neighborhood = button.neighborhood;
  neighborhoodTextField.clearButtonMode = UITextFieldViewModeAlways;
  neighborhoodTextField.text = [_neighborhood nameTitle];
  [self hideDropdownLists];
}

- (void) showNeighborhoodList
{
  [UIView animateWithDuration: 0.15 animations: ^{
    neighborhoodListView.alpha = 1.0;
  }];
}

- (void) toggleBedButton: (id) sender
{
  UIButton *button = (UIButton *) sender;
  // If the key has a value
  if ([[_beds objectForKey: [button currentTitle]] length] > 0) {
    // Clear the value
    [_beds setObject: @"" forKey: [button currentTitle]];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor: [UIColor textColor] forState: UIControlStateNormal];
  }
  // If the key has no value
  else {
    // Set the value
    [_beds setObject: [button currentTitle] forKey: [button currentTitle]];
    button.backgroundColor = [UIColor grayMedium];
    [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
  }
  // Need to hide previous results with updated results
  [_mapViewController removeAllAnnotations];
}

@end
