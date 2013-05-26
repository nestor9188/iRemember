//
//  MainViewController.h
//  iRemember
//
//  Created by nest0r on 13-4-4.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterFlowView.h"

@interface MainViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, WaterFlowViewDataSource, WaterFlowViewDelegate>

- (IBAction)showRightView:(id)sender;
- (IBAction)addNote:(id)sender;
- (IBAction)toggleDisplayMode:(id)sender;

- (void)checkUnreadNote;
- (void)resetRemindFinishedNote;
- (void)beginSearch;

@end
