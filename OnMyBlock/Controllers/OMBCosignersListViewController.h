//
//  OMBCosignersListViewController.h
//  OnMyBlock
//
//  Created by Morgan Schwanke on 12/2/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBRenterApplicationSectionViewController.h"

@interface OMBCosignersListViewController : 
  OMBRenterApplicationSectionViewController
<UIActionSheetDelegate>
{
  NSIndexPath *selectedIndexPath;
  UIActionSheet *sheet;
}

@end
