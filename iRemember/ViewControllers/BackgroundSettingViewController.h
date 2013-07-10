//
//  BackgroundSettingViewController.h
//  iRemember
//
//  Created by nest0r on 13-5-28.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterFlowView.h"
#import "MainViewController.h"

@interface BackgroundSettingViewController : UIViewController<WaterFlowViewDataSource, WaterFlowViewDelegate>

@property (strong ,nonatomic) MainViewController *mainViewController;

@end
