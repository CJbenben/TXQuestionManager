//
//  TXQuestionTipView.h
//  LYHM
//
//  Created by chenxiaojie on 2023/3/16.
//  Copyright © 2023 chenxiaojie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXQuestionTipView : UIView

@property (nonatomic, copy) void(^feedbackClickBlock)(void);

@end

NS_ASSUME_NONNULL_END
