//
//  BackgroundSettingViewController.m
//  iRemember
//
//  Created by nest0r on 13-5-28.
//  Copyright (c) 2013年 nestree. All rights reserved.
//

#import "BackgroundSettingViewController.h"

@interface BackgroundSettingViewController ()

@property (strong, nonatomic) WaterFlowView *scrollView;
@property (strong, nonatomic) NSMutableArray *backgroundArray;

@end

@implementation BackgroundSettingViewController

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
	// Do any additional setup after loading the view.
    self.scrollView = [[WaterFlowView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT - 20)];
    [self.scrollView setWaterFlowDataSource:self];
    [self.scrollView setWaterFlowDelegate:self];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    self.backgroundArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 28; i++) {
        [self.backgroundArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    [self.scrollView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WaterFlowViewDataSource

- (NSInteger)numberOfColumnsInWaterFlowView:(WaterFlowView *)waterFlowView
{
    return 2;
}

- (NSInteger)waterFlowView:(WaterFlowView *)waterFlowView numberOfRowsInColumn:(NSInteger)column
{
    if (self.backgroundArray.count % 2 == 0) {
        // 备忘数目为2的倍数, 则每列行数都为总备忘数的一半
        return self.backgroundArray.count / 2;
    } else {
        // 备忘数为奇数,则第一列比第二列多返回一个
        if (column == 0) {
            return self.backgroundArray.count / 2 + 1;
        } else {
            return self.backgroundArray.count / 2;
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
//    if ((indexPath.column + 1) * (indexPath.row + 1) > self.backgroundArray.count) {
//        return nil;
//    }
    cell.backImageView.image = nil;
    int imageCount = indexPath.row * 2 + indexPath.column + 1;
    cell.backImageView.backgroundColor =  [UIColor
                                           colorWithPatternImage:[UIImage imageNamed:[NSString
                                                                                      stringWithFormat:@"bg_%d.jpg", imageCount]]];
    return cell;
}

- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(WFIndexPath *)indexPath
{
	return 120;
}

#pragma mark - WaterFlowViewDelegate

- (void)waterFlowView:(WaterFlowView *)waterFlowView didSelectRowAtIndexPath:(WFIndexPath *)indexPath
{
    int imageCount = indexPath.row * 2 + indexPath.column + 1;
    NSLog(@"image count :%d", imageCount);
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:imageCount] forKey:kBackground];
    [self.mainViewController resetBackground];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
