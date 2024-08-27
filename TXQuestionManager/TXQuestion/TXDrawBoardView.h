//
//  TXDrawBoardView.h
//  LYHM
//
//  Created by chenxiaojie on 2023/3/16.
//  Copyright © 2023 chenxiaojie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXBezierPath : UIBezierPath
/// 画笔的颜色
@property (nonatomic, copy) UIColor *lineColor;
/// 是否是橡皮擦
@property (nonatomic, assign) BOOL isErase;

@end

// 画板
@interface TXDrawBoardView : UIView

@property (nonatomic, strong) TXBezierPath *bezierPath;
/// 画笔的颜色
@property (nonatomic, strong) UIColor *lineColor;
/// 是否是橡皮擦
@property (nonatomic, assign) BOOL isErase;

// 撤销
- (void)revokeAction;
// 清空
- (void)removeAction;
// 恢复
- (void)resumeAction;
// 保存
- (void)saveAction;

@end
