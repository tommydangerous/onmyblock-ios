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
#import "UIImage+Color.h"

const int kPadding = 20;

@implementation OMBMapFilterViewController

@synthesize bath              = _bath;
@synthesize beds              = _beds;
@synthesize bedsArray         = _bedsArray;
@synthesize mapViewController = _mapViewController;
@synthesize maxRent           = _maxRent;
@synthesize minRent           = _minRent;
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
  [super loadView];
  
  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view     = [[UIView alloc] initWithFrame: screen];
  UIColor *borderColor = [UIColor grayMedium];
  UIFont *labelFont = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 16];
  UIFont *textFieldFont = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 16];

  // Create beds array and dictionary
  _bedsArray = @[@"Studio", @"1", @"2", @"3", @"4+"];
  _beds = [NSMutableDictionary dictionaryWithObjects: 
    @[@"", @"", @"", @"", @""] forKeys: _bedsArray];

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
  neighborhoodTextField.layer.borderColor = borderColor.CGColor;
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

  // Rent
  // View
  rentView = [[UIView alloc] init];
  rentView.backgroundColor = [UIColor clearColor];
  rentView.frame = CGRectMake(kPadding,
    (neighborhoodView.frame.origin.y + neighborhoodView.frame.size.height + 
      (kPadding * 0.5)),
        (screen.size.width - (kPadding * 2)), 
          neighborhoodView.frame.size.height);
  [self.view addSubview: rentView];
  // Label
  UILabel *rentLabel = [[UILabel alloc] init];
  rentLabel.backgroundColor = [UIColor clearColor];
  rentLabel.font = labelFont;
  rentLabel.frame = CGRectMake(0, 0, 
    rentView.frame.size.width, 40);
  rentLabel.text = @"Rent";
  rentLabel.textColor = [UIColor textColor];
  [rentView addSubview: rentLabel];
  // Min rent
  minRentTextField = [[TextFieldPadding alloc] init];
  minRentTextField.backgroundColor = [UIColor whiteColor];
  minRentTextField.delegate = self;
  minRentTextField.frame = CGRectMake(0, 
    (rentLabel.frame.origin.y + rentLabel.frame.size.height),
      ((screen.size.width - (kPadding * 2)) * 0.4), (24 + kPadding));
  minRentTextField.font     = textFieldFont;
  minRentTextField.layer.borderColor = borderColor.CGColor;
  minRentTextField.layer.borderWidth = 0.5;
  minRentTextField.layer.cornerRadius = 2;
  minRentTextField.paddingX = kPadding * 0.5;
  minRentTextField.paddingY = kPadding * 0.5;
  minRentTextField.placeholder = @"Min";
  minRentTextField.textAlignment = NSTextAlignmentCenter;
  minRentTextField.textColor = [UIColor textColor];
  [rentView addSubview: minRentTextField];
  UITapGestureRecognizer *rentGestureRecognizer = 
    [[UITapGestureRecognizer alloc] initWithTarget: self 
      action: @selector(showRentListView:)];
  [minRentTextField addGestureRecognizer: rentGestureRecognizer];

  // To view
  UILabel *toLabel = [[UILabel alloc] init];
  toLabel.backgroundColor = [UIColor clearColor];
  toLabel.font = textFieldFont;
  toLabel.frame = CGRectMake(
    ((screen.size.width - ((kPadding * 2) + 20)) / 2.0), 
      minRentTextField.frame.origin.y, 20, minRentTextField.frame.size.height);
  toLabel.text = @"to";
  toLabel.textAlignment = NSTextAlignmentCenter;
  toLabel.textColor = [UIColor textColor];
  [rentView addSubview: toLabel];

  // Max rent
  maxRentTextField = [[TextFieldPadding alloc] init];
  maxRentTextField.backgroundColor = [UIColor whiteColor];
  maxRentTextField.delegate = self;
  maxRentTextField.frame = CGRectMake(
    (screen.size.width - (minRentTextField.frame.size.width + (kPadding * 2))), 
      (rentLabel.frame.origin.y + rentLabel.frame.size.height),
        ((screen.size.width - (kPadding * 2)) * 0.4), (24 + kPadding));
  maxRentTextField.font     = textFieldFont;
  maxRentTextField.layer.borderColor = borderColor.CGColor;
  maxRentTextField.layer.borderWidth = 0.5;
  maxRentTextField.layer.cornerRadius = 2;
  maxRentTextField.paddingX = kPadding * 0.5;
  maxRentTextField.paddingY = kPadding * 0.5;
  maxRentTextField.placeholder = @"Max";
  maxRentTextField.textAlignment = NSTextAlignmentCenter;
  maxRentTextField.textColor = [UIColor textColor];
  [rentView addSubview: maxRentTextField];
  rentGestureRecognizer = 
    [[UITapGestureRecognizer alloc] initWithTarget: self 
      action: @selector(showRentListView:)];
  [maxRentTextField addGestureRecognizer: rentGestureRecognizer];

  // Beds
  // View
  bedsView = [[UIView alloc] init];
  bedsView.backgroundColor = [UIColor clearColor];
  bedsView.frame = CGRectMake(kPadding,
    (rentView.frame.origin.y + rentView.frame.size.height + (kPadding * 0.5)),
      (screen.size.width - (kPadding * 2)), 
        neighborhoodView.frame.size.height);
  [self.view addSubview: bedsView];
  // Label
  UILabel *bedsLabel = [[UILabel alloc] init];
  bedsLabel.backgroundColor = [UIColor clearColor];
  bedsLabel.font = labelFont;
  bedsLabel.frame = CGRectMake(0, 0, 
    bedsView.frame.size.width, 40);
  bedsLabel.text = @"Bedrooms";
  bedsLabel.textColor = [UIColor textColor];
  [bedsView addSubview: bedsLabel];
  // Buttons
  bedButtons = [[UIView alloc] init];
  bedButtons.backgroundColor = [UIColor whiteColor];
  bedButtons.frame = CGRectMake(0, 
    (bedsLabel.frame.origin.y + bedsLabel.frame.size.height),
      bedsView.frame.size.width, neighborhoodTextField.frame.size.height);
  [bedsView addSubview: bedButtons];
  // Create buttons
  for (NSString *string in _bedsArray) {
    int index = (int) [_bedsArray indexOfObject: string];
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(
      (index * (bedsView.frame.size.width / [_bedsArray count])), 0,
        (bedButtons.frame.size.width / [_bedsArray count]), 
            bedButtons.frame.size.height);
    button.titleLabel.font = textFieldFont;
    [button addTarget: self action: @selector(toggleBedButton:)
      forControlEvents: UIControlEventTouchUpInside];
    [button setBackgroundImage: [UIImage imageWithColor: [UIColor grayMedium]]
      forState: UIControlStateHighlighted];
    [button setTitle: string forState: UIControlStateNormal];
    [button setTitleColor: [UIColor textColor] forState: UIControlStateNormal];
    [button setTitleColor: [UIColor whiteColor] 
      forState: UIControlStateHighlighted];
    [bedButtons addSubview: button];
  }

  // Bath
  // View
  bathView = [[UIView alloc] init];
  bathView.backgroundColor = [UIColor clearColor];
  bathView.frame = CGRectMake(kPadding,
    (bedsView.frame.origin.y + bedsView.frame.size.height + 
      (kPadding * 0.5)),
        (screen.size.width - (kPadding * 2)), 
          neighborhoodView.frame.size.height);
  [self.view addSubview: bathView];
  // Label
  UILabel *bathLabel = [[UILabel alloc] init];
  bathLabel.backgroundColor = [UIColor clearColor];
  bathLabel.font = labelFont;
  bathLabel.frame = CGRectMake(0, 0, bathView.frame.size.width, 40);
  bathLabel.text = @"Bathrooms";
  bathLabel.textColor = [UIColor textColor];
  [bathView addSubview: bathLabel];
  // Buttons
  bathButtons = [[UIView alloc] init];
  bathButtons.backgroundColor = [UIColor whiteColor];
  bathButtons.frame = CGRectMake(0, 
    (bathLabel.frame.origin.y + bathLabel.frame.size.height),
      bathView.frame.size.width, neighborhoodTextField.frame.size.height);
  [bathView addSubview: bathButtons];
  // Create buttons
  NSArray *bathArray = @[@"1+", @"2+", @"3+", @"4+"];
  for (NSString *string in bathArray) {
    int index = (int) [bathArray indexOfObject: string];
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(
      (index * (bedsView.frame.size.width / [bathArray count])), 0,
        (bathButtons.frame.size.width / [bathArray count]), 
            bathButtons.frame.size.height);
    button.titleLabel.font = textFieldFont;
    [button addTarget: self action: @selector(toggleBathButton:)
      forControlEvents: UIControlEventTouchUpInside];
    [button setBackgroundImage: [UIImage imageWithColor: [UIColor grayMedium]]
      forState: UIControlStateHighlighted];
    [button setTitle: string forState: UIControlStateNormal];
    [button setTitleColor: [UIColor textColor] forState: UIControlStateNormal];
    [button setTitleColor: [UIColor whiteColor] 
      forState: UIControlStateHighlighted];
    [bathButtons addSubview: button];
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
  neighborhoodListView.showsVerticalScrollIndicator = NO;
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
    [button setBackgroundImage: [UIImage imageWithColor: 
      [UIColor backgroundColor]] forState: UIControlStateHighlighted];
    [button setTitle: [neighborhood nameTitle] forState:
      UIControlStateNormal];
    [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [button setTitleColor: [UIColor textColor] 
      forState: UIControlStateHighlighted];
    [neighborhoodList addObject: button];
  }
  // Add buttons to neighborhood list
  for (UIButton *button in neighborhoodList) {
    int index = (int) [neighborhoodList indexOfObject: button];
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

  // Rent buttons
  float rentButtonsHeight = (screen.size.height - (20 + 44 + (kPadding * 2)));
  // Min list
  minRentListView = [[UIScrollView alloc] init];
  minRentListView.alpha = 0.0;
  minRentListView.backgroundColor = neighborhoodListView.backgroundColor;
  minRentListView.frame = CGRectMake(kPadding, kPadding, 
    minRentTextField.frame.size.width, rentButtonsHeight);
  minRentListView.layer.cornerRadius = 2.0;
  minRentListView.showsVerticalScrollIndicator = NO;
  [self createButtonsForRentList: minRentListView];
  [self.view addSubview: minRentListView];
  // Max list
  maxRentListView = [[UIScrollView alloc] init];
  maxRentListView.alpha = 0.0;
  maxRentListView.backgroundColor = neighborhoodListView.backgroundColor;
  maxRentListView.frame = CGRectMake(
    (maxRentTextField.frame.origin.x + kPadding), kPadding, 
      maxRentTextField.frame.size.width, rentButtonsHeight);
  maxRentListView.layer.cornerRadius = 2.0;
  maxRentListView.showsVerticalScrollIndicator = NO;
  [self createButtonsForRentList: maxRentListView];
  [self.view addSubview: maxRentListView];
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
  [self dismissViewController];
}

- (void) cancel
{
  // Neighborhood
  _neighborhood = nil;
  neighborhoodTextField.text = @"";

  // Rent
  maxRentTextField.text = @"";
  minRentTextField.text = @"";
  _maxRent              = nil;
  _minRent              = nil;

  // Beds
  NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
  for (NSString *key in _beds) {
    [dictionary setObject: @"" forKey: key];
  }
  _beds = dictionary;

  // Bath
  _bath = nil;

  [self clearAllButtons];
  [self dismissViewController];
}

- (void) clearAllButtons
{
  // Bed
  for (UIButton *button in bedButtons.subviews) {
    if ([button isKindOfClass: [UIButton class]]) {
      button.backgroundColor = [UIColor whiteColor];
      [button setTitleColor: [UIColor textColor] forState: 
        UIControlStateNormal];
    }
  }
  // Bath
  [self clearBathButtons];
}

- (void) clearBathButtons
{
  for (UIButton *button in bathButtons.subviews) {
    if ([button isKindOfClass: [UIButton class]]) {
      button.backgroundColor = [UIColor clearColor];
      [button setTitleColor: [UIColor textColor] 
        forState: UIControlStateNormal];
    }
  }
}

- (void) createButtonsForRentList: (UIScrollView *) scroll
{
  UIScrollView *listView;
  if (scroll == maxRentListView)
    listView = maxRentListView;
  else if (scroll == minRentListView)
    listView = minRentListView;
  NSMutableArray *priceList = [NSMutableArray array];
  int price = 0;
  while (price <= 8000) {
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor clearColor];
    button.contentHorizontalAlignment = 
      UIControlContentHorizontalAlignmentCenter;
    button.titleLabel.font = minRentTextField.font;
    NSString *buttonTitle;
    if (price == 0)
      buttonTitle = @"Any";
    else
      buttonTitle = [NSString stringWithFormat: @"$%i", price];
    [button addTarget: self action: @selector(selectedRent:)
      forControlEvents: UIControlEventTouchUpInside];
    [button setBackgroundImage: [UIImage imageWithColor: 
      [UIColor backgroundColor]] forState: UIControlStateHighlighted];
    [button setTitle: buttonTitle forState: UIControlStateNormal];
    [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [button setTitleColor: [UIColor textColor] 
      forState: UIControlStateHighlighted];
    [priceList addObject: button];
    price += 500;
  }
  // Add buttons to min and max rent list view
  for (UIButton *button in priceList) {
    int index = (int) [priceList indexOfObject: button];
    button.frame = CGRectMake(0, (index * minRentTextField.frame.size.height),
      listView.frame.size.width, minRentTextField.frame.size.height);
    [listView addSubview: button];
    if (index != 0) {
      CALayer *borderTop = [CALayer layer];
      borderTop.backgroundColor = [UIColor backgroundColor].CGColor;
      borderTop.frame = CGRectMake(0, 0, 
        listView.frame.size.width, 0.5);
      [button.layer addSublayer: borderTop];
    }
  }
  // Min and max list view content size
  listView.contentSize = CGSizeMake(
    listView.frame.size.width, 
      ([priceList count] * minRentTextField.frame.size.height));
}

- (void) dismissViewController
{
  // Show the filter label with what filters were applied
  [_mapViewController updateFilterLabel];
  // Tells the map that region did change so that it fetches the properties
  [_mapViewController refreshProperties];

  [self dismissViewControllerAnimated: YES completion: ^{
    [self hideDropdownLists];
  }];
}

- (void) hideDropdownLists
{
  [UIView animateWithDuration: 0.15 animations: ^{
    maxRentListView.alpha      = 0.0;
    minRentListView.alpha      = 0.0;
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

- (void) selectedRent: (UIButton *) button
{
  NSNumber *price;
  if ([button.currentTitle isEqualToString: @"Any"])
    price = nil;
  else {
    NSRegularExpression *regex = 
      [NSRegularExpression regularExpressionWithPattern: @"([0-9]+)" 
        options: 0 error: nil];
    NSArray *matches = [regex matchesInString: button.currentTitle
      options: 0 range: NSMakeRange(0, [button.currentTitle length])];
    NSTextCheckingResult *result = [matches objectAtIndex: 0];
    price = [NSNumber numberWithInt: 
      [[button.currentTitle substringWithRange: result.range] intValue]];
  }
  if (button.superview == maxRentListView) {
    maxRentTextField.text = button.currentTitle;
    _maxRent = price;
  }
  else if (button.superview == minRentListView) {
    minRentTextField.text = button.currentTitle;
    _minRent = price;
  }
  [self hideDropdownLists];
  // Need to do this in order to remove all previous annotations and 
  // only show properties with the filters applied
  [_mapViewController removeAllAnnotations];
}

- (void) showNeighborhoodList
{
  [self hideDropdownLists];
  [UIView animateWithDuration: 0.15 animations: ^{
    neighborhoodListView.alpha = 1.0;
  }];
}

- (void) showRentListView: (UIGestureRecognizer *) gestureRecognizer
{
  [self hideDropdownLists];
  UIView *v;
  if (gestureRecognizer.view == minRentTextField)
    v = minRentListView;
  if (gestureRecognizer.view == maxRentTextField)
    v = maxRentListView;
  [UIView animateWithDuration: 0.15 animations: ^{
    v.alpha = 1.0;
  }];
}

- (void) toggleBathButton: (UIButton *) button
{
  [self clearBathButtons];
  NSRegularExpression *regex = 
    [NSRegularExpression regularExpressionWithPattern: @"([0-9]+)" 
      options: 0 error: nil];
  NSArray *matches = [regex matchesInString: button.currentTitle
    options: 0 range: NSMakeRange(0, [button.currentTitle length])];
  NSTextCheckingResult *result = [matches objectAtIndex: 0];
  NSNumber *number = [NSNumber numberWithInt: 
    [[button.currentTitle substringWithRange: result.range] intValue]];
  if (!_bath || _bath != number) {
    _bath = number;
    button.backgroundColor = [UIColor grayMedium];
    [button setTitleColor: [UIColor whiteColor] 
      forState: UIControlStateNormal];
  }
  else if (_bath == number)
    _bath = nil;
  [self hideDropdownLists];
  // Need to do this in order to remove all previous annotations and 
  // only show properties with the filters applied
  [_mapViewController removeAllAnnotations];
}

- (void) toggleBedButton: (UIButton *) button
{
  // If the key has a value
  if ([[_beds objectForKey: [button currentTitle]] length] > 0) {
    // Clear the value
    [_beds setObject: @"" forKey: [button currentTitle]];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor: [UIColor textColor] forState: UIControlStateNormal];
  }
  // If the key has no value
  else {
    // Set the value
    [_beds setObject: [button currentTitle] forKey: [button currentTitle]];
    button.backgroundColor = [UIColor grayMedium];
    [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
  }
  [self hideDropdownLists];
  // Need to do this in order to remove all previous annotations and 
  // only show properties with the filters applied
  [_mapViewController removeAllAnnotations];
}

@end
