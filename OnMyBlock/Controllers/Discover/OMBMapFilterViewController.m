//
//  OMBMapFilterViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/20/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMapFilterViewController.h"

#import "AMBlurView.h"
#import "NSString+Extensions.h"
#import "OMBMapFilterBathroomsCell.h"
#import "OMBMapFilterBedroomsCell.h"
#import "OMBMapFilterNeighborhoodCell.h"
#import "OMBMapFilterPropertyTypeCell.h"
#import "OMBMapFilterRentCell.h"
#import "OMBNeighborhood.h"
#import "OMBNeighborhoodStore.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"

float kStandardHeight = 44.0f;

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

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth = screen.size.width;
  CGFloat padding = 20.0f;

  self.table.backgroundColor = [UIColor grayUltraLight];
  self.table.separatorInset  = UIEdgeInsetsMake(0.0f, padding, 0.0f, 0.0f);
  self.table.tableFooterView = [[UIView alloc] initWithFrame: 
    CGRectMake(0.0f, 0.0f, screenWidth, padding)];

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

  // Header for the neighborhood table view
  AMBlurView *headerView = [[AMBlurView alloc] init];
  headerView.blurTintColor = [UIColor blueLight];
  headerView.frame = CGRectMake(0.0f, 0.0f, 
    neighborhoodTableViewContainer.frame.size.width, kStandardHeight);
  [neighborhoodTableViewContainer addSubview: headerView];
  UILabel *headerLabel = [[UILabel alloc] init];
  headerLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  headerLabel.frame = CGRectMake(0.0f, 0.0f, 
    headerView.frame.size.width, headerView.frame.size.height);
  headerLabel.text = @"Select neighborhood";
  headerLabel.textAlignment = NSTextAlignmentCenter;
  headerLabel.textColor = [UIColor textColor];
  [headerView addSubview: headerLabel];
  // Cancel button
  UIButton *neighborhoodCancelButton = [UIButton new];
  neighborhoodCancelButton.titleLabel.font = [UIFont fontWithName: 
    @"HelveticaNeue-Medium" size: 15];
  CGRect neighborhoodCancelButtonRect = [@"Cancel" boundingRectWithSize:
    CGSizeMake(headerView.frame.size.width, headerView.frame.size.height)
      font: neighborhoodCancelButton.titleLabel.font];
  neighborhoodCancelButton.frame = CGRectMake(padding, 0.0f,
    neighborhoodCancelButtonRect.size.width, headerView.frame.size.height);
  [neighborhoodCancelButton addTarget: self 
    action: @selector(cancelSelectNeighborhood) 
      forControlEvents: UIControlEventTouchUpInside];
  [neighborhoodCancelButton setTitle: @"Cancel" forState: UIControlStateNormal];
  [neighborhoodCancelButton setTitleColor: [UIColor blueDark] 
    forState: UIControlStateNormal];
  [headerView addSubview: neighborhoodCancelButton];

  // Neighborhood selection
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
  neighborhoodTableView.separatorInset = UIEdgeInsetsMake(0.0f, padding, 
    0.0f, 0.0f);
  // Header view
  UIView *neighborhoodTableHeaderView = [UIView new];
  neighborhoodTableHeaderView.frame = CGRectMake(0.0f, 0.0f, 
    neighborhoodTableView.frame.size.width, kStandardHeight);
  neighborhoodTableView.tableHeaderView = neighborhoodTableHeaderView;
  // Label
  UILabel *currentLocationLabel = [UILabel new];
  currentLocationLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
    size: 15];
  currentLocationLabel.frame = CGRectMake(padding, 0.0f,
    neighborhoodTableHeaderView.frame.size.width,
      neighborhoodTableHeaderView.frame.size.height);
  currentLocationLabel.text = @"User Current Location";
  currentLocationLabel.textColor = [UIColor blue];
  [neighborhoodTableHeaderView addSubview: currentLocationLabel];
  // Image view
  CGFloat imageSize = padding;
  UIImageView *headerImageView = [UIImageView new];
  headerImageView.frame = CGRectMake(
    neighborhoodTableHeaderView.frame.size.width - (imageSize + padding), 
      (neighborhoodTableHeaderView.frame.size.height - imageSize) * 0.5, 
        imageSize, imageSize);
  headerImageView.image = [UIImage imageNamed: @"gps_cursor_blue.png"];
  [neighborhoodTableHeaderView addSubview: headerImageView];
  // Current location button
  currentLocationButton = [UIButton new];
  currentLocationButton.frame = neighborhoodTableHeaderView.frame;
  [currentLocationButton addTarget: self action: @selector(userCurrentLocation)
    forControlEvents: UIControlEventTouchUpInside];
  [neighborhoodTableHeaderView addSubview: currentLocationButton];

  // Footer view
  neighborhoodTableView.tableFooterView = [[UIView alloc] initWithFrame:
    CGRectZero];
  [neighborhoodTableViewContainer addSubview: neighborhoodTableView];

  // Rent picker view container
  rentPickerViewContainer = [UIView new];
  [self.view addSubview: rentPickerViewContainer];

  // Header for rent picker view with cancel and done button
  AMBlurView *rentPickerViewHeader = [[AMBlurView alloc] init];
  rentPickerViewHeader.blurTintColor = [UIColor blueLight];
  rentPickerViewHeader.frame = CGRectMake(0.0f, 0.0f,
    self.view.frame.size.width, kStandardHeight);
  [rentPickerViewContainer addSubview: rentPickerViewHeader];
  // Header label
  UILabel *rentPickerViewHeaderLabel = [UILabel new];
  rentPickerViewHeaderLabel.font = headerLabel.font;
  rentPickerViewHeaderLabel.frame = rentPickerViewHeader.frame;
  rentPickerViewHeaderLabel.text = @"Rent Range";
  rentPickerViewHeaderLabel.textAlignment = headerLabel.textAlignment;
  rentPickerViewHeaderLabel.textColor = headerLabel.textColor;
  [rentPickerViewHeader addSubview: rentPickerViewHeaderLabel];
  // Cancel button
  UIButton *rentCancelButton = [UIButton new];
  rentCancelButton.titleLabel.font = neighborhoodCancelButton.titleLabel.font;
  rentCancelButton.frame = neighborhoodCancelButton.frame;
  [rentCancelButton addTarget: self
    action: @selector(cancelSelectRent) 
      forControlEvents: UIControlEventTouchUpInside];
  [rentCancelButton setTitle: @"Cancel" forState: UIControlStateNormal];
  [rentCancelButton setTitleColor: [UIColor blueDark] 
    forState: UIControlStateNormal];
  [rentPickerViewHeader addSubview: rentCancelButton];
  // Done button
  UIButton *rentDoneButton = [UIButton new];
  rentDoneButton.titleLabel.font = rentCancelButton.titleLabel.font;
  CGRect rentDoneButtonRect = [@"Done" boundingRectWithSize:
    CGSizeMake(rentPickerViewHeader.frame.size.width, 
      rentPickerViewHeader.frame.size.height)
        font: rentDoneButton.titleLabel.font];
  rentDoneButton.frame = CGRectMake(rentPickerViewHeader.frame.size.width - 
    (padding + rentDoneButtonRect.size.width), 0.0f,
      rentDoneButtonRect.size.width, rentPickerViewHeader.frame.size.height);
  [rentDoneButton addTarget: self 
    action: @selector(hidePickerView) 
      forControlEvents: UIControlEventTouchUpInside];
  [rentDoneButton setTitle: @"Done" forState: UIControlStateNormal];
  [rentDoneButton setTitleColor: [UIColor blueDark] 
    forState: UIControlStateNormal];
  [rentPickerViewHeader addSubview: rentDoneButton];

  // Rent scroller
  rentPickerView = [[UIPickerView alloc] init];
  rentPickerView.backgroundColor = [UIColor whiteColor];
  rentPickerView.dataSource = self;
  rentPickerView.delegate   = self;
  rentPickerView.frame = CGRectMake(0.0f, 
    rentPickerViewHeader.frame.origin.y + 
    rentPickerViewHeader.frame.size.height, 
      rentPickerView.frame.size.width, rentPickerView.frame.size.height);
  [rentPickerViewContainer addSubview: rentPickerView];
  
  rentPickerViewContainer.frame = CGRectMake(0.0f, self.view.frame.size.height,
    rentPickerView.frame.size.width, 
      rentPickerViewHeader.frame.size.height + 
      rentPickerView.frame.size.height);
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
  // Rent
  // Bedrooms
  // Bathrooms
  // Property Type
  if (tableView == self.table) {
    return 5;
  }
  else if (tableView == neighborhoodTableView) {
    return [[[OMBNeighborhoodStore sharedStore] cities] count];
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
    headerCell.backgroundColor = tableView.backgroundColor;
    headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    headerCell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
      size: 15];
    headerCell.textLabel.textAlignment = NSTextAlignmentCenter;
    headerCell.textLabel.textColor = [UIColor grayMedium];
    // Neighborhood
    if (indexPath.section == 0) {
      // Header
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
    // Rent
    else if (indexPath.section == 1) {
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
    // Bedrooms
    else if (indexPath.section == 2) {
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
    // Bathrooms
    else if (indexPath.section == 3) {
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
    // Property Type
    else if (indexPath.section == 4) {
      if (indexPath.row == 0) {
        headerCell.textLabel.text = @"Property Type";
      }
      else if (indexPath.row == 1) {
        static NSString *PropertyTypeCellIdentifier = 
          @"PropertyTypeCellIdentifier";
        OMBMapFilterPropertyTypeCell *cell = 
          [tableView dequeueReusableCellWithIdentifier: 
            PropertyTypeCellIdentifier];
        if (!cell)
          cell = [[OMBMapFilterPropertyTypeCell alloc] initWithStyle:
            UITableViewCellStyleDefault reuseIdentifier: 
              PropertyTypeCellIdentifier];
        return cell;
      }
    }
    return headerCell;
  }
  // Neighborhood slide up selection
  else if (tableView == neighborhoodTableView) {
    static NSString *NeighborhoodNameCellIdentifier = 
      @"NeighborhoodNameCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
      NeighborhoodNameCellIdentifier];
    if (!cell)
      cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
        reuseIdentifier: NeighborhoodNameCellIdentifier];
    NSString *city = 
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
  // Normal table with filter options
  if (tableView == self.table) {
    return 2;
  }
  // Neighborhood
  else if (tableView == neighborhoodTableView) {
    NSString *city = 
      [[[OMBNeighborhoodStore sharedStore] cities] objectAtIndex: section];
    NSArray *neighborhoods = 
      [[OMBNeighborhoodStore sharedStore] sortedNeighborhoodsForCity: city];
    return [neighborhoods count];
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
  // Neighborhood table view
  else if (tableView == neighborhoodTableView) {
    NSString *city = 
      [[[OMBNeighborhoodStore sharedStore] cities] objectAtIndex: 
        indexPath.section];
    NSArray *neighborhoods = 
      [[OMBNeighborhoodStore sharedStore] sortedNeighborhoodsForCity: city];
    OMBNeighborhood *neighborhood = 
      [neighborhoods objectAtIndex: indexPath.row];
    if (selectedNeighborhood == neighborhood) {
      selectedNeighborhood = nil;
    }
    else {
      selectedNeighborhood = [neighborhoods objectAtIndex: indexPath.row];
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
heightForHeaderInSection: (NSInteger) section
{
  if (tableView == neighborhoodTableView) {
    return kStandardHeight;
  }
  return 0.0f;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat standardHeight = 44.0f; 
  if (tableView == self.table) {    
    // Header labels
    if (indexPath.row == 0) {
      return standardHeight;
    }
    // Cells
    else if (indexPath.row == 1) {
      return standardHeight;
    }
  }
  if (tableView == neighborhoodTableView) {
    return standardHeight;
  }
  return 0.0f;
}

- (UIView *) tableView: (UITableView *) tableView 
viewForHeaderInSection: (NSInteger) section
{
  if (tableView == neighborhoodTableView) {
    AMBlurView *blur = [[AMBlurView alloc] init];
    blur.blurTintColor = [UIColor grayLight];
    blur.frame = CGRectMake(0.0f, 0.0f, 
      tableView.frame.size.width, kStandardHeight);
    UILabel *label = [UILabel new];
    label.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
    label.frame = blur.frame;
    label.text = [[[[OMBNeighborhoodStore sharedStore] cities] objectAtIndex: 
      section] capitalizedString];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayMedium];
    [blur addSubview: label];
    return blur;
  }
  return [[UIView alloc] initWithFrame: CGRectZero];
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
    [bedroomsCell resetButtons];
    // Clear the bathrooms
    OMBMapFilterBathroomsCell *bathroomsCell = (OMBMapFilterBathroomsCell *)
      [self.table cellForRowAtIndexPath:
        [NSIndexPath indexPathForRow: 1 inSection: 3]];
    [bathroomsCell resetButtons];
    // Property type
    OMBMapFilterPropertyTypeCell *propertyTypeCell = 
      (OMBMapFilterPropertyTypeCell *)
        [self.table cellForRowAtIndexPath: 
          [NSIndexPath indexPathForRow: 1 inSection: 4]];
    [propertyTypeCell resetButtons];
  }];
}

- (void) cancelSelectNeighborhood
{
  selectedNeighborhood = nil;
  OMBMapFilterNeighborhoodCell *cell = (OMBMapFilterNeighborhoodCell *)
    [self.table cellForRowAtIndexPath: 
      [NSIndexPath indexPathForRow: 1 inSection: 0]];
  cell.neighborhoodTextField.text = @"";
  [neighborhoodTableView reloadData];
  [self hideNeighborhoodTableViewContainer];
}

- (void) cancelSelectRent
{
  OMBMapFilterRentCell *cell = (OMBMapFilterRentCell *) 
    [self.table cellForRowAtIndexPath: 
      [NSIndexPath indexPathForRow: 1 inSection: 1]];
  cell.minRentTextField.text = cell.maxRentTextField.text = @"";
  [rentPickerView selectRow: 0 inComponent: 0 animated: YES];
  [rentPickerView selectRow: 0 inComponent: 1 animated: YES];
  [self hidePickerView];
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
  CGRect rect = rentPickerViewContainer.frame;
  rect.origin.y = self.view.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 0.0f;
    rentPickerViewContainer.frame = rect;
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
  // [self showDoneBarButtonItem];
}

- (void) showPickerView
{
  CGRect rect = rentPickerViewContainer.frame;
  rect.origin.y = self.view.frame.size.height -
    rentPickerViewContainer.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 1.0f;
    rentPickerViewContainer.frame = rect;
  }];
  // [self showDoneBarButtonItem];
}

- (void) showSearchBarButtonItem
{
  [self.navigationItem setRightBarButtonItem: searchBarButtonItem
    animated: YES];
}

- (void) userCurrentLocation
{
  // OMBNeighborhood *currentLocation = [[OMBNeighborhood alloc] init];
  // currentLocation.coordinate = CLLocationCoordinate2DMake(0, 0);
  // currentLocation.name       = @"current location";
  // Neighborhood
  OMBMapFilterNeighborhoodCell *neighborhoodCell = 
    (OMBMapFilterNeighborhoodCell *) [self.table cellForRowAtIndexPath: 
      [NSIndexPath indexPathForRow: 1 inSection: 0]];
  neighborhoodCell.neighborhoodTextField.text = @"Current Location";
  [self hideNeighborhoodTableViewContainer];
}

@end
