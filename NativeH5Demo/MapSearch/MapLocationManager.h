//
//  MapLocationManager.h
//  NucarfProject
//
//  Created by zhaixingxing on 2019/8/12.
//  Copyright © 2019 zhaixingxing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Success)(id _Nullable json);

NS_ASSUME_NONNULL_BEGIN

@interface MapLocationManager : NSObject


@property (nonatomic, copy) Success weatherLiveBlock;
@property (nonatomic, copy) Success weatherForecastBlock;




+ (instancetype)shareManager;

- (void)setupMapKey;
- (void)startRequestLocationSuccess:(void(^)(id json))success;

- (void)searchWeatherLiveSuccess:(Success)success;
- (void)searchWeatherForecastSuccess:(Success)success;



@end

NS_ASSUME_NONNULL_END
