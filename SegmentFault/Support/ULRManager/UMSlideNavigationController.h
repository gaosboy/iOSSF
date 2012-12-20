//
//  UMSlideNavigationController.h
//  SegmentFault
//
//  Created by jiajun on 11/26/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMSlideNavigationController : UIViewController

@property (strong, nonatomic)   NSArray             *items;
@property (strong, nonatomic)   UITableView         *slideView;
@property (strong, nonatomic)   UINavigationItem    *navItem;
@property (strong, nonatomic)   NSIndexPath         *currentIndex;

- (id)initWithItems:(NSArray *)items;
- (void)showItemAtIndex:(NSIndexPath *)index;

@end
