//
//  YLDetailFooterView.m
//  YLUCar
//
//  Created by lm on 2019/2/16.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLDetailFooterView.h"
#import "YLBannerCollectionView.h"
#import "YLDetailBannerModel.h"

@interface YLDetailFooterView ()

@property (nonatomic, strong) YLBannerCollectionView *banner;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YLDetailFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    YLBannerCollectionView *banner = [[YLBannerCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 2 * LeftMargin, 220)];
    banner.layer.cornerRadius = 5.f;
    banner.layer.masksToBounds = YES;
    banner.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:banner];
    self.banner = banner;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = YLFont(14);
    titleLabel.textColor = YLColor(155.f, 155.f, 155.f);
    titleLabel.text = @"瑕疵,共0张";
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat bannerW = self.frame.size.width - 2 * LeftMargin;
    CGFloat bannerH = 200;
    self.banner.frame = CGRectMake(LeftMargin, 0, bannerW, bannerH);
    self.titleLabel.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.banner.frame) + Margin, bannerW, 20);
}

- (void)setModels:(NSArray *)models {
    _models = models;
    
    if (!models) {
        return;
    }
    NSMutableArray *images = [NSMutableArray array];
    for (NSInteger i = 0; i < models.count; i++) {
        YLDetailBannerModel *model = models[i];
        [images addObject:model.img];
    }
    self.banner.images = images;
    self.titleLabel.text = [NSString stringWithFormat:@"瑕疵,共%ld张", models.count];
}

@end
