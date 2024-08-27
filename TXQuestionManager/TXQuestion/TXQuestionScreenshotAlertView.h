//
//  TXQuestionScreenshotAlertView.h
//  LYHM
//
//  Created by chenxiaojie on 2023/3/16.
//  Copyright © 2023 chenxiaojie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXDrawBoardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXQuestionScreenshotAlertView : UIView
/// 画板
@property (nonatomic, strong) TXDrawBoardView *drawBoardView;
@property (nonatomic, strong) UIView *screenshotBgView;
/// 原始截图 image
@property (nonatomic, strong) UIImage *screenshotImage;
/// 二维码 image
@property (nonatomic, strong) UIImage *qrCodeImage;

@property (nonatomic, copy) void(^saveBtnBlock)(void);
@property (nonatomic, copy) void(^cancelBtnBlock)(void);

@end

NS_ASSUME_NONNULL_END
