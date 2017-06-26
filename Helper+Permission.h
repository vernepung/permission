//
//  Helper+Authorization.h
//  VPPublicUntilitisForPod
//
//  Created by vernepung on 2017/6/16.
//  Copyright © 2017年 vernepung. All rights reserved.
//

#import "Helper.h"

@interface Helper (Permission)

/**
 当前是否有推送权限(只读取,不请求)

 @param complete 是否允许推送
 */
+ (void)checkingNotificationPermisssionWithCompleteBlock:(void(^)(BOOL result))complete;
/**
 检查相机权限

 @return 是否允许使用相机
 */
+ (BOOL)checkingVideoPermission;

/**
 检查相册权限

 @return 是否允许使用相册
 */
+ (BOOL)checkingPhotoPermission;

/**
 打开当前App的权限设置界面
 */
+ (void)openAuthorizatioinSetting;
@end
