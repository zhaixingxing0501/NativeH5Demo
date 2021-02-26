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
#import "SearchViewController.h"
#import "MapLocationManager.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextView *URLTF;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *app_id;
@property (nonatomic, strong) NSString *secret;

@property (strong, nonatomic) IBOutlet UITextField *app_idTF;
@property (strong, nonatomic) IBOutlet UITextField *secretTF;
/// 经度
@property (strong, nonatomic) IBOutlet UITextField *longitudeTF;
/// 纬度
@property (strong, nonatomic) IBOutlet UITextField *latitudeTF;
@property (strong, nonatomic) IBOutlet UITextField *keyTF;
@property (strong, nonatomic) IBOutlet UITextField *valueTF;

@end

NSString *kApp_id = @"app_id";
NSString *kSecret = @"secret";
NSString *kUrl = @"url";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小程序调试";
    // Do any additional setup after loading the view.

//    NSString *mobile1 = @"18222116409";
//    NSString *keyStr1 = @"fdbab8561f7138914179b773a732e1aa";
//    NSString *res11 = [mobile1 AES256EncryptKey:keyStr1];
//    NSString *secret1 = @"N/7pJLohSGzlWQIgLDxwiQ==";
//
//    if ([res11 isEqualToString:secret1]) {
//        NSLog(@"相同");
//    }
//    NSString *res12 = [secret1 AES256DecryptKey:keyStr1];

    self.URLTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUrl];
    self.app_idTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:kApp_id];
    self.secretTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:kSecret];
//
//    self.url = @"http://tyb-qa-api.nucarf.cn/station/#/oilstation?mobile=spuDgO4vLFZCSFgXRNM4mw%3D%3D&latitude=39.85856&longitude=116.28616";
    self.url = @"http://tyb-qa-api.nucarf.cn/station/#/oilstation?mobile=mPGlGV0YXIBCnj76Pgl%2BaA%3D%3D&latitude=23.106111&longitude=113.379656";

    self.app_id = @"b371a642b6c5aa3ad0c0744462b792cf";
    self.secret = @"418efe81b1af6f342b5f12e9c5854c7a";

//    self.secretTF.text = self.secret;
//    self.app_idTF.text = self.app_id;
//    self.URLTF.text = self.url;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"test" style:UIBarButtonSystemItemDone target:self action:@selector(buttonAction:)];
    self.navigationItem.leftItemsSupplementBackButton = YES;

    [[MapLocationManager shareManager] startRequestLocationSuccess:^(CLLocation *location) {
        if (location) {
            
//            CLLocationCoordinate2D amapcoord = AMapCoordinateConvert(CLLocationCoordinate2DMake(39.989612,116.480972), AMapCoordinateType);
            CLLocationCoordinate2D amapcoord = AMapCoordinateConvert(location.coordinate, AMapCoordinateTypeGPS);
            NSLog(@"%f, %f", location.coordinate.latitude, location.coordinate.longitude);
            self.latitudeTF.text = [NSString stringWithFormat:@"%f", amapcoord.latitude];
            self.longitudeTF.text = [NSString stringWithFormat:@"%f", amapcoord.longitude];
        }
    }];
}

- (void)buttonAction:(UIButton *)sender {
//    [self testPay];
    [self openH5];
//    [self testOpenMiniProgram];
}

- (IBAction)locationAdd:(UIButton *)sender {
    @try {
        self.URLTF.text =  [self loadRequestData:self.URLTF.text andPram:@{ @"latitude": self.latitudeTF.text }];
        self.URLTF.text = [self loadRequestData:self.URLTF.text andPram:@{ @"longitude": self.longitudeTF.text }];
    } @catch (NSException *exception) {
    } @finally {
    }
}

- (IBAction)LocationSearch:(id)sender {
    SearchViewController *vc = [SearchViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)paramAdd:(id)sender {
    @try {
        self.URLTF.text =  [self loadRequestData:self.URLTF.text andPram:@{ self.keyTF.text: self.valueTF.text }];
    } @catch (NSException *exception) {
    } @finally {
    }
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
    vc.urlStr = self.url;
    vc.app_id = self.app_id;
    vc.secret = self.secret;
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 跳转H5 页面
- (IBAction)pushH5:(UIButton *)sender {
    BaseWKWebViewController *vc = [[BaseWKWebViewController alloc] init];
    vc.urlStr = self.URLTF.text;
    vc.app_id = self.app_idTF.text;
    vc.secret = self.secretTF.text;
    [[NSUserDefaults standardUserDefaults] setObject:self.app_idTF.text forKey:kApp_id];
    [[NSUserDefaults standardUserDefaults] setObject:self.secretTF.text forKey:kSecret];
    [[NSUserDefaults standardUserDefaults] setObject:self.URLTF.text forKey:kUrl];
    [[NSUserDefaults standardUserDefaults] synchronize];

    if (![self.URLTF.text hasPrefix:@"http"]) {
        [self showMsg:@"请输入正确的请求地址"];
        return;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)loadRequestData:(NSString *)url andPram:(NSDictionary *)dic {
    __block NSString *temStr = @"?";
    if ([url containsString:@"?"]) {
        temStr = @"&";
    }
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        temStr = [temStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, obj]];
    }];
    return [NSString stringWithFormat:@"%@%@", url, temStr];
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
