//
//  OMBFinishListingTitleDescriptionViewController.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 7/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingTitleDescriptionViewController.h"

#import "OMBLabelTextFieldCell.h"
#import "OMBResidence.h"
#import "OMBResidenceUpdateConnection.h"
#import "UIImage+Resize.h"

@implementation OMBFinishListingTitleDescriptionViewController

- (id)initWithResidence:(OMBResidence *)object
{
  if(!(self = [super initWithResidence:object]))
    return nil;
  
  self.screenName = self.title = @"Title and description";
  tagSection = OMBFinishListingSectionTitleDescription;
  
  return self;
}


- (void)loadView
{
  [super loadView];
  
  saveBarButtonItem.enabled = YES;
  self.navigationItem.rightBarButtonItem = saveBarButtonItem;
  
  CGFloat screenWidth = [self screen].size.width;
  
  // Spacing
	UIBarButtonItem *flexibleSpace =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
	    UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
  
	// Left padding
	UIBarButtonItem *leftPadding =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
	    UIBarButtonSystemItemFixedSpace target: nil action: nil];
	// iOS 7 toolbar spacing is 16px; 20px on iPad
	leftPadding.width = 4.0f;
  
	// Cancel
	UIBarButtonItem *cancelBarButtonItemForTextFieldToolbar =
    [[UIBarButtonItem alloc] initWithTitle: @"Cancel"
      style: UIBarButtonItemStylePlain target: self
        action: @selector(cancelFromInputAccessoryView)];
  
	// Done
	UIBarButtonItem *doneBarButtonItemForTextFieldToolbar =
    [[UIBarButtonItem alloc] initWithTitle: @"Done"
      style: UIBarButtonItemStylePlain target: self
        action: @selector(saveFromInputAccessoryView)];
  
	// Right padding
	UIBarButtonItem *rightPadding =
  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
	 UIBarButtonSystemItemFixedSpace target: nil action: nil];
	// iOS 7 toolbar spacing is 16px; 20px on iPad
	rightPadding.width = 4.0f;
  
	textFieldToolbar = [UIToolbar new];
	textFieldToolbar.clipsToBounds = YES;
	textFieldToolbar.frame = CGRectMake(0.0f, 0.0f,
    screenWidth, OMBStandardHeight);
	textFieldToolbar.items = @[leftPadding,
    cancelBarButtonItemForTextFieldToolbar,
      flexibleSpace,
        doneBarButtonItemForTextFieldToolbar,
          rightPadding];
	textFieldToolbar.tintColor = [UIColor blue];
  
  [super setupForTable];
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  valueDictionary = [NSMutableDictionary dictionaryWithDictionary: @{
    @"title"       : residence.title,
    @"description" : residence.description
   }];
  
  [self shouldEnableBarButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  [self done];
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  
  return [OMBLabelTextFieldCell heightForCellWithIconImageView];
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
  // Title
  // Description
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSInteger row = indexPath.row;
  
  static NSString *LabelTextCellID = @"LabelTextCellID";
  OMBLabelTextFieldCell *cell =
    [tableView dequeueReusableCellWithIdentifier: LabelTextCellID];
  
  if (!cell) {
    cell = [[OMBLabelTextFieldCell alloc] initWithStyle:
     UITableViewCellStyleDefault reuseIdentifier: LabelTextCellID];
    [cell setFrameUsingIconImageView];
  }
  
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textField.font = [UIFont normalTextFont];
  cell.textField.textColor = [UIColor blueDark];
  cell.textFieldLabel.font = [UIFont normalTextFont];
  NSString *imageName = @"user_icon.png";
  NSString *key;
  NSString *labelString;
  // Title
  if (row == 0) {
    imageName = @"house_icon_2.png";
    key         = @"title";
    labelString = @"Title";
    cell.textField.keyboardType = UIKeyboardTypeDefault;
  }
  // Description
  else if (row == 1) {
    imageName = @"house_icon_2.png";
    key         = @"description";
    labelString = @"Description";
    cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
  }
  cell.iconImageView.image = [UIImage image: [UIImage imageNamed: imageName]
    size: cell.iconImageView.frame.size];
  cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
  cell.textField.delegate  = self;
  cell.textField.indexPath = indexPath;
  cell.textField.placeholder = [labelString capitalizedString];
  cell.textField.text = [valueDictionary objectForKey: key];
  cell.textFieldLabel.text = labelString;
    [cell.textField addTarget: self action: @selector(textFieldDidChange:)
      forControlEvents: UIControlEventEditingChanged];
  cell.clipsToBounds = YES;
  
  return cell;

}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (TextFieldPadding *) textField
{
  textField.inputAccessoryView = textFieldToolbar;

}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [self done];
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancelFromInputAccessoryView
{
  [self.view endEditing: YES];
  isEditing = NO;
  [self.table beginUpdates];
  [self.table endUpdates];
}

- (void)save
{
  [self done];
  [self nextSection];
}

- (void)done
{
  
  residence.title       = [valueDictionary objectForKey:@"title"];
  residence.description = [valueDictionary objectForKey:@"description"];
  
  // Title
  if(![residence.title length]){
    [self firstResponderAtIndex: [NSIndexPath indexPathForRow:0 inSection:0]];
  }
  // Description
  else if (![residence.description length]) {
    [self firstResponderAtIndex: [NSIndexPath indexPathForRow:1 inSection:0]];
  }
  // Update
  else{
    OMBResidenceUpdateConnection *conn =
      [[OMBResidenceUpdateConnection alloc] initWithResidence: residence
        attributes: @[@"title", @"description"]];
    [conn start];
    [self.view endEditing:YES];
    
  }
}

- (void) doneFromInputAccessoryView
{
  [self cancelFromInputAccessoryView];
}

- (void)firstResponderAtIndex:(NSIndexPath *)indexPath
{
  
  [((OMBLabelTextFieldCell *)[self.table cellForRowAtIndexPath:indexPath]).textField becomeFirstResponder];
}

- (void) saveFromInputAccessoryView
{
	[self done];
}

- (void) textFieldDidChange: (TextFieldPadding *) textField
{
  
  if (textField.indexPath.row == 0) {
    [valueDictionary setObject: textField.text forKey: @"title"];
  }
  else if (textField.indexPath.row == 1) {
    [valueDictionary setObject: textField.text forKey: @"description"];
  }
  
  [self shouldEnableBarButton];
  
}

- (void)shouldEnableBarButton
{
  
  if([[valueDictionary objectForKey:@"title"] length] &&
     [[valueDictionary objectForKey:@"description"] length])
    saveBarButtonItem.enabled = YES;
  else
    saveBarButtonItem.enabled = NO;
  
}

@end
