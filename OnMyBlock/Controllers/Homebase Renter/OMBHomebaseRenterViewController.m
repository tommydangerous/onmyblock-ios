//
//  OMBHomebaseBuyerViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseRenterViewController.h"

#import "AMBlurView.h"
#import "DRNRealTimeBlurView.h"
#import "OMBCenteredImageView.h"
#import "OMBExtendedHitAreaViewContainer.h"
#import "OMBHomebaseRenterRoommateImageView.h"
#import "UIColor+Extensions.h"

@implementation OMBHomebaseRenterViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = @"Homebase Renter";
  self.title      = @"Tommy's Homebase";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setMenuBarButtonItem];

  selectedSegmentIndex = 0;

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view     = [[UIView alloc] initWithFrame: screen];
  self.view.backgroundColor = [UIColor grayUltraLight];

  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat padding      = 20.0f;
  CGFloat standardHeight = 44.0f;

  backViewOffsetY = padding + standardHeight;
  // The image in the back
  backView = [UIView new];
  backView.frame = CGRectMake(0.0f, 0.0f, 
    screenWidth, screenHeight * 0.4f);
  [self.view addSubview: backView];
  // Image of residence
  OMBCenteredImageView *residenceImageView = 
    [[OMBCenteredImageView alloc] init];
  residenceImageView.frame = backView.frame;  
  residenceImageView.image = [UIImage imageNamed: 
    @"intro_still_image_slide_3_background.jpg"];
  [backView addSubview: residenceImageView];
  // Black tint
  UIView *colorView = [[UIView alloc] init];
  colorView.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.3f];
  colorView.frame = residenceImageView.frame;
  [backView addSubview: colorView];
  // Blur
  DRNRealTimeBlurView *blurView = [[DRNRealTimeBlurView alloc] init];
  blurView.blurRadius = 0.3f;
  blurView.frame = residenceImageView.frame;  
  blurView.renderStatic = YES;
  [backView addSubview: blurView];

  CGFloat imageSize = backView.frame.size.width / 3.0f;
  // Images scroll
  imagesScrollView = [UIScrollView new];
  imagesScrollView.clipsToBounds = NO;
  imagesScrollView.delegate = self;
  imagesScrollView.frame = CGRectMake(
    (backView.frame.size.width - imageSize) * 0.5f, 0.0f, 
      imageSize, backView.frame.size.height);
  imagesScrollView.contentSize = CGSizeMake(imageSize * 10, 
    imagesScrollView.frame.size.height);
  imagesScrollView.pagingEnabled = YES;
  imagesScrollView.showsHorizontalScrollIndicator = NO;
  [backView addSubview: imagesScrollView];

  // Extended hit area for images scroll
  OMBExtendedHitAreaViewContainer *extendedHitArea = 
    [[OMBExtendedHitAreaViewContainer alloc] init];
  extendedHitArea.frame = backView.frame;
  extendedHitArea.scrollView = imagesScrollView;
  [backView addSubview: extendedHitArea];

  // Need to do this or else blur is off
  backView.frame = CGRectMake(0.0f, backViewOffsetY,
    backView.frame.size.width, backView.frame.size.height);

  // Add/Remove Roommates button
  addRemoveRoommatesButton = [UIButton new];
  addRemoveRoommatesButton.frame = CGRectMake(padding, 
    (backView.frame.origin.y + backView.frame.size.height) - standardHeight, 
      screenWidth - (padding * 2), standardHeight);
  addRemoveRoommatesButton.titleLabel.font = [UIFont fontWithName: 
    @"HelveticaNeue-Medium" size: 15];
  [addRemoveRoommatesButton addTarget: self 
    action: @selector(addRemoveRoommatesButtonSelected) 
      forControlEvents: UIControlEventTouchUpInside];
  [addRemoveRoommatesButton setTitle: @"Add/Remove Roommates" 
    forState: UIControlStateNormal];
  [addRemoveRoommatesButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [self.view addSubview: addRemoveRoommatesButton];

  imageViewArray = [NSMutableArray array];

  for (int i = 0; i < 10; i++) {
    CGRect rect = CGRectMake(imageSize * i, 0.0f, imageSize, 
      backView.frame.size.height - addRemoveRoommatesButton.frame.size.height);
    OMBHomebaseRenterRoommateImageView *imageView = 
      [[OMBHomebaseRenterRoommateImageView alloc] initWithFrame: rect];
    if (i % 2) {
      imageView.imageView.image = [UIImage imageNamed: @"tommy_d.png"];
      imageView.nameLabel.text = @"Tommy";
    }
    else {
      imageView.imageView.image = [UIImage imageNamed: @"edward_d.jpg"];
      imageView.nameLabel.text = @"Edward";
    }
    [imageViewArray addObject: imageView];
    [imagesScrollView addSubview: imageView];
  }

  // Buttons
  buttonsView = [UIView new];
  buttonsView.clipsToBounds = YES;
  buttonsView.frame = CGRectMake(padding, 
    backView.frame.origin.y + backView.frame.size.height + padding, 
      screenWidth - (padding * 2), standardHeight);
  buttonsView.layer.borderColor = [UIColor blue].CGColor;
  buttonsView.layer.borderWidth = 1.0f;
  buttonsView.layer.cornerRadius = buttonsView.frame.size.height * 0.5f;
  [self.view addSubview: buttonsView];
  UIView *middleDivider = [UIView new];
  middleDivider.backgroundColor = [UIColor blue];
  middleDivider.frame = CGRectMake((buttonsView.frame.size.width - 1.0f) * 0.5f,
    0.0f, 1.0f, buttonsView.frame.size.height);
  [buttonsView addSubview: middleDivider];

  // Activity button
  activityButton = [UIButton new];
  activityButton.frame = CGRectMake(0.0f, 0.0f, 
    buttonsView.frame.size.width * 0.5f, buttonsView.frame.size.height);
  activityButton.tag = 0;
  activityButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  [activityButton addTarget: self action: @selector(segmentButtonSelected:)
    forControlEvents: UIControlEventTouchUpInside];
  [activityButton setTitle: @"Activity Feed" forState: UIControlStateNormal];
  [activityButton setTitleColor: middleDivider.backgroundColor
    forState: UIControlStateNormal];
  [buttonsView addSubview: activityButton];

  // Payments button
  paymentsButton = [UIButton new];
  paymentsButton.frame = CGRectMake(
    activityButton.frame.origin.x + activityButton.frame.size.width, 
      activityButton.frame.origin.y, 
        activityButton.frame.size.width, activityButton.frame.size.height);
  paymentsButton.tag = 1;
  paymentsButton.titleLabel.font = activityButton.titleLabel.font;
  [paymentsButton addTarget: self action: @selector(segmentButtonSelected:)
    forControlEvents: UIControlEventTouchUpInside];
  [paymentsButton setTitle: @"Rental Payments" forState: UIControlStateNormal];
  [paymentsButton setTitleColor: middleDivider.backgroundColor
    forState: UIControlStateNormal];
  [buttonsView addSubview: paymentsButton];

  CGFloat tableViewOriginY = backView.frame.origin.y + 
    padding + buttonsView.frame.size.height + padding;
  CGRect tableViewFrame = CGRectMake(0.0f, tableViewOriginY, 
    screenWidth, screenHeight - tableViewOriginY);
  // Activity table view
  _activityTableView = [[UITableView alloc] initWithFrame: tableViewFrame
    style: UITableViewStylePlain];
  _activityTableView.alwaysBounceVertical = YES;
  _activityTableView.backgroundColor      = [UIColor clearColor];
  _activityTableView.dataSource           = self;
  _activityTableView.delegate             = self;
  _activityTableView.separatorColor       = [UIColor grayLight];
  _activityTableView.separatorInset = UIEdgeInsetsMake(0.0f, padding, 
    0.0f, 0.0f);
  _activityTableView.showsVerticalScrollIndicator = NO;
  [self.view insertSubview: _activityTableView 
    belowSubview: addRemoveRoommatesButton];
  // Activity table header view
  OMBExtendedHitAreaViewContainer *activityTableViewHeader = 
    [OMBExtendedHitAreaViewContainer new];
  activityTableViewHeader.frame = CGRectMake(0.0f, 0.0f,
    _activityTableView.frame.size.width, 
      (backView.frame.origin.y + backView.frame.size.height) - 
      tableViewOriginY);
  activityTableViewHeader.scrollView = imagesScrollView;
  _activityTableView.tableHeaderView = activityTableViewHeader;

  // Payments table view
  _paymentsTableView = [[UITableView alloc] initWithFrame: tableViewFrame
    style: UITableViewStylePlain];
  _paymentsTableView.alwaysBounceVertical = 
    _activityTableView.alwaysBounceVertical;
  _paymentsTableView.backgroundColor = _activityTableView.backgroundColor;
  _paymentsTableView.dataSource = self;
  _paymentsTableView.delegate = self;
  _paymentsTableView.separatorColor = _activityTableView.separatorColor;
  _paymentsTableView.separatorInset = _activityTableView.separatorInset;
  _paymentsTableView.showsVerticalScrollIndicator = 
    _activityTableView.showsVerticalScrollIndicator;
  [self.view insertSubview: _paymentsTableView 
    belowSubview: addRemoveRoommatesButton];
  // Payment table header view
  OMBExtendedHitAreaViewContainer *paymentTableViewHeader = 
    [OMBExtendedHitAreaViewContainer new];
  paymentTableViewHeader.frame = activityTableViewHeader.frame;
  paymentTableViewHeader.scrollView = imagesScrollView;
  _paymentsTableView.tableHeaderView = paymentTableViewHeader;

  [self changeTableView];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  [imagesScrollView setContentOffset: 
    CGPointMake(imagesScrollView.frame.size.width, 0.0f) animated: NO];
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding        = 20.0f;
  CGFloat standardHeight = 44.0f;
  CGFloat y = scrollView.contentOffset.y;
  
  CGFloat percent = 0.0f;
  // Images
  if (scrollView == imagesScrollView) {
    CGFloat width = scrollView.frame.size.width;
    CGFloat x     = scrollView.contentOffset.x;
    CGFloat page  = x / width;
    // Scale the slide views
    for (UIView *iView in imageViewArray) {
      percent = (x - (width * [imageViewArray indexOfObject: iView])) / width;
      if (percent < 0)
        percent *= -1;
      CGFloat scalePercent = 1 - percent;
      if (scalePercent > 1)
        scalePercent = 1;
      else if (scalePercent < 0.5f)
        scalePercent = 0.5f;
      iView.transform = CGAffineTransformMakeScale(scalePercent, scalePercent);
    }
  }
  // Activity
  else if (scrollView == _activityTableView) {
    CGFloat originalButtonsViewOriginY = padding + standardHeight + 
      (screen.size.height * 0.4f) + padding;
    CGFloat minOriginY = padding + standardHeight + padding;
    CGFloat maxDistanceForBackView = originalButtonsViewOriginY - minOriginY;

    CGFloat newOriginY = originalButtonsViewOriginY - y;
    if (newOriginY > originalButtonsViewOriginY)
      newOriginY = originalButtonsViewOriginY;
    else if (newOriginY < minOriginY)
      newOriginY = minOriginY;
    // Move the buttons
    CGRect buttonsViewRect = buttonsView.frame;
    buttonsViewRect.origin.y = newOriginY;
    buttonsView.frame = buttonsViewRect;
  }
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  if (tableView == _activityTableView) {
    return 2;
  }
  return 0;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
      reuseIdentifier: CellIdentifier];
  if (indexPath.row % 2) {
    cell.backgroundColor = [UIColor redColor];
  }
  else {
    cell.backgroundColor = [UIColor blueColor];
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return 50;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView 
heightForHeaderInSection: (NSInteger) section
{
  return 0.0f;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return 50.0f;
}

- (UIView *) tableView: (UITableView *) tableView 
viewForHeaderInSection: (NSInteger) section
{
  CGFloat padding = 20.0f;
  AMBlurView *blurView = [[AMBlurView alloc] init];
  blurView.blurTintColor = [UIColor blueLight];
  blurView.frame = CGRectMake(0.0f, 0.0f, 
    tableView.frame.size.width, 13.0f * 2);
  UILabel *label = [UILabel new];
  label.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 13];
  label.frame = CGRectMake(padding, 0.0f, 
    blurView.frame.size.width - (padding * 2), blurView.frame.size.height);
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = [UIColor blueDark];
  [blurView addSubview: label];
  NSString *titleString = @"";
  label.text = titleString;
  return blurView;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addRemoveRoommatesButtonSelected
{
  NSLog(@"ADD REMOVE ROOMMATES");
}

- (void) changeTableView
{
  CGFloat padding = 20.0f;
  if (selectedSegmentIndex == 0) {
    activityButton.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.5f];
    _activityTableView.hidden = NO;
    paymentsButton.backgroundColor = [UIColor clearColor];
    _paymentsTableView.hidden = YES;
    // Change the content offset of activity table view 
    // if payments table view is not scrolled pass the threshold
    CGFloat threshold = ((backView.frame.size.height - backViewOffsetY) - 
      (padding + buttonsView.frame.size.height + padding));
    if (_paymentsTableView.contentOffset.y < threshold) {
      _activityTableView.contentOffset = _paymentsTableView.contentOffset;
    }
    // If activity table view content offset is less than threshold
    else if (_activityTableView.contentOffset.y < threshold) {
      _activityTableView.contentOffset = CGPointMake(
        _activityTableView.contentOffset.x, threshold);
    }
  }
  else if (selectedSegmentIndex == 1) {
    activityButton.backgroundColor = [UIColor clearColor];
    _activityTableView.hidden = YES;
    paymentsButton.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.5f];
    _paymentsTableView.hidden = NO;
    // Change the content offset of payments table view 
    // if activity table view is not scrolled pass the threshold
    CGFloat threshold = ((backView.frame.size.height - backViewOffsetY) - 
      (padding + buttonsView.frame.size.height + padding));
    if (_activityTableView.contentOffset.y < threshold) {
      _paymentsTableView.contentOffset = _activityTableView.contentOffset;
    }
    // If payments table view content offset is less than threshold
    else if (_paymentsTableView.contentOffset.y < threshold) {
      _paymentsTableView.contentOffset = CGPointMake(
        _paymentsTableView.contentOffset.x, threshold);
    }
  }
}

- (void) segmentButtonSelected: (UIButton *) button
{
  selectedSegmentIndex = button.tag;
  [self changeTableView];
}

@end
