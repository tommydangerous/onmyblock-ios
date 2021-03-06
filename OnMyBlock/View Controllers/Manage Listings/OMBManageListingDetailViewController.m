//
//  OMBManageListingDetailViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBManageListingDetailViewController.h"

#import "AMBlurView.h"
#import "NSString+Extensions.h"
#import "OMBBlurView.h"
#import "OMBCenteredImageView.h"
#import "OMBFinishListingViewController.h"
#import "OMBImageOneLabelCell.h"
#import "OMBManageListingDetailEditCell.h"
#import "OMBManageListingDetailStatusCell.h"
#import "OMBResidence.h"
#import "OMBResidenceDetailViewController.h"
#import "OMBResidenceImagesConnection.h"
#import "OMBSwitch.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"
#import "OMBSwitch.h"

@interface OMBManageListingDetailViewController ()
{
  OMBCenteredImageView *centerImageView;
  NSDateFormatter *dateFormatter;
  UIImage *editCellImage;
  UIImage *previewCellImage;
  OMBResidence *residence;
  UIImage *statusCellImage;
  UIImage *statusCellImageNotListed;

  UIView *fadedBackground;
  // Status
  AMBlurView *bottomStatusView;
  UIButton *cancelStatusButton;
  UILabel *descriptionStatusLabel;
  UIButton *reasonTwoButton;
  UIButton *rentedButton;
  UITextField *rentedTextField;
  BOOL isShowingPicker;
  BOOL isShowingStatusView;
  UILabel *titlelabel;
  // Relist
  UIButton *cancelRelistButton;
  UILabel *descriptionRelistLabel;
  UIButton *relistButton;
  AMBlurView *relistView;

  // Date Picker
  NSTimeInterval availableDate;
  UIDatePicker *datePicker;
  UIView *pickerViewContainer;
  UILabel *pickerViewHeaderLabel;
}

@end

@implementation OMBManageListingDetailViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  editCellImage = [UIImage image: [UIImage imageNamed: @"house_icon.png"]
    size: [OMBManageListingDetailEditCell sizeForImage]];
  previewCellImage = [UIImage image:
    [UIImage imageNamed: @"manage_listing_preview_icon.png"]
      size: [OMBImageOneLabelCell sizeForImage]];
  statusCellImage = [UIImage image:
    [UIImage imageNamed: @"manage_listing_listed_icon.png"]
      size: [OMBImageOneLabelCell sizeForImage]];
  statusCellImageNotListed = [UIImage image:
    [UIImage imageNamed: @"manage_listing_not_listed_icon.png"]
      size: [OMBImageOneLabelCell sizeForImage]];
  residence = object;

  dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"MMM d, yyyy";

  self.title = [residence titleOrAddress];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen   = [self screen];
  CGFloat padding = OMBPadding;

  centerImageView = [[OMBCenteredImageView alloc] init];
  centerImageView.frame = CGRectMake(0.0f, 0.0f,
    screen.size.width, screen.size.height * 0.4f);
  [self setupBackgroundWithView: centerImageView
    startingOffsetY: padding + OMBStandardHeight];

  // This black tinted background appears when you click the status row
  fadedBackground = [[UIView alloc] init];
  fadedBackground.alpha = 0.0f;
  fadedBackground.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.8f];
  fadedBackground.frame = screen;
  [self.view addSubview: fadedBackground];
  UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget: self
      action: @selector(hideViews)];
  [fadedBackground addGestureRecognizer: tapGesture];

  // When the user wants to unlist or mark residence as rented
  CGFloat widthBottomStatus = self.view.frame.size.width;
  bottomStatusView = [[AMBlurView alloc] init];
  [self.view addSubview: bottomStatusView];
  // Title
  titlelabel       = [UILabel new];
  titlelabel.font  = [UIFont mediumLargeTextFontBold];
  titlelabel.frame = CGRectMake(padding, padding,
    widthBottomStatus - (padding * 2), 33.0f);
  titlelabel.textAlignment = NSTextAlignmentCenter;
  titlelabel.textColor     = [UIColor grayMedium];
  [bottomStatusView addSubview:titlelabel];
  // Description about unlisting
  descriptionStatusLabel       = [UILabel new];
  descriptionStatusLabel.font  = [UIFont normalTextFont];
  NSString *desc = @"You can choose when this place will be available "
    @"again in the future if it is rented.";
  NSAttributedString *aDesc = [desc attributedStringWithFont:
    descriptionStatusLabel.font lineHeight: 22.0f];
  CGRect descriptionRect = [aDesc boundingRectWithSize:
    CGSizeMake(titlelabel.frame.size.width, 9999.0f)
      options: NSStringDrawingUsesLineFragmentOrigin context: nil];
  descriptionStatusLabel.attributedText = aDesc;
  descriptionStatusLabel.frame = CGRectMake(titlelabel.frame.origin.x,
    titlelabel.frame.origin.y + titlelabel.frame.size.height +
      (padding * 0.25f),
        titlelabel.frame.size.width, descriptionRect.size.height);
  descriptionStatusLabel.numberOfLines = 0;
  descriptionStatusLabel.textAlignment = NSTextAlignmentCenter;
  descriptionStatusLabel.textColor     = [UIColor textColor];
  [bottomStatusView addSubview: descriptionStatusLabel];

  // Buttons
  CGSize sizeButton = CGSizeMake(titlelabel.frame.size.width,
    OMBStandardButtonHeight);
  // Rented this place
  rentedButton = [UIButton new];
  rentedButton.backgroundColor = [UIColor whiteColor];
  rentedButton.frame = CGRectMake(titlelabel.frame.origin.x,
    descriptionStatusLabel.frame.origin.y +
      descriptionStatusLabel.frame.size.height + padding,
        sizeButton.width, sizeButton.height);
  rentedButton.titleLabel.font = [UIFont normalTextFontBold];
  rentedButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  [rentedButton addTarget: self action: @selector(showDatePicker)
    forControlEvents: UIControlEventTouchUpInside];
  [rentedButton setTitle: @"This place is rented"
    forState: UIControlStateNormal];
  [rentedButton setTitleColor: [UIColor textColor]
    forState: UIControlStateNormal];
  [bottomStatusView addSubview: rentedButton];

  rentedTextField = [UITextField new];
  rentedTextField.backgroundColor = [UIColor whiteColor];
  rentedTextField.enabled = NO;
  rentedTextField.font = [UIFont mediumTextFont];
  rentedTextField.frame = CGRectMake(titlelabel.frame.origin.x,
    rentedButton.frame.origin.y + rentedButton.frame.size.height,
      sizeButton.width, sizeButton.height);
  rentedTextField.layer.cornerRadius = OMBCornerRadius;
  rentedTextField.placeholder   = @"Choose a date";
  rentedTextField.textAlignment = NSTextAlignmentCenter;
  rentedTextField.textColor = [UIColor textColor];
  [bottomStatusView addSubview: rentedTextField];

  // I don't want to rent this place anymore
  reasonTwoButton = [UIButton new];
  reasonTwoButton.backgroundColor = rentedButton.backgroundColor;
  reasonTwoButton.frame = CGRectMake(rentedButton.frame.origin.x,
    rentedButton.frame.origin.y + rentedButton.frame.size.height + 1.0f,
      sizeButton.width, sizeButton.height);
  reasonTwoButton.titleLabel.font = rentedButton.titleLabel.font;
  reasonTwoButton.titleLabel.textAlignment =
    rentedButton.titleLabel.textAlignment;
  [reasonTwoButton addTarget: self action: @selector(noLonger)
    forControlEvents: UIControlEventTouchUpInside];
  [reasonTwoButton setTitle: @"Unlist this place"
    forState: UIControlStateNormal];
  [reasonTwoButton setTitleColor: [UIColor textColor]
    forState: UIControlStateNormal];
  [bottomStatusView addSubview: reasonTwoButton];

  cancelStatusButton = [UIButton new];
  cancelStatusButton.backgroundColor = reasonTwoButton.backgroundColor;
  cancelStatusButton.frame = CGRectMake(padding,
    reasonTwoButton.frame.origin.y +
      reasonTwoButton.frame.size.height + padding * 0.5f,
        sizeButton.width, sizeButton.height);
  cancelStatusButton.layer.borderColor = reasonTwoButton.layer.borderColor;
  cancelStatusButton.layer.borderWidth = reasonTwoButton.layer.borderWidth;
  cancelStatusButton.titleLabel.font = reasonTwoButton.titleLabel.font;
  cancelStatusButton.titleLabel.textAlignment =
    reasonTwoButton.titleLabel.textAlignment;
  [cancelStatusButton addTarget:self
    action:@selector(hideBottomStatus)
      forControlEvents:UIControlEventTouchUpInside];
  [cancelStatusButton setTitle: @"Cancel" forState: UIControlStateNormal];
  [cancelStatusButton setTitleColor: [UIColor blue]
    forState: UIControlStateNormal];
  [bottomStatusView addSubview:cancelStatusButton];

  bottomStatusView.frame =
    CGRectMake(0.0f, self.view.frame.size.height,
      widthBottomStatus, cancelStatusButton.frame.origin.y +
        cancelStatusButton.frame.size.height + padding);

  // Date picker
  // Picker view container
  pickerViewContainer = [UIView new];
  [self.view addSubview: pickerViewContainer];

  // Header for picker view with cancel and done button
  UIView *pickerViewHeader = [[UIView alloc] init];
  pickerViewHeader.backgroundColor = [UIColor grayUltraLight];
  pickerViewHeader.frame = CGRectMake(0.0f, 0.0f,
    screen.size.width, 44.0f);
  [pickerViewContainer addSubview: pickerViewHeader];

  pickerViewHeaderLabel = [[UILabel alloc] init];
  pickerViewHeaderLabel.font = [UIFont normalTextFontBold];
  pickerViewHeaderLabel.frame = pickerViewHeader.frame;
  pickerViewHeaderLabel.textAlignment = NSTextAlignmentCenter;
  pickerViewHeaderLabel.textColor = [UIColor textColor];
  [pickerViewHeader addSubview: pickerViewHeaderLabel];
  // Cancel button
  UIButton *cancelButton = [UIButton new];
  cancelButton.titleLabel.font = [UIFont fontWithName:
    @"HelveticaNeue-Medium" size: 15];
  CGRect cancelButtonRect = [@"Cancel" boundingRectWithSize:
    CGSizeMake(pickerViewHeader.frame.size.width,
      pickerViewHeader.frame.size.height) font: cancelButton.titleLabel.font];
  cancelButton.frame = CGRectMake(padding, 0.0f,
    cancelButtonRect.size.width, pickerViewHeader.frame.size.height);
  [cancelButton addTarget: self
    action: @selector(cancelPicker)
      forControlEvents: UIControlEventTouchUpInside];
  [cancelButton setTitle: @"Cancel" forState: UIControlStateNormal];
  [cancelButton setTitleColor: [UIColor blueDark]
    forState: UIControlStateNormal];
  [pickerViewHeader addSubview: cancelButton];
  // Done button
  UIButton *doneButton = [UIButton new];
  doneButton.titleLabel.font = cancelButton.titleLabel.font;
  CGRect doneButtonRect = [@"Save" boundingRectWithSize:
    CGSizeMake(pickerViewHeader.frame.size.width,
      pickerViewHeader.frame.size.height)
        font: doneButton.titleLabel.font];
  doneButton.frame = CGRectMake(pickerViewHeader.frame.size.width -
    (padding + doneButtonRect.size.width), 0.0f,
      doneButtonRect.size.width, pickerViewHeader.frame.size.height);
  [doneButton addTarget: self
    action: @selector(donePicker)
      forControlEvents: UIControlEventTouchUpInside];
  [doneButton setTitle: @"Save" forState: UIControlStateNormal];
  [doneButton setTitleColor: [UIColor blueDark]
     forState: UIControlStateNormal];
  [pickerViewHeader addSubview: doneButton];

  datePicker = [[UIDatePicker alloc] init];
  datePicker.backgroundColor = UIColor.whiteColor;
  datePicker.frame = CGRectMake(0.0f, pickerViewHeader.frame.origin.y +
    pickerViewHeader.frame.size.height,
      datePicker.frame.size.width, datePicker.frame.size.height);
  datePicker.datePickerMode = UIDatePickerModeDate;
  datePicker.minimumDate = [NSDate date];
  NSDateComponents *maximunDateComponents =
    [[NSCalendar currentCalendar] components:
      NSCalendarUnitYear | NSCalendarUnitMonth
        fromDate: datePicker.minimumDate];
  [maximunDateComponents setYear:maximunDateComponents.year + 2];
  [maximunDateComponents setDay: 1];
  datePicker.maximumDate =
    [[NSCalendar currentCalendar] dateFromComponents: maximunDateComponents];
  [datePicker addTarget: self action: @selector(dateChanged:)
       forControlEvents: UIControlEventValueChanged];
  [pickerViewContainer addSubview: datePicker];

  pickerViewContainer.frame =
    CGRectMake(0.0f, self.view.frame.size.height,
      self.view.frame.size.width,
        pickerViewHeader.frame.size.height +
          datePicker.frame.size.height);

  // When a user clicks the status row while the residence is
  // not rented or not inactive
  relistView = [[AMBlurView alloc] init];
  NSString *descriptionRelist =
    @"Would you like to relist your place and make it available for rent?";
  NSAttributedString *aDescRelist =
    [descriptionRelist attributedStringWithFont: descriptionStatusLabel.font
      lineHeight: 22.0f];
  CGRect descriptionRelistRect = [aDescRelist boundingRectWithSize:
    CGSizeMake(titlelabel.frame.size.width, 9999.0f)
      options: NSStringDrawingUsesLineFragmentOrigin context: nil];
  descriptionRelistLabel = [UILabel new];
  descriptionRelistLabel.attributedText = aDescRelist;
  descriptionRelistLabel.font = descriptionStatusLabel.font;
  descriptionRelistLabel.frame = CGRectMake(padding,
    padding, widthBottomStatus - 2 * padding,
      descriptionRelistRect.size.height);
  descriptionRelistLabel.numberOfLines = 0;
  descriptionRelistLabel.textAlignment = NSTextAlignmentCenter;
  descriptionRelistLabel.textColor = descriptionStatusLabel.textColor;
  [relistView addSubview: descriptionRelistLabel];

  relistButton = [UIButton new];
  relistButton.backgroundColor = rentedButton.backgroundColor;
  relistButton.frame = CGRectMake(padding,
    descriptionRelistLabel.frame.origin.y +
      descriptionRelistLabel.frame.size.height + padding,
        sizeButton.width, sizeButton.height);
  relistButton.titleLabel.font = rentedButton.titleLabel.font;
  relistButton.titleLabel.textAlignment =
    rentedButton.titleLabel.textAlignment;
  [relistButton addTarget: self action: @selector(relistAction)
    forControlEvents: UIControlEventTouchUpInside];
  [relistButton setTitle: @"Relist this place" forState: UIControlStateNormal];
  [relistButton setTitleColor: [UIColor textColor]
    forState: UIControlStateNormal];
  [relistView addSubview: relistButton];

  cancelRelistButton = [UIButton new];
  cancelRelistButton.backgroundColor = relistButton.backgroundColor;
  cancelRelistButton.frame = CGRectMake(padding,
    relistButton.frame.origin.y +
      relistButton.frame.size.height + padding * 0.5f,
        sizeButton.width, sizeButton.height);
  cancelRelistButton.layer.borderColor = relistButton.layer.borderColor;
  cancelRelistButton.layer.borderWidth = relistButton.layer.borderWidth;
  cancelRelistButton.titleLabel.font = relistButton.titleLabel.font;
  cancelRelistButton.titleLabel.textAlignment =
    relistButton.titleLabel.textAlignment;
  [cancelRelistButton addTarget:self
    action:@selector(hideRelistView)
      forControlEvents:UIControlEventTouchUpInside];
  [cancelRelistButton setTitle: @"Cancel"
    forState: UIControlStateNormal];
  [cancelRelistButton setTitleColor: [UIColor blue]
    forState: UIControlStateNormal];
  [relistView addSubview:cancelRelistButton];

  relistView.frame = CGRectMake(0.0, self.view.frame.size.height,
    widthBottomStatus, cancelRelistButton.frame.origin.y +
      cancelRelistButton.frame.size.height + padding);
  [self.view addSubview: relistView];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.table reloadData];
  [self updateBackgroundImage];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  if (section == OMBManageListingDetailSectionTop) {
    UIColor *cellBackgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.0f];
    UIImage *selectedBackgroundImage = [UIImage imageWithColor:
      [UIColor colorWithWhite: 1.0f alpha: 0.3f]];
    if (row == OMBManageListingDetailSectionTopRowEdit) {
      static NSString *EditID = @"EditID";
      OMBManageListingDetailEditCell *cell =
        [tableView dequeueReusableCellWithIdentifier: EditID];
      if (!cell) {
        cell = [[OMBManageListingDetailEditCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: EditID];
        cell.backgroundColor = cellBackgroundColor;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:
          cell.frame];
        imageView.image = selectedBackgroundImage;
        cell.selectedBackgroundView = imageView;
        [cell setImage: editCellImage];
      }
      cell.bottomLabel.text = [NSString stringWithFormat: @"%@ - %i bd / %i ba",
        [NSString numberToCurrencyString: residence.minRent],
          (int) residence.bedrooms, (int) residence.bathrooms];
      cell.middleLabel.text = [NSString stringWithFormat: @"%@, %@",
        [residence.city capitalizedString], [residence stateFormattedString]];
      cell.topLabel.text = [residence.address capitalizedString];
      cell.clipsToBounds = YES;
      return cell;
    }
    else if (row == OMBManageListingDetailSectionTopRowPreview) {
      static NSString *PreviewID = @"PreviewID";
      OMBImageOneLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:
        PreviewID];
      if (!cell) {
        cell = [[OMBImageOneLabelCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: PreviewID];
        cell.backgroundColor = cellBackgroundColor;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:
          cell.frame];
        imageView.image = selectedBackgroundImage;
        cell.selectedBackgroundView = imageView;
      }
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      [cell setFont: [UIFont normalTextFontBold]];
      [cell setImage: previewCellImage text: @"Preview Listing"];
      [cell setImageViewAlpha: 0.8f];
      [cell setImageViewCircular: NO];
      cell.clipsToBounds = YES;
      return cell;
    }
    else if (row == OMBManageListingDetailSectionTopRowStatus) {
      static NSString *StatusID = @"StatusID";
      OMBManageListingDetailStatusCell *cell =
        [tableView dequeueReusableCellWithIdentifier: StatusID];
      if (!cell) {
        cell = [[OMBManageListingDetailStatusCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: StatusID];
        cell.backgroundColor = cellBackgroundColor;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:
          cell.frame];
        imageView.image = selectedBackgroundImage;
        cell.selectedBackgroundView = imageView;
      }
      cell.separatorInset = UIEdgeInsetsMake(0.0f,
        tableView.frame.size.width, 0.0f, 0.0f);
      cell.textFieldLabel.text = @"Listing Status";
      if (residence.inactive || residence.rented) {
        [cell setImage: statusCellImageNotListed];
      }
      else {
        [cell setImage: statusCellImage];
      }
      // custom behavior...
      NSString *offText = @"Unlisted";
      BOOL state = YES;
      UIColor *offColor = residence.rented ?
        [UIColor orange] : [UIColor grayColor];
      if(residence.inactive || residence.rented){
        offText = residence.inactive ?
          @"Unlisted" : @"Rented";
        state = NO;
      }

      [cell setSwitchTintColor: [UIColor green]
        withOffColor: offColor withOnText:@"Listed"
          andOffText: offText];
      [cell.customSwitch setState: state withAnimation: NO];
      cell.clipsToBounds = YES;
      return cell;
    }
  }
  return [UITableViewCell new];
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Edit
  // Preview
  // Listing Status
  return 3;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  if (section == OMBManageListingDetailSectionTop) {
    if (row == OMBManageListingDetailSectionTopRowEdit) {
      return [OMBManageListingDetailEditCell heightForCell];
    }
    else if (row == OMBManageListingDetailSectionTopRowPreview) {
      return [OMBImageOneLabelCell heightForCell];
    }
    else if (row == OMBManageListingDetailSectionTopRowStatus) {
      return [OMBManageListingDetailStatusCell heightForCell];
    }
  }
  return 0.0f;
}

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSInteger row     = indexPath.row;
  NSInteger section = indexPath.section;
  if (section == OMBManageListingDetailSectionTop) {
    UIViewController *vc;
    if (row == OMBManageListingDetailSectionTopRowEdit) {
      vc = [[OMBFinishListingViewController alloc] initWithResidence:
        residence];
    }
    else if (row == OMBManageListingDetailSectionTopRowPreview) {
      vc = [[OMBResidenceDetailViewController alloc] initWithResidence:
        residence];
    }
    else if (row == OMBManageListingDetailSectionTopRowStatus){
      if (residence.inactive || residence.rented)
        [self showRelistView];
      else
        [self showBottomStatus];
    }
    if (vc)
      [self.navigationController pushViewController: vc animated: YES];
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancelPicker
{
  [self updatePicker];
  [self hideDatePicker];
}

- (void) dateChanged: (UIDatePicker *) picker
{
  rentedTextField.text = [dateFormatter stringFromDate: picker.date];
}

- (void) donePicker
{
  [self hideDatePicker];

  // Save the residence
  availableDate        = [datePicker.date timeIntervalSince1970];
  residence.moveInDate = availableDate;
  residence.inactive   = NO;
  residence.rented     = YES;

  [self updatePicker];
  [self hideBottomStatus];
  [self updateResidence];
}

- (void) hideBottomStatus
{
  if(isShowingPicker)
     [self hideDatePicker];

  CGRect rect = bottomStatusView.frame;
  CGRect rect2 = pickerViewContainer.frame;
  rect.origin.y = self.view.frame.size.height;
  rect2.origin.y = self.view.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 0.0f;
    bottomStatusView.frame = rect;
    pickerViewContainer.frame = rect2;
  }];
  isShowingStatusView = NO;
  [self.table reloadData];
}

- (void) hideDatePicker
{
  isShowingPicker = NO;
  [self resize];
  CGRect rect = pickerViewContainer.frame;
  CGRect rect2 = bottomStatusView.frame;
  rect.origin.y = self.view.frame.size.height;
  rect2.origin.y = self.view.frame.size.height -
    bottomStatusView.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    bottomStatusView.frame = rect2;
    pickerViewContainer.frame = rect;
  }];
}

- (void) hideRelistView
{
  CGRect rect = relistView.frame;
  rect.origin.y = self.view.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 0.0f;
    relistView.frame = rect;
  }];
  [self.table reloadData];
}

- (void) hideViews
{
  if(isShowingStatusView)
    [self hideBottomStatus];
  else
    [self hideRelistView];
}

- (void) noLonger
{
  residence.inactive = YES;
  residence.rented   = NO;
  [self hideBottomStatus];
  [self updateResidence];
  [self.table reloadData];
}

- (void) relist
{
  residence.inactive = NO;
  residence.rented   = NO;
  [self.table reloadData];
}

- (void) relistAction
{
  [self relist];
  [self hideRelistView];
  [self updateResidence];
}

- (void) resize
{
  CGFloat padding = 20.f;
  CGRect rect1 = rentedTextField.frame;
  CGRect rect2 = bottomStatusView.frame;
  if(isShowingPicker){
    titlelabel.text = @"Next available date?";
    rentedTextField.hidden = NO;
    reasonTwoButton.hidden = YES;
    cancelStatusButton.hidden = YES;
    descriptionStatusLabel.hidden = YES;
    rentedButton.hidden = YES;
    rect1.origin.y = titlelabel.frame.origin.y +
      titlelabel.frame.size.height + padding;
    rect2.size.height = rect1.origin.y +
      rect1.size.height + padding;
  }else{
    rentedTextField.hidden = YES;
    reasonTwoButton.hidden = NO;
    cancelStatusButton.hidden = NO;
    descriptionStatusLabel.hidden = NO;
    rentedButton.hidden = NO;
    isShowingPicker = NO;
    titlelabel.text = @"Rented or Unlist";
    rect1.origin.y = rentedButton.frame.origin.y +
      rentedButton.frame.size.height;
    rect2.size.height = cancelStatusButton.frame.origin.y +
    cancelStatusButton.frame.size.height + padding;
  }

  rentedTextField.frame = rect1;
  bottomStatusView.frame = rect2;
}

- (void) showBottomStatus
{
  [self resize];
  isShowingStatusView = YES;
  CGRect rect   = bottomStatusView.frame;
  rect.origin.y = self.view.frame.size.height - rect.size.height;
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    fadedBackground.alpha  = 1.0f;
    bottomStatusView.frame = rect;
  }];
}

- (void) showDatePicker
{
  if (!isShowingPicker){
    isShowingPicker = YES;
    [self updatePicker];
    [self resize];
    CGRect rect = pickerViewContainer.frame;
    CGRect rect2 = bottomStatusView.frame;
    rect2.origin.y = self.view.frame.size.height -
      (bottomStatusView.frame.size.height + rect.size.height);
    rect.origin.y = self.view.frame.size.height -
      pickerViewContainer.frame.size.height;
    [UIView animateWithDuration: OMBStandardDuration animations:^{
      bottomStatusView.frame = rect2;
      pickerViewContainer.frame = rect;
    }];
  }
}

- (void) showRelistView
{
  CGRect rect   = relistView.frame;
  rect.origin.y = self.view.frame.size.height - rect.size.height;
  [UIView animateWithDuration: OMBStandardDuration animations: ^{
    fadedBackground.alpha = 1.0f;
    relistView.frame      = rect;
  }];
}

- (void) updateBackgroundImage
{
  // Download the residence's images
  OMBResidenceImagesConnection *conn =
    [[OMBResidenceImagesConnection alloc] initWithResidence: residence];
  conn.completionBlock = ^(NSError *error) {
    // Add the cover photo
    __weak typeof(backgroundBlurView) weakBlurView   = backgroundBlurView;
    __weak typeof(centerImageView) weakImageView = centerImageView;
    [residence setImageForCenteredImageView:
      (OMBCenteredImageView *) centerImageView
        withURL: residence.coverPhotoURL completion: ^{
          [weakBlurView refreshWithImage: 
            [(OMBCenteredImageView *) weakImageView image]];
        }];
  };
  [conn start];
}

- (void) updateResidence
{
  [residence updateAttributes: @[@"inactive", @"moveInDate", @"rented"]
    completion: ^(NSError *error) {
      if (error) {
        [self showAlertViewWithError: error];
      }
      [self containerStopSpinningFullScreen];
    }];
  [self containerStartSpinningFullScreen];
}

- (void) updatePicker
{
  if(availableDate){
    [datePicker setDate:[NSDate dateWithTimeIntervalSince1970: availableDate]
      animated: NO];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"MMM d, yyyy";
    rentedTextField.text = [dateFormat stringFromDate:
      [NSDate dateWithTimeIntervalSince1970: availableDate]];
  }else{
    rentedTextField.text = @"";
  }
}

@end
