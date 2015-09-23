//
//  ZJMagnetometerViewController.m
//  ZJCoreMotion
//
//  Created by YunTu on 15/9/7.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJMagnetometerViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "ZJMotionManager.h"

@interface ZJMagnetometerViewController ()

@property(nonatomic, strong) CMMotionManager *motionMange;

@property (strong, nonatomic) UIImageView *compassIV;

@end

@implementation ZJMagnetometerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.compassIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bnavi_icon_location_fixed"]];
    self.compassIV.frame = CGRectMake(0, 0, 54, 54);
    self.compassIV.center = self.view.center;
    [self.view addSubview:self.compassIV];
    
    self.motionMange = [ZJMotionManager shareMotionManager];

    if (self.motionMange.isMagnetometerAvailable) {
        [self.motionMange startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData *magnetometerData, NSError *error) {
            double rotation = atan2(magnetometerData.magneticField.x, magnetometerData.magneticField.y) - M_PI;    // 垂直向下时坐标:(0, -1, 0) atan2(0, -1); 即:x = -1, y = 0;弧度数为pi
            self.compassIV.transform = CGAffineTransformMakeRotation(rotation);
        }];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"磁力仪不可用" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.motionMange.isMagnetometerActive) {
        [self.motionMange stopMagnetometerUpdates];
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
