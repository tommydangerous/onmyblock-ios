//
//  OMBFinishListingAddressViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingAddressViewController.h"

#import "AMBlurView.h"
#import "NSString+Extensions.h"
#import "OMBAnnotation.h"
#import "OMBAnnotationView.h"
#import "OMBResidenceUpdateConnection.h"
#import "OMBGoogleMapsReverseGeocodingConnection.h"
#import "OMBGooglePlacesConnection.h"
#import "OMBLabelTextFieldCell.h"
#import "OMBResidence.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

@implementation OMBFinishListingAddressViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super initWithResidence: object])) return nil;

  locationManager                 = [[CLLocationManager alloc] init];
  locationManager.delegate        = self;
  locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  locationManager.distanceFilter  = 50;

  CGRect rect = [@"Address" boundingRectWithSize:
    CGSizeMake(9999, OMBStandardHeight) font: [UIFont normalTextFont]];
  sizeForLabelTextFieldCell = rect.size;

  self.screenName = self.title = @"Location";

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(makeTableViewSmaller:)
      name: UIKeyboardWillShowNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(makeTableViewLarger:)
      name: UIKeyboardWillHideNotification object: nil];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = 20.0f;

  // Map  
  map = [[MKMapView alloc] init];
  map.delegate = self;
  map.frame = CGRectMake(0.0f, 0.0f, screenWidth, screen.size.height);
  map.mapType = MKMapTypeStandard;
  [self.view addSubview: map];

  addressTextFieldView = [[AMBlurView alloc] init];
  addressTextFieldView.frame = CGRectMake(0.0f, 20.0f + 44.0f, 
    screenWidth, padding + 44.0f + padding);
  [self.view addSubview: addressTextFieldView];
  // Bottom border
  CALayer *addressTextFieldViewBottomBorder = [CALayer layer];
  addressTextFieldViewBottomBorder.backgroundColor = 
    [UIColor grayLight].CGColor;
  addressTextFieldViewBottomBorder.frame = CGRectMake(0.0f, 
    addressTextFieldView.frame.size.height - 1.0f, 
      addressTextFieldView.frame.size.width, 1.0f);
  [addressTextFieldView.layer addSublayer: 
    addressTextFieldViewBottomBorder];
  // Address text field when searching for location
  addressTextField = [[TextFieldPadding alloc] init];
  addressTextField.backgroundColor = [UIColor grayVeryLight];
  addressTextField.delegate = self;
  addressTextField.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 15];
  addressTextField.frame = CGRectMake(padding, padding, 
    addressTextFieldView.frame.size.width - (padding * 2), 44.0f);
  addressTextField.layer.cornerRadius = 2.0f;
  addressTextField.paddingX = padding * 0.5f;
  addressTextField.placeholderColor = [UIColor grayMedium];
  addressTextField.placeholder = @"Address";
  addressTextField.returnKeyType = UIReturnKeyDone;
  addressTextField.rightViewMode = UITextFieldViewModeAlways;
  addressTextField.textColor = [UIColor textColor];
  [addressTextField addTarget: self action: @selector(textFieldDidChange:)
    forControlEvents: UIControlEventEditingChanged];
  [addressTextFieldView addSubview: addressTextField];
  // Current location button
  currentLocationButton = [UIButton new];
  currentLocationButton.frame = CGRectMake(0.0f, 0.0f,
    addressTextField.frame.size.height, addressTextField.frame.size.height);
  UIImage *currentLocationButtonImage = [UIImage image: [UIImage imageNamed: 
    @"gps_cursor_blue.png"] size: CGSizeMake(padding, padding)];
  [currentLocationButton addTarget: self action: @selector(useCurrentLocation)
    forControlEvents: UIControlEventTouchUpInside];
  [currentLocationButton setImage: currentLocationButtonImage 
    forState: UIControlStateNormal];
  addressTextField.rightView = currentLocationButton;

  // List of address results
  CGFloat addressTableViewHeight = screen.size.height - 
    (addressTextFieldView.frame.origin.y + 
      addressTextFieldView.frame.size.height);
  addressTableView = [[UITableView alloc] initWithFrame: CGRectMake(0.0f,
    addressTextFieldView.frame.origin.y + 
    addressTextFieldView.frame.size.height, 
      screenWidth,  addressTableViewHeight)
    style: UITableViewStylePlain];
  addressTableView.backgroundColor = [UIColor grayUltraLight];
  addressTableView.dataSource = self;
  addressTableView.delegate = self;
  addressTableView.hidden = YES;
  addressTableView.separatorColor  = [UIColor grayLight];
  addressTableView.separatorInset  = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
  addressTableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
  addressTableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
  [self.view addSubview: addressTableView];

  CGFloat textFieldTableViewHeight = screen.size.height - 
    addressTableView.frame.origin.y;
  textFieldTableView = [[UITableView alloc] initWithFrame: CGRectMake(0.0f,
    screen.size.height, screenWidth, textFieldTableViewHeight)
      style: UITableViewStylePlain];
  textFieldTableView.backgroundColor = [UIColor grayUltraLight];
  textFieldTableView.dataSource = self;
  textFieldTableView.delegate = self;
  textFieldTableView.hidden = YES;
  textFieldTableView.separatorColor = [UIColor grayLight];
  textFieldTableView.separatorInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
  textFieldTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  textFieldTableView.tableFooterView = [[UIView alloc] initWithFrame: 
    CGRectZero];
  [self.view addSubview: textFieldTableView];
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];

  [addressTextField becomeFirstResponder];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  address = [residence.address capitalizedString];
  city    = [residence.city capitalizedString];
  state   = [residence.state capitalizedString];
  unit    = residence.unit;
  zip     = residence.zip;

  OMBGoogleMapsReverseGeocodingConnection *conn;
  if (residence.latitude && residence.longitude) {
    conn = [[OMBGoogleMapsReverseGeocodingConnection alloc] initWithCoordinate:
      CLLocationCoordinate2DMake(residence.latitude, residence.longitude)];
  }
  else {
    conn = [[OMBGoogleMapsReverseGeocodingConnection alloc] initWithAddress:
      [NSString stringWithFormat: @"%@, %@", city, state]];
  }
  conn.delegate = self;
  [conn start];

  if ([address length]) {
    addressTextField.text = [NSString stringWithFormat: @"%@", address];
    if ([city length])
      addressTextField.text = [NSString stringWithFormat: @"%@, %@",
        addressTextField.text, city];
    if ([state length])
      addressTextField.text = [NSString stringWithFormat: @"%@, %@",
        addressTextField.text, state];
    if ([zip length])
      addressTextField.text = [NSString stringWithFormat: @"%@, %@",
        addressTextField.text, zip];
  }

  // If all this info is already there, allow them to save
  if (residence.address && residence.city && residence.state && residence.zip) {
    saveBarButtonItem.enabled = YES;
    [self.navigationItem setRightBarButtonItem: saveBarButtonItem animated: NO];
  }
}

#pragma mark - Protocol

#pragma mark - Protocol CLLocationManagerDelegate

- (void) locationManager: (CLLocationManager *) manager
didFailWithError: (NSError *) error
{
  NSLog(@"Location manager did fail with error: %@", 
    error.localizedDescription);
}

- (void) locationManager: (CLLocationManager *) manager
didUpdateLocations: (NSArray *) locations
{
  CLLocationCoordinate2D coordinate;
  if ([locations count]) {
    for (CLLocation *location in locations) {
      coordinate = location.coordinate;
    }
  }
  [locationManager stopUpdatingLocation];
  [self foundLocation: coordinate];
}

#pragma mark - Protocol MKMapViewDelegate

- (MKAnnotationView *) mapView: (MKMapView *) mapView
viewForAnnotation: (id <MKAnnotation>) annotation
{
  // If the annotation is the user's location, show the default pulsing circle
  if (annotation == mapView.userLocation)
    return nil;

  static NSString *ReuseIdentifier = @"AnnotationViewIdentifier";
  OMBAnnotationView *annotationView = (OMBAnnotationView *)
    [map dequeueReusableAnnotationViewWithIdentifier: ReuseIdentifier];
  if (!annotationView) {
    annotationView = 
      [[OMBAnnotationView alloc] initWithAnnotation: annotation 
        reuseIdentifier: ReuseIdentifier];
  }
  [annotationView loadAnnotation: annotation];
  return annotationView;
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Subclasses implement this
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  // Address
  if (tableView == addressTableView) {
    if (indexPath.row < 
      [tableView numberOfRowsInSection: indexPath.section] - 1) {

      NSDictionary *dict = [_addressArray objectAtIndex: indexPath.row];
      cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
        size: 15];
      cell.textLabel.text = [dict objectForKey: @"formatted_address"];
      cell.textLabel.textColor = [UIColor textColor];
    }
    else {
      cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
        size: 15];
      cell.textLabel.text = @"Use address form";
      cell.textLabel.textColor = [UIColor blue];
    }
  }
  // Address form
  else if (tableView == textFieldTableView) {
    static NSString *TextFieldCellIdentifier = @"TextFieldCellIdentifier";
    OMBLabelTextFieldCell *c = [tableView dequeueReusableCellWithIdentifier:
      TextFieldCellIdentifier];
    if (!c) {
      c = [[OMBLabelTextFieldCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: TextFieldCellIdentifier];
      [c setFrameUsingSize: sizeForLabelTextFieldCell];
    }
    c.selectionStyle = UITableViewCellSelectionStyleNone;
    c.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    c.textField.delegate = self;
    c.textField.text = @"";
    // Top border
    UIView *topBorder = [c.contentView viewWithTag: 9998];
    if (topBorder)
      [topBorder removeFromSuperview];
    else {
      topBorder = [UIView new];
      topBorder.backgroundColor = [UIColor grayLight];
      topBorder.frame = CGRectMake(0.0f, 0.0f, 
        tableView.frame.size.width, 0.5f);
      topBorder.tag = 9998;
    }
    // Bottom border
    UIView *bottomBorder = [c.contentView viewWithTag: 9999];
    if (bottomBorder)
      [bottomBorder removeFromSuperview];
    else {
      bottomBorder = [UIView new];
      bottomBorder.backgroundColor = [UIColor grayLight];
      bottomBorder.frame = CGRectMake(0.0f, 44.0f - 0.5f, 
        tableView.frame.size.width, 0.5f);
      bottomBorder.tag = 9999;
    }
    NSString *string = @"";
    if (indexPath.row == 0) {
      c.textField.text = address;
      string = @"Address";
      [c.contentView addSubview: topBorder];
    }
    else if (indexPath.row == 1) {
      c.textField.text = unit;
      string = @"Unit";
    }
    else if (indexPath.row == 2) {
      c.textField.text = city;
      string = @"City";
    }
    else if (indexPath.row == 3) {
      c.textField.text = state;
      string = @"State";
    }
    else if (indexPath.row == 4) {
      c.textField.text = zip;
      string = @"Zip";
      [c.contentView addSubview: bottomBorder];
    }
    
    c.textFieldLabel.text = string;
    return c;
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Address
  if (tableView == addressTableView) {
    return [_addressArray count] + 1;
  }
  else if (tableView == textFieldTableView) {
    return 5;
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (tableView == addressTableView) {
    if (indexPath.row < 
      [tableView numberOfRowsInSection: indexPath.section] - 1) {

      NSString *formattedAddress = [[_addressArray objectAtIndex: 
        indexPath.row] objectForKey: @"formatted_address"];
      [self setAddressInfoFromString: formattedAddress];
    }
    [self showAddressForm];
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return 44.0f;
}

#pragma mark - Protocol UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) foundLocation: (CLLocationCoordinate2D) coordinate
{
  [self setMapViewRegion: coordinate withMiles: 0.5f animated: YES];
  // Use Google Places API with coordinate as opposed to search text
  // Search for places via Google
  OMBGoogleMapsReverseGeocodingConnection *conn = 
    [[OMBGoogleMapsReverseGeocodingConnection alloc] initWithCoordinate:
      coordinate];
  conn.completionBlock = ^(NSError *error) {
    addressTextField.text = [[_addressArray firstObject] objectForKey:
      @"formatted_address"];

    // Enabled the save button
    saveBarButtonItem.enabled = YES;
    [self.navigationItem setRightBarButtonItem: saveBarButtonItem 
      animated: YES];

    // Set address from the formatted string
    [self setAddressInfoFromString: addressTextField.text];

    // Address
    OMBLabelTextFieldCell *addressCell = (OMBLabelTextFieldCell *)
      [textFieldTableView cellForRowAtIndexPath: 
        [NSIndexPath indexPathForRow: 0 inSection: 0]];
    addressCell.textField.text = address;
    // City
    OMBLabelTextFieldCell *cityCell = (OMBLabelTextFieldCell *)
      [textFieldTableView cellForRowAtIndexPath: 
        [NSIndexPath indexPathForRow: 2 inSection: 0]];
    cityCell.textField.text = city;
    // State
    OMBLabelTextFieldCell *stateCell = (OMBLabelTextFieldCell *)
      [textFieldTableView cellForRowAtIndexPath: 
        [NSIndexPath indexPathForRow: 3 inSection: 0]];
    stateCell.textField.text = state;
    // Zip
    OMBLabelTextFieldCell *zipCell = (OMBLabelTextFieldCell *)
      [textFieldTableView cellForRowAtIndexPath: 
        [NSIndexPath indexPathForRow: 4 inSection: 0]];
    zipCell.textField.text = zip;
  };
  conn.delegate = self;
  [conn start];

  // Add annotation
  OMBAnnotation *annotation = [[OMBAnnotation alloc] init];
  annotation.coordinate     = coordinate;
  [map addAnnotation: annotation];
}

- (void) makeTableViewLarger: (NSNotification *) notification
{
  NSTimeInterval duration = [[notification.userInfo objectForKey: 
    UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [UIView animateWithDuration: duration delay: 0.0f 
    options: UIViewAnimationOptionCurveEaseOut animations: 
    ^{
      CGRect screen = [[UIScreen mainScreen] bounds];
      CGFloat addressTableViewHeight = screen.size.height - 
        (addressTextFieldView.frame.origin.y + 
          addressTextFieldView.frame.size.height);
      CGRect rect = addressTableView.frame;
      rect.size.height = addressTableViewHeight;
      addressTableView.frame = rect;

      // Text field table view
      CGRect rect2 = textFieldTableView.frame;
      rect2.size.height = screen.size.height - (20.0f + 44.0f);
      textFieldTableView.frame = rect2;
    } 
    completion: nil
  ];
}

- (void) makeTableViewSmaller: (NSNotification *) notification
{
  NSTimeInterval duration = [[notification.userInfo objectForKey: 
    UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [UIView animateWithDuration: duration delay: 0.0f 
    options: UIViewAnimationOptionCurveEaseOut animations: 
    ^{
      CGRect screen = [[UIScreen mainScreen] bounds];
      CGFloat addressTableViewHeight = screen.size.height - 
        (addressTextFieldView.frame.origin.y + 
          addressTextFieldView.frame.size.height);
      CGRect rect = addressTableView.frame;
      rect.size.height = addressTableViewHeight - 216.0f;
      addressTableView.frame = rect;

      // Text field table view
      CGRect rect2 = textFieldTableView.frame;
      rect2.size.height = (screen.size.height - (20.0f + 44.0f)) - 216.0f;
      textFieldTableView.frame = rect2;
    } 
    completion: nil
  ];
}

- (void) setMapViewRegion: (CLLocationCoordinate2D) coordinate 
withMiles: (CGFloat) miles animated: (BOOL) animated
{
  // 1609 meters = 1 mile
  int distanceInMiles = 1609 * miles;
  MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(coordinate, distanceInMiles, 
      distanceInMiles);
  [map setRegion: region animated: animated];
}

- (void) showAddressForm
{
  // Animate the address text field view up
  [UIView animateWithDuration: 0.25f animations: ^{
    CGRect rect = addressTextFieldView.frame;
    rect.origin.y = -1 * rect.size.height;
    addressTextFieldView.frame = rect;
  }];

  // Reload the address table so the values show up
  [textFieldTableView reloadData];

  // Animate the text field table view up
  [UIView animateWithDuration: 0.25f animations: ^{
    textFieldTableView.hidden = NO;
    CGRect rect = textFieldTableView.frame;
    rect.origin.y = 20.0f + 44.0f;
    textFieldTableView.frame = rect;
  } completion: ^(BOOL finished) {
    addressTableView.hidden = YES;
    OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *) 
      [textFieldTableView cellForRowAtIndexPath:
        [NSIndexPath indexPathForRow: 0 inSection: 0]];
    [cell.textField becomeFirstResponder];

    saveBarButtonItem.enabled = YES;
  }];
}

- (void) startGooglePlacesConnection
{
  // Search for places via Google
  OMBGoogleMapsReverseGeocodingConnection *conn = 
    [[OMBGoogleMapsReverseGeocodingConnection alloc] initWithAddress: 
      addressTextField.text];
  conn.completionBlock = ^(NSError *error) {
    [addressTableView reloadData];
  };
  conn.delegate = self;
  [conn start];
}

- (void) textFieldDidChange: (UITextField *) textField
{
  NSInteger length = [[textField.text stripWhiteSpace] length];
  if (length) {
    saveBarButtonItem.enabled = NO;
    [self.navigationItem setRightBarButtonItem: saveBarButtonItem
      animated: YES];
    addressTextField.clearButtonMode = UITextFieldViewModeAlways;
    addressTextField.rightViewMode   = UITextFieldViewModeNever;
    // Show address table view
    addressTableView.hidden = NO;
    map.hidden = YES;

    // Stop timer
    [typingTimer invalidate];
    // Start timer
    typingTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5f target: self
      selector: @selector(startGooglePlacesConnection) userInfo: nil 
        repeats: NO];

  }
  else {
    [self.navigationItem setRightBarButtonItem: nil animated: YES];
    addressTextField.clearButtonMode = UITextFieldViewModeNever;
    addressTextField.rightViewMode   = UITextFieldViewModeAlways;
    addressTableView.hidden = YES;
    map.hidden = NO;
  }
}

- (void) save
{
  // Address
  OMBLabelTextFieldCell *addressCell = (OMBLabelTextFieldCell *)
    [textFieldTableView cellForRowAtIndexPath: 
      [NSIndexPath indexPathForRow: 0 inSection: 0]];
  residence.address = addressCell.textField.text;
  // Unit
  OMBLabelTextFieldCell *unitCell = (OMBLabelTextFieldCell *)
    [textFieldTableView cellForRowAtIndexPath: 
      [NSIndexPath indexPathForRow: 1 inSection: 0]];
  residence.unit = unitCell.textField.text;
  // City
  OMBLabelTextFieldCell *cityCell = (OMBLabelTextFieldCell *)
    [textFieldTableView cellForRowAtIndexPath: 
      [NSIndexPath indexPathForRow: 2 inSection: 0]];
  residence.city = cityCell.textField.text;
  // State
  OMBLabelTextFieldCell *stateCell = (OMBLabelTextFieldCell *)
    [textFieldTableView cellForRowAtIndexPath: 
      [NSIndexPath indexPathForRow: 3 inSection: 0]];
  residence.state = stateCell.textField.text;
  // Zip
  OMBLabelTextFieldCell *zipCell = (OMBLabelTextFieldCell *)
    [textFieldTableView cellForRowAtIndexPath: 
      [NSIndexPath indexPathForRow: 4 inSection: 0]];
  residence.zip = zipCell.textField.text;

  if (![residence.address length]) {
    [addressCell.textField becomeFirstResponder];
  }
  else if (![residence.city length]) {
    [cityCell.textField becomeFirstResponder];
  }
  else if (![residence.state length]) {
    [stateCell.textField becomeFirstResponder];
  }
  else if (![residence.zip length]) {
    [zipCell.textField becomeFirstResponder];
  }
  else {
    OMBResidenceUpdateConnection *conn = 
      [[OMBResidenceUpdateConnection alloc] initWithResidence: residence 
        attributes: @[
          @"address",
          @"city",
          @"state",
          @"unit",
          @"zip"
        ]
      ];
    [conn start];
    [self.navigationController popViewControllerAnimated: YES];
  }
}

- (void) setAddressInfoFromString: (NSString *) string
{
  // Address
  NSArray *words = [string componentsSeparatedByString: @","];
  if ([words count] >= 1) {
    address = [words objectAtIndex: 0];
  }
  if ([words count] >= 2) {
    city = [words objectAtIndex: 1];
  }
  if ([words count] >= 3) {
    NSString *stateZip = [words objectAtIndex: 2];
    // State
    NSRegularExpression *stateRegEx =
      [NSRegularExpression regularExpressionWithPattern: @"([A-Za-z]+)"
        options: 0 error: nil];
    NSArray *stateMatches = [stateRegEx matchesInString: stateZip
      options: 0 range: NSMakeRange(0, [stateZip length])];
    if ([stateMatches count]) {
      NSTextCheckingResult *stateResult = [stateMatches objectAtIndex: 0];
      state = [stateZip substringWithRange: stateResult.range];
    }

    // Zip
    NSRegularExpression *zipRegEx =
      [NSRegularExpression regularExpressionWithPattern: @"([0-9-]+)"
        options: 0 error: nil];
    NSArray *zipMatches = [zipRegEx matchesInString: stateZip
      options: 0 range: NSMakeRange(0, [stateZip length])];
    if ([zipMatches count]) {
      NSTextCheckingResult *zipResult = [zipMatches objectAtIndex: 0];
      zip = [stateZip substringWithRange: zipResult.range];
    }
  }
}

- (void) useCurrentLocation
{
  [locationManager startUpdatingLocation];
}

@end
