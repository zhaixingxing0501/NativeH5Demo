//
//  NSString+AES.h
//  NativeH5Demo
//
//  Created by nucarf on 2021/1/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (AES)

- (NSString *)AES256EncryptKey:(NSString *)key;

- (NSString *)AES256DecryptKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
