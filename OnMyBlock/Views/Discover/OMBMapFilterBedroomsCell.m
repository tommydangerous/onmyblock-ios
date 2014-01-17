//
//  OMBMapFilterBedroomsCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/20/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMapFilterBedroomsCell.h"

#import "OMBMapFilterViewController.h"

@implementation OMBMapFilterBedroomsCell

#pragma mark - Initialize

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{ 
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.maxButtons = 5;

  [self setupButtons];
  [self setupButtonTitles];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) buttonSelected: (UIButton *) button
{
  [super buttonSelected: button];

  NSNumber *key = [NSNumber numberWithInt: button.tag];
  NSNumber *number = [self.selectedButtons objectForKey: key];
  BOOL selected = [number boolValue];

  if (self.delegate && 
    [self.delegate isKindOfClass: [OMBMapFilterViewController class]]) {

    NSMutableArray *array = [[(OMBMapFilterViewController *) self.delegate 
      valuesDictionary] objectForKey: @"bedrooms"];
    if (selected) {
      NSMutableArray *newArray = [NSMutableArray arrayWithArray: array];
      [newArray addObject: [NSNumber numberWithInt: button.tag]];
      [[(OMBMapFilterViewController *) self.delegate valuesDictionary] 
        setObject: newArray forKey: @"bedrooms"];
    }
    else {
      NSPredicate *predicate = [NSPredicate predicateWithBlock: 
        ^BOOL (id evaluatedObject, NSDictionary *bindings) {
          NSNumber *n = (NSNumber *) evaluatedObject;
          return [n intValue] != 
            [[NSNumber numberWithInt: button.tag] intValue];
        }
      ];
      NSMutableArray *newArray = (NSMutableArray *) 
        [array filteredArrayUsingPredicate: predicate];
      [[(OMBMapFilterViewController *) self.delegate valuesDictionary] 
        setObject: newArray forKey: @"bedrooms"];
    }
  }
}

- (void) setupButtonTitles
{
  for (int i = 0; i < self.maxButtons; i++) {
    UIButton *button = [self.buttons objectAtIndex: i];
    NSString *string = [NSString stringWithFormat: @"%i", i];
    if (i == 0) {
      string = @"Studio";
    }
    else if (i == self.maxButtons - 1) {
      string = [string stringByAppendingString: @"+"];
    }
    [button setTitle: string forState: UIControlStateNormal];
  }
}

@end
