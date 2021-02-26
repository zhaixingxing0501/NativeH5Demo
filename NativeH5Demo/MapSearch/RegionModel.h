//
//  RegionModel.h
//  NativeH5Demo
//
//  Created by nucarf on 2021/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegionModel : NSObject

/***  详细地址  ****/
@property (nonatomic, copy) NSString *name;
/***  经度  ****/
@property (nonatomic, copy) NSString *lng;
/***  纬度  ****/
@property (nonatomic, copy) NSString *lat;

@end

NS_ASSUME_NONNULL_END
