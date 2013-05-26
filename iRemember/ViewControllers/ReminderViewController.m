//
//  ReminderViewController.m
//  iRemember
//
//  Created by nest0r on 13-4-11.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import "ReminderViewController.h"

@interface ReminderViewController ()

@property (readwrite, nonatomic) BOOL isRemindByDate;
@property (readwrite, nonatomic) BOOL isRemindByLocation;
@property (readwrite, nonatomic) BOOL isNoteReminderEdited;

- (void)updateNote;

@end

@implementation ReminderViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNote:(Note *)note {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.note = note;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![self.note.fireDate isEqualToString:@""]) self.isRemindByDate = YES;
    if (self.note.fireDistance > 0) self.isRemindByLocation = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num;
    if (section == 0) {
        self.isRemindByDate ? (num = 2) : (num = 1);
    }
    if (section == 1) {
        self.isRemindByLocation ? (num = 3) : (num = 1);
    }
    if (section == 2) {
        num = 1;
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"cell %d", indexPath.row];
    
    if (indexPath.section == 0) {
        // date cell
        switch (indexPath.row) {
            case 0: {
                cell.textLabel.text = @"根据时间提醒";
                UISwitch *dateSwitch = [[UISwitch alloc] init];
                self.isRemindByDate ? [dateSwitch setOn:YES] : [dateSwitch setOn:NO];
                [dateSwitch addTarget:self
                               action:@selector(remindByDate:)
                     forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = dateSwitch;
                break;
            }
            case 1: {
                DateInputTableViewCell *dateCell = [[DateInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                [dateCell setDatePickerMode:UIDatePickerModeDateAndTime];
                if (![self.note.fireDate isEqualToString:@""])
                    [dateCell setDateValue:[Utilities dateFromString:self.note.fireDate]];
                dateCell.delegate = self;
                dateCell.textLabel.text = @"提醒时间";
                return dateCell;
            }
            default:
                break;
        }
    }
    
    if (indexPath.section == 1) {
        // location cell
        switch (indexPath.row) {
            case 0: {
                cell.textLabel.text = @"根据位置提醒";
                UISwitch *locationSwitch = [[UISwitch alloc] init];
                self.isRemindByLocation ? [locationSwitch setOn:YES] : [locationSwitch setOn:NO];
                [locationSwitch addTarget:self
                                   action:@selector(remindByLocation:)
                         forControlEvents:UIControlEventValueChanged];
                [cell setAccessoryView:locationSwitch];                
                break;
            }
            case 1: {
                IntegerInputTableViewCell *integerCell = [[IntegerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                [integerCell setNumberValue:self.note.fireDistance];
                integerCell.delegate = self;
                integerCell.textLabel.text = @"提醒距离";
                return integerCell;
            }
            case 2: {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                cell.backgroundColor = [UIColor clearColor];
                cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
                cell.textLabel.font = [UIFont systemFontOfSize:13];
                cell.textLabel.textColor = [UIColor colorWithWhite:0 alpha:0.8];
                cell.textLabel.numberOfLines = 2;
                if (self.note.fireDistance == 0) {
                    cell.textLabel.text = @"请输入提醒距离,iRemimber将在您离开距此地该距离后提醒您";
                } else {
                    cell.textLabel.text = [NSString stringWithFormat:@"将在离开%d米后提醒我", self.note.fireDistance];
                }
                
                return cell;
            }
                
            default:
                break;
        }
    }
    
    if (indexPath.section == 2) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = @"完成";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - CustomCellDelegate

- (void)tableViewCell:(IntegerInputTableViewCell *)cell didEndEditingWithInteger:(NSUInteger)value {
    self.isNoteReminderEdited = YES;

    self.note.fireDistance = value;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSLog(@"distance is: %d", value);
}

- (void)tableViewCell:(DateInputTableViewCell *)cell didEndEditingWithDate:(NSDate *)value {
    NSLog(@"选中时间");
    self.isNoteReminderEdited = YES;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDefaultDateFormatter];
    self.note.fireDate = [dateFormatter stringFromDate:value];
}

#pragma mark - Actions

- (void)remindByDate:(id)sender {
    self.isNoteReminderEdited = YES;
    
    UISwitch *dateSwitch = (UISwitch *)sender;
    if (dateSwitch.isOn) {
        self.isRemindByDate = YES;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        self.isRemindByDate = NO;
        self.note.fireDate = @"";
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)remindByLocation:(id)sender {
    self.isNoteReminderEdited = YES;

    UISwitch *dateSwitch = (UISwitch *)sender;
    if (dateSwitch.isOn) {
        self.isRemindByLocation = YES;
        
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:1];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:1];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1, indexPath2, nil]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        self.isRemindByLocation = NO;
        self.note.fireDistance = 0;
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:1];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:1];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1, indexPath2, nil]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)updateNote {
    if (!self.isNoteReminderEdited) return;         // 如果reminder设置没有变化，不更新
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDefaultDateFormatter];
    if ([[dateFormatter dateFromString:self.note.fireDate] timeIntervalSinceNow] > 0) {
        // 提醒时间设置如果在当前时间之后
        if (self.note.fireDistance > 0) {
            self.note.state = NoteStateRemindByDateAndLocation;
        } else {
            self.note.state = NoteStateRemindByDate;
        }
    } else {
        // 提醒时间设置如果在当前时间之前
        self.note.fireDate = @"";           // fireDate日期无效，清空它
        if (self.note.fireDistance > 0) {
            self.note.state = NoteStateRemindByLocation;
        } else {
            self.note.state = NoteStateDefault;
        }
    }
    
    [self.delegate reminderView:self noteSettingChanged:self.note];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        [self updateNote];
        [self dismissModalViewControllerAnimated:YES];
    }
}

@end
