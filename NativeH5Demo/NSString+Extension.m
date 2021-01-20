//
//  NSString+Extension.m
//  Pods
//
//  Created by zhaixingxing on 2020/10/19.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

#pragma mark - 号码校验

+ (BOOL)isMobile:(NSString *)mobileNumbel {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188, 198
     * 联通：130,131,132,152,155,156,185,186, 166
     * 电信：133,1349,153,180,189,181(增加), 199
     */
    NSString *MOBIL = @"^1([0-9][0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378]|9[8])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString *CU = @"^1(3[0-2]|5[256]|6[6]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString *CT = @"^1((33|53|8[019]|9[9])[0-9]|349)\\d{7}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];

    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }

    return NO;
}

+ (NSString *)returnMysteryMobile:(NSString *)mobileNum range:(NSRange)range {
    if ([NSString isMobile:mobileNum]) {
        NSMutableString *str1 = [[NSMutableString alloc] initWithString:mobileNum];
        [str1 replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return str1;
    }
    return mobileNum;
}

+ (BOOL)isIdentify:(NSString *)identityStr {
    if (identityStr.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X|x)$";

    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if (![identityStringPredicate evaluateWithObject:identityStr]) return NO;

    //** 开始进行校验 *//

    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];

    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];

    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for (int i = 0; i < 17; i++) {
        NSInteger subStrIndex = [[identityStr substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum += subStrIndex * idCardWiIndex;
    }

    //计算出校验码所在数组的位置
    NSInteger idCardMod = idCardWiSum % 11;
    //得到最后一位身份证号码
    NSString *idCardLast = [identityStr substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if (idCardMod == 2) {
        if (![idCardLast isEqualToString:@"X"] || ![idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    } else {
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if (![idCardLast isEqualToString:[idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)isCarNumber:(NSString *)carStr {
    NSString *carnumRegex = @"([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领a-zA-Z]{1}[a-zA-Z]{1}(([0-9]{5}[dfDF])|([dfDF]([a-hj-np-zA-HJ-NP-Z0-9])[0-9]{4})))|([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领a-zA-Z]{1}[a-zA-Z]{1}[a-hj-np-zA-HJ-NP-Z0-9]{4}[a-hj-np-zA-HJ-NP-Z0-9挂学警港澳]{1})";
    NSPredicate *carStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", carnumRegex];
    return [carStringPredicate evaluateWithObject:carStr];
}

#pragma mark - 字符串格式化

- (BOOL)isBlankString {
    if (!self) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [self stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

- (NSAttributedString *)returnAttributeStrWithLineSpace:(CGFloat)lineSpace {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpace;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    return [[NSAttributedString alloc] initWithString:self attributes:attributes];
}

- (NSAttributedString *)returnAttributeString {
    return [self returnAttributeStrWithLineSpace:5];
}

+ (NSString *)arrayToJsonString:(NSArray *)arr {
    NSError *parseError = nil;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:arr options:kNilOptions error:&parseError];
    NSString *jsonString =  [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    //去掉字符串中的空格
    NSRange range = { 0, jsonString.length };
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = { 0, mutStr.length };
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return [mutStr copy];
}

+ (NSString *)dictionaryToJsonString:(NSDictionary *)dic {
    NSError *parseError = nil;
    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

        NSString *jsonString =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

        //去掉字符串中的空格
        NSRange range = { 0, jsonString.length };
        [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

        //去掉字符串中的换行符
        NSRange range2 = { 0, mutStr.length };
        [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

        return [mutStr copy];
    } else {
        return @"";
    }
}

- (NSDictionary *)toDictionary {
    if (self == nil) {
        return nil;
    }
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];

    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];

    if (err) {
        NSLog(@"json解析失败：%@", err);
        return nil;
    }
    return dic;
}

- (NSArray *)toArraySeparator:(NSString *)separator {
    return [NSArray stringToArr:self separator:separator];
}

- (NSArray *)toArray {
    return [self toArraySeparator:@","];
}

#pragma mark - 字符串大小

+ (float)widthForString:(NSString *)str fontSize:(float)fontSize height:(float)height {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return [NSString widthForString:str font:font height:height];
}

+ (float)widthForString:(NSString *)str font:(UIFont *)font height:(float)height {
    NSDictionary *attribute = @{ NSFontAttributeName: font };
    CGSize boundingSize = CGSizeMake(CGFLOAT_MAX, height);
    CGSize sizeToFit = [str boundingRectWithSize:boundingSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return sizeToFit.width;
}

+ (float)heightForString:(NSString *)str fontSize:(float)fontSize width:(float)width {
    UIFont *font =  [UIFont systemFontOfSize:fontSize];
    return [NSString heightForString:str withFont:font width:width];
}

+ (float)heightForString:(NSString *)str withFont:(UIFont *)font width:(float)width {
    NSDictionary *attribute = @{ NSFontAttributeName: font };
    CGSize boundingSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize sizeToFit = [str boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return sizeToFit.height + 1;
}

+ (float)heightForString:(NSString *)str withFont:(UIFont *)font width:(float)width LineHeight:(CGFloat)lineHeight {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineHeight;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{ NSFontAttributeName: font, NSParagraphStyleAttributeName: paraStyle, NSKernAttributeName: @1.0f };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, [UIScreen mainScreen].bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

//MARK: - 数字格式化

- (BOOL)isPureFloat {
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

- (BOOL)isPureInt {
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (NSString *)stringDivide100 {
    if (![self isPureInt] && ![self isPureFloat]) return @"";
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithString:@"0"];
    @autoreleasepool {
        NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber *number2 = [NSDecimalNumber decimalNumberWithString:@"100"];
        result = [number1 decimalNumberByDividingBy:number2];
    }

    return result.stringValue;
}

- (NSString *)stringMultiply100 {
    if (![self isPureInt] && ![self isPureFloat]) return @"";
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithString:@"0"];
    @autoreleasepool {
        NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber *number2 = [NSDecimalNumber decimalNumberWithString:@"100"];
        result = [number1 decimalNumberByMultiplyingBy:number2];
    }
    return result.stringValue;
}

- (NSString *)stringFormatWithStyle:(NumberFormatter)style {
    NSString *string = @"";
    @autoreleasepool {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSNumber *number = [formatter numberFromString:self];
        formatter.numberStyle = (NSInteger)style;
        string = [formatter stringFromNumber:number];
    }
    return string;
}

@end

@implementation NSDictionary (Extension)

+ (NSDictionary *)stringToDictionary:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];

    if (err) {
        NSLog(@"json解析失败：%@", err);
        return nil;
    }
    return dic;
}

- (NSString *)jsonString {
    NSError *parseError = nil;
    if (self) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];

        NSString *jsonString =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

        //去掉字符串中的空格
        NSRange range = { 0, jsonString.length };
        [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

        //去掉字符串中的换行符
        NSRange range2 = { 0, mutStr.length };
        [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

        return [mutStr copy];
    } else {
        return @"";
    }
}

@end

@implementation NSArray (Extension)

/// 字符串转数组
/// @param jsonString 字符串 (" ," 号分割)
+ (NSArray *)stringToArr:(NSString *)jsonString {
    return [NSArray stringToArr:jsonString separator:@","];
}

/// 字符串转数组
/// @param jsonString 字符串
/// @param separator 分隔符
+ (NSArray *)stringToArr:(NSString *)jsonString separator:(NSString *)separator {
    return [NSArray stringToArr:jsonString separator:separator];
}

- (NSString *)toString {
    NSError *parseError = nil;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&parseError];
    NSString *jsonString =  [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    //去掉字符串中的空格
    NSRange range = { 0, jsonString.length };
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = { 0, mutStr.length };
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return [mutStr copy];
}

@end
