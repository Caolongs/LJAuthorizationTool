//
//  LJAuthorizationTool.m
//  LJAuthorizationDemo
//
//  Created by cao longjian on 17/6/29.
//  Copyright © 2017年 Jiji. All rights reserved.
//

#import "LJAuthorizationTool.h"
//#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>


//忽略过期API警告
#define SUPPRESS_DEPRECATED_WARNING(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation LJAuthorizationTool

/**
 *  请求相册访问权限
 */
+ (void)requestImagePickerAuthorization:(void(^)(LJAuthorizationStatus status))callback {
    
    if (!([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ||
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])) {
        [self executeCallback:callback status:LJAuthorizationStatusNotSupport];
        return;
    }
    //ALAuthorizationStatus ios8以前
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusNotDetermined) { // 未授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self executeCallback:callback status:LJAuthorizationStatusAuthorized];
                } else if (status == PHAuthorizationStatusDenied) {
                    [self executeCallback:callback status:LJAuthorizationStatusDenied];
                } else if (status == PHAuthorizationStatusRestricted) {
                    [self executeCallback:callback status:LJAuthorizationStatusRestricted];
                }
            }];
        
    } else if (authStatus == PHAuthorizationStatusAuthorized) {
        [self executeCallback:callback status:LJAuthorizationStatusAuthorized];
    } else if (authStatus == PHAuthorizationStatusDenied) {
        [self executeCallback:callback status:LJAuthorizationStatusDenied];
    } else if (authStatus == PHAuthorizationStatusRestricted) {
        [self executeCallback:callback status:LJAuthorizationStatusRestricted];
    }

}

/**
 *  请求摄像头权限
 */
+ (void)requestVideoAuthorization:(void(^)(LJAuthorizationStatus status))callback {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self executeCallback:callback status:LJAuthorizationStatusNotSupport];
        return;
    }
        
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [self executeCallback:callback status:LJAuthorizationStatusAuthorized];
            } else {
                [self executeCallback:callback status:LJAuthorizationStatusDenied];
            }
        }];
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        [self executeCallback:callback status:LJAuthorizationStatusAuthorized];
    } else if (authStatus == AVAuthorizationStatusDenied) {
        [self executeCallback:callback status:LJAuthorizationStatusDenied];
    } else if (authStatus == AVAuthorizationStatusRestricted) {
        [self executeCallback:callback status:LJAuthorizationStatusRestricted];
    }
}

/**
 *  请求麦克风权限 - 同摄像头类似
 *
 *  @param callback <#callback description#>
 */
+ (void)requestAudioAuthorization:(void(^)(LJAuthorizationStatus status))callback{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                [self executeCallback:callback status:LJAuthorizationStatusAuthorized];
            } else {
                [self executeCallback:callback status:LJAuthorizationStatusDenied];
            }
        }];
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        [self executeCallback:callback status:LJAuthorizationStatusAuthorized];
    } else if (authStatus == AVAuthorizationStatusDenied) {
        [self executeCallback:callback status:LJAuthorizationStatusDenied];
    } else if (authStatus == AVAuthorizationStatusRestricted) {
        [self executeCallback:callback status:LJAuthorizationStatusRestricted];
    }
}

/**
 *  请求通讯录权限
 */
+ (void)requestAddressBookAuthorization:(void (^)(LJAuthorizationStatus))callback {
    
    
    if ([UIDevice currentDevice].systemVersion.floatValue > 9.0) {
        CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        
        if (authStatus == CNAuthorizationStatusNotDetermined) {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    [self executeCallback:callback status:LJAuthorizationStatusAuthorized];
                } else {
                    [self executeCallback:callback status:LJAuthorizationStatusDenied];
                }
            }];
            
        } else if (authStatus == CNAuthorizationStatusAuthorized) {
            [self executeCallback:callback status:LJAuthorizationStatusAuthorized];
        } else if (authStatus == CNAuthorizationStatusDenied) {
            [self executeCallback:callback status:LJAuthorizationStatusDenied];
        } else if (authStatus == CNAuthorizationStatusRestricted) {
            [self executeCallback:callback status:LJAuthorizationStatusRestricted];
        }
    } else {
        
        
SUPPRESS_DEPRECATED_WARNING(
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        if (authStatus == kABAuthorizationStatusNotDetermined) {
            __block ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            if (addressBook == NULL) {
                [self executeCallback:callback status:LJAuthorizationStatusNotSupport];
                return;
            }
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    [self executeCallback:callback status:LJAuthorizationStatusAuthorized];
                } else {
                    [self executeCallback:callback status:LJAuthorizationStatusDenied];
                }
                if (addressBook) {
                    CFRelease(addressBook);
                    addressBook = NULL;
                }
            });
            return;
        } else if (authStatus == kABAuthorizationStatusAuthorized) {
            [self executeCallback:callback status:LJAuthorizationStatusAuthorized];
        } else if (authStatus == kABAuthorizationStatusDenied) {
            [self executeCallback:callback status:LJAuthorizationStatusDenied];
        } else if (authStatus == kABAuthorizationStatusRestricted) {
            [self executeCallback:callback status:LJAuthorizationStatusRestricted];
        }
                            );
    }

}

#pragma mark - callback
+ (void)executeCallback:(void (^)(LJAuthorizationStatus))callback status:(LJAuthorizationStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (callback) {
            callback(status);
        }
    });
}

+ (void)openURLToSetting {
    NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
        
        if ([UIDevice currentDevice].systemVersion.floatValue > 9.0) {
            [[UIApplication sharedApplication] openURL:settingUrl options:@{} completionHandler:nil];
        } else {
            SUPPRESS_DEPRECATED_WARNING(
            [[UIApplication sharedApplication] openURL:settingUrl];
                                        );
        }
        
    }
}

@end
