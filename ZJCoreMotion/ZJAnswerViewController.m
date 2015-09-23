//
//  ZJAnswerViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 15/7/24.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJAnswerViewController.h"

@interface ZJAnswerViewController ()

@end

@implementation ZJAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    label.text = @"Answer";
    label.center = self.view.center;
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:label];
    
    self.view.backgroundColor = [UIColor whiteColor];
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
