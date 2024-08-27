//
//  TXQuestionManager.h
//  LYHM
//
//  Created by chenxiaojie on 2023/3/16.
//  Copyright © 2023 chenxiaojie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXQuestionManager : NSObject
/// 原始信息
@property (nonatomic, strong) NSString *deviceInfo;
/// 是否需要加密，默认：YES
@property (nonatomic, assign) BOOL needEncrypt;

+ (TXQuestionManager *)sharedInstance;

- (void)start;

@end

NS_ASSUME_NONNULL_END
