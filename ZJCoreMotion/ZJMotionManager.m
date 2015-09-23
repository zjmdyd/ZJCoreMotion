//
//  ZJMotionManager.m
//  ZJCoreAnimation
//
//  Created by YunTu on 15/7/23.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJMotionManager.h"

static CMMotionManager *_motionManager;

@implementation ZJMotionManager

+ (CMMotionManager *)shareMotionManager {
    if (!_motionManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _motionManager = [[CMMotionManager alloc] init];
        });
    }
    
    return _motionManager;
}

@end
