//
//  TXQuestionManager.m
//  LYHM
//
//  Created by chenxiaojie on 2023/3/16.
//  Copyright © 2023 chenxiaojie. All rights reserved.
//

#import "TXQuestionManager.h"
#import "Masonry/Masonry.h"
#import "TXQuestionTipView.h"
#import "TXQuestionScreenshotAlertView.h"
#import "TXQuestionUtil.h"

static TXQuestionManager *sharedManager = nil;

@interface TXQuestionManager ()

@property (nonatomic, strong) TXQuestionTipView *questionTipView;
@property (nonatomic, strong) TXQuestionScreenshotAlertView *screenshotAlertView;
@property (nonatomic, assign) BOOL showScreenshotAlertView;

@end

@implementation TXQuestionManager

+ (TXQuestionManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.needEncrypt = YES;
    });
    return sharedManager;
}

- (void)start {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshot:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

#pragma mark - Private Method
- (void)userDidTakeScreenshot:(NSNotification *)notification {
    // 正在截图页面，不需要显示反馈问题
    if (self.showScreenshotAlertView) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 5), dispatch_get_main_queue(), ^{
        [self.questionTipView removeFromSuperview];
    });
    [[UIApplication sharedApplication].windows.firstObject addSubview:self.questionTipView];
    [self.questionTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo([UIApplication sharedApplication].windows.firstObject).offset(-100);
        make.trailing.equalTo([UIApplication sharedApplication].windows.firstObject);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.questionTipView.feedbackClickBlock = ^{
        weakSelf.showScreenshotAlertView = YES;
        [weakSelf.questionTipView removeFromSuperview];
        [weakSelf.screenshotAlertView.drawBoardView removeAction];
        weakSelf.screenshotAlertView.screenshotImage = [TXQuestionUtil imageWithScreenshot];
        weakSelf.screenshotAlertView.qrCodeImage = [TXQuestionUtil loadQRCodeImgWithStr:[TXQuestionUtil getDeviceInfo:weakSelf.deviceInfo needEncrypt:weakSelf.needEncrypt]];
        [[UIApplication sharedApplication].windows.firstObject addSubview:weakSelf.screenshotAlertView];
        [weakSelf.screenshotAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo([UIApplication sharedApplication].windows.firstObject);
        }];
    };
    
    self.screenshotAlertView.saveBtnBlock = ^{
        weakSelf.showScreenshotAlertView = NO;
        [weakSelf.screenshotAlertView removeFromSuperview];
        UIImage *image = [TXQuestionUtil captureImageFromView:weakSelf.screenshotAlertView.screenshotBgView imageRect:CGRectMake(0, -20, weakSelf.screenshotAlertView.screenshotBgView.frame.size.width, weakSelf.screenshotAlertView.screenshotBgView.frame.size.height+40)];
        [TXQuestionUtil saveImgToSystemAlbumWithImage:image];
    };
    self.screenshotAlertView.cancelBtnBlock = ^{
        weakSelf.showScreenshotAlertView = NO;
        [weakSelf.screenshotAlertView removeFromSuperview];
    };
}

- (TXQuestionTipView *)questionTipView {
    if (_questionTipView == nil) {
        _questionTipView = [[TXQuestionTipView alloc] init];
    }
    return _questionTipView;
}

- (TXQuestionScreenshotAlertView *)screenshotAlertView {
    if (_screenshotAlertView == nil) {
        _screenshotAlertView = [[TXQuestionScreenshotAlertView alloc] init];
    }
    return _screenshotAlertView;
}

@end
