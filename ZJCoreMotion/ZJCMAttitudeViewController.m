//
//  ZJCMAttitudeViewController.m
//  ZJCoreMotion
//
//  Created by YunTu on 15/9/7.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJCMAttitudeViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "ZJMotionManager.h"
#import "ZJAnswerViewController.h"

@interface ZJCMAttitudeViewController () {
    NSTimer *_timer;
}

@property(nonatomic, strong) CMMotionManager *motionMange;

@end

@implementation ZJCMAttitudeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    label.text = @"Question";
    label.textColor = [UIColor whiteColor];
    label.center = self.view.center;
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor redColor];
    [self.view addSubview:label];

    self.motionMange = [ZJMotionManager shareMotionManager];
    if (self.motionMange.deviceMotionAvailable) {
        [self.motionMange startDeviceMotionUpdates];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getInitAttitude) userInfo:nil repeats:YES];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"陀螺仪不可用" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)getInitAttitude {
    if (!self.motionMange.deviceMotion) {
        return;
    }
    [_timer invalidate];
    
    CMAttitude *initAttitude = self.motionMange.deviceMotion.attitude;
    
    __block BOOL showingPrompt = NO;    // trigger values - a gap so there isn't a flicker zone
    double showPromptTrigger = 1.0f;
    double showAnswerTrigger = 0.8f;
    
    [self.motionMange startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        [motion.attitude multiplyByInverseOfAttitude:initAttitude];
        double magnitude = [self magnitudeFromAttitude:motion.attitude];
//        NSLog(@"%f", magnitude);
        
        // show the prompt
        if (!showingPrompt && (magnitude > showPromptTrigger)) {
            showingPrompt = YES;
            ZJAnswerViewController *vc = [ZJAnswerViewController new];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:vc animated:YES completion:nil];
        }
        
        // hide the prompt
        if (showingPrompt && (magnitude < showAnswerTrigger)) {
            showingPrompt = NO;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (double)magnitudeFromAttitude:(CMAttitude *)attitude {
    return sqrt(pow(attitude.roll, 2.0f) + pow(attitude.yaw, 2.0f) + pow(attitude.pitch, 2.0f));
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.motionMange.isDeviceMotionActive) {
        [self.motionMange stopDeviceMotionUpdates];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
