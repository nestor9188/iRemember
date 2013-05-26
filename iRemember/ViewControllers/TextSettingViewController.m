//
//  TextSettingViewController.m
//  iRemember
//
//  Created by nest0r on 13-5-23.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import "TextSettingViewController.h"
#import "GzColors.h"

@interface TextSettingViewController ()

@property (strong ,nonatomic)  WEPopoverController *popController;
@property (strong, nonatomic) UITableViewCell *colorCell;

@end

@implementation TextSettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBounces:NO];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"字体大小";
    }
    if (section == 1) {
        return @"字体颜色";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 56;
    }
    return tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    // Configure the cell...
    if (indexPath.section == 0) {
        // 字体大小
        NSArray *items = [NSArray arrayWithObjects:@"小", @"中", @"大", nil];
        UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:items];
        CGRect frame = seg.frame;
        frame.size.width = 120;
        seg.frame = frame;
        seg.segmentedControlStyle = UISegmentedControlStylePlain;
        [seg addTarget:self
                action:@selector(fontSizeChanged:)
      forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = seg;
        cell.textLabel.text = @"当前大小";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        int fontSize = [[[NSUserDefaults standardUserDefaults] objectForKey:kNoteFontSize] intValue];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        switch (fontSize) {
            case 16:
                seg.selectedSegmentIndex = 0;
                break;
            case 20:
                seg.selectedSegmentIndex = 1;
                break;
            case 24:
                seg.selectedSegmentIndex = 2;
                break;
            default:
                break;
        }
    }
    if (indexPath.section == 1) {
        // 字体颜色
        cell.textLabel.textColor = [UIColor purpleColor];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.text = @"当前颜色";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.colorCell = cell;
    }
    if (indexPath.section == 2) {
        // 完成
        cell.textLabel.text = @"完成";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"编辑： %d", indexPath.row);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"index :%d", indexPath.row);
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        // 设置颜色
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

        if (!self.popController) {
            
            ColorViewController *contentViewController = [[ColorViewController alloc] init];
            contentViewController.delegate = self;
            self.popController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
            self.popController.delegate = self;
            self.popController.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
            
            [self.popController presentPopoverFromRect:cell.frame
                                                    inView:self.view
                                  permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown)
                                                  animated:YES];
            
        } else {
            [self.popController dismissPopoverAnimated:YES];
            self.popController = nil;
        }
    }
    
    if (indexPath.section == 2) {
        // 点击完成，回到主视图
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - ColorViewDelegate

- (void)colorPopoverControllerDidSelectColor:(NSString *)hexColor {
    NSLog(@"选中颜色 : %@", hexColor);
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.colorCell.textLabel.textColor = [GzColors colorFromHex:hexColor];
                     }];
    [[NSUserDefaults standardUserDefaults] setObject:hexColor forKey:kNoteFontColor];
    [self.popController dismissPopoverAnimated:YES];
    self.popController = nil;
}

#pragma mark WEPopoverControllerDelegate implementation

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	self.popController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//YES表示弹出试图将会在点击外面的部分后消失
	return YES;
}

#pragma mark - Actions

- (void)fontSizeChanged:(UISegmentedControl *)seg {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    int fontSize = 0;
    switch (seg.selectedSegmentIndex) {
        case 0:
            fontSize = 16;
            break;
        case 1:
            fontSize = 20;
            break;
        case 2:
            fontSize = 24;
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:fontSize] forKey:kNoteFontSize];
}

@end
