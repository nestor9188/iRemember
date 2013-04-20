//
//  MainViewController.m
//  iRemember
//
//  Created by nest0r on 13-4-4.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "NoteViewController.h"
#import "Note.h"
#import "NoteDatabase.h"
#import "NoteCell.h"
#import "NotePreview.h"

#define kPadding            50
#define kPreviewWidth       80

@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) WaterFlowView *scrollView;
@property (strong, nonatomic) NoteViewController *noteViewController;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) NSMutableArray *notes;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES];
    
    WaterFlowView *scrollView = [[WaterFlowView alloc] initWithFrame:self.tableView.frame];
    [scrollView setAlwaysBounceVertical:YES];
    [scrollView setWaterFlowDataSource:self];
    [scrollView setWaterFlowDelegate:self];
    self.scrollView = scrollView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkUnreadNote];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resetRemindFinishedNote];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.notes count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"备忘";
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    NoteCell *cell = (NoteCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NoteCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    Note *note = [self.notes objectAtIndex:indexPath.row];
    if (note.state == NoteStateRemindFinished) cell.contentLabel.textColor = [UIColor redColor];
    cell.contentLabel.text = [NSString stringWithFormat:@"%d,%@", note.state, note.content];
    cell.dateLabel.text = [Utilities customDateString:note.modifiedDate];
    NSLog(@"modified date is: %@", note.modifiedDate);
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Note *note = [self.notes objectAtIndex:indexPath.row];
    if (!_noteViewController) {
        self.noteViewController = [[NoteViewController alloc] init];
    }
    self.noteViewController.note = note;
    [self.navigationController pushViewController:self.noteViewController animated:YES];
}

#pragma mark - WaterFlowViewDataSource

- (NSInteger)waterFlowView:(WaterFlowView *)waterFlowView numberOfRowsInColumn:(NSInteger)column
{
    if (self.notes.count % 2 == 0) {
        // 备忘数目为2的倍数, 则每列行数都为总备忘数的一半
        return self.notes.count / 2;
    } else {
        // 备忘数为奇数,则第一列比第二列多返回一个
        if (column == 0) {
            return self.notes.count / 2 + 1;
        } else {
            return self.notes.count / 2;
        }
    }
}

- (WaterFlowViewCell *)waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(WFIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"WaterFlowViewCell";
    WaterFlowViewCell *cell = [self.scrollView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell) {
#ifdef DEBUG
        //NSLog(@"Cell is allocated.\n");
#endif
        cell = [[WaterFlowViewCell alloc] initWithIdentifier:cellIdentifier];
        cell.delegate = waterFlowView;
    } else {
#ifdef DEBUG
        //NSLog(@"Cell is reused from reuse-queue.\n");
#endif
    }
    if ((indexPath.column + 1) * (indexPath.row + 1) > self.notes.count) {
        return nil;
    }
    Note *note = [self.notes objectAtIndex:indexPath.row * waterFlowView.columns + indexPath.column];
    cell.contentLabel.text = note.content;
    if (indexPath.column == 0) {
        cell.backgroundColor = [UIColor redColor];
    } else if (indexPath.column == 1) {
        cell.backgroundColor = [UIColor yellowColor];
    } else {
        cell.backgroundColor = [UIColor blueColor];
    }
    
    return cell;
}

- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(WFIndexPath *)indexPath
{
    float height = 0;
    
	switch ((indexPath.row + indexPath.column )  % 5) {
		case 0:
			height = 127;
			break;
		case 1:
			height = 100;
			break;
		case 2:
			height = 87;
			break;
		case 3:
			height = 114;
			break;
		case 4:
			height = 140;
			break;
		default:
			break;
	}
	
	height += indexPath.row + indexPath.column;
	
    height = 120;
	return height;
}

- (NSInteger)numberOfColumnsInWaterFlowView:(WaterFlowView *)waterFlowView
{
    return 2;
}

#pragma mark - WaterFlowViewDelegate

- (void)waterFlowView:(WaterFlowView *)waterFlowView didSelectRowAtIndexPath:(WFIndexPath *)indexPath
{
    NSLog(@"selected");
    Note *note = [self.notes objectAtIndex:indexPath.row * waterFlowView.columns + indexPath.column];
    if (!_noteViewController) {
        self.noteViewController = [[NoteViewController alloc] init];
    }
    self.noteViewController.note = note;
    [self.navigationController pushViewController:self.noteViewController animated:YES];
}

#pragma mark - Actions

- (IBAction)showRightView:(id)sender {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.menuController showRightController:YES];
}

- (IBAction)addNote:(id)sender {
    if (!_noteViewController) {
        self.noteViewController = [[NoteViewController alloc] init];
    }
    _noteViewController.note = nil;
    [self presentViewController:_noteViewController animated:YES completion:nil];
}

- (IBAction)toggleDisplayMode:(id)sender {
    if (self.tableView.superview) {
        // 显示格子视图
        [self.scrollView reloadData];
        [self.tableView removeFromSuperview];
        [self.view addSubview:self.scrollView];
    } else {
        // 显示列表视图
        [self.scrollView removeFromSuperview];
        [self.view addSubview:self.tableView];
    }
}

- (void)checkUnreadNote {
    self.notes = [[NSMutableArray alloc] initWithArray:[[NoteDatabase sharedInstance] notes]];
    for (Note *note in self.notes) {
        if (note.state == NoteStateRemindByDate || note.state == NoteStateRemindByDateAndLocation) {
            if (!([[Utilities dateFromString:note.fireDate] timeIntervalSinceNow] > 0)) {
                note.state = NoteStateRemindFinished;
                note.fireDate = @"";
                [[NoteDatabase sharedInstance] updateNote:note];
            }
        }
    }
    [self.tableView reloadData];
}

- (void)resetRemindFinishedNote {
    // 如果有状态为NoteStateRemindFinished的note,重置状态
    for (Note *note in self.notes) {
        if (note.state == NoteStateRemindFinished) {
            if (![note.fireDate isEqualToString:@""]) {
                // 仍然有根据时间提醒的设置
                note.state = NoteStateRemindByDate;
                // 移除位置提醒通知
                [Utilities removeNotificationWithNoteID:note.noteID withMode:NotificationModeLocation];
            } else if (note.fireDistance > 0) {
                // 仍然有根据位置提醒的设置
                [[[UIAlertView alloc] initWithTitle:@"lalafs"
                                           message:nil
                                          delegate:self
                                 cancelButtonTitle:@"cancel"
                                 otherButtonTitles:nil, nil]
                                                show];
                note.state = NoteStateRemindByLocation;
                // 移除日期提醒通知
                [Utilities removeNotificationWithNoteID:note.noteID withMode:NotificationModeDate];
            } else {
                // 没有任何提醒设置，重置状态为default
                note.state = NoteStateDefault;
                [Utilities removeNotificationWithNoteID:note.noteID withMode:NotificationModeDate];
                [Utilities removeNotificationWithNoteID:note.noteID withMode:NotificationModeLocation];
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.notes indexOfObject:note] inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [[NoteDatabase sharedInstance] updateNote:note];
        }
    }
    UIApplication *app = [UIApplication sharedApplication];
    int count = [[app scheduledLocalNotifications] count];
    NSLog(@"notification cound is: %d", count);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
