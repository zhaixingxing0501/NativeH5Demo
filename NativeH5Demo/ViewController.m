//
//  ViewController.m
//  NativeH5Demo
//
//  Created by zhaixingxing on 2021/1/14.
//

#import "ViewController.h"
#import <WXApi.h>
#import "BaseWKWebViewController.h"
#import "Request/Request.h"
#import "NSString+AES.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *URLTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小程序调试";
    // Do any additional setup after loading the view.

//    NSString *mobile = @"18222116409";
//    NSString *keyStr = @"ZsHkkqm6lsGwUP4c";
//    NSString *res1 = [mobile AES256EncryptKey:keyStr];
//    NSString *secret = @"UtIB2fw3G8/FkpeABgRy9Q==";
//    NSString *res = [secret AES256DecryptKey:keyStr];
//
    
    
    NSString *mobile1 = @"18222116409";
    NSString *keyStr1 = @"fdbab8561f7138914179b773a732e1aa";
    NSString *res11 = [mobile1 AES256EncryptKey:keyStr1];
    NSString *secret1 = @"N/7pJLohSGzlWQIgLDxwiQ==";
    
    if ([res11 isEqualToString:secret1]) {
        NSLog(@"相同");
    }
    NSString *res12 = [secret1 AES256DecryptKey:keyStr1];
    
    
}

- (IBAction)buttonAction:(UIButton *)sender {
//    [self testPay];
    [self openH5];
//    [self testOpenMiniProgram];
}

- (void)testPay {
    NSString *url = @"http://tyb_ci_api_one.nucarf.cn/channel/order?app_id=2a10fa39e3546d256bf993f546b6d73b&sign=d824b9527c39eb9654adc01b86e52c5f&seed=236efc602a4434da";

    NSDictionary *param = @{
        @"station_id": @"20092",
        @"fuel_id": @"1020",
        @"consumer_mobile": @"18553322306",
        @"fuel_gun_no": @"1",
        @"final_amount": @"1",
        @"original_amount": @"1",
        @"fuel_price": @"510",
        @"payment_callback_url": @"http://tyb_ci_api_one.nucarf.cn/station/#/order/detail?action=callback",
        @"notify_url": @"1",
    };
    
    [Request post:url parameters:param success:^(id _Nonnull responseObject) {
        NSString *webUrl = [responseObject[@"data"] objectForKey:@"cashier_url"];

        NSLog(@"web地址:%@", webUrl);

        dispatch_async(dispatch_get_main_queue(), ^{
                           BaseWKWebViewController *vc = [[BaseWKWebViewController alloc] init];
                           vc.urlStr = webUrl;
                           [self.navigationController pushViewController:vc animated:YES];
                       });
    } failure:^(NSError *_Nonnull error) {
        NSLog(@"请求失败");
    }];
}

- (void)testOpenMiniProgram {
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = @"gh_f825c654e3de";  //拉起的小程序的username
    launchMiniProgramReq.path = @"pages/pay/index?order_sn=2020122918512157565751";    ////拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypePreview; //拉起小程序的类型

    [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {
        NSLog(@"打开完成");
    }];
}

- (void)openH5 {
    BaseWKWebViewController *vc = [[BaseWKWebViewController alloc] init];
    vc.urlStr = @"http://tyb-qa-api.nucarf.cn/station/#/oilstation?mobile=mPGlGV0YXIBCnj76Pgl%2BaA%3D%3D&latitude=23.106013&longitude=113.379406";
//    vc.urlStr = @"http://33l38x6599.zicp.vip:28775/#/?pay_state=paid&order_no=2021011411382310255995";
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 跳转H5 页面
- (IBAction)pushH5:(UIButton *)sender {
    BaseWKWebViewController *vc = [[BaseWKWebViewController alloc] init];
    vc.urlStr = self.URLTextField.text;

    if (![self.URLTextField.text hasPrefix:@"http"]) {
        [self showMsg:@"请输入正确的请求地址"];
        return;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showMsg:(NSString *)msg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];

    [self presentViewController:alertController animated:YES completion:^{
        dispatch_after(5.0, dispatch_get_main_queue(), ^{
                           [alertController dismissViewControllerAnimated:YES completion:nil];
                       });
    }];
}

@end
