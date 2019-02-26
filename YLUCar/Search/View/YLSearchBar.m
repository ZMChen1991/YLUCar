//
//  YLSearchBar.m
//  YLGoodCard
//
//  Created by lm on 2018/11/3.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLSearchBar.h"

@implementation YLSearchBar

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // 设置圆角
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.font = [UIFont systemFontOfSize:14];
        self.textColor = YLColor(51.f, 51.f, 51.f);
        
        // 设置内容 -- 垂直居中
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        // 修改占位字体大小
        [self setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        // 修改占位字体颜色
//        [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//        [self setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.placeholder = @"请搜索您想要的车";
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
        
        // 设置左边显示一个放大镜
        UIImageView *leftView = [[UIImageView alloc] init];
        leftView.image = [UIImage imageNamed:@"搜索"];
        leftView.frame = CGRectMake(0, 0, leftView.image.size.width + 10, leftView.image.size.height);
        
        // 设置leftView的内容居中
        leftView.contentMode = UIViewContentModeCenter;
        self.leftView = leftView;
        
        // 设置左边的View永远显示
        self.leftViewMode = UITextFieldViewModeAlways;
        
        // 设置右边永远显示清除按钮
        self.clearButtonMode = UITextFieldViewModeAlways;
    }
    
    return self;
}

+ (instancetype)searchBar {
    return [[self alloc] init];
}
@end
