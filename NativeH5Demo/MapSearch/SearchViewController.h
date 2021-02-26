//
//  SearchViewController.h
//  NativeH5Demo
//
//  Created by nucarf on 2021/2/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : UIViewController

@property (nonatomic, copy) void (^backBlock)(NSString *lat,  NSString *lng);

@end

NS_ASSUME_NONNULL_END
