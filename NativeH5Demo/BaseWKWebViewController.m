//
//  BaseWKWebViewController.m
//  NucarfProject
//
//  Created by zhaixingxing on 2020/3/19.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "BaseWKWebViewController.h"
#import <WebKit/WebKit.h>
#import <WXApi.h>
#import "NSString+Extension.h"
#import "NSString+AES.h"

@interface BaseWKWebViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation BaseWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];

    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;

    [configuration.userContentController addScriptMessageHandler:self name:@"openMiniProgram"];
    [configuration.userContentController addScriptMessageHandler:self name:@"handleMethodByTyb"];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlStr]];

    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) configuration:configuration];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;

    [self.view addSubview:webView];
    [webView loadRequest:request];
    self.wkWebView = webView;
    [self.view addSubview:self.progressView];
    [webView addObserver:self  forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonSystemItemClose target:self action:@selector(backAction:)];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonSystemItemDone target:self action:@selector(refreshAction:)];
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

- (void)refreshAction:(id)sender {
    [self.wkWebView reload];
}
- (void)backAction:(id)sender {
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// MARK: - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"网页标题:%@", webView.title);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", error);
}

//! WKWeView在每次加载请求前会调用此方法来确认是否进行请求跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    NSString *url = self.wkWebView.URL.absoluteString;
//    NSLog(@"加载url:%@", url);
//    decisionHandler(WKNavigationActionPolicyAllow);
//}

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(nonnull WKNavigationResponse *)navigationResponse decisionHandler:(nonnull void (^)(WKNavigationResponsePolicy))decisionHandler {
//    NSString *url = self.wkWebView.URL.absoluteString;
//    NSLog(@"加载响应url:%@", url);
//    decisionHandler(WKNavigationResponsePolicyAllow);
//}
 

// MARK: - H5 向 Native 发送信息
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"测试:名字%@, 内容%@", message.name, message.body);
    if ([message.name isEqualToString:@"openMiniProgram"]) {
        [self openMiniProgram:message.body];
    } else if ([message.name isEqualToString:@"handleMethodByTyb"]) {
        [self loadAppid];
    }
}

// MARK: - 加载Appid 和  secret
- (void)loadAppid {
    NSLog(@"当前页面地址%@", self.wkWebView.URL.absoluteString);

    NSDictionary *param = @{
        @"app_id": self.app_id,
        @"secret":self.secret
    };

    NSString *paramString = [param jsonString];
    NSString *js = [NSString stringWithFormat:@"tybRegisterData('%@')", paramString];

    [self.wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable obj, NSError *_Nullable error) {
        NSLog(@"H5 调取原生注入方法, 加载app_id");
    }];
}

// MARK: - 打开微信小程序
- (void)openMiniProgram:(NSString *)paramString {
    //字符串转NSDictionary
    NSDictionary *params = [paramString toDictionary];

    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = params[@"appId"]; //拉起的小程序的username
    launchMiniProgramReq.path = params[@"path"];   ////拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
    launchMiniProgramReq.miniProgramType = [params[@"type"] integerValue]; //拉起小程序的类型

    [WXApi sendReq:launchMiniProgramReq completion:nil];
}

// MARK: - 关闭webView
- (void)closeWebView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.wkWebView.estimatedProgress;
        // 加载完成
        if (self.wkWebView.estimatedProgress  >= 1.0f) {
            [UIView animateWithDuration:0.25f animations:^{
                self.progressView.alpha = 0.0f;
                self.progressView.progress = 0.0f;
            }];
        } else {
            self.progressView.alpha = 1.0f;
        }
    }
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
        _progressView.progressViewStyle = UIProgressViewStyleBar;
        _progressView.tintColor = UIColor.greenColor;
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
