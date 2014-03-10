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
#import "OMBMapFilterDateAvailableCell.h"
#import "OMBNeighborhood.h"
#import "OMBNeighborhoodStore.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"

@interface OMBMapFilterViewController ()
{
	NSString *minRentString;
	NSString *maxRentString;
}

@end

@implementation OMBMapFilterViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  calendar = [NSCalendar currentCalendar];

  // Location manager
  locationManager                 = [[CLLocationManager alloc] init];
  locationManager.delegate        = self;
  locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  locationManager.distanceFilter  = 50;

  [self resetValuesDictionary];

  self.title = @"Filter";
  
  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  // Any, 500... 7500+
  rentPickerViewRows = 8000 / 500;

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
  UIFont *boldFont = [UIFont boldSystemFontOfSize: 17];
  [searchBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
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
      action: @selector(hidePickerView)];
  [fadedBackground addGestureRecognizer: tapGesture];

  neighborhoodTableViewContainer = [[UIView alloc] init];
  neighborhoodTableViewContainer.frame = CGRectMake(0.0f, 
    screenHeight, screenWidth, screenHeight * 0.6);
  [self.view addSubview: neighborhoodTableViewContainer];

  // Header for the neighborhood table view
  AMBlurView *headerView = [[AMBlurView alloc] init];
  headerView.blurTintColor = [UIColor grayLight];
  headerView.frame = CGRectMake(0.0f, 0.0f, 
    neighborhoodTableViewContainer.frame.size.width, OMBStandardHeight);
  [neighborhoodTableViewContainer addSubview: headerView];
  UILabel *headerLabel = [[UILabel alloc] init];
  headerLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  headerLabel.frame = CGRectMake(0.0f, 0.0f, 
    headerView.frame.size.width, headerView.frame.size.height);
  headerLabel.text = @"School or Neighborhood";
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
    neighborhoodTableView.frame.size.width, OMBStandardHeight);
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
  pickerViewContainer = [UIView new];
  [self.view addSubview: pickerViewContainer];

  // Header for rent picker view with cancel and done button
  AMBlurView *pickerViewHeader = [[AMBlurView alloc] init];
  pickerViewHeader.blurTintColor = [UIColor grayLight];
  pickerViewHeader.frame = CGRectMake(0.0f, 0.0f,
    self.view.frame.size.width, OMBStandardHeight);
	[pickerViewContainer addSubview:pickerViewHeader];
	
  // Header label
  pickerViewHeaderLabel = [UILabel new];
  pickerViewHeaderLabel.font = headerLabel.font;
  pickerViewHeaderLabel.frame = pickerViewHeader.frame;
  pickerViewHeaderLabel.text = @"";
  pickerViewHeaderLabel.textAlignment = headerLabel.textAlignment;
  pickerViewHeaderLabel.textColor = headerLabel.textColor;
  [pickerViewHeader addSubview: pickerViewHeaderLabel];
  // Cancel button
  UIButton *rentCancelButton = [UIButton new];
  rentCancelButton.titleLabel.font = neighborhoodCancelButton.titleLabel.font;
  rentCancelButton.frame = neighborhoodCancelButton.frame;
  [rentCancelButton addTarget: self
    action: @selector(cancelPicker)
      forControlEvents: UIControlEventTouchUpInside];
  [rentCancelButton setTitle: @"Cancel" forState: UIControlStateNormal];
  [rentCancelButton setTitleColor: [UIColor blueDark] 
    forState: UIControlStateNormal];
  [pickerViewHeader addSubview: rentCancelButton];
  // Done button
  UIButton *rentDoneButton = [UIButton new];
  rentDoneButton.titleLabel.font = rentCancelButton.titleLabel.font;
  CGRect rentDoneButtonRect = [@"Done" boundingRectWithSize:
    CGSizeMake(pickerViewHeader.frame.size.width,
      pickerViewHeader.frame.size.height)
        font: rentDoneButton.titleLabel.font];
  rentDoneButton.frame = CGRectMake(pickerViewHeader.frame.size.width -
    (padding + rentDoneButtonRect.size.width), 0.0f,
      rentDoneButtonRect.size.width, pickerViewHeader.frame.size.height);
  [rentDoneButton addTarget: self 
    action: @selector(done) 
      forControlEvents: UIControlEventTouchUpInside];
  [rentDoneButton setTitle: @"Done" forState: UIControlStateNormal];
  [rentDoneButton setTitleColor: [UIColor blueDark] 
    forState: UIControlStateNormal];
  [pickerViewHeader addSubview: rentDoneButton];

  // Rent scroller
  rentPickerView = [[UIPickerView alloc] init];
  rentPickerView.backgroundColor = [UIColor whiteColor];
  rentPickerView.dataSource = self;
  rentPickerView.delegate   = self;
	minRentString = [self pickerView:rentPickerView titleForRow:0 forComponent:0];
	maxRentString = [self pickerView:rentPickerView titleForRow:([self pickerView:rentPickerView numberOfRowsInComponent:1]-1) forComponent:1];
	[rentPickerView selectRow: 0 inComponent: 0 animated: NO];
    [rentPickerView selectRow:([self pickerView:rentPickerView numberOfRowsInComponent:1]-1) inComponent: 1 animated: NO];
  rentPickerView.frame = CGRectMake(0.0f,
    pickerViewHeader.frame.origin.y +
    pickerViewHeader.frame.size.height,
      rentPickerView.frame.size.width, rentPickerView.frame.size.height);
  UILabel *hyphenLabel = [[UILabel alloc] init];
  hyphenLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 18];
  float sizeHyphen = 70.f;
  hyphenLabel.frame = CGRectMake((rentPickerView.frame.size.width - sizeHyphen) * 0.5f, (rentPickerView.frame.size.height - sizeHyphen) * 0.5f,
                            sizeHyphen, sizeHyphen);
  hyphenLabel.text = @"-";
  hyphenLabel.textAlignment = NSTextAlignmentCenter;
  hyphenLabel.textColor = [UIColor textColor];
  [rentPickerView addSubview:hyphenLabel];
  
	// Date Available scroller
	availabilityPickerView = [[UIPickerView alloc] init];
	availabilityPickerView.backgroundColor = [UIColor whiteColor];
	availabilityPickerView.dataSource = self;
	availabilityPickerView.delegate = self;
	availabilityPickerView.frame = rentPickerView.frame;
	
  pickerViewContainer.frame = CGRectMake(0.0f, self.view.frame.size.height,
    rentPickerView.frame.size.width, 
      pickerViewHeader.frame.size.height +
      rentPickerView.frame.size.height);
}

- (void) viewWillAppear: (BOOL) animated
{
  moveInDates = [NSMutableDictionary dictionary];

  NSUInteger unitFlags = (NSDayCalendarUnit | NSMonthCalendarUnit | 
    NSWeekdayCalendarUnit | NSYearCalendarUnit);
  NSDate *today = [NSDate date];

  // Testing
  // NSDateComponents *c = [NSDateComponents new];
  // [c setDay: 1];
  // [c setMonth: 11];
  // [c setYear: 2014];
  // today = [calendar dateFromComponents: c];

  NSDateComponents *todayComps = [calendar components: unitFlags
    fromDate: today];
  NSInteger startMonth = ([todayComps month] - 1) / 3;
  startMonth = (startMonth * 3) + 1;
  NSInteger startYear = [todayComps year];

  NSInteger stepMonth = 3;
  for (int i = 0; i < 4; i++) {
    NSDateComponents *comps = [NSDateComponents new];
    [comps setDay: 1];
    NSInteger month = startMonth + (i * stepMonth);
    NSInteger year  = startYear;
    if (month > 12) {
      year  = startYear + (month / 12);
      month = month % 12;
    }
    [comps setMonth: month];
    [comps setYear: year];

    NSString *season;
    if ([comps month] < 4)
      season = @"winter";
    else if ([comps month] < 7)
      season = @"spring";
    else if ([comps month] < 10)
      season = @"summer";
    else
      season = @"fall";
    NSString *string = [NSString stringWithFormat: @"%@ %i",
      [season capitalizedString], [comps year]];
    [moveInDates setObject: [calendar dateFromComponents: comps]
      forKey: string];
  }
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

#pragma mark - Protocol UIPickerViewDataSource

- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView
{
	if (pickerView == rentPickerView)
	{
		return 2;
	}
	else if (pickerView == availabilityPickerView)
	{
		return 1;
	}
	return 0;
}

- (NSInteger) pickerView: (UIPickerView *) pickerView 
numberOfRowsInComponent: (NSInteger) component
{
	if (pickerView == rentPickerView)
	{
		// Any, 500, ... 7,500+
		return rentPickerViewRows;
	}
	else if (pickerView == availabilityPickerView)
	{
		// Immediately, Fall, Spring, Winter, Summer
		// return 5;
    return [moveInDates count];
	}
	return 0;
}

#pragma mark - Protocol UIPickerViewDelegate

- (void) pickerView: (UIPickerView *) pickerView didSelectRow: (NSInteger) row 
inComponent: (NSInteger) component
{
	if (pickerView == rentPickerView)
	{
		OMBMapFilterRentCell *cell = (OMBMapFilterRentCell *)
		[self.table cellForRowAtIndexPath:
		 [NSIndexPath indexPathForRow: 1 inSection: 1]];
		NSString *string = [self pickerView: pickerView titleForRow: row
							   forComponent: component];
		if (component == 0) {
			minRentString = string;
			[_valuesDictionary setObject: [NSNumber numberWithInt: 500 * row]
								  forKey: @"minRent"];
		}
		else if (component == 1) {
			maxRentString = string;
			[_valuesDictionary setObject: [NSNumber numberWithInt: 500 * row]
								  forKey: @"maxRent"];
		}
		cell.rentRangeTextField.text = [NSString stringWithFormat:@"%@ - %@", minRentString, maxRentString];
	}
	else if (pickerView == availabilityPickerView)
	{
		OMBMapFilterDateAvailableCell *cell = (OMBMapFilterDateAvailableCell *)
		  [self.table cellForRowAtIndexPath:
		    [NSIndexPath indexPathForRow:1 inSection: 5]];
    cell.dateAvailable.text = [self moveInDateStringAtIndex: row];
    [_valuesDictionary setObject: 
      [[self moveInDatesSortedArray] objectAtIndex: row] 
        forKey: @"moveInDate"];
		// NSString *string = [self pickerView: pickerView titleForRow: row
		// 					   forComponent: component];
		// cell.dateAvailable.text = string;
		// [_valuesDictionary setObject:string
		// 					  forKey:@"dateAvailable"];
	}
}

- (CGFloat) pickerView: (UIPickerView *) pickerView 
rowHeightForComponent: (NSInteger) component
{
  return 44.0f;
}

- (NSString *) pickerView: (UIPickerView *) pickerView
			  titleForRow: (NSInteger) row
			 forComponent: (NSInteger) component
{
	if (pickerView == rentPickerView)
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
	else if (pickerView == availabilityPickerView) {
		// switch (row)
		// {
		// 	case 0: return @"Immediately";
		// 	case 1: return @"Winter '14 (Jan - Mar)";
		// 	case 2: return @"Spring '14 (Apr - June)";
		// 	case 3: return @"Summer '14 (July - Sept)";
		// 	case 4: return @"Fall '14 (Oct - Dec)";
		// 	default: break;
		// }

    // return [[self moveInDatesStringArray] objectAtIndex: row];

    return [self moveInDateStringAtIndex: row];
	}
	
  return nil;
}

- (CGFloat) pickerView: (UIPickerView *) pickerView 
widthForComponent: (NSInteger) component
{
	if (pickerView == rentPickerView)
	{
		return [OMBMapFilterRentCell widthForTextField];
	}
	else if (pickerView == availabilityPickerView)
	{
		return pickerView.bounds.size.width - 40.0f;
	}
	return 0;
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
	// DateAvailable
  if (tableView == self.table) {
    return 6;
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
        headerCell.textLabel.text = @"Choose Location";
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
        cell.delegate = self;
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
        cell.delegate = self;
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
	  // Date Available
	else if (indexPath.section == 5) {
		if (indexPath.row == 0) {
			headerCell.textLabel.text = @"Date Available";
		}
		else if (indexPath.row == 1) {
			static NSString *PropertyTypeCellIdentifier =
			@"DateAvailableCellIdentifier";
			OMBMapFilterDateAvailableCell *cell =
        [tableView dequeueReusableCellWithIdentifier: 
          PropertyTypeCellIdentifier];
			if (!cell)
				cell = [[OMBMapFilterDateAvailableCell alloc] initWithStyle:
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
    cell.textLabel.text = neighborhood.name;
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
  // The normal table with all the rows of filter options
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
		[self showPickerView: rentPickerView];
    }
  // Date available
	else if (indexPath.section == 5 && indexPath.row == 1) {
		[self.table scrollToRowAtIndexPath:
		 [NSIndexPath indexPathForRow: 0 inSection: indexPath.section]
						  atScrollPosition: UITableViewScrollPositionTop animated: YES];
		[self hideNeighborhoodTableViewContainer];
		[self showPickerView:availabilityPickerView];
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
      string = selectedNeighborhood.name;
    }    
    cell.neighborhoodTextField.text = string;
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    [tableView reloadData];

    if (selectedNeighborhood) {
      [_valuesDictionary setObject: selectedNeighborhood
        forKey: @"neighborhood"];
    }
    else
      [_valuesDictionary setObject: @"" forKey: @"neighborhood"];

    [self done];
  }
}

- (CGFloat) tableView: (UITableView *) tableView 
heightForHeaderInSection: (NSInteger) section
{
  if (tableView == neighborhoodTableView) {
    return 13.0f * 2;
  }
  else if (tableView == self.table) {
    // Property Type
    if (section == 4)
      return 0.0f;
  }
  return 0.0f;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat standardHeight = 44.0f; 
  if (tableView == self.table) {
    // Property Type
    if (indexPath.section == 4)
      return 0.0f;
    
    // Date Available
    if (indexPath.section == 5)
      return 0.0f;

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
      tableView.frame.size.width, 13.0f * 2);
    UILabel *label = [UILabel new];
    label.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 13];
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
  _shouldSearch = NO;
  if ([_valuesDictionary objectForKey: @"bathrooms"] != [NSNull null])
    _shouldSearch = YES;
  else if ([[_valuesDictionary objectForKey: @"bedrooms"] count] > 0)
    _shouldSearch = YES;
  else if ([_valuesDictionary objectForKey: @"maxRent"] != [NSNull null])
    _shouldSearch = YES;
  else if ([_valuesDictionary objectForKey: @"minRent"] != [NSNull null])
    _shouldSearch = YES;
  else if ([_valuesDictionary objectForKey: @"neighborhood"] != [NSNull null])
    _shouldSearch = YES;
  else if ([[_valuesDictionary objectForKey: @"propertyType"] count] > 0)
    _shouldSearch = YES;
	else if ([_valuesDictionary objectForKey:@"moveInDate"] != [NSNull null])
		_shouldSearch = YES;

  [self resetValuesDictionary];

  [self dismissViewControllerWithCompletion: ^{
    // Neighborhood
    OMBMapFilterNeighborhoodCell *neighborhoodCell = 
      (OMBMapFilterNeighborhoodCell *) [self.table cellForRowAtIndexPath: 
        [NSIndexPath indexPathForRow: 1 inSection: 0]];
    neighborhoodCell.neighborhoodTextField.text = @"";
    selectedNeighborhood = nil;
    [neighborhoodTableView reloadData];
    // Clear rent
    OMBMapFilterRentCell *rentCell = (OMBMapFilterRentCell *)
      [self.table cellForRowAtIndexPath:
        [NSIndexPath indexPathForRow: 1 inSection: 1]];
    rentCell.rentRangeTextField.text = @"";
    [rentPickerView selectRow: 0 inComponent: 0 animated: NO];
    [rentPickerView selectRow:([self pickerView:rentPickerView numberOfRowsInComponent:1]-1) inComponent: 1 animated: NO];
	  
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
	  // Date Available
	  OMBMapFilterDateAvailableCell *dateAvailableCell = (OMBMapFilterDateAvailableCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:5]];
	  dateAvailableCell.dateAvailable.text = @"";
	  [availabilityPickerView selectRow: 0 inComponent: 0 animated: NO];
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

- (void) cancelPicker
{
	if ([rentPickerView superview]) {
		OMBMapFilterRentCell *cell = (OMBMapFilterRentCell *)
		  [self.table cellForRowAtIndexPath:
		    [NSIndexPath indexPathForRow: 1 inSection: 1]];
		cell.rentRangeTextField.text = @"";
		[rentPickerView selectRow: 0 inComponent: 0 animated: YES];
		[rentPickerView selectRow: 0 inComponent: 1 animated: YES];
    [_valuesDictionary setObject: [NSNull null] forKey: @"rentRange"];
	}
	else if ([availabilityPickerView superview]) {
		OMBMapFilterDateAvailableCell *cell = (OMBMapFilterDateAvailableCell *)
		  [self.table cellForRowAtIndexPath: 
        [NSIndexPath indexPathForRow: 1 inSection: 5]];
		cell.dateAvailable.text = @"";
		[availabilityPickerView selectRow: 0 inComponent: 0 animated: YES];
    [_valuesDictionary setObject: [NSNull null] forKey: @"moveInDate"];
	}
	
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
  [self hidePickerView];

  // Select what is there already if they did move the scroller
  // but they clicked done
  // Rent
  if ([rentPickerView superview]) {
    // Min rent
    if ([_valuesDictionary objectForKey: @"minRent"] == [NSNull null]) {
      [self pickerView: rentPickerView didSelectRow: 0 inComponent: 0];
    }
    // Max rent
    if ([_valuesDictionary objectForKey: @"maxRent"] == [NSNull null]) {
      [self pickerView: rentPickerView didSelectRow: rentPickerViewRows - 1
        inComponent: 1];
    }
  }
  // Dates Available
  else if ([availabilityPickerView superview]) {
    if ([_valuesDictionary objectForKey: @"moveInDate"] == [NSNull null])
      [self pickerView: availabilityPickerView didSelectRow: 0 
        inComponent: 0];
  }
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
    [_valuesDictionary setObject: neighborhood forKey: @"neighborhood"];
  }
  [locationManager stopUpdatingLocation];
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
  [self hideNeighborhoodTableViewContainer];
  CGRect rect = pickerViewContainer.frame;
  rect.origin.y = self.view.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 0.0f;
    pickerViewContainer.frame = rect;
  }];
  [self showSearchBarButtonItem];
}

- (NSArray *) moveInDatesSortedArray
{
  return [[moveInDates allValues] sortedArrayUsingComparator: 
    ^(id obj1, id obj2) {
      return [obj1 compare: obj2];
    }
  ];
}

- (NSArray *) moveInDatesStringArray
{
  NSMutableArray *arrayDates = [NSMutableArray array];
  NSMutableArray *arrayStrings = [NSMutableArray array];
  for (NSString *key in [moveInDates allKeys]) {
    NSDate *date = [moveInDates objectForKey: key];
    NSDate *lastDate = [arrayDates lastObject];
    NSLog(@"LAST DATE: %@", lastDate);
    NSLog(@"DATE: %@",      date);

    if (lastDate) {
      // Last date is earlier than date
      if ([lastDate compare: date] == NSOrderedAscending) {
        [arrayDates addObject: date];
        [arrayStrings addObject: key];
      }
      // Last date is later than date
      else if ([lastDate compare: date] == NSOrderedDescending) {
        NSInteger index = [arrayDates indexOfObject: lastDate];
        [arrayDates insertObject: date atIndex: index];
        [arrayStrings insertObject: key atIndex: index];
      }
    }
    else {
      [arrayDates addObject: date];
      [arrayStrings addObject: key];
    }
    NSLog(@"%@", arrayDates);
  }
  return (NSArray *) arrayStrings;
}

- (NSString *) moveInDateStringAtIndex: (NSInteger) index
{
  NSUInteger unitFlags = (NSDayCalendarUnit | NSMonthCalendarUnit | 
    NSWeekdayCalendarUnit | NSYearCalendarUnit);
  NSDateComponents *comps = [calendar components: unitFlags
    fromDate: [[self moveInDatesSortedArray] objectAtIndex: index]];
  NSString *season;
  if ([comps month] < 4)
    season = @"winter";
  else if ([comps month] < 7)
    season = @"spring";
  else if ([comps month] < 10)
    season = @"summer";
  else
    season = @"fall";
  return [NSString stringWithFormat: @"%@ %i",
    [season capitalizedString], [comps year]];
}

- (void) resetValuesDictionary
{
  _valuesDictionary = [NSMutableDictionary dictionaryWithDictionary: 
    @{
      @"bathrooms":    [NSNull null],
      @"bedrooms":     [NSMutableArray array],
      @"maxRent":      [NSNull null],
      @"minRent":      [NSNull null],
      @"neighborhood": [NSNull null],
      @"propertyType": [NSMutableArray array],
      @"moveInDate": [NSNull null]
	  // @"dateAvailable":[NSNull null]
    }
  ];
}

- (void) search
{
  _shouldSearch = YES;
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

- (void) showPickerView:(UIPickerView *)pickerView
{
	if (rentPickerView == pickerView) {
		pickerViewHeaderLabel.text = @"Rent Range";
		
		[availabilityPickerView removeFromSuperview];
		[pickerViewContainer addSubview:rentPickerView];
	}
	else if (availabilityPickerView == pickerView) {
		pickerViewHeaderLabel.text = @"Date Available";
		
		[rentPickerView removeFromSuperview];
		[pickerViewContainer addSubview:availabilityPickerView];
	}
	
  CGRect rect = pickerViewContainer.frame;
  rect.origin.y = self.view.frame.size.height -
    pickerViewContainer.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 1.0f;
    pickerViewContainer.frame = rect;
  }];
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
  selectedNeighborhood = nil;
  [neighborhoodTableView reloadData];
  [locationManager startUpdatingLocation];
}

@end
