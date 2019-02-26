//
//  YLSearchHistoryView.m
//  YLUCar
//
//  Created by lm on 2019/2/26.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLSearchHistoryView.h"
#import "YLCondition.h"

static NSString *const cellID = @"cellID";

@interface YLSearchHistoryView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) YLCondition *deleteBtn;

@property (nonatomic, strong) UICollectionView *collectView;

//@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation YLSearchHistoryView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    CGFloat btnW = 50;
    CGFloat btnH = 20;
    YLCondition *deleteBtn = [YLCondition buttonWithType:UIButtonTypeCustom];
    deleteBtn.type = YLConditionTypeWhite;
    deleteBtn.titleLabel.font = YLFont(14);
    deleteBtn.frame = CGRectMake(YLScreenWidth - LeftMargin - btnW, TopMargin, btnW, btnH);
    [deleteBtn setTitle:@"清空" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    self.deleteBtn = deleteBtn;
    
    CGFloat titleW = YLScreenWidth - 2 * LeftMargin - btnW - TopMargin;
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, TopMargin, titleW, btnH)];
    titleLable.text = @"搜索记录";
    titleLable.font = YLFont(16);
    titleLable.textColor = YLColor(51.f, 51.f, 51.f);
    titleLable.textAlignment = NSTextAlignmentLeft;
//    titleLable.backgroundColor = [UIColor redColor];
    [self addSubview:titleLable];
    self.titleLabel = titleLable;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLable.frame) + TopMargin, YLScreenWidth, 1)];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat collectW = YLScreenWidth;
    CGRect rect = CGRectMake(0, CGRectGetMaxY(line.frame) + TopMargin, collectW, 100);
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    collectView.backgroundColor = [UIColor whiteColor];
    collectView.delegate = self;
    collectView.dataSource = self;
    collectView.bounces = NO;
    [collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self addSubview:collectView];
    self.collectView = collectView;
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, CGRectGetMaxY(line.frame) + TopMargin, YLScreenWidth - 2 * LeftMargin, btnH)];
    detailLabel.text = @"暂无搜索记录";
    detailLabel.textColor = YLColor(51.f, 51.f, 51.f);
    detailLabel.font = YLFont(14);
    [self addSubview:detailLabel];
    self.detailLabel = detailLabel;
    if (self.searchHistory.count == 0) {
        detailLabel.hidden = NO;
    } else {
        detailLabel.hidden = YES;
    }
    
    self.viewHeight = CGRectGetMaxY(collectView.frame);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.searchHistory.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    // 为防止重叠,移除cell的子视图
    for (id subView in cell.contentView.subviews) {
        if (subView) {
            [subView removeFromSuperview];
        }
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    label.layer.borderWidth = 0.5f;
    label.layer.borderColor = YLColor(233.f, 233.f, 233.f).CGColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = YLFont(12);
    label.text = self.searchHistory[indexPath.row];
    label.textColor = YLColor(51.f, 51.f, 51.f);
    [cell.contentView addSubview:label];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = self.searchHistory[indexPath.row];
    CGSize size = [string getSizeWithFont:YLFont(12)];
    return CGSizeMake(size.width + 20, size.height + 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    NSLog(@"%@", cell);
//    NSLog(@"%@", self.searchHistory[indexPath.row]);
    NSString *searchTitle = self.searchHistory[indexPath.row];
//    if (self.searchBlock) {
//        self.searchBlock(searchTitle);
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchTitle:)]) {
        [self.delegate searchTitle:searchTitle];
    }
}


- (void)deleteClick {
    NSLog(@"点击了清空按钮");
    [self.searchHistory removeAllObjects];
    [self.collectView reloadData];
    self.detailLabel.hidden = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clearSearchHistory)]) {
        [self.delegate clearSearchHistory];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}

- (void)setSearchHistory:(NSMutableArray *)searchHistory {
    _searchHistory = searchHistory;
    if (!searchHistory) {
        return;
    }
    
    if (searchHistory.count == 0) {
        self.collectView.hidden = YES;
        self.detailLabel.hidden = NO;
    } else {
        self.detailLabel.hidden = YES;
        self.collectView.hidden = NO;
        [self.collectView reloadData];
    }
    
}

- (void)setIsHideDelete:(BOOL)isHideDelete {
    _isHideDelete = isHideDelete;
    if (isHideDelete) {
        self.deleteBtn.hidden = YES;
    } else {
        self.deleteBtn.hidden = NO;
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

@end
