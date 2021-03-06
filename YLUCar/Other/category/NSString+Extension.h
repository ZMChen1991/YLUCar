//
//  NSString+Extension.h
//  YLGoodCard
//
//  Created by lm on 2018/11/8.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
// 获取字符串的长度
- (CGSize)getSizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;
- (CGSize)getSizeWithFont:(UIFont *)font;

- (NSString *)stringToNumberString;

/**
  更改字符串中某段字符的颜色

 @param changeString 需要改变颜色的字符串
 @param color 修改的颜色
 @return 修改颜色后的字符串
 */
- (NSMutableAttributedString *)changeString:(NSString *)changeString color:(UIColor *)color;

// 是否空白字符
+ (BOOL) isBlankString:(NSString *)string;

// 日期转字符串
+ (NSString *)stringByDate:(NSDate *)date;

// 显示2秒弹窗
+ (void)showMessage:(NSString *)message;

@end
