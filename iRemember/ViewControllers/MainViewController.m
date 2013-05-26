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

#define kPadding            50
#define kPreviewWidth       80

@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) WaterFlowView *scrollView;
@property (strong, nonatomic) NoteViewController *noteViewController;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) NSMutableArray *notes;
@property (strong, nonatomic) UISearchDisplayController *mySearchDisplayController;
@property (strong, nonatomic) NSMutableArray *filteredNoteArray;

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
    
    UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"8.jpg"]];
    [self.view addSubview:backView];
    [self.view sendSubviewToBack:backView];
    
    WaterFlowView *scrollView = [[WaterFlowView alloc] initWithFrame:self.tableView.frame];
    [scrollView setAlwaysBounceVertical:YES];
    [scrollView setWaterFlowDataSource:self];
    [scrollView setWaterFlowDelegate:self];
    self.scrollView = scrollView;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -44, IPHONE_WIDTH, 44)];
    [searchBar setPlaceholder:@"搜索"];
    [self.view addSubview:searchBar];
    
    UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar
                                                                                           contentsController:self];
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.delegate = self;
    self.mySearchDisplayController = searchDisplayController;
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredNoteArray count];
    } else {
        return [self.notes count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    NoteCell *cell = (NoteCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NoteCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    Note *note = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        note = [self.filteredNoteArray objectAtIndex:indexPath.row];
    } else {
        note = [self.notes objectAtIndex:indexPath.row];
    }
    
    if (note.state == NoteStateRemindFinished) cell.contentLabel.textColor = [UIColor redColor];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@", note.content];
    cell.dateLabel.text = [Utilities customDateString:note.modifiedDate];
    NSLog(@"modified date is: %@", note.modifiedDate);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除备忘
        Note *note = [self.notes objectAtIndex:indexPath.row];
        [[NoteDatabase sharedInstance] deleteNote:note];
        self.notes = [[NSMutableArray alloc] initWithArray:[[NoteDatabase sharedInstance] notes]];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    // 为了更好的用户体验，在右侧显示删除按钮时隐藏时间标签
    NoteCell *cell = (NoteCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.dateLabel.alpha = 0;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         cell.dateLabel.alpha = 0;
                     }];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    // 为了更好的用户体验，在右侧删除按钮消失时显示时间标签
    NoteCell *cell = (NoteCell *)[tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         cell.dateLabel.alpha = 1.0;
                     }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Note *note = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        note = [self.filteredNoteArray objectAtIndex:indexPath.row];
    } else {
        note = [self.notes objectAtIndex:indexPath.row];
    }
    if (!_noteViewController) {
        self.noteViewController = [[NoteViewController alloc] init];
    }
    self.noteViewController.note = note;
    [self.navigationController pushViewController:self.noteViewController animated:YES];
}

#pragma mark - WaterFlowViewDataSource

- (NSInteger)numberOfColumnsInWaterFlowView:(WaterFlowView *)waterFlowView
{
    return 2;
}

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
        cell = [[WaterFlowViewCell alloc] initWithIdentifier:cellIdentifier];
        cell.delegate = waterFlowView;
    }
    if ((indexPath.column + 1) * (indexPath.row + 1) > self.notes.count) {
        return nil;
    }
    Note *note = [self.notes objectAtIndex:indexPath.row * waterFlowView.columns + indexPath.column];
    cell.contentLabel.text = note.content;
    return cell;
}

- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(WFIndexPath *)indexPath
{
    float height = 120;
	return height;
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
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.menuController showRightController:YES];
}

- (IBAction)addNote:(id)sender {
    self.noteViewController = [[NoteViewController alloc] init];
    _noteViewController.note = nil;
    [self.navigationController pushViewController:_noteViewController animated:YES];
}

- (IBAction)toggleDisplayMode:(id)sender {
    if (self.tableView.superview) {
        // 显示格子视图
        [self.scrollView reloadData];
        [self.tableView removeFromSuperview];
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.8;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = @"oglFlip";
        animation.subtype = kCATransitionFromLeft;
        [self.view addSubview:self.scrollView];
        [self.view.layer addAnimation:animation forKey:@"animation"];
    } else {
        // 显示列表视图
        [self.scrollView removeFromSuperview];
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.8;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = @"oglFlip";
        animation.subtype = kCATransitionFromLeft;
        [self.view addSubview:self.tableView];
        [self.view.layer addAnimation:animation forKey:@"animation"];
    }
}

- (void)checkUnreadNote {
    if ([self.searchDisplayController isActive]) {
        // 如果是搜索界面，不执行下面的语句
        return;
    }
    self.notes = [[NSMutableArray alloc] initWithArray:[[NoteDatabase sharedInstance] notes]];
    self.filteredNoteArray = [[NSMutableArray alloc] initWithCapacity:self.notes.count];
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

#pragma mark - Public methods

- (void)beginSearch {
    CGRect frame = self.searchDisplayController.searchBar.frame;
    frame.origin.y = 0;
    CGRect tableFrame = self.tableView.frame;
    tableFrame.origin.y = 44;
    tableFrame.size.height = IPHONE_HEIGHT - 20 - 44 - 44;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.searchDisplayController.searchBar.frame = frame;
                         self.tableView.frame = tableFrame;
                     }];
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

#pragma mark - Search methods

- (void)filtContentForSearchText:(NSString *)searchText {
    [self.filteredNoteArray removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.content contains[c] %@", searchText];
    NSArray *tempArray = [self.notes filteredArrayUsingPredicate:predicate];
    self.filteredNoteArray = [NSMutableArray arrayWithArray:tempArray];
}

#pragma mark - SearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

}

#pragma mark - SearchDisplayController delegate

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    NSLog(@"将要隐藏");
    CGRect frame = self.searchDisplayController.searchBar.frame;
    frame.origin.y = -44;
    CGRect tableFrame = self.tableView.frame;
    tableFrame.origin.y = 0;
    tableFrame.size.height = IPHONE_HEIGHT - 20 - 44;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.searchDisplayController.searchBar.frame = frame;
                         self.tableView.frame = tableFrame;
                     }];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView{

}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filtContentForSearchText:searchString];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
