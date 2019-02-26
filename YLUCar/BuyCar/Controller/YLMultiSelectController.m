//
//  YLMultiSelectController.m
//  YLUCar
//
//  Created by lm on 2019/1/29.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLMultiSelectController.h"
#import "YLConditionParamModel.h"
#import "YLConditionCell.h"
#import "YLCollectHeader.h"

static NSString *const cellID = @"YLSelectCell";
static NSString *const footerID = @"YLSelectFooter";
static NSString *const headerID = @"YLSelectheader";

@interface YLMultiSelectController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation YLMultiSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self yl_initView];
}

- (void)yl_initView {
    
    CGFloat btnY = CGRectGetMaxY(self.collectionView.frame);
    CGFloat btnW = (YLScreenWidth - 3 * LeftMargin) / 2;
    CGFloat btnH = 44;
    UIButton *restBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    restBtn.frame = CGRectMake(LeftMargin, btnY, btnW, btnH);
    [restBtn setTitle:@"重置" forState:UIControlStateNormal];
    [restBtn setTitleColor:YLColor(8.f, 169.f, 255.f) forState:UIControlStateNormal];
    restBtn.backgroundColor = [UIColor whiteColor];
    restBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    restBtn.layer.borderWidth = 1.f;
    restBtn.layer.borderColor = YLColor(8.f, 169.f, 255.f).CGColor;
    [restBtn addTarget:self action:@selector(restALLCondition) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:restBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(CGRectGetMaxX(restBtn.frame) + LeftMargin, btnY, btnW, btnH);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = YLColor(8.f, 169.f, 255.f);
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}

- (void)restALLCondition {
    NSLog(@"-------重置所有条件--------");
    for (NSInteger i = 0; i < self.multiSelectModels.count; i++) {
        NSArray *arr = self.multiSelectModels[i];
        for (NSInteger j = 0; j < arr.count; j++) {
            YLConditionParamModel *model = arr[j];
            if (model.isSelect) {
                model.isSelect = !model.isSelect;
            }
        }
    }
    
    if (self.restAllConditionBlock) {
        self.restAllConditionBlock(self.multiSelectModels);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sureClick {
    NSLog(@"-------条件已确认--------");
    if (self.sureBlock) {
        self.sureBlock(self.multiSelectModels);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.multiSelectModels.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.multiSelectModels[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YLConditionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    YLConditionParamModel *model = self.multiSelectModels[indexPath.section][indexPath.row];
    cell.model = model;
    return cell;
}

// 如果单独出现这个方法，是不会执行的，必须设定尺寸才能执行
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerID forIndexPath:indexPath];
    // 此处的header可能会产生复用，要将之前原有的子视图移除掉
    for (YLCollectHeader *view in header.subviews) {
        [view removeFromSuperview];
    }
    YLCollectHeader *head = [[YLCollectHeader alloc] initWithFrame:header.bounds];
    head.title = self.headerTitles[indexPath.section];
    [header addSubview:head];
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 30);
    return itemSize;
}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    CGSize itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
//    return itemSize;
//}


#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == self.multiSelectModels.count - 1) {
        YLConditionParamModel *model = self.multiSelectModels[indexPath.section][indexPath.row];
        model.isSelect = !model.isSelect;
        if (model.isSelect) {
            model.param = @"1";
        } else {
            model.param = @"0";
        }
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    } else {
        YLConditionParamModel *model = self.multiSelectModels[indexPath.section][indexPath.row];
        model.isSelect = !model.isSelect;
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 小cell
        CGFloat leftMargin = 15;
        CGFloat itemSpacing = 15;
        CGFloat topMargin = 5;
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 2 * leftMargin - 2 * itemSpacing) / 3;
        layout.itemSize = CGSizeMake(width, 36);
        // cell的行间距
        layout.minimumLineSpacing = itemSpacing;
        // cell的垂直间距
        layout.minimumInteritemSpacing = itemSpacing;
        // collectionView的滑动方向
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // collectionView的边缘间距
        layout.sectionInset = UIEdgeInsetsMake(topMargin, leftMargin, 15, leftMargin);
        CGFloat collectH = YLScreenHeight - 64 - 44 - leftMargin;
        if (KIsiPhoneX) {
            collectH -= 34;
        }
        CGRect rect = CGRectMake(0, 0, YLScreenWidth, collectH);
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.bounces = NO;
        [_collectionView registerClass:[YLConditionCell class] forCellWithReuseIdentifier:cellID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    }
    return _collectionView;
}


- (void)setMultiSelectModels:(NSArray *)multiSelectModels {
    _multiSelectModels = [multiSelectModels copy];
    [self.collectionView reloadData];
}

- (void)setHeaderTitles:(NSArray *)headerTitles {
    _headerTitles = [headerTitles copy];
}

@end
