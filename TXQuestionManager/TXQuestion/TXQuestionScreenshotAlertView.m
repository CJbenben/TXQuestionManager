//
//  TXQuestionScreenshotAlertView.m
//  LYHM
//
//  Created by chenxiaojie on 2023/3/16.
//  Copyright © 2023 chenxiaojie. All rights reserved.
//

#import "TXQuestionScreenshotAlertView.h"
#import "Masonry/Masonry.h"

@interface TXQuestionScreenshotAlertView ()

@property (nonatomic, strong) UIStackView *topHStackView;
@property (nonatomic, strong) UIImageView *screenshotImageView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *qrCodeImageView;
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) NSArray <NSString *> *titleAry;

@end

@implementation TXQuestionScreenshotAlertView

#pragma mark - Public Method
- (void)setScreenshotImage:(UIImage *)screenshotImage {
    _screenshotImage = screenshotImage;
    self.screenshotImageView.image = screenshotImage;
}

- (void)setQrCodeImage:(UIImage *)qrCodeImage {
    _qrCodeImage = qrCodeImage;
    self.qrCodeImageView.image = qrCodeImage;
}

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - Action
- (void)topTitleAction:(UIButton *)button {
    if (button.tag == 0) {
        if (self.cancelBtnBlock) {
            self.cancelBtnBlock();
        }
    } else if (button.tag == 1) {
        [self.drawBoardView revokeAction];
    } else if (button.tag == 2) {
        [self.drawBoardView removeAction];
    } else if (button.tag == 3) {
        [self.drawBoardView resumeAction];
    } else if (button.tag == 4) {
        if (self.saveBtnBlock) {
            self.saveBtnBlock();
        }
    }
}

#pragma mark - UI
- (void)setupUI {
    self.backgroundColor  = [[UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1] colorWithAlphaComponent:1];

    [self addSubview:self.topHStackView];
    [self.topHStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
        make.height.mas_equalTo(50);
    }];
    
    for (NSInteger index = 0; index < self.titleAry.count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        [button setTitle:self.titleAry[index] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(topTitleAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topHStackView addArrangedSubview:button];
    }
    
    [self addSubview:self.screenshotBgView];
    [self.screenshotBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topHStackView.mas_bottom);
        make.leading.equalTo(self).offset(40);
        make.trailing.equalTo(self).offset(-40);
    }];
    [self.screenshotBgView addSubview:self.screenshotImageView];
    [self.screenshotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.screenshotBgView);
        make.height.equalTo(self.screenshotBgView.mas_width).multipliedBy(UIScreen.mainScreen.bounds.size.height/UIScreen.mainScreen.bounds.size.width);
    }];
    [self.screenshotBgView addSubview:self.drawBoardView];
    [self.drawBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.screenshotImageView);
    }];
    [self.screenshotBgView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.screenshotImageView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.screenshotBgView);
    }];
    
    [self.bottomView addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView);
        make.leading.equalTo(self.bottomView).offset(10);
        make.bottom.equalTo(self.bottomView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.bottomView addSubview:self.qrCodeImageView];
    [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView);
        make.trailing.equalTo(self.bottomView).offset(-10);
        make.size.equalTo(self.logoImageView);
    }];
    
    self.coverView.backgroundColor = self.backgroundColor;
    [self addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomView);
    }];
}

#pragma mark - Setter Getter
- (UIStackView *)topHStackView {
    if (!_topHStackView) {
        _topHStackView = [[UIStackView alloc] init];
        _topHStackView.axis = UILayoutConstraintAxisHorizontal;
        _topHStackView.alignment = UIStackViewAlignmentFill;
        _topHStackView.distribution = UIStackViewDistributionFillEqually;
        _topHStackView.spacing = 0;
    }
    return _topHStackView;
}

- (UIView *)screenshotBgView {
    if (!_screenshotBgView) {
        _screenshotBgView = [[UIView alloc] init];
    }
    return _screenshotBgView;
}

- (UIImageView *)screenshotImageView {
    if (!_screenshotImageView) {
        _screenshotImageView = [[UIImageView alloc] init];
    }
    return _screenshotImageView;
}

- (TXDrawBoardView *)drawBoardView {
    if(_drawBoardView == nil){
        _drawBoardView = [[TXDrawBoardView alloc] init];
    }
    return _drawBoardView;
}


- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"AppIcon"];
    }
    return _logoImageView;
}

- (UIImageView *)qrCodeImageView {
    if (!_qrCodeImageView) {
        _qrCodeImageView = [[UIImageView alloc] init];
    }
    return _qrCodeImageView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
    }
    return _coverView;
}

- (NSArray<NSString *> *)titleAry {
    if (!_titleAry) {
        _titleAry = @[@"取消", @"撤销", @"清空", @"恢复", @"保存"];
    }
    return _titleAry;
}

@end
