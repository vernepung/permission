//
//  Helper+Authorization.m
//  VPPublicUntilitisForPod
//
//  Created by vernepung on 2017/6/16.
//  Copyright © 2017年 vernepung. All rights reserved.
//

#import "Helper+Permission.h"
#import "UtilsMacro.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <UserNotifications/UserNotifications.h>


@implementation Helper (Permission)

+ (void)checkingNotificationPermisssionWithCompleteBlock:(void(^)(BOOL result))complete {
    if ([appVersion() floatValue] >= 10.0) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
            ExecBlock(complete, settings.authorizationStatus == UNAuthorizationStatusAuthorized);
        }];
    }else{ //if([appVersion() floatValue] >= 8.0)
        ExecBlock(complete, [[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone);
    }
}

+ (BOOL)checkingPhotoPermission {
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    __block BOOL allowed = YES;
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined:
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status != PHAuthorizationStatusAuthorized) {
                    allowed = NO;
                    DLog(@"%@",@"user denied photo permission");
                }
            }];
            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            break;
        case PHAuthorizationStatusAuthorized:
            
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
            allowed = NO;
            break;
    }
    return allowed;
}

+ (BOOL)checkingVideoPermission {
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    __block BOOL allowed = YES;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_semaphore_signal(sem);
                allowed = granted;
                if (!granted) {
                    DLog(@"%@",@"user denied video permission");
                }
            }];
            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            allowed = NO;
            break;
    }
    return allowed;
}

+ (void)openAuthorizatioinSetting {
    openUrlInSafari(UIApplicationOpenSettingsURLString);
}


@end
