//
//  TXQuestionTipView.m
//  LYHM
//
//  Created by chenxiaojie on 2023/3/16.
//  Copyright © 2023 chenxiaojie. All rights reserved.
//

#import "TXQuestionTipView.h"
#import "Masonry/Masonry.h"

@interface TXQuestionTipView ()

@property (nonatomic, strong) UILabel *titleL;

@end

@implementation TXQuestionTipView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClickTapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - Action
- (void)viewClickTapAction {
    if (self.feedbackClickBlock) {
        self.feedbackClickBlock();
    }
}

#pragma mark - UI
- (void)setupUI {
    self.layer.cornerRadius = 6;
    self.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    [self addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.top.equalTo(self).offset(12);
        make.leading.equalTo(self).offset(16);
    }];
}

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.text = @"反馈问题";
        _titleL.textColor = [UIColor whiteColor];
    }
    return _titleL;
}

@end
