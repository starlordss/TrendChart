//
//  SZTrendChartUtil.h
//  TrendChart
//
//  Created by Zahi on 2018/5/30.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZTrendChartUtil : NSObject
/** 将浮点数值转换为小数字符串 默认保留两位小数 */
+ (NSString *)decimalValue:(CGFloat)value;

/** 将浮点数值转换为小数字符串 count为保留的小数个数 */
+ (NSString *)decimalValue:(CGFloat)value count:(NSUInteger)count;

+ (NSAttributedString *)attachmentImageNamed:(NSString *)imageNamed bounds:(CGRect)bounds;

+ (NSAttributedString *)attributeText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font;

+ (NSAttributedString *)attributeText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

+ (NSAttributedString *)attributeText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font alignment:(NSTextAlignment)alignment;

+ (CGSize)attributeString:(NSAttributedString *)attString boundingRectWithSize:(CGSize)size;

#pragma mark - String

+ (NSString *)safeString:(NSString *)string placeHolder:(NSString *)placeHolder;

@end
