//
//  ViewController.m
//  LJAuthorizationDemo
//
//  Created by cao longjian on 17/6/29.
//  Copyright © 2017年 Jiji. All rights reserved.
//

#import "ViewController.h"
#import "LJAuthorizationTool.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSArray *testList;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.testList = @[@"获取相册权限",
                      @"获取相机权限",
                      @"获取麦克风权限",
                      @"获取通讯录权限"];
    [self.view addSubview:self.tableView];
}


- (void)requestAddressBook {
    [LJAuthorizationTool requestAddressBookAuthorization:^(LJAuthorizationStatus status) {
        [self requestAuthCallback:status];
    }];
}

- (void)requestCamera {
    [LJAuthorizationTool requestVideoAuthorization:^(LJAuthorizationStatus status) {
        [self requestAuthCallback:status];
    }];
}

- (void)requestAudio {
    [LJAuthorizationTool requestAudioAuthorization:^(LJAuthorizationStatus status) {
        [self requestAuthCallback:status];
    }];
}

- (void)requestAlbum {
    [LJAuthorizationTool requestImagePickerAuthorization:^(LJAuthorizationStatus status) {
        [self requestAuthCallback:status];
    }];
}



- (void)requestAuthCallback:(LJAuthorizationStatus)status {
    switch (status) {
        case LJAuthorizationStatusAuthorized:
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"授权成功" message:@"可以访问你要访问的内容了" preferredStyle:UIAlertControllerStyleAlert];
            
    
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                }];
                [alertController addAction:cancelAction];
            
            
            [self presentViewController:alertController animated:YES completion:nil];
        }

            break;
            
        case LJAuthorizationStatusDenied:
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"授权失败" message:@"前往设置-" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            [alertController addAction:cancelAction];
            
            UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"现在设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [LJAuthorizationTool openURLToSetting];
            }];
            
            [alertController addAction:setAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
        case LJAuthorizationStatusRestricted:
            
        {
            
            
        }
            break;
            
        case LJAuthorizationStatusNotSupport:
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"授权失败" message:@"设备不支持" preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            [alertController addAction:cancelAction];
            
            
            [self presentViewController:alertController animated:YES completion:nil];
        }

        default:
            break;
    }
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.testList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.testList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self requestAlbum];
    } else if (indexPath.row == 1) {
        [self requestCamera];
    } else if (indexPath.row == 2) {
        [self requestAudio];
    } else if (indexPath.row == 3) {
        [self requestAddressBook];
    }
}


#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
