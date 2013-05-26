//
//  NoteViewController.m
//  iRemember
//
//  Created by nest0r on 13-4-9.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import "NoteViewController.h"
#import "Note.h"
#import "NoteDatabase.h"
#import "KGNotePad.h"
#import "ReminderViewController.h"
#import "GzColors.h"

@interface NoteViewController ()

@property (strong, nonatomic) IBOutlet KGNotePad *notePad;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) UIButton *hideButton;
@property (readwrite, nonatomic) BOOL isNewNote;
@property (readwrite, nonatomic) BOOL isNoteEdited;
@property (readwrite, nonatomic) BOOL isShowReminderView;

- (void)saveNote;

@end

@implementation NoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    self = [self initWithNibName:@"NoteViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 加载顶部时间视图
//    CGRect frame = _infoView.frame;
//    frame.origin.x = 20;
//    frame.origin.y = -24;
//    _infoView.frame = frame;
    
//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
//    topView.backgroundColor = [UIColor whiteColor];
//    CGRect frame = topView.frame;
//    frame.origin.x = 20;
//    frame.origin.y = 0 - frame.size.height;
//    topView.frame = frame;
    
//    [self.notePad.textView addSubview:topView];
//    self.notePad.textView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
//    [self.notePad.textView setContentOffset:CGPointMake(0, -44)];
    
    // custom hideButton
    UIButton *hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hideButton setFrame:CGRectMake(IPHONE_WIDTH - 36, IPHONE_HEIGHT - 20, 36, 36)];
    [hideButton setImage:[UIImage imageNamed:@"downArrow_72"] forState:UIControlStateNormal];
    [hideButton setAlpha:0.7];
    [hideButton addTarget:self
                        action:@selector(hideKeyboard:)
              forControlEvents:UIControlEventTouchUpInside];
    [hideButton setHidden:YES];
    [self.view addSubview:hideButton];
    self.hideButton = hideButton;
    
    self.notePad.textView.delegate = self;
    
    UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background1_320_480.jpg"]];
    [self.view addSubview:backView];
    [self.view sendSubviewToBack:backView];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will appear");
    [super viewWillAppear:animated];
    // 设置字体大小
    int fontSize = [[[NSUserDefaults standardUserDefaults] objectForKey:kNoteFontSize] intValue];
    [self.notePad.textView setFont:[UIFont systemFontOfSize:fontSize]];
    
    // 设置字体颜色
    NSString *colorHex = [[NSUserDefaults standardUserDefaults] objectForKey:kNoteFontColor];
    UIColor *textColor = [GzColors colorFromHex:colorHex];
    [self.notePad.textView setTextColor:textColor];
    
    
    if (self.isShowReminderView) {
        self.isShowReminderView = NO;
        return;
    }
    // 添加键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameWillChanged:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    if (_note == nil) {
        self.isNewNote = YES;
        Note *note = [[Note alloc] init];
        self.note = note;
        return;
    }
    self.notePad.textView.text = _note.content;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"view will disappear");

    if (self.isShowReminderView) return;
    
    // 取消键盘监听
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    self.isNoteEdited = YES;
    return YES;
}

#pragma mark - Keyboard listner

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.notePad.frame;
    frame.size.height = 460 - keyboardRect.size.height;
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.notePad.frame = frame;
                     }];
    frame = self.hideButton.frame;
    frame.origin.y = IPHONE_HEIGHT - 20 - keyboardRect.size.height - frame.size.height;
    self.hideButton.frame = frame;
    [self.hideButton setHidden:NO];
    NSLog(@"notePad frame is: %f", self.notePad.frame.size.height);
    NSLog(@"keyboard will show!!!!!!!!!!!!!!");
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.notePad.frame;
    frame.size.height = 416;
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.notePad.frame = frame;
                     }];
    [self.hideButton setHidden:YES];
}

- (void)keyboardFrameWillChanged:(NSNotification *)notification {
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"keyboard height is: %f", keyboardRect.size.height);
    CGRect frame = self.hideButton.frame;
    frame.origin.y = IPHONE_HEIGHT - 20 - keyboardRect.size.height - frame.size.height;
    self.hideButton.frame = frame;
}

#pragma mark - Note methods

- (void)saveNote {
    _note.content = self.notePad.textView.text;
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    _note.modifiedDate = dateString;
    NSLog(@"date is: %@", dateString);
    if (self.isNewNote) {
        // 新建note
        if (![self.notePad.textView.text isEqualToString:@""]) {
            // 有内容再新建
            [[NoteDatabase sharedInstance] insertNote:_note];
        }
    } else {
        // 更新note
        if (self.isNoteEdited) {
            // 已经编辑了再更新
            [[NoteDatabase sharedInstance] updateNote:_note];
            NSLog(@"note state is: %d", _note.state);
        }
    }
}

- (void)resetNote {
    self.isNewNote = NO;
    self.isNoteEdited = NO;
    self.note = nil;
    self.notePad.textView.text = @"";
}

#pragma mark - Actions

- (void)hideKeyboard:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender {
    if (!self.isNewNote) {
        // 非新建备忘时才保存
        [self saveNote];
    }
    
    [self resetNote];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showReminderSettings:(id)sender {
    self.isShowReminderView = YES;
    ReminderViewController *reminderViewController = [[ReminderViewController alloc] initWithNote:self.note];
    [reminderViewController setDelegate:self];
    [self presentViewController:reminderViewController animated:YES completion:nil];
}

- (IBAction)done:(id)sender {
    [self saveNote];
    
    [self resetNote];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)share:(id)sender {
    //构造分享内容
    NSString *shareMsg = self.notePad.textView.text;
    NSString *description = self.note.modifiedDate;
    id<ISSContent> publishContent = [ShareSDK content:shareMsg
                                       defaultContent:@""
                                                image:nil
                                                title:@"我的小小备忘,iRemember"
                                                  url:@"http://www.sharesdk.cn"
                                          description:description
                                            mediaType:SSPublishContentMediaTypeNews];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];

}

#pragma mark - ReminderViewDelegate

- (void)reminderView:(ReminderViewController *)reminderView noteSettingChanged:(Note *)note {
    NSLog(@"note update");
    self.isNoteEdited = YES;
    self.note = note;
    if (self.note.state == NoteStateRemindByDate) {
        // 更新时间提醒通知设定
        [self updateDateNotificationWithNote:note];
    }
    
    if (self.note.state == NoteStateRemindByLocation) {
        // 更新位置提醒监听设定
        [self updateLocationNotificationWithNote:note];
    }
    
    if (self.note.state == NoteStateRemindByDateAndLocation) {
        // 时间和位置提醒方式都更新
        [self updateDateNotificationWithNote:note];
        [self updateLocationNotificationWithNote:note];
    }
}

#pragma mark - Notification methods

- (void)updateDateNotificationWithNote:(Note *)note {
    // 更新根据时间提醒的通知
    UIApplication *application = [UIApplication sharedApplication];
    NSArray *preNotifications = [application scheduledLocalNotifications];
    for (UILocalNotification *notification in preNotifications) {
        if ([[notification.userInfo objectForKey:@"noteID"] integerValue] == note.noteID &&
            [[notification.userInfo objectForKey:@"notificationMode"] integerValue] == NotificationModeDate) {
            // 移除旧的通知
            [application cancelLocalNotification:notification];
        }
    }
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.fireDate = [Utilities dateFromString:note.fireDate];
    localNotification.repeatInterval = 0;
    localNotification.alertBody = [NSString stringWithFormat:@"这是时间通知%@", note.content];
    localNotification.alertAction = @"进入";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:note.noteID], @"noteID",
                                     [NSNumber numberWithInteger:NotificationModeDate], @"notificationMode",
                                     nil];
    localNotification.userInfo = userInfo;
    
    // 将通知信息添加到程序
    [application scheduleLocalNotification:localNotification];
}

- (void)updateLocationNotificationWithNote:(Note *)note {
    // 更新监听的地理位置范围,为一个圆,中心为当前位置,半径为设置的提醒距离,离开此范围后调用本地通知
    NSLog(@"这个要执行2此？");
    
    NSArray *preRegions = [[[HTLocationManager sharedLocationManager] monitoredRegions] allObjects];
    for (int i = 0; i < preRegions.count; i++) {
        NSString *tID = [[preRegions objectAtIndex:i] identifier];
        if ([tID isEqualToString:[NSString stringWithFormat:@"%d", note.noteID]]) {
            [[HTLocationManager sharedLocationManager] stopMonitoringForRegion:[preRegions objectAtIndex:i]];
        }
    }
    
    CLLocation *location = [[HTLocationManager sharedLocationManager] location];
    CLRegion *geofence = [[CLRegion alloc] initCircularRegionWithCenter:location.coordinate
                                                                 radius:note.fireDistance   // 半径为设置的距离
                                                             identifier:[NSString stringWithFormat:@"%d", self.note.noteID]];
    

//    [[[HTLocationManager alloc] init] startMonitoringForRegion:geofence
//                                                   onExitBlock:^(NSString *identifier) {
//                                                       [self beginLocationNotificationWithNote:note];
//                                                   }];
    
    [[HTLocationManager sharedInstance] startMonitoringForRegion:geofence
                                                     onExitBlock:^(NSString *identifier) {
                                                         NSLog(@"identifier is: %@", identifier);
                                                         [self beginLocationNotificationWithNote:note];
                                                     }];
}

- (void)beginLocationNotificationWithNote:(Note *)note {
    UIApplication *application = [UIApplication sharedApplication];
    NSArray *preNotifications = [application scheduledLocalNotifications];
    for (UILocalNotification *notification in preNotifications) {
        if ([[notification.userInfo objectForKey:@"noteID"] integerValue] == note.noteID &&
            [[notification.userInfo objectForKey:@"notificationMode"] integerValue] == 2) {
            // 移除旧的通知
            [application cancelLocalNotification:notification];
        }
    }
    static NSInteger inteval = 1;
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    // 一秒后发出通知, 如果有连续多个通知，之后的通知全部延迟5秒发出
    localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:inteval];   
    localNotification.repeatInterval = 0;
    localNotification.alertBody = [NSString stringWithFormat:@"这是位置通知%@", note.content];
    localNotification.alertAction = @"进入";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:note.noteID], @"noteID",
                                     [NSNumber numberWithInteger:NotificationModeLocation], @"notificationMode",
                                     nil];
    localNotification.userInfo = userInfo;
    
    // 将note状态变为已完成提醒，并设置提醒距离为0
    note.fireDistance = 0;
    note.state = NoteStateRemindFinished;
    [[NoteDatabase sharedInstance] updateNote:note];
    
    // 将通知信息添加到程序
    [application scheduleLocalNotification:localNotification];
}

@end
