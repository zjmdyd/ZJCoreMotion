//
//  ViewController.m
//  ZJCoreMotion
//
//  Created by YunTu on 15/8/29.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ViewController.h"

#import "ZJAccelerometerViewController.h"
#import "ZJGyroViewController.h"
#import "ZJUserAccelerationViewController.h"
#import "ZJCMAttitudeViewController.h"
#import "ZJMagnetometerViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSArray *_sectionTitles, *_titles;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *CELLID = @"cellID";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAry];
}

- (void)initAry {
    _sectionTitles = @[@"基础知识篇", @"Demo篇"];
    
    NSArray *s1 = @[@"Accelerometer(加速计)", @"Gyro(陀螺仪)", @"UserAcceleration", @"CMAttitude", @"Magnetometer(磁力仪)"];
    NSArray *s2 = @[@"FlipAnimation"];
    _titles = @[s1, s2];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionTitles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sectionTitles[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.textLabel.text = _titles[indexPath.section][indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    UIViewController *vc;
    
    if (indexPath.section == 0) {
        if (row == 0) {
            vc = [ZJAccelerometerViewController new];
        }else if (row == 1) {
            vc = [ZJGyroViewController new];
        }else if (row == 2) {
            vc = [ZJUserAccelerationViewController new];
        }else if (row == 3) {
            vc = [ZJCMAttitudeViewController new];
        }else if (row == 4) {
            vc = [ZJMagnetometerViewController new];
        }
    }else if (indexPath.section == 1){
        if (row == 0) {
        }
    }
    
    if (vc) {
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
