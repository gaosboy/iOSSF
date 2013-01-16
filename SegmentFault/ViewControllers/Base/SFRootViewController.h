//
//  SFRootViewController.h
//  SegmentFault
//
//  Created by jiajun on 11/28/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "UMViewController.h"

@interface SFRootViewController : UMViewController

// 先打开另一个VC（如：登陆），再打开该VC
- (void)delayOpen;
- (void)didLogout;

@end
