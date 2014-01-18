//
//  OMBCreateListingViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCreateListingViewController.h"

#import "OMBActivityView.h"
#import "OMBCreateListingConnection.h"
#import "OMBCreateListingDetailCell.h"
#import "OMBCreateListingPropertyTypeCell.h"
#import "OMBExtendedHitAreaViewContainer.h"
#import "OMBFinishListingViewController.h"
#import "OMBGoogleMapsReverseGeocodingConnection.h"
#import "OMBGooglePlacesConnection.h"
#import "OMBNavigationController.h"
#import "OMBTemporaryResidence.h"
#import "OMBUser.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

@implementation OMBCreateListingViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  locationManager                 = [[CLLocationManager alloc] init];
  locationManager.delegate        = self;
  locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  locationManager.distanceFilter  = 50;

  // Create new temporary residence
  _temporaryResidence = [[OMBTemporaryResidence alloc] init];
  _temporaryResidence.user = [OMBUser currentUser];

  self.screenName = @"Create Listing";
  self.title      = @"Step 1";

  valuesDictionary = [NSMutableDictionary dictionary];
  [valuesDictionary setObject: [NSNumber numberWithInt: 1] 
    forKey: @"bathrooms"];
  [valuesDictionary setObject: [NSNumber numberWithInt: 1] 
    forKey: @"bedrooms"];
  [valuesDictionary setObject: @"" forKey: @"city"];
  [valuesDictionary setObject: [NSNumber numberWithInt: 6] 
    forKey: @"leaseMonths"];
  [valuesDictionary setObject: @"" forKey: @"propertyType"];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Back"
      style: UIBarButtonItemStylePlain target: self
        action: @selector(back)];
  cancelBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Cancel"
      style: UIBarButtonItemStylePlain target: self
        action: @selector(cancel)];
  UIFont *boldFont = [UIFont boldSystemFontOfSize: 17];
  nextBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Next"
      style: UIBarButtonItemStylePlain target: self
        action: @selector(next)];
  [nextBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
  saveBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Save"
      style: UIBarButtonItemStylePlain target: self
        action: @selector(save)];
  [saveBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
  self.navigationItem.leftBarButtonItem = cancelBarButtonItem;

  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;

  CGFloat padding = 20.0f;

  UIView *headerView = [UIView new];
  [self.view addSubview: headerView];

  UIView *progressBarBackground = [UIView new];
  progressBarBackground.backgroundColor = [UIColor grayUltraLight];
  progressBarBackground.frame = CGRectMake(0.0f, 0.0f, screenWidth, padding);
  [headerView addSubview: progressBarBackground];

  progressBar = [UIView new];
  progressBar.backgroundColor = [UIColor blue];
  progressBar.frame = CGRectMake(0.0f, 0.0f, 0.0f, 
    progressBarBackground.frame.size.height);
  [progressBarBackground addSubview: progressBar];

  stepLabel = [UILabel new];
  stepLabel.frame = CGRectMake(0.0f, progressBarBackground.frame.origin.y + 
    progressBarBackground.frame.size.height, screenWidth, 0.0f);
  stepLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 36];
  stepLabel.text = @"Step 1";
  stepLabel.textAlignment = NSTextAlignmentCenter;
  stepLabel.textColor = [UIColor blueDark];
  [headerView addSubview: stepLabel];

  questionLabel = [UILabel new];
  questionLabel.frame = CGRectMake(0.0f, stepLabel.frame.origin.y +
    stepLabel.frame.size.height + padding, screenWidth, 27.0f);
  questionLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
  questionLabel.text = @"What type of place is this?";
  questionLabel.textAlignment = stepLabel.textAlignment;
  questionLabel.textColor = [UIColor textColor];
  [headerView addSubview: questionLabel];

  headerView.frame = CGRectMake(0.0f, padding + 44.0f, screenWidth, 
    progressBarBackground.frame.size.height + stepLabel.frame.size.height +
      padding + questionLabel.frame.size.height + padding);

  CGFloat tableViewHeight = screen.size.height - 
    (headerView.frame.origin.y + headerView.frame.size.height);

  // Step 1
  propertyTypeTableView = [[UITableView alloc] initWithFrame: CGRectMake(
    0.0f, screen.size.height - tableViewHeight, screenWidth, tableViewHeight) 
      style: UITableViewStylePlain];
  propertyTypeTableView.alwaysBounceVertical = NO;
  propertyTypeTableView.dataSource = self;
  propertyTypeTableView.delegate = self;
  propertyTypeTableView.separatorColor = [UIColor grayLight];
  propertyTypeTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
  [self.view addSubview: propertyTypeTableView];
  CALayer *topBorder = [CALayer layer];
  topBorder.backgroundColor = propertyTypeTableView.separatorColor.CGColor;
  topBorder.frame = CGRectMake(0.0f, 0.0f, 
    propertyTypeTableView.frame.size.width, 0.5f);
  [propertyTypeTableView.layer addSublayer: topBorder];

  // Step 2
  locationView = [UIView new];
  locationView.frame = CGRectMake(screenWidth, 
    propertyTypeTableView.frame.origin.y, screenWidth, tableViewHeight);
  [self.view addSubview: locationView];

  cityTextField = [[TextFieldPadding alloc] init];
  cityTextField.backgroundColor = [UIColor grayVeryLight];
  cityTextField.delegate = self;
  cityTextField.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  cityTextField.frame = CGRectMake(padding, 0.0f, 
    screenWidth - (padding * 2), 44.0f);
  cityTextField.layer.cornerRadius = 2.0f;
  cityTextField.paddingX = padding * 0.5f;
  cityTextField.placeholderColor = [UIColor grayMedium];
  cityTextField.placeholder = @"City";
  cityTextField.returnKeyType = UIReturnKeyDone;
  cityTextField.rightViewMode = UITextFieldViewModeAlways;
  cityTextField.textColor = [UIColor textColor];
  [cityTextField addTarget: self action: @selector(textFieldDidChange:)
    forControlEvents: UIControlEventEditingChanged];
  [locationView addSubview: cityTextField];
  // Current location button
  currentLocationButton = [UIButton new];
  currentLocationButton.frame = CGRectMake(0.0f, 0.0f,
    cityTextField.frame.size.height, cityTextField.frame.size.height);
  UIImage *currentLocationButtonImage = [UIImage image: [UIImage imageNamed: 
    @"gps_cursor_blue.png"] size: CGSizeMake(padding, padding)];
  [currentLocationButton addTarget: self action: @selector(useCurrentLocation)
    forControlEvents: UIControlEventTouchUpInside];
  [currentLocationButton setImage: currentLocationButtonImage 
    forState: UIControlStateNormal];
  cityTextField.rightView = currentLocationButton;

  CGFloat mapOriginY = cityTextField.frame.origin.y + 
    cityTextField.frame.size.height + padding;
  map = [[MKMapView alloc] init];
  map.delegate = self;
  map.frame = CGRectMake(0.0f, mapOriginY, screenWidth, 
    locationView.frame.size.height - mapOriginY);
  map.mapType = MKMapTypeStandard;
  map.rotateEnabled = NO;
  map.scrollEnabled = NO;
  map.showsPointsOfInterest = NO;
  map.zoomEnabled = NO;
  [locationView addSubview: map];

  // City table view
  cityTableView = [[UITableView alloc] initWithFrame: 
    CGRectMake(map.frame.origin.x, map.frame.origin.y, 
      map.frame.size.width, map.frame.size.height) 
        style: UITableViewStylePlain];
  cityTableView.alwaysBounceVertical = YES;
  cityTableView.dataSource = self;
  cityTableView.delegate = self;
  cityTableView.hidden = YES;
  cityTableView.separatorColor = [UIColor grayLight];
  cityTableView.separatorInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
  cityTableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
  [locationView addSubview: cityTableView];

  // Step 3
  detailsTableView = [[UITableView alloc] initWithFrame: CGRectMake(
    locationView.frame.origin.x, propertyTypeTableView.frame.origin.y,
     propertyTypeTableView.frame.size.width, 
      propertyTypeTableView.frame.size.height) style: UITableViewStylePlain];
  detailsTableView.alwaysBounceVertical = YES;
  detailsTableView.dataSource = self;
  detailsTableView.delegate = self;
  detailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview: detailsTableView];

  // Activty spinner
  activityView = [[OMBActivityView alloc] init];
  [self.view addSubview: activityView];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  stepNumber = 0;
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

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault 
      reuseIdentifier: CellIdentifier];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  // Property type
  if (tableView == propertyTypeTableView) {
    static NSString *PropertyTypeCellIdentifier = @"PropertyTypeCellIdentifier";
    OMBCreateListingPropertyTypeCell *c = 
      [tableView dequeueReusableCellWithIdentifier:
          PropertyTypeCellIdentifier];
    if (!c)
      c = [[OMBCreateListingPropertyTypeCell alloc] initWithStyle:
        UITableViewCellStyleDefault reuseIdentifier: 
          PropertyTypeCellIdentifier];
    UIImage *image;
    NSString *string = @"";
    if (indexPath.row == 0) {
      image  = [UIImage imageNamed: @"sublet_icon.png"];
      string = @"Sublet";
    }
    else if (indexPath.row == 1) {
      image  = [UIImage imageNamed: @"house_icon_2.png"];
      string = @"House";
    }
    else if (indexPath.row == 2) {
      image  = [UIImage imageNamed: @"apartment_icon_2.png"];
      string = @"Apartment";
    }
    [c setFramesForSubviewsWithSize: CGSizeMake(tableView.frame.size.width,
      tableView.frame.size.height / 3.0f)];
    c.propertyTypeImageView.alpha = 0.5f;
    c.propertyTypeImageView.image = image;
    c.propertyTypeLabel.text      = string;
    return c;
  }
  // City
  else if (tableView == cityTableView) {
    static NSString *CityCellIdentifier = @"CityCellIdentifier";
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:
      CityCellIdentifier];
    if (!cell1)
      cell1 = [[UITableViewCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: CityCellIdentifier];
    cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell1.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
      size: 15];
    cell1.textLabel.text = [_citiesArray objectAtIndex: indexPath.row];
    cell1.textLabel.textColor = [UIColor textColor];
    return cell1;
  }
  // Details
  else if (tableView == detailsTableView) {
    static NSString *DetailCellIdentifier = @"DetailCellIdentifier";
    OMBCreateListingDetailCell *c = 
      [tableView dequeueReusableCellWithIdentifier: DetailCellIdentifier];
    if (!c)
      c = [[OMBCreateListingDetailCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: DetailCellIdentifier];
    c.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *string      = @"";
    NSString *valueString = @"";
    if (indexPath.row == 0) {
      string = @"Bedrooms";
      valueString = [NSString stringWithFormat: @"%i",
        [[valuesDictionary objectForKey: @"bedrooms"] intValue]];
    }
    else if (indexPath.row == 1) {
      string = @"Bathrooms";
      valueString = [NSString stringWithFormat: @"%i",
        [[valuesDictionary objectForKey: @"bathrooms"] intValue]];
    }
    else if (indexPath.row == 2) {
      string = @"Month Lease";
      valueString = [NSString stringWithFormat: @"%i",
        [[valuesDictionary objectForKey: @"leaseMonths"] intValue]];
    }
    [c setFramesForSubviewsWithSize: CGSizeMake(tableView.frame.size.width,
      tableView.frame.size.height / 3.0f)];
    c.detailNameLabel.text = string;
    c.minusButton.tag = indexPath.row;
    c.plusButton.tag = indexPath.row;
    c.valueLabel.text = valueString;
    [c.minusButton addTarget: self action: @selector(minusButtonSelected:)
      forControlEvents: UIControlEventTouchUpInside];
    [c.plusButton addTarget: self action: @selector(plusButtonSelected:)
      forControlEvents: UIControlEventTouchUpInside];
    return c;
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Property Type
  if (tableView == propertyTypeTableView) {
    return 3;
  }
  // City
  else if (tableView == cityTableView) {
    return [_citiesArray count];
  }
  // Details
  else if (tableView == detailsTableView) {
    return 3;
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Property Type
  if (tableView == propertyTypeTableView) {
    NSString *string = @"";
    if (indexPath.row == 0) {
      string = @"sublet";
    }
    else if (indexPath.row == 1) {
      string = @"house";
    }
    else if (indexPath.row == 2) {
      string = @"apartment";
    }
    [valuesDictionary setObject: string forKey: @"propertyType"];
    [self next];
  }
  // City
  else if (tableView == cityTableView) {
    cityTextField.text = [_citiesArray objectAtIndex: indexPath.row];
    [self next];
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Property Type
  if (tableView == propertyTypeTableView) {
    return tableView.frame.size.height / 3.0f;
  }
  else if (tableView == cityTableView) {
    return 44.0f;
  }
  // Details
  else if (tableView == detailsTableView) {
    return tableView.frame.size.height / 3.0f;
  }
  return 0.0f;
}

#pragma mark - Protocol UITextFieldDelegate

- (BOOL) textField: (UITextField *) textField 
shouldChangeCharactersInRange: (NSRange) range 
replacementString: (NSString *) string
{
  if (textField == cityTextField)
    [self.navigationItem setRightBarButtonItem: nil animated: YES];
  return YES;
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) back
{
  if (stepNumber > 0) {
    stepNumber -= 1;

    CGRect screen = [[UIScreen mainScreen] bounds];
    CGRect progressBarRect = progressBar.frame;
    progressBarRect.size.width = screen.size.width * (stepNumber / 3.0f);
    [UIView animateWithDuration: 0.25f animations: ^{
      progressBar.frame = progressBarRect;
    }];
 
    if (stepNumber == 0) {
      [self.navigationItem setLeftBarButtonItem: cancelBarButtonItem
        animated: YES];
      [self.navigationItem setRightBarButtonItem: nil animated: YES];
    }
    else {
      [self.navigationItem setLeftBarButtonItem: backBarButtonItem
        animated: YES];
      [self.navigationItem setRightBarButtonItem: nextBarButtonItem
        animated: YES];
    }

    void (^animations) (void) = ^(void) {};
    void (^completion) (BOOL finished) = ^(BOOL finished) {};
    // Step 3 to step 2
    if (stepNumber == 1) {
      animations = ^(void) {
        stepLabel.text     = @"Step 2";
        questionLabel.text = [NSString stringWithFormat: 
          @"What city is this %@ in?", 
            [valuesDictionary objectForKey: @"propertyType"]];
        UILabel *label = (UILabel *) self.navigationItem.titleView;
        label.text = @"Step 2";

        // Move locationView
        CGRect rect2       = locationView.frame;
        rect2.origin.x     = 0.0f;
        locationView.frame = rect2;
        // Move detailsTableView
        CGRect rect3           = detailsTableView.frame;
        rect3.origin.x         = rect3.size.width;
        detailsTableView.frame = rect3;
      };
    }
    // Step 2 to Step 1
    else if (stepNumber == 0) {
      animations = ^(void) {
        stepLabel.text     = @"Step 1";
        questionLabel.text = @"What type of place is this?";
        UILabel *label = (UILabel *) self.navigationItem.titleView;
        label.text = @"Step 1";

        // Move the propertyTypeTableView
        CGRect rect1 = propertyTypeTableView.frame;
        rect1.origin.x = 0.0f;
        propertyTypeTableView.frame = rect1;

        // Move locationView
        CGRect rect2       = locationView.frame;
        rect2.origin.x     = rect2.size.width;
        locationView.frame = rect2;
      };
    }
    [UIView animateWithDuration: 0.25f animations: animations 
      completion: completion];
  }
  [self.view endEditing: YES];
}

- (void) cancel
{
  [self.navigationController dismissViewControllerAnimated: YES
    completion: nil];
}

- (void ) changeDetailValueAtIndex: (int) index plus: (BOOL) plus
{
  NSString *key = @"";
  
  // Bedrooms
  if (index == 0) {
    key = @"bedrooms";
  }
  // Bathrooms
  else if (index == 1) {
    key = @"bathrooms";
  }
  // Bedrooms
  else if (index == 2) {
    key = @"leaseMonths";
  }
  int value = [[valuesDictionary objectForKey: key] intValue];
  if (plus) {
    value += 1;
  }
  else {
    value -= 1;
  }
  if (value < 0) {
    value = 0;
  }
  [valuesDictionary setObject: [NSNumber numberWithInt: value]
    forKey: key];
  OMBCreateListingDetailCell *cell = (OMBCreateListingDetailCell *)
    [detailsTableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: index
      inSection: 0]];
  cell.valueLabel.text = [NSString stringWithFormat: @"%i", value];
}

- (void) checkValidationForCity
{
  [valuesDictionary setObject: cityTextField.text forKey: @"city"];
  if ([[[valuesDictionary objectForKey: @"city"] stripWhiteSpace] length]) {
    nextBarButtonItem.enabled = YES;
  }
  else {
    nextBarButtonItem.enabled = NO;
  }
}

- (void) foundLocation: (CLLocationCoordinate2D) coordinate
{
  [self setMapViewRegion: coordinate withMiles: 5 animated: YES];
  // Use Google Places API with coordinate as opposed to search text
  // Search for places via Google
  OMBGoogleMapsReverseGeocodingConnection *conn = 
    [[OMBGoogleMapsReverseGeocodingConnection alloc] initWithCoordinate:
      coordinate];
  conn.completionBlock = ^(NSError *error) {
    cityTableView.hidden = YES;
    [self.navigationItem setRightBarButtonItem: nextBarButtonItem 
      animated: YES];
    [self checkValidationForCity];
  };
  conn.delegate = self;
  [conn start];
}

- (void) minusButtonSelected: (UIButton *) button
{
  [self changeDetailValueAtIndex: button.tag plus: NO];
}

- (void) next
{
  if (stepNumber < 2) {
    stepNumber += 1;
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGRect progressBarRect = progressBar.frame;
    progressBarRect.size.width = screen.size.width * (stepNumber / 3.0f);
    [UIView animateWithDuration: 0.25f animations: ^{
      progressBar.frame = progressBarRect;
    }];
    
    [self.navigationItem setLeftBarButtonItem: backBarButtonItem
      animated: YES];
    // Last step; details
    if (stepNumber == 2) 
      [self.navigationItem setRightBarButtonItem: saveBarButtonItem
        animated: YES];

    void (^animations) (void) = ^(void) {};
    void (^completion) (BOOL finished) = ^(BOOL finished) {};
    // Step 1 to Step 2
    if (stepNumber == 1) {
      animations = ^(void) {
        stepLabel.text     = @"Step 2";
        questionLabel.text = [NSString stringWithFormat: 
          @"What city is this %@ in?", 
            [valuesDictionary objectForKey: @"propertyType"]];
        UILabel *label = (UILabel *) self.navigationItem.titleView;
        label.text = @"Step 2";

        // Move the propertyTypeTableView
        CGRect rect1                = propertyTypeTableView.frame;
        rect1.origin.x              = -1 * rect1.size.width;
        propertyTypeTableView.frame = rect1;

        // Move locationView
        CGRect rect2       = locationView.frame;
        rect2.origin.x     = 0.0f;
        locationView.frame = rect2;
      };
      [self useCurrentLocation];
      [self checkValidationForCity];
    }
    // Step 2 to Step 3
    else if (stepNumber == 2) {
      animations = ^(void) {
        stepLabel.text     = @"Step 3";
        questionLabel.text = [NSString stringWithFormat: 
          @"Details about your %@?", 
            [valuesDictionary objectForKey: @"propertyType"]];
        UILabel *label = (UILabel *) self.navigationItem.titleView;
        label.text = @"Step 3";

        // Move locationView
        CGRect rect2       = locationView.frame;
        rect2.origin.x     = -1 * rect2.size.width;
        locationView.frame = rect2;
        // Move detailsTableView
        CGRect rect3           = detailsTableView.frame;
        rect3.origin.x         = 0.0f;
        detailsTableView.frame = rect3;
      };
      [self checkValidationForCity];
    }
    [UIView animateWithDuration: 0.25f animations: animations 
      completion: completion];
  }
  [self.view endEditing: YES];
}

- (void) plusButtonSelected: (UIButton *) button
{
  [self changeDetailValueAtIndex: button.tag plus: YES];
}

- (void) save
{
  [activityView startSpinning];

  stepNumber += 1;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGRect progressBarRect = progressBar.frame;
  progressBarRect.size.width = screen.size.width * (stepNumber / 3.0f);
  [UIView animateWithDuration: 0.25f animations: ^{
    progressBar.frame = progressBarRect;
  } completion: ^(BOOL finished) {
    OMBCreateListingConnection *conn = 
      [[OMBCreateListingConnection alloc] initWithTemporaryResidence: 
        _temporaryResidence dictionary: valuesDictionary];
    conn.completionBlock = ^(NSError *error) {
      if (error) {
        [activityView stopSpinning];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: 
          @"Save failed" message: @"Please try again" 
            delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [alertView show];
        stepNumber -= 1;
        CGRect newRect = progressBar.frame;
        newRect.size.width = screen.size.width * (stepNumber / 3.0f);
        [UIView animateWithDuration: 0.25f animations: ^{
          progressBar.frame = newRect;
        }];
      }
      else {
        [[self appDelegate].container.manageListingsNavigationController 
          pushViewController:
            [[OMBFinishListingViewController alloc] initWithResidence: 
              _temporaryResidence] animated: NO];
        [self cancel];
      }
    };
    [conn start]; 
  }];
}

- (void) setCityTextFieldTextWithString: (NSString *) string
{
  cityTextField.text = string;
}

- (void) setMapViewRegion: (CLLocationCoordinate2D) coordinate 
withMiles: (int) miles animated: (BOOL) animated
{
  // 1609 meters = 1 mile
  int distanceInMiles = 1609 * miles;
  MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(coordinate, distanceInMiles, 
      distanceInMiles);
  [map setRegion: region animated: animated];
}

- (void) startGooglePlacesConnection
{
  // Search for places via Google
  OMBGooglePlacesConnection *conn = 
    [[OMBGooglePlacesConnection alloc] initWithString: cityTextField.text
      citiesOnly: YES];
  conn.completionBlock = ^(NSError *error) {
    [cityTableView reloadData];
  };
  conn.delegate = self;
  [conn start];
}

- (void) textFieldDidChange: (UITextField *) textField
{
  // City
  if (textField == cityTextField) {
    // Stop timer
    [typingTimer invalidate];
    // Start timer
    if ([[textField.text stripWhiteSpace] length]) {
      typingTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5f target: self 
        selector: @selector(startGooglePlacesConnection) userInfo: nil 
          repeats: NO];
      // Show city table view
      cityTableView.hidden = NO;
    }
    else {
      cityTableView.hidden = YES;
    }
    [self checkValidationForCity];
  } 
}

- (void) useCurrentLocation
{
  [locationManager startUpdatingLocation];
}

@end
