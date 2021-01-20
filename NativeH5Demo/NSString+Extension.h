//
//  NSString+Extension.h
//  Pods
//
//  Created by zhaixingxing on 2020/10/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    // 三位逗号分隔显示
    NumberFormatterDecimal = 1,
    // 附带当前货币标识
    NumberFormatterMoney = 2,
    // *100 加 % 号显示
    NumberFormatterPercent = 3,
    // 中文显示
    NumberFormatterChinese = 5,
} NumberFormatter;

@interface NSString (Extension)

#pragma mark - 号码校验

/// 是否是手机号
/// @param mobileNumbel 手机号
+ (BOOL)isMobile:(NSString *)mobileNumbel;

/// 手机号替换 ***
/// @param mobileNum 手机号
+ (NSString *)returnMysteryMobile:(NSString *)mobileNum range:(NSRange)range;

/// 身份证号码校验
/// @param identityStr 身份证号码
+ (BOOL)isIdentify:(NSString *)identityStr;

/// 车牌号校验
/// @param carStr 车牌号
+ (BOOL)isCarNumber:(NSString *)carStr;

#pragma mark - 字符串格式化

/// 判断字符串是否为空
- (BOOL)isBlankString;

/// 字符串添加行间距
/// @param lineSpace 行间距
- (NSAttributedString *)returnAttributeStrWithLineSpace:(CGFloat)lineSpace;

/// 字符串添加行间距5
- (NSAttributedString *)returnAttributeString;

/// 数组转字符串
/// @param arr 数组
+ (NSString *)arrayToJsonString:(NSArray *)arr;

/// 字典转字符串
/// @param dic 字典
+ (NSString *)dictionaryToJsonString:(NSDictionary *)dic;

/// 字符串转字典
- (NSDictionary *)toDictionary;

/// 字符串转数组
/// @param separator 分隔符
- (NSArray *)toArraySeparator:(NSString *)separator;

/// 字符串转数组( ,号分割)
- (NSArray *)toArray;

#pragma mark - 字符串大小

/// 获取字符串宽度
/// @param str 字符串
/// @param fontSize 字体大小
/// @param height 字符串高度
+ (float)widthForString:(NSString *)str fontSize:(float)fontSize height:(float)height;

/// 获取字符串宽度
/// @param str 字符串
/// @param font 字体
/// @param height 字符串高度
+ (float)widthForString:(NSString *)str font:(UIFont *)font height:(float)height;

/// 获取字符串高度
/// @param str 字符串
/// @param fontSize 字体大小
/// @param width 宽度
+ (float)heightForString:(NSString *)str fontSize:(float)fontSize width:(float)width;

/// 获取字符串高度
/// @param str 字符串
/// @param font 字体
/// @param width 宽度
+ (float)heightForString:(NSString *)str withFont:(UIFont *)font width:(float)width;

/// 获取字符串高度
/// @param str 字符串
/// @param font 字体
/// @param width 宽度
/// @param lineHeight 行高
+ (float)heightForString:(NSString *)str withFont:(UIFont *)font width:(float)width LineHeight:(CGFloat)lineHeight;

//MARK: - 数字字符串格式化

/// 是否是 int 字符串
- (BOOL)isPureInt;

/// 是否是 float 字符串
- (BOOL)isPureFloat;

/// 字符串除以100
- (NSString *)stringDivide100;
/// 字符串乘以100
- (NSString *)stringMultiply100;

/// 字符串格式化显示
/// @param style 字符串格式
- (NSString *)stringFormatWithStyle:(NumberFormatter)style;

@end

@interface NSDictionary (Extension)

/// 字符串转字典
/// @param jsonString 字符串
+ (NSDictionary *)stringToDictionary:(NSString *)jsonString;

/// 字典转字符串
- (NSString *)jsonString;

@end

@interface NSArray (Extension)

/// 字符串转数组
/// @param jsonString 字符串 (" ," 号分割)
+ (NSArray *)stringToArr:(NSString *)jsonString;

/// 字符串转数组
/// @param jsonString 字符串
/// @param separator 分隔符
+ (NSArray *)stringToArr:(NSString *)jsonString separator:(NSString *)separator;

/// 数组转字符串
- (NSString *)toString;

@end

NS_ASSUME_NONNULL_END
