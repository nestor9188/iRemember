//
//  OptionsViewController.m
//  iRemember
//
//  Created by nest0r on 13-4-9.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import "OptionsViewController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "TextSettingViewController.h"
#import "AppDelegate.h"
#import "NoteDatabase.h"
#import "MainViewController.h"
#import "BackgroundSettingViewController.h"

@interface OptionsViewController ()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UISwitch *passcodeSwitch;
@property (strong, nonatomic) MBProgressHUD *progressView;

- (void)syncToCloud;
- (void)recoveryFromCloud;

@end

@implementation OptionsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!_tableView) {
        CGRect frame = self.view.bounds;
        frame.origin.x = 40;
        frame.size.width -= 40;
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:tableView];
        self.tableView = tableView;
    }
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_1.jpg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView deselectRowAtIndexPath:_tableView.indexPathForSelectedRow animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return 1;
    }
    
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"背景";
    }
    if (section == 2) {
        return @"字体";
    }
    if (section == 3) {
        return @"密码";
    }
    if (section == 4) {
        return @"同步";
    }
    
    return @"";
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 0) {
        cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 260, 44)];
        searchBar.placeholder = @"点击开始搜索";
        // 设置搜索框背景透明
        searchBar.backgroundColor = [UIColor clearColor];
        [[searchBar.subviews objectAtIndex:0]removeFromSuperview];
        [searchBar setUserInteractionEnabled:NO];
        
        cell.accessoryView = searchBar;
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = @"更换背景";
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = @"更改字体";
    }
    if (indexPath.section == 3) {
        cell.textLabel.text = @"开启密码";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *passcode = [[NSUserDefaults standardUserDefaults] objectForKey:kPasscode];

        
        UISwitch *passcodeSwitch = [[UISwitch alloc] init];
        [passcodeSwitch addTarget:self
                           action:@selector(enablePassword:)
                 forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = passcodeSwitch;
        if (passcode.length > 0) {
            [passcodeSwitch setOn:YES];
        } else {
            [passcodeSwitch setOn:NO];
        }
        
        self.passcodeSwitch = passcodeSwitch;
    }
    if (indexPath.section == 4) {
        cell.textLabel.text = @"云同步";
    }

    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        // 搜索
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.menuController showRootController:YES];
        // 延迟0.2秒调用会有更协调的动画效果
        [self.mainViewController performSelector:@selector(beginSearch) withObject:nil afterDelay:0.2f];
    }
    
    if (indexPath.section == 1) {
        // 设置背景
        BackgroundSettingViewController *bgvc = [[BackgroundSettingViewController alloc] initWithNibName:nil bundle:nil];
        bgvc.mainViewController = self.mainViewController;
        DDMenuController *menuController = (DDMenuController*)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
        [menuController pushViewController:bgvc animated:YES];
    }
    
    if (indexPath.section == 2) {
        // 设置字体
        TextSettingViewController *textSettingVC = [[TextSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
        DDMenuController *menuController = (DDMenuController*)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
        [menuController pushViewController:textSettingVC animated:YES];
    }
    if (indexPath.section == 4) {
        // 云同步
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"将备忘同步到云端", @"从云端恢复",  nil];
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];
    }
}

#pragma mark - Actions

- (void)enablePassword:(UISwitch *)sender {
    PAPasscodeViewController *passcodeViewController;
    if (self.passcodeSwitch.isOn) {
        // 设置密码
        passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionSet];
    } else {
        // 取消密码，先让用户输入一次密码
        passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionEnter];
    }
    passcodeViewController.delegate = self;
    passcodeViewController.simple = YES;
    
    AppDelegate *app  = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.menuController presentModalViewController:passcodeViewController animated:YES];
}

#pragma mark - Cloud sync

- (void)syncToCloud {
    // 开始同步时显示一个进度条
    self.progressView = [[MBProgressHUD alloc] initWithView:self.view];
    [self.progressView show:YES];
    
    NSString *sqlQueue = [[NSUserDefaults standardUserDefaults] objectForKey:kSQLQueue];
    NSLog(@"数据库队列：%@", sqlQueue);
    if (sqlQueue.length > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"cloud_sync", @"command",
                                       sqlQueue, @"sql_queue",
                                       nil];
        [[API sharedInstance] commandWithParams:params
                                   onCompletion:^(NSDictionary *json) {
                                       // 同步结束后隐藏进度条
                                       [self.progressView hide:YES];                                       
                                       NSLog(@"%@", json);
                                       if ([json objectForKey:@"error"] == nil) {                                           
                                           NSLog(@"同步成功");
                                           // 充值SQL队列
                                           [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kSQLQueue];
                                           [[[UIAlertView alloc] initWithTitle:@"本地日志已同步到云端"
                                                                       message:@""
                                                                      delegate:self
                                                             cancelButtonTitle:@"好的"
                                                             otherButtonTitles:nil, nil] show];
                                       } else {
                                           [[[UIAlertView alloc] initWithTitle:@"同步出了点问题"
                                                                      message:@"你的网络有点不给力哦~ 请等等再试"
                                                                     delegate:self
                                                            cancelButtonTitle:@"好的"
                                                            otherButtonTitles:nil, nil] show];
                                       }
                                   }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"本地日志已同步到云端"
                                    message:@""
                                   delegate:self
                          cancelButtonTitle:@"好的"
                          otherButtonTitles:nil, nil] show];
    }

}

- (void)recoveryFromCloud {
    [[NoteDatabase sharedInstance] recoveryFromCloudWithCompletionBlock:^(BOOL success) {
        if (success) {
            [[[UIAlertView alloc] initWithTitle:@"备忘已从云端恢复~"
                                        message:@""
                                       delegate:self
                              cancelButtonTitle:@"好的"
                              otherButtonTitles:nil, nil] show];
            [self.mainViewController reloadNotes];
        }
    }];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {
        // 选择是同步还是恢复
        if (buttonIndex == 1) {
            // 从云端恢复，会删除本地SQLite数据库，是高危操作，要再次提醒用户
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"本操作会删除本地所有数据，请保证网络通畅，确定要恢复吗？"
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:@"从云端恢复"
                                                            otherButtonTitles:nil];
            actionSheet.tag = 2;
            [actionSheet showInView:self.view];
            
        }
        if (buttonIndex == 0) {
            // 增量同步本地变化的备忘到云端
            [self syncToCloud];
        }
    }
    
    if (actionSheet.tag == 2) {
        if (buttonIndex == 0) {
            // 确认恢复
            [self recoveryFromCloud];
        }
    }
}

#pragma mark - PAPasscodeViewControllerDelegate

- (void)PAPasscodeViewControllerDidCancel:(PAPasscodeViewController *)controller {
    [controller dismissModalViewControllerAnimated:YES];
    NSString *passcode = [[NSUserDefaults standardUserDefaults] objectForKey:kPasscode];
    if (passcode.length > 0) {
        // 密码开启状态，保证密码开关为开
        [self.passcodeSwitch setOn:YES];
    } else {
        [self.passcodeSwitch setOn:NO];
    }
}

- (void)PAPasscodeViewControllerDidSetPasscode:(PAPasscodeViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:^{
        NSLog(@"passcode: %@", controller.passcode);
        // 设置密码，保存设置好的密码
        [[NSUserDefaults standardUserDefaults] setObject:controller.passcode forKey:kPasscode];
    }];
}

- (void)PAPasscodeViewControllerDidEnterPasscode:(PAPasscodeViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:^{
        if (!self.passcodeSwitch.isOn) {
            // 关闭密码，清空保存的密码
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kPasscode];
        }
    }];
}



@end
