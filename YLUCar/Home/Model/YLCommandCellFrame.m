//
//  YLCommandCellFrame.m
//  YLUCar
//
//  Created by lm on 2019/1/28.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLCommandCellFrame.h"

@implementation YLCommandCellFrame

- (void)setModel:(YLCommandModel *)model {
    _model = model;
    
//    if (self.isLargeImage) {
//        CGFloat imageH = 228;
//        CGFloat imageW = YLScreenWidth - 2 * LeftMargin;
//        self.displayImgF = CGRectMake(LeftMargin, TopMargin, imageW, imageH);
//
//        CGFloat titleY = CGRectGetMaxY(self.displayImgF) + LeftMargin;
//        CGFloat titleW = imageW;
//        CGFloat titleH = 34;
//        CGSize titleSize = [model.title getSizeWithFont:YLFont(14)];
//        if (titleSize.width > titleW) {
//            titleH += titleSize.height;
//        }
//        self.titleF = CGRectMake(LeftMargin, titleY, titleW, titleH);
//
//        CGFloat courseH = 17;
//        self.courseF = CGRectMake(LeftMargin, CGRectGetMaxY(self.titleF) + Margin, titleW, courseH);
//
//        NSString *price = [model.price stringToNumberString];
//        CGSize priceSize = [price getSizeWithFont:YLFont(18)];
//        self.priceF = CGRectMake(LeftMargin, CGRectGetMaxY(self.courseF) + Margin, priceSize.width + TopMargin, priceSize.height);
//
//        CGFloat originalPriceW = YLScreenWidth - CGRectGetMaxX(self.priceF) - LeftMargin;
//        self.originalPriceF = CGRectMake(CGRectGetMaxX(self.priceF), CGRectGetMaxY(self.courseF) + Margin, originalPriceW, 25);
//        self.lineF = CGRectMake(0, CGRectGetMaxY(self.displayImgF) + TopMargin, YLScreenWidth, 1);
//        self.cellHeight = CGRectGetMaxY(self.lineF);
//
//    } else {
//        self.displayImgF = CGRectMake(LeftMargin, TopMargin, 120, 86);
//        CGFloat courseW = YLScreenWidth - 120 - 2 * LeftMargin - TopMargin;
//        CGFloat titleX = CGRectGetMaxX(self.displayImgF) + LeftMargin;
//        CGFloat titleW = YLScreenWidth - CGRectGetMaxX(self.displayImgF) - 2 * LeftMargin;
//        CGFloat titleH = 34;
//        NSString *price = [model.price stringToNumberString];
//        CGFloat priceW = [price getSizeWithFont:[UIFont systemFontOfSize:18]].width + TopMargin;
//        self.titleF = CGRectMake(titleX, TopMargin, titleW, titleH);
//        self.courseF = CGRectMake(titleX, CGRectGetMaxY(self.titleF) + 5, courseW, 17);
//        self.priceF = CGRectMake(titleX, CGRectGetMaxY(self.courseF) + 5, priceW, 25);
//        self.originalPriceF = CGRectMake(CGRectGetMaxX(self.priceF), CGRectGetMaxY(self.courseF) + 5, YLScreenWidth - CGRectGetMaxX(self.priceF) - 15 , 25);
//        self.lineF = CGRectMake(0, CGRectGetMaxY(self.displayImgF) + TopMargin, YLScreenWidth, 1);
//        self.cellHeight = CGRectGetMaxY(self.lineF);
//    }
    
}

- (void)setIsLargeImage:(BOOL)isLargeImage {
    _isLargeImage = isLargeImage;
    
    if (isLargeImage) {
        CGFloat imageH = 228;
        CGFloat imageW = YLScreenWidth - 2 * LeftMargin;
        self.displayImgF = CGRectMake(LeftMargin, TopMargin, imageW, imageH);
        
        CGFloat titleY = CGRectGetMaxY(self.displayImgF) + TopMargin;
        CGFloat titleW = imageW;
        CGFloat titleH = 34;
        CGSize titleSize = [self.model.title getSizeWithFont:YLFont(14)];
        if (titleSize.width > titleW) {
            titleH += titleSize.height;
        }
        self.titleF = CGRectMake(LeftMargin, titleY, titleW, titleH);
        
        CGFloat courseH = 17;
        self.courseF = CGRectMake(LeftMargin, CGRectGetMaxY(self.titleF) + Margin, titleW, courseH);
        
        NSString *price = [self.model.price stringToNumberString];
        CGSize priceSize = [price getSizeWithFont:YLFont(18)];
        self.priceF = CGRectMake(LeftMargin, CGRectGetMaxY(self.courseF) + Margin, priceSize.width + TopMargin, priceSize.height);
        
        CGFloat originalPriceW = YLScreenWidth - CGRectGetMaxX(self.priceF) - LeftMargin;
        self.originalPriceF = CGRectMake(CGRectGetMaxX(self.priceF), CGRectGetMaxY(self.courseF) + Margin, originalPriceW, 25);
        self.lineF = CGRectMake(0, CGRectGetMaxY(self.priceF) + TopMargin, YLScreenWidth, 1);
        self.cellHeight = CGRectGetMaxY(self.lineF);
        
    } else {
        self.displayImgF = CGRectMake(LeftMargin, TopMargin, 120, 86);
        CGFloat courseW = YLScreenWidth - 120 - 2 * LeftMargin - TopMargin;
        CGFloat titleX = CGRectGetMaxX(self.displayImgF) + LeftMargin;
        CGFloat titleW = YLScreenWidth - CGRectGetMaxX(self.displayImgF) - 2 * LeftMargin;
        CGFloat titleH = 34;
        NSString *price = [self.model.price stringToNumberString];
        CGFloat priceW = [price getSizeWithFont:[UIFont systemFontOfSize:18]].width + TopMargin;
        self.titleF = CGRectMake(titleX, TopMargin, titleW, titleH);
        self.courseF = CGRectMake(titleX, CGRectGetMaxY(self.titleF) + 5, courseW, 17);
        self.priceF = CGRectMake(titleX, CGRectGetMaxY(self.courseF) + 5, priceW, 25);
        self.originalPriceF = CGRectMake(CGRectGetMaxX(self.priceF), CGRectGetMaxY(self.courseF) + 5, YLScreenWidth - CGRectGetMaxX(self.priceF) - 15 , 25);
        self.lineF = CGRectMake(0, CGRectGetMaxY(self.displayImgF) + TopMargin, YLScreenWidth, 1);
        self.cellHeight = CGRectGetMaxY(self.lineF);
    }
}

@end
