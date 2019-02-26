//
//  YLNotableView.m
//  YLUCar
//
//  Created by lm on 2019/1/29.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLNotableView.h"

@interface YLNotableView ()

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, assign) NSInteger count;

@end

@implementation YLNotableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin, 8, 36, height - 2 * 8)];
        icon.contentMode = UIViewContentModeScaleAspectFill;
        icon.image = [UIImage imageNamed:@"最新成交"];
        [self addSubview:icon];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) + 20, 8, width - 36 - 20 - 2 * LeftMargin, height- 2 * 8)];
        titleL.font = [UIFont systemFontOfSize:12];
        titleL.numberOfLines = 0;
        [self addSubview:titleL];
        self.titleL = titleL;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleL.frame)+8, width, 1)];
        line.backgroundColor = YLColor(233.f, 233.f, 233.f);
        [self addSubview:line];
        
        // 使用定时器更新title
        [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(updataTitles) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)updataTitles {
    
    if (!self.titles.count) {
        return;
    }
    if (self.count < self.titles.count) {
        self.titleL.text = self.titles[self.count];
    } else {
        self.count = 0;
        self.titleL.text = self.titles[self.count];
    }
    self.count++;
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    self.count = 0;
    
    if (!titles.count) {
        return;
    }
    self.titleL.text = titles[self.count];
}
@end
