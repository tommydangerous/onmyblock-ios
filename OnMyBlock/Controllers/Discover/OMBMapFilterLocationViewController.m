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
#import "OMBMapFilterBathroomsCell.h"
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

@implementation OMBMapFilterLocationViewController

#pragma mark - Initializer

- (id) initWithSelectedNeighborhood:(OMBNeighborhood *) selectedNeighborhood
{
  if (!(self = [super init])) return nil;
  
  self.title = @"Choose Location";
  _selectedNeighborhood = selectedNeighborhood;
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

  CGFloat padding = 20.0f;
  
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
  UIView *neighborhoodTableHeaderView = [UIView new];
  neighborhoodTableHeaderView.backgroundColor = [UIColor grayLight];
  neighborhoodTableHeaderView.frame = CGRectMake(0.0f, 0.0f,
    self.table.frame.size.width, OMBStandardHeight);
  self.table.tableHeaderView = neighborhoodTableHeaderView;
  // Filter
  filterTextField = [[TextFieldPadding alloc] init];
  filterTextField.backgroundColor = [UIColor whiteColor];
  filterTextField.delegate = self;
  filterTextField.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  filterTextField.frame = CGRectMake(padding * 0.5, OMBStandardHeight * 0.1f,
                                     neighborhoodTableHeaderView.frame.size.width - (padding), OMBStandardHeight * 0.8f);
  filterTextField.layer.cornerRadius = 6.0f;
  filterTextField.leftPaddingX = padding * 1.5f;
  filterTextField.returnKeyType = UIReturnKeySearch;
  filterTextField.rightPaddingX = padding * 1.5f;
  filterTextField.textColor = [UIColor textColor];
  [filterTextField addTarget: self action: @selector(textFieldDidChange:)
            forControlEvents: UIControlEventEditingChanged];
  [neighborhoodTableHeaderView addSubview: filterTextField];
  // Filter image view
  CGFloat sizeImage = 17;
  filterImageView = [[UIImageView alloc] initWithImage:
                     [UIImage changeColorForImage:[UIImage imageNamed:@"search"]
                                          toColor:[UIColor grayMedium]]];
  filterImageView.frame = CGRectMake((neighborhoodTableHeaderView.frame.size.width - sizeImage) * 0.5f,
                                     (neighborhoodTableHeaderView.frame.size.height - sizeImage) * 0.5f,
                                     sizeImage , sizeImage);
  [neighborhoodTableHeaderView addSubview: filterImageView];
  
  // Label
  UILabel *currentLocationLabel = [UILabel new];
  currentLocationLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
                                              size: 15];
  currentLocationLabel.frame = CGRectMake(padding, OMBStandardHeight,
                                          neighborhoodTableHeaderView.frame.size.width,
                                          OMBStandardHeight);
  currentLocationLabel.text = @"User Current Location";
  currentLocationLabel.textColor = [UIColor blue];
  //[neighborhoodTableHeaderView addSubview: currentLocationLabel];
  // Image view
  CGFloat imageSize = padding;
  UIImageView *headerImageView = [UIImageView new];
  headerImageView.frame = CGRectMake(
                                     neighborhoodTableHeaderView.frame.size.width - (imageSize + padding),
                                     OMBStandardHeight + (OMBStandardHeight - imageSize) * 0.5,
                                     imageSize, imageSize);
  headerImageView.image = [UIImage imageNamed: @"gps_cursor_blue.png"];
  //[neighborhoodTableHeaderView addSubview: headerImageView];
  // Current location button
  CGRect buttonFrame = neighborhoodTableHeaderView.frame;
  buttonFrame.origin.y = OMBStandardHeight;
  buttonFrame.size.height = OMBStandardHeight;
  
  // Footer view
  self.table.tableFooterView = [[UIView alloc] initWithFrame:
    CGRectZero];
}

- (void) viewWillAppear:(BOOL)animated
{
  [self.table reloadData];
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewWillBeginDragging: (UIScrollView *) scrollView
{
  if(isEditing){
    [self hideTextField];
  }
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
    cell.backgroundColor = [UIColor grayUltraLight];
    cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
                                          size: 15];
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
    blur.blurTintColor = [UIColor grayVeryLight];
    blur.frame = CGRectMake(0.0f, 0.0f,
                            tableView.frame.size.width, 13.0f * 2);
    UILabel *label = [UILabel new];
    label.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 13];
    label.frame = blur.frame;
    label.text = [keys[section] capitalizedString];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blue];
    [blur addSubview: label];
    return blur;
    
    /*AMBlurView *blur = [[AMBlurView alloc] init];
     blur.blurTintColor = [UIColor grayVeryLight];
     blur.frame = CGRectMake(0.0f, 0.0f,
     tableView.frame.size.width, 13.0f * 2);
     UILabel *label = [UILabel new];
     label.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 13];
     label.frame = blur.frame;
     label.text = [[[[OMBNeighborhoodStore sharedStore] cities] objectAtIndex:
     section] capitalizedString];
     label.textAlignment = NSTextAlignmentCenter;
     label.textColor = [UIColor blue];
     [blur addSubview: label];
     return blur;*/
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

@end
