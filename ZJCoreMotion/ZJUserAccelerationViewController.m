//
//  ZJUserAccelerationViewController.m
//  ZJCoreMotion
//
//  Created by YunTu on 15/9/7.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJUserAccelerationViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "ZJMotionManager.h"

@interface ZJUserAccelerationViewController ()

@property(nonatomic, strong) CMMotionManager *motionMange;

@end

@implementation ZJUserAccelerationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.text = @"左侧敲击返回父VC";
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = self.view.center;
    [self.view addSubview:label];
    
    self.motionMange = [ZJMotionManager shareMotionManager];
    
    if (self.motionMange.isDeviceMotionAvailable) {
        [self.motionMange startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *data, NSError *error) {
            if (data.userAcceleration.x < -2.5f) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"deviceMotion服务不可用" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.motionMange.isDeviceMotionActive) {
        [self.motionMange stopDeviceMotionUpdates];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
