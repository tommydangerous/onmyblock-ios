//
//  OMBMapFilterViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/20/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMapFilterViewController.h"

#import "NSString+Extensions.h"
#import "OMBMapFilterBathroomsCell.h"
#import "OMBMapFilterBedroomsCell.h"
#import "OMBMapFilterNeighborhoodCell.h"
#import "OMBMapFilterRentCell.h"
#import "OMBNeighborhood.h"
#import "OMBNeighborhoodStore.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"

@implementation OMBMapFilterViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Filter";
  
  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  // Navigation item
  doneBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Done"
      style: UIBarButtonItemStylePlain target: self action: @selector(done)];
  // Left bar button item
  self.navigationItem.leftBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Cancel" 
      style: UIBarButtonItemStylePlain target: self action: @selector(cancel)];
  // Right bar button item
  searchBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Search" 
      style: UIBarButtonItemStylePlain target: self action: @selector(search)];
  self.navigationItem.rightBarButtonItem = searchBarButtonItem;

  self.table.backgroundColor = [UIColor clearColor];
  self.table.separatorInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth = screen.size.width;

  fadedBackground = [[UIView alloc] init];
  fadedBackground.alpha = 0.0f;
  fadedBackground.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.8f];
  fadedBackground.frame = screen;
  [self.view addSubview: fadedBackground];
  UITapGestureRecognizer *tapGesture = 
    [[UITapGestureRecognizer alloc] initWithTarget: self 
      action: @selector(done)];
  [fadedBackground addGestureRecognizer: tapGesture];

  neighborhoodTableViewContainer = [[UIView alloc] init];
  neighborhoodTableViewContainer.frame = CGRectMake(0.0f, 
    screenHeight, screenWidth, screenHeight * 0.6);
  [self.view addSubview: neighborhoodTableViewContainer];

  // Header for the neighborhood
  UIView *headerView = [[UIView alloc] init];
  headerView.backgroundColor = [UIColor blueLight];
  headerView.frame = CGRectMake(0.0f, 0.0f, 
    neighborhoodTableViewContainer.frame.size.width, 44.0f);
  [neighborhoodTableViewContainer addSubview: headerView];
  UILabel *headerLabel = [[UILabel alloc] init];
  headerLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  headerLabel.frame = CGRectMake(20.0f, 0.0f, 
    headerView.frame.size.width, headerView.frame.size.height);
  headerLabel.text = @"Select neighborhood";
  headerLabel.textColor = [UIColor blueDark];
  [headerView addSubview: headerLabel];

  neighborhoodTableView = [[UITableView alloc] initWithFrame: 
    CGRectMake(0.0f, headerView.frame.size.height, 
      neighborhoodTableViewContainer.frame.size.width,
      neighborhoodTableViewContainer.frame.size.height - 
      headerView.frame.size.height)
        style: UITableViewStylePlain];
  neighborhoodTableView.alwaysBounceVertical = YES;
  neighborhoodTableView.dataSource = self;
  neighborhoodTableView.delegate = self;
  neighborhoodTableView.separatorColor = [UIColor grayLight];
  neighborhoodTableView.separatorInset = UIEdgeInsetsMake(0.0f, 20.0f, 
    0.0f, 0.0f);
  neighborhoodTableView.showsVerticalScrollIndicator = NO;
  neighborhoodTableView.tableFooterView = [[UIView alloc] initWithFrame:
    CGRectZero];
  [neighborhoodTableViewContainer addSubview: neighborhoodTableView];

  rentPickerView = [[UIPickerView alloc] init];
  rentPickerView.backgroundColor = [UIColor whiteColor];
  rentPickerView.dataSource = self;
  rentPickerView.delegate   = self;
  rentPickerView.frame = CGRectMake(0.0f, self.view.frame.size.height, 
    rentPickerView.frame.size.width, rentPickerView.frame.size.height);
  [self.view addSubview: rentPickerView];
  CALayer *topBorder = [CALayer layer];
  topBorder.backgroundColor = [UIColor grayDark].CGColor;
  topBorder.frame = CGRectMake(0.0f, 0.0f, 
    rentPickerView.frame.size.width, 0.5f);
  [rentPickerView.layer addSublayer: topBorder];

  pickerViewBackground = [[UIView alloc] init];
  pickerViewBackground.frame = rentPickerView.frame;
  [self.view insertSubview: pickerViewBackground belowSubview: rentPickerView];
}

#pragma mark - Protocol

#pragma mark - Protocol UIPickerViewDataSource

- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView
{
  return 2;
}

- (NSInteger) pickerView: (UIPickerView *) pickerView 
numberOfRowsInComponent: (NSInteger) component
{
  // Any, 500, ... 9,500+
  return 10000 / 500;
}

#pragma mark - Protocol UIPickerViewDelegate

- (void) pickerView: (UIPickerView *) pickerView didSelectRow: (NSInteger) row 
inComponent: (NSInteger) component
{
  OMBMapFilterRentCell *cell = (OMBMapFilterRentCell *) 
    [self.table cellForRowAtIndexPath: 
      [NSIndexPath indexPathForRow: 1 inSection: 1]];
  NSString *string = [self pickerView: pickerView titleForRow: row
    forComponent: component];
  if (component == 0) {
    cell.minRentTextField.text = string;
  }
  else if (component == 1) {
    cell.maxRentTextField.text = string;
  }
}

- (CGFloat) pickerView: (UIPickerView *) pickerView 
rowHeightForComponent: (NSInteger) component
{
  return 44.0f;
}

- (NSString *) pickerView: (UIPickerView *) pickerView 
titleForRow: (NSInteger) row forComponent: (NSInteger) component
{
  if (row == 0) {
    return @"Any";
  }
  NSString *string = [NSString numberToCurrencyString: 500 * row];
  if (row == [pickerView numberOfRowsInComponent: component] - 1) {
    string = [string stringByAppendingString: @"+"];
  }
  return string;
}

- (CGFloat) pickerView: (UIPickerView *) pickerView 
widthForComponent: (NSInteger) component
{
  return [OMBMapFilterRentCell widthForTextField];
}

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewWillBeginDragging: (UIScrollView *) scrollView
{
  if (scrollView == self.table) {
    [self done];
  }
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Neighborhood
  // Price Range
  // Bedrooms
  // Bathrooms
  // Move in Date
  // Month Term
  // Type of Place
  if (tableView == self.table) {
    return 4;
  }
  else if (tableView == neighborhoodTableView) {
    return 1;
  }
  return 0;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (tableView == self.table) {
    static NSString *HeaderCellIdentifier = @"HeaderCellIdentifier";
    UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:
      HeaderCellIdentifier];
    if (!headerCell)
      headerCell = [[UITableViewCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: HeaderCellIdentifier];
    headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    headerCell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
      size: 15];
    headerCell.textLabel.textColor = [UIColor textColor];
    if (indexPath.section == 0) {
      if (indexPath.row == 0) {
        headerCell.textLabel.text = @"Neighborhood";
      }
      else if (indexPath.row == 1) {
        static NSString *NeighborhoodCellIdentifier = 
          @"NeighborhoodCellIdentifier";
        OMBMapFilterNeighborhoodCell *cell = 
          [tableView dequeueReusableCellWithIdentifier: 
            NeighborhoodCellIdentifier];
        if (!cell)
          cell = [[OMBMapFilterNeighborhoodCell alloc] initWithStyle:
            UITableViewCellStyleDefault reuseIdentifier: 
              NeighborhoodCellIdentifier];
        return cell;
      }
    }
    if (indexPath.section == 1) {
      if (indexPath.row == 0) {
        headerCell.textLabel.text = @"Rent";
      }
      else if (indexPath.row == 1) {
        static NSString *RentCellIdentifier = @"RentCellIdentifier";
        OMBMapFilterRentCell *cell = 
          [tableView dequeueReusableCellWithIdentifier: RentCellIdentifier];
        if (!cell)
          cell = [[OMBMapFilterRentCell alloc] initWithStyle:
            UITableViewCellStyleDefault reuseIdentifier: 
              RentCellIdentifier];
        return cell;
      }
    }
    if (indexPath.section == 2) {
      if (indexPath.row == 0) {
        headerCell.textLabel.text = @"Bedrooms";
      }
      else if (indexPath.row == 1) {
        static NSString *BedroomsCellIdentifier = 
          @"BedroomsCellIdentifier";
        OMBMapFilterBedroomsCell *cell = 
          [tableView dequeueReusableCellWithIdentifier: 
            BedroomsCellIdentifier];
        if (!cell)
          cell = [[OMBMapFilterBedroomsCell alloc] initWithStyle:
            UITableViewCellStyleDefault reuseIdentifier: 
              BedroomsCellIdentifier];
        return cell;
      }
    }
    if (indexPath.section == 3) {
      if (indexPath.row == 0) {
        headerCell.textLabel.text = @"Bathrooms";
      }
      else if (indexPath.row == 1) {
        static NSString *BathroomsCellIdentifier = 
          @"BathroomsCellIdentifier";
        OMBMapFilterBathroomsCell *cell = 
          [tableView dequeueReusableCellWithIdentifier: 
            BathroomsCellIdentifier];
        if (!cell)
          cell = [[OMBMapFilterBathroomsCell alloc] initWithStyle:
            UITableViewCellStyleDefault reuseIdentifier: 
              BathroomsCellIdentifier];
        return cell;
      }
    }
    return headerCell;
  }
  else if (tableView == neighborhoodTableView) {
    static NSString *NeighborhoodNameCellIdentifier = 
      @"NeighborhoodNameCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
      NeighborhoodNameCellIdentifier];
    if (!cell)
      cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
        reuseIdentifier: NeighborhoodNameCellIdentifier];
    OMBNeighborhood *neighborhood = 
      [[[OMBNeighborhoodStore sharedStore] sortedNeighborhoods] objectAtIndex:
        indexPath.row];
    if (selectedNeighborhood == neighborhood) {
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
      cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
      size: 15];
    cell.textLabel.text= [neighborhood nameTitle];
    cell.textLabel.textColor = [UIColor textColor];
    return cell;
  }
  return [[UITableViewCell alloc] init];
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  if (tableView == self.table) {
    return 2;
  }
  if (tableView == neighborhoodTableView) {
    return [[[OMBNeighborhoodStore sharedStore] sortedNeighborhoods] count];
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (tableView == self.table) {
    // Neighborhoods
    if (indexPath.section == 0 && indexPath.row == 1) {
      [self.table scrollToRowAtIndexPath: 
        [NSIndexPath indexPathForRow: 0 inSection: indexPath.section] 
          atScrollPosition: UITableViewScrollPositionTop animated: YES];
      [self hidePickerView];
      [self showNeighborhoodTableViewContainer];
    }
    // Rent
    else if (indexPath.section == 1 && indexPath.row == 1) {
      [self.table scrollToRowAtIndexPath: 
        [NSIndexPath indexPathForRow: 0 inSection: indexPath.section] 
          atScrollPosition: UITableViewScrollPositionTop animated: YES];
      [self hideNeighborhoodTableViewContainer];
      [self showPickerView];
    }
  }
  else if (tableView == neighborhoodTableView) {
    OMBNeighborhood *neighborhood = 
      [[[OMBNeighborhoodStore sharedStore] sortedNeighborhoods] objectAtIndex:
        indexPath.row];
    if (selectedNeighborhood == neighborhood) {
      selectedNeighborhood = nil;
    }
    else {
      selectedNeighborhood = 
        [[[OMBNeighborhoodStore sharedStore] sortedNeighborhoods] objectAtIndex:
          indexPath.row];
    }
    OMBMapFilterNeighborhoodCell *cell = (OMBMapFilterNeighborhoodCell *)
      [self.table cellForRowAtIndexPath: 
        [NSIndexPath indexPathForRow: 1 inSection: 0]];
    NSString *string = @"";
    if (selectedNeighborhood) {
      string = [selectedNeighborhood nameTitle];
    }    
    cell.neighborhoodTextField.text = string;
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    [tableView reloadData];
    [self done]; 
  }
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat standardHeight = 44.0f;
  CGFloat padding = 20.0f;
  if (tableView == self.table) {
    if (indexPath.section == 2 && indexPath.row == 1 ||
      indexPath.section == 3 && indexPath.row == 1) {
      return (padding * 0.5) + 58.0f + (padding * 0.5);
    }
    // Header labels
    if (indexPath.row == 0) {
      return standardHeight;
    }
    else if (indexPath.row == 1) {
      return (padding * 0.25) + standardHeight + (padding * 0.1);
    }
  }
  if (tableView == neighborhoodTableView) {
    return standardHeight;
  }
  return 0.0f;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancel
{
  [self dismissViewControllerWithCompletion: ^{
    // Neighborhood
    OMBMapFilterNeighborhoodCell *neighborhoodCell = 
      (OMBMapFilterNeighborhoodCell *) [self.table cellForRowAtIndexPath: 
        [NSIndexPath indexPathForRow: 1 inSection: 0]];
    neighborhoodCell.neighborhoodTextField.text = @"";
    // Clear rent
    OMBMapFilterRentCell *rentCell = (OMBMapFilterRentCell *)
      [self.table cellForRowAtIndexPath:
        [NSIndexPath indexPathForRow: 1 inSection: 1]];
    rentCell.minRentTextField.text = rentCell.maxRentTextField.text = @"";
    [rentPickerView selectRow: 0 inComponent: 0 animated: NO];
    [rentPickerView selectRow: 0 inComponent: 1 animated: NO];
    // Clear the bedroom buttons
    OMBMapFilterBedroomsCell *bedroomsCell = (OMBMapFilterBedroomsCell *)
      [self.table cellForRowAtIndexPath: 
        [NSIndexPath indexPathForRow: 1 inSection: 2]];
    [bedroomsCell deselectAllButtons];
    // Clear the bathrooms
    OMBMapFilterBathroomsCell *bathroomsCell = (OMBMapFilterBathroomsCell *)
      [self.table cellForRowAtIndexPath:
        [NSIndexPath indexPathForRow: 1 inSection: 3]];
    [bathroomsCell deselectAllButtons];
  }];
}

- (void) dismissViewControllerWithCompletion: (void (^)(void)) block
{
  // Show the filter label with what filters were applied
  // [_mapViewController updateFilterLabel];
  // Tells the map that region did change so that it fetches the properties
  // [_mapViewController refreshProperties];

  [self dismissViewControllerAnimated: YES completion: ^{
    // [self hideDropdownLists];
    if (block)
      block();
    [self done];
  }];
}

- (void) done
{
  [self hideNeighborhoodTableViewContainer];
  [self hidePickerView];
}

- (void) hideNeighborhoodTableViewContainer
{
  CGRect rect = neighborhoodTableViewContainer.frame;
  rect.origin.y = self.view.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 0.0f;
    neighborhoodTableViewContainer.frame = rect;
  }];
  [self showSearchBarButtonItem];
}

- (void) hidePickerView
{
  CGRect rect = rentPickerView.frame;
  rect.origin.y = self.view.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    pickerViewBackground.frame = rentPickerView.frame = rect;
  }];
  [self showSearchBarButtonItem];
}

- (void) search
{
  [self dismissViewControllerWithCompletion: nil];
}

- (void) showDoneBarButtonItem
{
  [self.navigationItem setRightBarButtonItem: doneBarButtonItem animated: YES];
}

- (void) showNeighborhoodTableViewContainer
{
  CGRect rect = neighborhoodTableViewContainer.frame;
  rect.origin.y = self.view.frame.size.height -
    neighborhoodTableViewContainer.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 1.0f;
    neighborhoodTableViewContainer.frame = rect;
  }];
  [self showDoneBarButtonItem];
}

- (void) showPickerView
{
  CGRect rect = rentPickerView.frame;
  rect.origin.y = self.view.frame.size.height -
    rentPickerView.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    pickerViewBackground.frame = rentPickerView.frame = rect;
  }];
  [self showDoneBarButtonItem];
}

- (void) showSearchBarButtonItem
{
  [self.navigationItem setRightBarButtonItem: searchBarButtonItem
    animated: YES];
}

@end
