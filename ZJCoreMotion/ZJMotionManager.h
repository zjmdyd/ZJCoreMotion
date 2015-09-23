//
//  ZJMotionManager.h
//  ZJCoreAnimation
//
//  Created by YunTu on 15/7/23.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface ZJMotionManager : NSObject

+ (CMMotionManager *)shareMotionManager;

@end
