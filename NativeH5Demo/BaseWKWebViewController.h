//
//  BaseWKWebViewController.h
//  NucarfProject
//
//  Created by zhaixingxing on 2020/3/19.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface BaseWKWebViewController : UIViewController

@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) NSString *app_id;
@property (nonatomic, strong) NSString *secret;
@end

NS_ASSUME_NONNULL_END
