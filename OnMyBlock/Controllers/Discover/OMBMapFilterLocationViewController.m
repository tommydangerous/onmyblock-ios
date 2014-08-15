//
//  OMBMapFilterLocationViewController.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/12/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMapFilterLocationViewController.h"

#import "AMBlurView.h"
#import "NSString+Extensions.h"
#import "NSUserDefaults+OnMyBlock.h"
#import "OMBMapFilterBathroomsCell.h"
#import "OMBMapFilterViewController.h"
#import "OMBMapFilterBedroomsCell.h"
#import "OMBMapFilterNeighborhoodCell.h"
#import "OMBMapFilterPropertyTypeCell.h"
#import "OMBMapFilterRentCell.h"
#import "OMBMapFilterDateAvailableCell.h"
#import "OMBNeighborhood.h"
#import "OMBNeighborhoodStore.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@interface OMBMapFilterLocationViewController () <UISearchBarDelegate>
{
  CLLocationManager *locationManager;
}

@end

@implementation OMBMapFilterLocationViewController

#pragma mark - Initializer

- (id) initWithSelectedNeighborhood:(OMBNeighborhood *) selectedNeighborhood
{
  if (!(self = [super init])) return nil;

  // Location manager
  locationManager                 = [[CLLocationManager alloc] init];
  locationManager.delegate        = self;
  locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  locationManager.distanceFilter  = 50;

  _selectedNeighborhood = selectedNeighborhood;

  self.title = @"Choose Location";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setupForTable];

  self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Cancel"
      style: UIBarButtonItemStylePlain target: self action: @selector(cancel)];

  // CGRect screen = [self screen];
  // CGFloat screenWidth = screen.size.width;
  CGFloat padding = OMBPadding;

  // Neighborhood table
  self.table.alwaysBounceVertical = YES;
  self.table.backgroundColor = [UIColor grayUltraLight];
  self.table.dataSource = self;
  self.table.delegate = self;
  self.table.separatorColor = [UIColor grayLight];
  self.table.separatorInset = UIEdgeInsetsMake(0.0f, padding,
                                               0.0f, 0.0f);
  temporaryNeighborhoods = [[OMBNeighborhoodStore sharedStore]
                            sortedNeighborhoodsForName:@""];

  // Header view
  AMBlurView *neighborhoodTableHeaderView   = [AMBlurView new];
  neighborhoodTableHeaderView.blurTintColor = [UIColor grayLight];
  neighborhoodTableHeaderView.frame         = CGRectMake(
    0, 0, self.table.frame.size.width, OMBStandardHeight * 2
  );
  self.table.tableHeaderView = neighborhoodTableHeaderView;

  // Filter
  // filterTextField = [[TextFieldPadding alloc] init];
  // filterTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  // filterTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  // filterTextField.backgroundColor = [UIColor grayUltraLight];
  // filterTextField.delegate = self;
  // filterTextField.font = [UIFont normalTextFont];
  // filterTextField.frame = CGRectMake(
  //   0, 0, neighborhoodTableHeaderView.frame.size.width, OMBStandardHeight
  // );
  // filterTextField.leftPaddingX = padding;
  // filterTextField.returnKeyType = UIReturnKeySearch;
  // filterTextField.rightPaddingX = filterTextField.leftPaddingX;
  // filterTextField.placeholderColor = [UIColor grayMedium];
  // filterTextField.placeholder = @"Search city or school";
  // filterTextField.textAlignment = NSTextAlignmentCenter;
  // filterTextField.textColor = [UIColor textColor];
  // [filterTextField addTarget: self action: @selector(textFieldDidChange:)
  //   forControlEvents: UIControlEventEditingChanged];

  UISearchBar *searchBar           = [[UISearchBar alloc] init];
  searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
  searchBar.autocorrectionType     = UITextAutocorrectionTypeNo;
  searchBar.delegate               = self;
  searchBar.frame = CGRectMake(0, 0, 
    CGRectGetWidth(neighborhoodTableHeaderView.frame), OMBStandardHeight
  );
  searchBar.placeholder = @"Search city or school";
  searchBar.tintColor   = [UIColor blue];
  searchBar.translucent = YES;
  [neighborhoodTableHeaderView addSubview:searchBar];

  // Filter image view
  // CGFloat sizeImage = OMBPadding * 0.8f;
  // filterImageView = [[UIImageView alloc] initWithImage:
  //   [UIImage changeColorForImage: [UIImage imageNamed: @"search"]
  //     toColor: [UIColor blue]]];
  // filterImageView.frame = CGRectMake(
  //   neighborhoodTableHeaderView.frame.size.width - sizeImage,
  //     0.0f, sizeImage, sizeImage);
  // [neighborhoodTableHeaderView addSubview: filterImageView];
  // [neighborhoodTableHeaderView setBackgroundColor:[UIColor grayUltraLight]];

  // Label
  UIButton *currentLocationButton = [UIButton new];
  // currentLocationButton.contentHorizontalAlignment =
  //   UIControlContentHorizontalAlignmentLeft;
  currentLocationButton.backgroundColor = [UIColor whiteColor];
  currentLocationButton.frame = CGRectMake(0.0f,
    searchBar.frame.origin.y + searchBar.frame.size.height,
      neighborhoodTableHeaderView.frame.size.width, OMBStandardHeight);
  currentLocationButton.titleLabel.font = [UIFont normalTextFontBold];
  [currentLocationButton addTarget: self action: @selector(useCurrentLocation)
    forControlEvents: UIControlEventTouchUpInside];
  [currentLocationButton setTitle: @"Use My Current Location"
    forState:UIControlStateNormal];
  [currentLocationButton setTitleColor: [UIColor blue]
    forState: UIControlStateNormal];
  [neighborhoodTableHeaderView addSubview: currentLocationButton];

  // Image view
  // CGFloat imageSize = padding;
  // UIImageView *headerImageView = [UIImageView new];
  // headerImageView.frame = CGRectMake(
  //                                    neighborhoodTableHeaderView.frame.size.width - (imageSize + padding +35.0),
  //                                    OMBStandardHeight + (OMBStandardHeight - imageSize) * 0.5,
  //                                    imageSize, imageSize);
  // headerImageView.image = [UIImage imageNamed: @"gps_cursor_blue.png"];
  // [neighborhoodTableHeaderView addSubview: headerImageView];
  // // Current location button
  // CGRect buttonFrame = neighborhoodTableHeaderView.frame;
  // buttonFrame.origin.y = OMBStandardHeight;
  // buttonFrame.size.height = OMBStandardHeight;

  // Footer view
  self.table.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
}

- (void) viewWillAppear:(BOOL)animated
{
  [self.table reloadData];
}

#pragma mark - Protocol

#pragma mark - Protocol CLLocationManagerDelegate

- (void) locationManager: (CLLocationManager *) manager
didFailWithError: (NSError *) error
{
  NSLog(@"Location manager did fail with error: %@",
    error.localizedDescription);
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:
    @"Could not locate" message: error.localizedDescription delegate: nil
      cancelButtonTitle: @"OK" otherButtonTitles: nil];
  [alertView show];
}

- (void) locationManager: (CLLocationManager *) manager
didUpdateLocations: (NSArray *) locations
{
  [self foundLocations: locations];
}

#pragma mark - UIAlertViewDelegate Protocol

- (void) alertView: (UIAlertView *) alertView
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  if (buttonIndex == 0) {
    [[self userDefaults] permissionCurrentLocationSet: NO];
  }
  else if (buttonIndex == 1) {
    [[self userDefaults] permissionCurrentLocationSet: YES];
    [self useCurrentLocation];
  }
}

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewWillBeginDragging: (UIScrollView *) scrollView
{
  if(isEditing){
    [self hideTextField];
  }
}

#pragma mark - Protocol UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  [self.view endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  temporaryNeighborhoods = 
    [[OMBNeighborhoodStore sharedStore] sortedNeighborhoodsForName:
      [searchText lowercaseString]];
  [self.table reloadData];
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  return [[temporaryNeighborhoods allKeys] count];
  //return [[[OMBNeighborhoodStore sharedStore] cities] count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (tableView == self.table) {
    static NSString *NeighborhoodNameCellIdentifier =
    @"NeighborhoodNameCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             NeighborhoodNameCellIdentifier];
    if (!cell)
      cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                    reuseIdentifier: NeighborhoodNameCellIdentifier];

    NSArray *keys = [[temporaryNeighborhoods allKeys] sortedArrayUsingSelector:
                     @selector(localizedCaseInsensitiveCompare:)];
    OMBNeighborhood *neighborhoodCity = [[temporaryNeighborhoods objectForKey:keys[indexPath.section]] objectAtIndex:
                                         indexPath.row];
    if (_selectedNeighborhood == neighborhoodCity) {
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
      cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont normalTextFont];
    cell.textLabel.text = neighborhoodCity.name;
    cell.textLabel.textColor = [UIColor textColor];
    return cell;

    /*NSString *city =
     [[[OMBNeighborhoodStore sharedStore] cities] objectAtIndex:
     indexPath.section];
     NSArray *neighborhoods =
     [[OMBNeighborhoodStore sharedStore] sortedNeighborhoodsForCity: city];
     OMBNeighborhood *neighborhood = [neighborhoods objectAtIndex:
     indexPath.row];
     if (selectedNeighborhood == neighborhood) {
     cell.accessoryType = UITableViewCellAccessoryCheckmark;
     }
     else {
     cell.accessoryType = UITableViewCellAccessoryNone;
     }
     cell.backgroundColor = [UIColor grayUltraLight];
     cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
     size: 15];
     cell.textLabel.text = neighborhood.name;
     cell.textLabel.textColor = [UIColor textColor];
     return cell;*/
  }
  return [[UITableViewCell alloc] init];
}

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
  // Neighborhood
  if (tableView == self.table) {
    NSArray *keys = [[temporaryNeighborhoods allKeys] sortedArrayUsingSelector:
                     @selector(localizedCaseInsensitiveCompare:)];
    return [[temporaryNeighborhoods objectForKey:keys[section]] count];

    /*NSString *city =
     [[[OMBNeighborhoodStore sharedStore] cities] objectAtIndex: section];
     NSArray *neighborhoods =
     [[OMBNeighborhoodStore sharedStore] sortedNeighborhoodsForCity: city];
     return [neighborhoods count];*/
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (tableView == self.table) {
    NSArray *keys = [[temporaryNeighborhoods allKeys] sortedArrayUsingSelector:
                     @selector(localizedCaseInsensitiveCompare:)];
    OMBNeighborhood *neighborhood = [[temporaryNeighborhoods
                                      objectForKey:keys[indexPath.section]]
                                     objectAtIndex: indexPath.row];

    /*NSString *city =
     [[[OMBNeighborhoodStore sharedStore] cities] objectAtIndex:
     indexPath.section];
     NSArray *neighborhoods =
     [[OMBNeighborhoodStore sharedStore] sortedNeighborhoodsForCity: city];
     OMBNeighborhood *neighborhood =
     [neighborhoods objectAtIndex: indexPath.row];*/
    if (_selectedNeighborhood == neighborhood) {
      _selectedNeighborhood = nil;
    }
    else {
      _selectedNeighborhood = neighborhood;
      //selectedNeighborhood = [neighborhoods objectAtIndex: indexPath.row];
    }

    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    [tableView reloadData];
    [self done];
    /*if (_selectedNeighborhood) {
     [_valuesDictionary setObject: selectedNeighborhood
     forKey: @"neighborhood"];
     }
     else
     [_valuesDictionary setObject: @"" forKey: @"neighborhood"];*/

  }
}

- (CGFloat) tableView: (UITableView *) tableView
heightForHeaderInSection: (NSInteger) section
{
  if (tableView == self.table) {
    return 13.0f * 2;
  }
  return 0.0f;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat standardHeight = 44.0f;
  if (tableView == self.table) {
    return standardHeight;
  }
  return 0.0f;
}

- (UIView *) tableView: (UITableView *) tableView
viewForHeaderInSection: (NSInteger) section
{
  if (tableView == self.table) {
    NSArray *keys = [[temporaryNeighborhoods allKeys] sortedArrayUsingSelector:
      @selector(localizedCaseInsensitiveCompare:)];
    AMBlurView *blur = [[AMBlurView alloc] init];
    blur.blurTintColor = [UIColor grayLight];
    blur.frame = CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 13.0f * 2);
    UILabel *label = [UILabel new];
    label.font = [UIFont smallTextFontBold];
    label.frame = blur.frame;
    label.text = [keys[section] capitalizedString];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blueDark];
    [blur addSubview: label];
    return blur;
  }
  return [[UIView alloc] initWithFrame: CGRectZero];
}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
  isEditing = YES;
  [UIView animateWithDuration: OMBStandardDuration animations:^{
    CGRect frame = filterImageView.frame;
    frame.origin.x = OMBPadding * 0.75f;
    filterImageView.frame = frame;
  }];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
  isEditing = NO;
  if(![[textField.text stripWhiteSpace] length])
    [UIView animateWithDuration: OMBStandardDuration animations:^{
      CGRect frame = filterImageView.frame;
      frame.origin.x = (self.table.frame.size.width - frame.size.width )* 0.5f;
      filterImageView.frame = frame;
    }];
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [self hideTextField];
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancel
{
  _selectedNeighborhood = nil;
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) done
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) foundLocations: (NSArray *) locations
{
  CLLocationCoordinate2D coordinate;
  if ([locations count]) {
    for (CLLocation *location in locations) {
      coordinate = location.coordinate;
    }
    OMBNeighborhood *neighborhood = [[OMBNeighborhood alloc] init];
    neighborhood.coordinate = coordinate;
    neighborhood.name = @"My Current Location";
    self.selectedNeighborhood = neighborhood;
    [self done];
  }
  [locationManager stopUpdatingLocation];
}

- (void) hideTextField
{
  [filterTextField resignFirstResponder];
  isEditing = NO;
}

- (void) textFieldDidChange: (UITextField *) textField
{
  // Filter
  if ([[textField.text stripWhiteSpace] length]) {
    filterTextField.clearButtonMode = UITextFieldViewModeAlways;
    filterTextField.enablesReturnKeyAutomatically = YES;
  }
  else {
    filterTextField.clearButtonMode = UITextFieldViewModeNever;
    filterTextField.enablesReturnKeyAutomatically = NO;
  }
  temporaryNeighborhoods = [[OMBNeighborhoodStore sharedStore]
                            sortedNeighborhoodsForName: [textField.text lowercaseString]];
  [self.table reloadData];

}

- (void) useCurrentLocation
{
  if ([[self userDefaults] permissionCurrentLocation]) {
    self.selectedNeighborhood = nil;
    [locationManager startUpdatingLocation];
  }
  else {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:
      @"Use Current Location" message: @"Allowing OnMyBlock to use your "
      @"current location will help us find better listings near you."
        delegate: self cancelButtonTitle: @"Not now"
          otherButtonTitles: @"Yes", nil];
    [alertView show];
  }
}

@end
