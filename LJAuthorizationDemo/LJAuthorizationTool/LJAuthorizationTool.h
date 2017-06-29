//
//  LJAuthorizationTool.h
//  LJAuthorizationDemo
//
//  Created by cao longjian on 17/6/29.
//  Copyright © 2017年 Jiji. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LJAuthorizationStatus) {
    LJAuthorizationStatusAuthorized = 0,    ///< 已授权
    LJAuthorizationStatusDenied,            ///< 拒绝
    LJAuthorizationStatusRestricted,        ///< 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
    LJAuthorizationStatusNotSupport         ///< 硬件等不支持
};


/**支持ios8以后*/
@interface LJAuthorizationTool : NSObject

/**
 *  请求相册访问权限
 *
 *  @param callback <#callback description#>
 */
+ (void)requestImagePickerAuthorization:(void(^)(LJAuthorizationStatus status))callback;

/**
 *  请求摄像头权限
 *
 *  @param callback <#callback description#>
 */
+ (void)requestVideoAuthorization:(void(^)(LJAuthorizationStatus status))callback;

/**
 *  请求麦克风权限
 *
 *  @param callback <#callback description#>
 */
+ (void)requestAudioAuthorization:(void(^)(LJAuthorizationStatus status))callback;

/**
 *  请求通讯录权限
 *
 *  @param callback <#callback description#>
 */
+ (void)requestAddressBookAuthorization:(void (^)(LJAuthorizationStatus))callback;




/**
 *  打开手机设置页面
 */
+ (void)openURLToSetting;


@end
