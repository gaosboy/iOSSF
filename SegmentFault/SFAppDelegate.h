//
//  SFAppDelegate.h
//  SegmentFault
//
//  Created by jiajun on 11/24/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFSlideNavViewController;
@class SFMainViewController;
@class SFQuestionListViewController;
@class UMNavigationController;
@class SFLoginViewController;

@interface SFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow                          *window;

@property (strong, nonatomic) NSMutableDictionary               *config;

@property (strong, nonatomic) SFSlideNavViewController          *navigator;

@property (strong, nonatomic) SFQuestionListViewController      *newestVC;
@property (strong, nonatomic) UMNavigationController            *newestNavigator;

@property (strong, nonatomic) SFMainViewController              *hottestVC;
@property (strong, nonatomic) UMNavigationController            *hottestNavigator;

@property (strong, nonatomic) SFMainViewController              *followedQuestionsVC;
@property (strong, nonatomic) UMNavigationController            *followedQuestionsNavigator;

@property (strong, nonatomic) SFLoginViewController             *userSettingsVC;
@property (strong, nonatomic) UMNavigationController            *userSettingsNavigator;

@end
