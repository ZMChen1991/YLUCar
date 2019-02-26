//
//  YLOrderCarDetailView.m
//  YLUCar
//
//  Created by lm on 2019/2/21.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLOrderCarDetailView.h"
#import "YLCondition.h"
#import "YLYearMonthDayPicker.h"
#import "YLTimePicker.h"

@interface YLOrderCarDetailView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) YLCondition *cancelBtn;
@property (nonatomic, strong) YLCondition *sureBtn;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *line;
//@property (nonatomic, strong) UIView *cover;

@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *timeString;


@end

@implementation YLOrderCarDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = YLFont(14);
    titleLabel.text = @"请选择看车时间";
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
    self.line = line;
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = YLFont(16);
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.text = @"请选择日期";
    dateLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *dateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDate)];
    [dateLabel addGestureRecognizer:dateTap];
    [self addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = YLFont(16);
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.text = @"请选择时间";
    timeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *timeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTime)];
    [timeLabel addGestureRecognizer:timeTap];
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.font = YLFont(12);
    detailLabel.text = @"多人已关注，预计很快售出，建议尽早预约";
    [self addSubview:detailLabel];
    self.detailLabel = detailLabel;
    
    YLCondition *cancelBtn = [YLCondition buttonWithType:UIButtonTypeCustom];
    cancelBtn.type = YLConditionTypeWhite;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = YLFont(14);
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    
    YLCondition *sureBtn = [YLCondition buttonWithType:UIButtonTypeCustom];
    sureBtn.type = YLConditionTypeBlue;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = YLFont(14);
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    self.sureBtn = sureBtn;
}

- (void)showDate {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    UIView *cover1 = [[UIView alloc] initWithFrame:window.bounds];
    cover1.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3];
    [window addSubview:cover1];
    
    CGFloat pickerH = 160;
    CGFloat pickerY = (YLScreenHeight - pickerH) / 2;
    CGRect rect = CGRectMake(0, pickerY, YLScreenWidth, pickerH);
    __weak typeof(self) weakSelf = self;
    YLYearMonthDayPicker *picker = [[YLYearMonthDayPicker alloc] initWithFrame:rect];
    picker.cancelBlock = ^{
        [cover1 removeFromSuperview];
    };
    picker.sureBlock = ^(NSString * _Nonnull licenseTime) {
        weakSelf.dateString = licenseTime;
        weakSelf.dateLabel.text = licenseTime;
        [cover1 removeFromSuperview];
    };
    [cover1 addSubview:picker];
}

- (void)showTime {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    UIView *cover1 = [[UIView alloc] initWithFrame:window.bounds];
    cover1.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3];
    [window addSubview:cover1];
    
    CGFloat pickerH = 160;
    CGFloat pickerY = (YLScreenHeight - pickerH) / 2;
    CGRect rect = CGRectMake(0, pickerY, YLScreenWidth, pickerH);
    __weak typeof(self) weakSelf = self;
    YLTimePicker *timePicker = [[YLTimePicker alloc] initWithFrame:rect];
    timePicker.cancelBlock = ^{
        [cover1 removeFromSuperview];
    };
    timePicker.sureBlock = ^(NSString * _Nonnull time) {
        weakSelf.timeString = time;
        weakSelf.timeLabel.text = time;
        [cover1 removeFromSuperview];
    };
    [cover1 addSubview:timePicker];
}

- (void)cancelClick {
    
    NSLog(@"取消预约看车");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderCarCancel)]) {
        [self.delegate orderCarCancel];
    }
    
    if (self.orderCarDetailCancelBlock) {
        self.orderCarDetailCancelBlock();
    }
}

- (void)sureClick {
    
    NSLog(@"确定预约看车");
    if (self.dateString && self.timeString) {
        NSString *time = [NSString stringWithFormat:@"%@ %@", self.dateString, self.timeString];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(orderCarTime:)]) {
            [self.delegate orderCarTime:time];
        }
        
        if (self.orderCarDetailSureBlock) {
            self.orderCarDetailSureBlock(time);
        }
        
    } else {
        [NSString showMessage:@"请选择日期和时间"];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat viewW = self.frame.size.width;
    CGFloat labelW = viewW - 2 * LeftMargin;
    CGFloat titleH = 20;
    self.titleLabel.frame = CGRectMake(LeftMargin, LeftMargin, labelW, titleH);
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + LeftMargin, viewW, 0.5);
    
    CGFloat dateLabelW = (viewW - 3 * LeftMargin) / 2;
    CGFloat dateLabelH = 30;
    CGFloat dateLabelY = CGRectGetMaxY(self.line.frame) + LeftMargin;
    self.dateLabel.frame = CGRectMake(LeftMargin, dateLabelY, dateLabelW, dateLabelH);
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.dateLabel.frame) + LeftMargin, dateLabelY, dateLabelW, dateLabelH);
    self.detailLabel.frame = CGRectMake(0, CGRectGetMaxY(self.dateLabel.frame) + LeftMargin, viewW, 20);
    
    CGFloat btnH = 40;
    CGFloat btnY = CGRectGetMaxY(self.detailLabel.frame) + Margin;
    self.cancelBtn.frame = CGRectMake(LeftMargin, btnY, dateLabelW, btnH);
    self.sureBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame) + LeftMargin, btnY, dateLabelW, btnH);
    NSLog(@"%f", CGRectGetMaxY(self.sureBtn.frame) + LeftMargin);
}
@end
