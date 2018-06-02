//
//  NSString+SZTrendChart.h
//  TrendChart
//
//  Created by Zahi on 2018/5/31.
//  Copyright © 2018年 Sideny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (SZTrendChart)

// 验证邮箱
-(BOOL)isValidateEmail;

//是否都为整形数字
- (BOOL)isPureInt;

// 验证身份证号码
- (BOOL)isValidateIDCard;

// 验证手机号码
- (BOOL)isValidateMobileNumber;
//海外手机号
- (BOOL)isOverseasValidateMobileNumber;
// 验证银行卡 (Luhn算法)
- (BOOL)isValidCardNumber;

//是否含有系统表情
- (BOOL)isContainEmoji;

- (float)stringWidthWithFont:(UIFont *)font height:(float)height;
- (float)stringHeightWithFont:(UIFont *)font width:(float)width;
- (float)stringHeightWithFont:(UIFont *)font width:(float)width lineSpacing:(float)lineSpacing;

- (CGSize)stringSizeWithFont:(UIFont *)font;
- (CGSize)stringSizeWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

//星座
-(NSString*)getAstor;

- (NSString *)getBinaryByhex;

@end
