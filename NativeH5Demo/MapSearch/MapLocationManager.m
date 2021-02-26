//
//  MapLocationManager.m
//  NucarfProject
//
//  Created by zhaixingxing on 2019/8/12.
//  Copyright © 2019 zhaixingxing. All rights reserved.
//

#import "MapLocationManager.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface MapLocationManager ()<AMapSearchDelegate, AMapLocationManagerDelegate>

/***  地图查询类  ****/
@property (nonatomic, strong) AMapSearchAPI *searchApi;
/***  天气查询请求  ****/
@property (nonatomic, strong) AMapWeatherSearchRequest *weatherRequest;
/***  定位管理  ****/
@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, assign) BOOL isWeatherLive;




@end

@implementation MapLocationManager




+ (instancetype)shareManager{
    static MapLocationManager *manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[MapLocationManager alloc]init];
    });
    return manager;
}

- (void)startRequestLocationSuccess:(void(^)(id json))success {
    
    if (![MapLocationManager isLocationServiceOpen]) {
        [[MapLocationManager shareManager] goSettingToLocationService];
        return;
    }
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error) {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
//                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"定位失败"];
                
                return;
            }
        }
        
        
        if (regeocode) {
            success(location);
        } else {
            success(nil);
//            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"定位失败"];
        }
        
    }];
}


- (void)setupMapKey {
    
    /***  设置地图的key  ****/
//    [AMapServices sharedServices].apiKey = GaoDeKey;
    
}

//判断是否开启定位
+ (BOOL)isLocationServiceOpen {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    } else
        return YES;
}

//去设置里面开启定位
- (void)goSettingToLocationService{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    } else {
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
//        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请前往设置,打开定位服务"];
        
    }
}

- (AMapSearchAPI *)searchApi {
    if (!_searchApi) {
        self.searchApi = [[AMapSearchAPI alloc] init];
        _searchApi.delegate = self;
    }
    return _searchApi;
}

//- (AMapWeatherSearchRequest *)weatherRequest {
//    if (!_weatherRequest) {
//        self.weatherRequest = [[AMapWeatherSearchRequest alloc] init];
//        //设置天气实时的
//        _weatherRequest.type = AMapWeatherTypeLive;
//    }
//    return _weatherRequest;
//}

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        self.locationManager = [[AMapLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        
        //设置期望定位精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //设置不允许系统暂停定位
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        //        //设置允许在后台定位
        //        [_locationManager setAllowsBackgroundLocationUpdates:NO];
        //设置定位超时时间,最低2s，此处设置为10s
        [_locationManager setLocationTimeout:10];
        //设置逆地理超时时间,最低2s，此处设置为10s
        [_locationManager setReGeocodeTimeout:10];
        //设置开启虚拟定位风险监测，可以根据需要开启
        [_locationManager setDetectRiskOfFakeLocation:NO];
    }
    return _locationManager;
}

@end
