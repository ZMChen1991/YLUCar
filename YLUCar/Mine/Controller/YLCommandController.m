//
//  YLCommandController.m
//  YLUCar
//
//  Created by lm on 2019/2/15.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLCommandController.h"
#import "YLSkipView.h"

@interface YLCommandController ()

@property (nonatomic, strong) YLSkipView *skip;

@end

@implementation YLCommandController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (YLSkipView *)skip {
    if (!_skip) {
        CGRect rect = CGRectMake(0, 0, YLScreenWidth, YLScreenHeight);
        _skip = [[YLSkipView alloc] initWithFrame:rect];
        [self.view addSubview:_skip];
    }
    return _skip;
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    self.skip.titles = titles;
}

- (void)setControllers:(NSArray *)controllers {
    _controllers = controllers;
    self.skip.controllers = controllers;
    for (NSInteger i = 0; i < controllers.count; i++) {
        [self addChildViewController:controllers[i]];
    }
    
}

@end
