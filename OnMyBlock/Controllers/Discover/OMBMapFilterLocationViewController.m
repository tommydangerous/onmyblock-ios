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
 #import "TextFieldPadding.h"
 #import "UIColor+Extensions.h"
 #import "UIImage+Color.h"

 @interface OMBMapFilterLocationViewController ()
 <CLLocationManagerDelegate, SearchManagerDelegate, UISearchBarDelegate>
 {
   CLLocationManager *locationManager;
   NSMutableArray *neighborhoodArray;
   UISearchBar *searchBar;
 }

 @end

 @implementation OMBMapFilterLocationViewController

 #pragma mark - Initializer

 - (id) initWithSelectedNeighborhood:(OMBNeighborhood *) selectedNeighborhood
 {
   if (!(self = [super init])) {
     return nil;
   }

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
       style: UIBarButtonItemStylePlain
         target: self action: @selector(cancel)];

   // CGRect screen = [self screen];
   // CGFloat screenWidth = screen.size.width;
   CGFloat padding = OMBPadding;

   // Neighborhood table
   self.table.alwaysBounceVertical = YES;
   self.table.backgroundColor = [UIColor grayUltraLight];
   self.table.dataSource = self;
   self.table.delegate = self;
   self.table.separatorColor = [UIColor grayLight];
   self.table.separatorInset = UIEdgeInsetsMake(
     0.0f, padding, 0.0f, 0.0f);

   // Header view
   AMBlurView *neighborhoodTableHeaderView   = [AMBlurView new];
   neighborhoodTableHeaderView.blurTintColor = [UIColor grayLight];
   neighborhoodTableHeaderView.frame         = CGRectMake(
     0, 0, self.table.frame.size.width, OMBStandardHeight * 2
   );
   self.table.tableHeaderView = neighborhoodTableHeaderView;

   searchBar                        = [[UISearchBar alloc] init];
   searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
   searchBar.autocorrectionType     = UITextAutocorrectionTypeNo;
   searchBar.delegate               = self;
   searchBar.frame = CGRectMake(0, 0, 
     CGRectGetWidth(neighborhoodTableHeaderView.frame), OMBStandardHeight
   );
   searchBar.placeholder = @"Search school";
   searchBar.tintColor   = [UIColor blue];
   searchBar.translucent = YES;
   [neighborhoodTableHeaderView addSubview:searchBar];

   // Label
   UIButton *currentLocationButton = [UIButton new];
   currentLocationButton.backgroundColor = [UIColor whiteColor];
   currentLocationButton.frame = CGRectMake(0.0f,
     searchBar.frame.origin.y + searchBar.frame.size.height,
       neighborhoodTableHeaderView.frame.size.width,
         OMBStandardHeight);
   currentLocationButton.titleLabel.font = [UIFont normalTextFontBold];
   [currentLocationButton addTarget: self
     action: @selector(useCurrentLocation)
       forControlEvents: UIControlEventTouchUpInside];
   [currentLocationButton setTitle: @"Use My Current Location"
     forState:UIControlStateNormal];
   [currentLocationButton setTitleColor: [UIColor blue]
     forState: UIControlStateNormal];
   [neighborhoodTableHeaderView addSubview: currentLocationButton];

   neighborhoodArray = [NSMutableArray array];
  
   // Footer view
   self.table.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
 }

 - (void)viewWillAppear:(BOOL)animated
 {
   [super viewWillAppear:animated];
   [self.table reloadData];
   if ([searchBar.text length] == 0) {
     [searchBar becomeFirstResponder];
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

 #pragma mark - Protocol SearchManagerDelegate

 - (void)searchFailedWithError:(NSError *)error
 {
   // When user is typing quickly, current searching have to be canceled.
 }

 - (void)searchSucceededWithResponseObject:(id)responseObject
 {
   if ([responseObject isKindOfClass:[NSArray class]]) {
    
     neighborhoodArray = [NSMutableArray array];
     for (NSDictionary *dic in responseObject) {
       OMBNeighborhood *neighborhood = [OMBNeighborhood new];
       [neighborhood readFromQBox:dic];
       [neighborhoodArray addObject:neighborhood];
     }
   }
  
   [self reloadData];
 }

 #pragma mark - Protocol UIAlertViewDelegate

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

 - (void)scrollViewWillBeginDragging: (UIScrollView *)scrollView
 {
   [self.view endEditing:YES];
 }

 #pragma mark - Protocol UISearchBarDelegate

 - (void)searchBar:(UISearchBar *)searchBar
   textDidChange:(NSString *)searchText
 {
   SchoolSearchManager *schoolSearch = [SchoolSearchManager sharedInstance];
   [schoolSearch cancel];
   [schoolSearch search:@{ @"query" : searchText }
     accessToken:nil delegate:self];
 }

 - (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
 {
   [self.view endEditing:YES];
 }

 #pragma mark - Protocol UITableViewDataSource

 - (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
 {
 //  return [[temporaryNeighborhoods allKeys] count];
   return 1;
 }

 - (UITableViewCell *)tableView:(UITableView *) tableView
   cellForRowAtIndexPath:(NSIndexPath *) indexPath
 {
   if (tableView == self.table) {
    
     static NSString *NeighborhoodCellID = @"NeighborhoodNameCellIdentifier";
     UITableViewCell *cell = [tableView
       dequeueReusableCellWithIdentifier: NeighborhoodCellID];
     if (!cell) {
       cell = [[UITableViewCell alloc] initWithStyle:
         UITableViewCellStyleDefault reuseIdentifier:NeighborhoodCellID];
     }
    
     if (neighborhoodArray.count) {
       OMBNeighborhood *neighborhoodCity =
         [neighborhoodArray objectAtIndex:indexPath.row];
      
       if (_selectedNeighborhood == neighborhoodCity) {
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
       }
       else {
         cell.accessoryType = UITableViewCellAccessoryNone;
       }
       cell.selectionStyle = UITableViewCellSelectionStyleDefault;
       cell.textLabel.text = neighborhoodCity.name;
       cell.textLabel.textAlignment = NSTextAlignmentLeft;
       cell.textLabel.textColor = [UIColor textColor];
       cell.userInteractionEnabled = YES;
     }
     else {
       cell.accessoryType = UITableViewCellAccessoryNone;
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       cell.textLabel.text = @"No matching schools";
       cell.textLabel.textAlignment = NSTextAlignmentCenter;
       cell.textLabel.textColor = UIColor.lightGrayColor;
       cell.userInteractionEnabled = NO;
     }
    
     cell.backgroundColor = [UIColor whiteColor];
     cell.textLabel.font = [UIFont normalTextFont];
    
     return cell;
   }
   return [[UITableViewCell alloc] init];
 }

 - (NSInteger) tableView: (UITableView *) tableView
   numberOfRowsInSection: (NSInteger) section
 {
   // Neighborhood
   if (tableView == self.table) {
     if (neighborhoodArray.count) {
       return neighborhoodArray.count;
     }
     else if ([searchBar.text length]){
       return 1;
     }
   }
   return 0;
 }

 #pragma mark - Protocol UITableViewDelegate

 - (void) tableView: (UITableView *) tableView
   didSelectRowAtIndexPath: (NSIndexPath *) indexPath
 {
   if (tableView == self.table) {
     OMBNeighborhood *neighborhood =
       [neighborhoodArray objectAtIndex:indexPath.row];
    
     if (_selectedNeighborhood == neighborhood) {
       _selectedNeighborhood = nil;
     }
     else {
       _selectedNeighborhood = neighborhood;
     }

     [tableView deselectRowAtIndexPath: indexPath animated: YES];
     [tableView reloadData];
     [self done];
   }
 }

 - (CGFloat) tableView: (UITableView *) tableView
 heightForHeaderInSection: (NSInteger) section
 {
   if (tableView == self.table &&
       (neighborhoodArray.count || [searchBar.text length])) {
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
     AMBlurView *blur = [[AMBlurView alloc] init];
     blur.blurTintColor = [UIColor grayLight];
     blur.frame = CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 13.0f * 2);
     UILabel *label = [UILabel new];
     label.font = [UIFont smallTextFontBold];
     label.frame = blur.frame;
     label.text = @"Results";
     label.textAlignment = NSTextAlignmentCenter;
     label.textColor = [UIColor blueDark];
     [blur addSubview: label];
     return blur;
   }
   return [[UIView alloc] initWithFrame: CGRectZero];
 }

 #pragma mark - Methods

 #pragma mark - Instance Methods

 - (void) cancel
 {
   _selectedNeighborhood = nil;
   [self.view endEditing:YES];
   [self dismissViewControllerAnimated:YES completion:nil];
 }

 - (void) done
 {
   [self.view endEditing:YES];
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

 - (void)reloadData
 {
   if (neighborhoodArray.count) {
     self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
   }
   else {
     self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
   }
  
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
