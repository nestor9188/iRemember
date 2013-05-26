//
//  OptionsViewController.h
//  iRemember
//
//  Created by nest0r on 13-4-9.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAPasscodeViewController.h"
#import "MainViewController.h"

@interface OptionsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, PAPasscodeViewControllerDelegate>

@property (strong ,nonatomic) MainViewController *mainViewController;

@end
