//
//  ZJAccelerometerViewController.m
//  ZJCoreMotion
//
//  Created by YunTu on 15/9/7.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJAccelerometerViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "ZJMotionManager.h"

@interface ZJAccelerometerViewController (){
    NSTimer *_timer;
}

@property(nonatomic, strong) CMMotionManager *motionMange;

@property (strong, nonatomic) UIButton *bollBtn;

@end

@implementation ZJAccelerometerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bollBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    self.bollBtn.frame = CGRectMake(20, 110, 30, 30);
    [self.view addSubview:self.bollBtn];
    
    NSArray *titles = @[@"加速计测试改变位置", @"加速计测试改变transform"];
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5 + 160 * i, 70, 150, 35)];
        btn.tag = i;
        btn.backgroundColor = [UIColor redColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)buttonAction:(UIButton *)sender {
    if (!self.motionMange) {
        self.motionMange = [ZJMotionManager shareMotionManager];
        [self.motionMange setAccelerometerUpdateInterval:0.01];
    }else {
        [self invalidateUpdate];
    }
    
    if (self.motionMange.accelerometerAvailable) {
        if (sender.tag == 0) {
            [self testAcceletometerPull];
        }else {
            [self testAcceletometerPush];
        }
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加速计不可用" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
}

// 加速计push
- (void)testAcceletometerPush {
    [self.motionMange startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        double rotation = atan2(accelerometerData.acceleration.x, accelerometerData.acceleration.y);    // 垂直向下时坐标:(0, -1, 0) atan2(0, -1); 即:x = -1, y = 0;弧度数为pi
        self.bollBtn.transform = CGAffineTransformMakeRotation(rotation);
    }];
}

// 加速计pull
- (void)testAcceletometerPull {
    [self.motionMange startAccelerometerUpdates];
    _timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(getAccelerometerInfo) userInfo:nil repeats:YES];
}

- (void)getAccelerometerInfo {
    CMAcceleration acc = self.motionMange.accelerometerData.acceleration;
    self.bollBtn.center = CGPointMake(self.bollBtn.center.x + acc.x, self.bollBtn.center.y - acc.y);
    NSLog(@"x = %f, y = %f, z = %f", acc.x, acc.y, acc.z);
}

- (void)viewWillDisappear:(BOOL)animated {
    [self invalidateUpdate];
}

- (void)invalidateUpdate {
    if (self.motionMange.isAccelerometerActive) {
        [self.motionMange stopAccelerometerUpdates];
    }
    if (_timer.isValid) {
        [_timer invalidate];
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
