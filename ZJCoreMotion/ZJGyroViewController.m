//
//  ZJGyroViewController.m
//  ZJCoreMotion
//
//  Created by YunTu on 15/9/7.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJGyroViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "ZJMotionManager.h"

@interface ZJGyroViewController ()

@property(nonatomic, strong) CMMotionManager *motionMange;

@property (strong, nonatomic) UIImageView *compassIV;

@end

@implementation ZJGyroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.compassIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bnavi_icon_location_fixed"]];
    self.compassIV.frame = CGRectMake(0, 0, 54, 54);
    self.compassIV.center = self.view.center;
    [self.view addSubview:self.compassIV];
    
    /*
        deviceMotion获取的是加速器和陀螺仪的复合数据
     */
    NSArray *titles = @[@"加速计测试改变transform", @"deviceMotion测试改变transform"];
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 70 + i * 55, 220, 35)];
        btn.tag = i;
        btn.backgroundColor = [UIColor redColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)buttonAction:(UIButton *)sender {
    if (!self.motionMange) {
        self.motionMange = [ZJMotionManager shareMotionManager];
    }else {
        [self invalidateUpdate];
    }
    
    if (sender.tag == 0) {
        if (self.motionMange.accelerometerAvailable) {
            [self.motionMange setAccelerometerUpdateInterval:0.01];
            [self testAcceletometerTranstorm];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加速计不可用" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
    }else {
        if (self.motionMange.deviceMotionAvailable) {
            [self.motionMange setDeviceMotionUpdateInterval:0.01];
            [self testDeviceMotionTranstorm];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"deviceMotion服务不可用" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
    }
}

// 加速计Transtorm
- (void)testAcceletometerTranstorm {
    [self.motionMange startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        double rotation = atan2(accelerometerData.acceleration.x, accelerometerData.acceleration.y) - M_PI;    // 垂直向下时坐标:(0, -1, 0) atan2(0, -1); 即:x = -1, y = 0;弧度数为pi
        self.compassIV.transform = CGAffineTransformMakeRotation(rotation);
    }];
}

// deviceMotion Transtorm :  deviceMotion = 加速计 + 陀螺仪
- (void)testDeviceMotionTranstorm {
    [self.motionMange startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *data, NSError *error) {
        double rotation = atan2(data.gravity.x, data.gravity.y) - M_PI;
        self.compassIV.transform = CGAffineTransformMakeRotation(rotation);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self invalidateUpdate];
}

- (void)invalidateUpdate {
    if (self.motionMange.isAccelerometerActive) {
        [self.motionMange stopAccelerometerUpdates];
    }
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
