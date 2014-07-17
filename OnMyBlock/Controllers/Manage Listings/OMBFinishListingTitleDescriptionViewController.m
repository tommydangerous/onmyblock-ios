//
//  OMBFinishListingTitleDescriptionViewController.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 7/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingTitleDescriptionViewController.h"

#import "OMBResidence.h"
#import "OMBResidenceUpdateConnection.h"
#import "OMBTextFieldCell.h"
#import "UIImage+Resize.h"

@implementation OMBFinishListingTitleDescriptionViewController

- (id)initWithResidence:(OMBResidence *)object
{
  if (!(self = [super initWithResidence: object])) return nil;
  
  self.screenName = self.title = @"Title and Description";
  tagSection      = OMBFinishListingSectionTitleDescription;
  
  return self;
}


- (void)loadView
{
  [super loadView];
  
  float padding = 20.f;
  
  saveBarButtonItem.enabled = YES;
  self.navigationItem.rightBarButtonItem = saveBarButtonItem;
  
  CGFloat screenWidth = [self screen].size.width;
  
  // Title
	titleToolbar = [UIToolbar new];
	titleToolbar.clipsToBounds = YES;
	titleToolbar.frame = CGRectMake(0.0f, 0.0f,
    screenWidth, OMBStandardHeight);
	titleToolbar.tintColor = [UIColor blue];
  
  maxCharacterTitle = 35;
  
  countLabel = [UILabel new];
  countLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  countLabel.frame = CGRectMake(padding, 0.0f,
    titleToolbar.frame.size.width - (padding * 2),
      titleToolbar.frame.size.height);
  countLabel.textAlignment = NSTextAlignmentRight;
  countLabel.textColor = [UIColor grayMedium];
  [titleToolbar addSubview: countLabel];
  
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
  
  // Description toolbar
	descriptionToolbar = [UIToolbar new];
	descriptionToolbar.clipsToBounds = YES;
	descriptionToolbar.frame = CGRectMake(0.0f, 0.0f,
    screenWidth, OMBStandardHeight);
  descriptionToolbar.items = @[leftPadding,
   cancelBarButtonItemForTextFieldToolbar,
     flexibleSpace,
       doneBarButtonItemForTextFieldToolbar,
         rightPadding];
	descriptionToolbar.tintColor = [UIColor blue];
  
  // Description Text View
  descriptionTextView = [UITextView new];
  descriptionTextView.delegate = self;
  descriptionTextView.font = [UIFont normalTextFont];
  descriptionTextView.frame = CGRectMake(20.f, padding,
    screenWidth - (padding * 2), padding * 5);
  descriptionTextView.inputAccessoryView = descriptionToolbar;
  descriptionTextView.textColor = [UIColor blueDark];
  
  // Add a placeholder
  descriptionPlaceholder = [UILabel new];
  descriptionPlaceholder.font = descriptionTextView.font;
  descriptionPlaceholder.frame = CGRectMake(5.0f, 8.0f,
    descriptionTextView.frame.size.width, 20.0f);
  descriptionPlaceholder.text = @"Please add a description...";
  descriptionPlaceholder.textColor = [UIColor grayMedium];
  [descriptionTextView addSubview:descriptionPlaceholder];
  
  [super setupForTable];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  
  valueDictionary = [NSMutableDictionary dictionaryWithDictionary: @{
    @"description" : @"",
    @"title"       : @""
   }];
  
  if (residence.description && [residence.description length]) {
    [valueDictionary setObject: residence.description forKey: @"description"];
  }
  if (residence.title && [residence.title length]) {
    [valueDictionary setObject: residence.title forKey: @"title"];
  }
  
  //[self updateCharacterCount];
  [self shouldEnableBarButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  [self done];
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  // Title
  if(indexPath.row == 0){
    return [OMBTextFieldCell heightForCell];
  }
  // Description
  else if(indexPath.row == 1){
    return OMBPadding + (22.0f * 5) + OMBPadding;
  }
  
  return 0.0f;
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
  
  static NSString *emptyCellID = @"emptyCellID";
  UITableViewCell *emptycell =
  [tableView dequeueReusableCellWithIdentifier: emptyCellID];
  if(!emptyCellID)
    emptycell = [[UITableViewCell alloc] initWithStyle:
      UITableViewCellStyleDefault reuseIdentifier:emptyCellID];
  
  // Title
  if(row == 0){
    static NSString *LabelTextCellID = @"LabelTextCellID";
    OMBTextFieldCell *cell =
      [tableView dequeueReusableCellWithIdentifier: LabelTextCellID];
    if (!cell) {
      cell = [[OMBTextFieldCell alloc] initWithStyle:
        UITableViewCellStyleDefault reuseIdentifier: LabelTextCellID];
    
    }
    
    NSString *labelString = @"Title";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cell.textField.delegate  = self;
    cell.textField.font = [UIFont normalTextFont];
    cell.textField.indexPath = indexPath;
    cell.textField.placeholder = [labelString capitalizedString];
    cell.textField.text = [valueDictionary objectForKey: @"title"];
    cell.textField.textColor = [UIColor blueDark];
    [cell.textField addTarget: self action: @selector(textFieldDidChange:)
      forControlEvents: UIControlEventEditingChanged];
    cell.clipsToBounds = YES;
    
    return cell;
  }
  // Description
  else if(row == 1){
    static NSString *descriptionCellID = @"descriptionCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:descriptionCellID];
    if(!cell){
      cell = [[UITableViewCell alloc] initWithStyle:
        UITableViewCellStyleDefault reuseIdentifier:descriptionCellID];
      [descriptionTextView removeFromSuperview];
      [cell.contentView addSubview:descriptionTextView];
    }
    
    descriptionTextView.text = [valueDictionary objectForKey: @"description"];
    
    if ([[descriptionTextView.text stripWhiteSpace] length]) {
      descriptionPlaceholder.hidden = YES;
    }
    else {
      descriptionPlaceholder.hidden = NO;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    return cell;
    
  }
  
  return emptycell;

}

#pragma mark - Protocol UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField
  shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  
  if([[textField.text stringByReplacingCharactersInRange:range 
      withString:string] length] > maxCharacterTitle)
  {
    return NO;
  };
  
  return YES;
}


- (void) textFieldDidBeginEditing: (TextFieldPadding *) textField
{
  textField.inputAccessoryView = titleToolbar;
  
  [self updateCharacterCount];
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [self done];
  return YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
  
  if ([[descriptionTextView.text stripWhiteSpace] length]) {
    descriptionPlaceholder.hidden = YES;
  }
  else {
    descriptionPlaceholder.hidden = NO;
  }
  
  [valueDictionary setObject: textView.text forKey: @"description"];
  [self shouldEnableBarButton];
}

- (void) textViewDidBeginEditing: (UITextView *) textView
{ 
  // [self.table beginUpdates];
  // [self.table endUpdates];
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow: 1 inSection: 0];
  [self scrollToRectAtIndexPath: indexPath];
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

- (void)doneFromInputAccessoryView
{
  [self cancelFromInputAccessoryView];
}

- (void)firstResponderAtIndex:(NSIndexPath *)indexPath
{
  
  // Title
  if(indexPath.row == 0){
    [((OMBTextFieldCell *)[self.table cellForRowAtIndexPath:indexPath]).textField becomeFirstResponder];
  }
  // Description
  else if(indexPath.row == 1){
    [descriptionTextView becomeFirstResponder];
  }
  
}

- (void)save
{
  [self done];
  [self nextSection];
}

- (void) saveFromInputAccessoryView
{
	[self done];
}

- (void) scrollToRectAtIndexPath: (NSIndexPath *) indexPath
{
  CGRect rect = [self.table rectForRowAtIndexPath: indexPath];
  rect.origin.y -= descriptionToolbar.frame.size.height * 2;
  [self.table setContentOffset: rect.origin animated: YES];
}

- (void)shouldEnableBarButton
{
  
  if([[valueDictionary objectForKey:@"title"] length] &&
     [[valueDictionary objectForKey:@"description"] length])
    saveBarButtonItem.enabled = YES;
  else
    saveBarButtonItem.enabled = NO;
  
}

- (void) textFieldDidChange: (TextFieldPadding *) textField
{
  
  if (textField.indexPath.row == 0) {
    [valueDictionary setObject: textField.text forKey: @"title"];
  }
  
  [self updateCharacterCount];
  [self shouldEnableBarButton];
  
}

- (void) updateCharacterCount
{
  OMBTextFieldCell *cell = (OMBTextFieldCell *)[self.table cellForRowAtIndexPath:
   [NSIndexPath indexPathForItem:0 inSection:0]];
  
  int number = maxCharacterTitle - [cell.textField.text length];
  
  countLabel.text = [NSString stringWithFormat:
    @"%i characters left", number];
  
}

@end
