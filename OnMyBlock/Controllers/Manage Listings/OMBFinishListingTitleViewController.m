//
//  OMBFinishListingTitleViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingTitleViewController.h"

#import "OMBResidence.h"
#import "OMBResidenceUpdateConnection.h"
#import "UIColor+Extensions.h"

@implementation OMBFinishListingTitleViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super initWithResidence: object])) return nil;

  maxCharacters     = 35;
  placeholderString = @"e.g. A 3 bedroom apartment near campus";

  self.screenName = self.title = @"Title";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) save
{
  int charactersRemaining = maxCharacters - [descriptionTextView.text length];

  if (charactersRemaining < 0)
    return;

  residence.title = descriptionTextView.text;

  OMBResidenceUpdateConnection *conn = 
    [[OMBResidenceUpdateConnection alloc] initWithResidence: residence 
      attributes: @[@"title"]];
  [conn start];

  nextSection = YES;
  
  [self.navigationController popViewControllerAnimated: YES];
}

- (void) setTextForDescriptionView
{
  if ([residence.title length])
    descriptionTextView.text = residence.title;
}

- (void) updateCharacterCount
{
  int charactersRemaining = maxCharacters - [descriptionTextView.text length];
  characterCountLabel.text = [NSString stringWithFormat: @"%i characters left",
    charactersRemaining];
  if (charactersRemaining < 0)
    characterCountLabel.textColor = [UIColor red];
  else
    characterCountLabel.textColor = [UIColor grayMedium];
}

@end
