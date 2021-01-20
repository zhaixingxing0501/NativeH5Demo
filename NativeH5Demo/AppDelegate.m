//
//  AppDelegate.m
//  NativeH5Demo
//
//  Created by zhaixingxing on 2021/1/14.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import <WXApi.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

#define WX_AppId          @"wx0d9488cb305b12c6"
#define WX_UNIVERSAL_LINK @"https://cloud.nucarf.net/"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    BOOL ret = [WXApi registerApp:WX_AppId universalLink:WX_UNIVERSAL_LINK];

    if (ret) {
        NSLog(@"注册成功");
    } else {
        NSLog(@"注册失败");
    }
    
    
    
        [IQKeyboardManager sharedManager].enable = YES;
        /** 点击背景回收键盘  */
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
        /** 开启tooleBar */
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;

    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
