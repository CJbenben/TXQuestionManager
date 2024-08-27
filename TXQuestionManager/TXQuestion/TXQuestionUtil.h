//
//  TXQuestionUtil.h
//  LYHM
//
//  Created by chenxiaojie on 2023/3/16.
//  Copyright © 2023 chenxiaojie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXQuestionUtil : NSObject

/**
 @brief 获取截图 image 对象
 @return UIImage
 */
+ (UIImage *)imageWithScreenshot;
/**
 @brief view 转 image
 @param view 需要转换的 view
 @param imageRect 大小
 @return UIImage
 */
+ (UIImage *)captureImageFromView:(UIView *)view imageRect:(CGRect)imageRect;
/**
 @brief 字符串转图片二维码
 @param qrcodeStr    需要转二维码的字符串
 @return UIImage
 */
+ (UIImage *)loadQRCodeImgWithStr:(NSString *)qrcodeStr;
/**
 @brief 保存图片到系统相册
 @param image 需要保存的图片
 */
+ (void)saveImgToSystemAlbumWithImage:(UIImage *)image;
/**
 @brief 获取设备信息
 @param originalInfo 原始信息
 @param needEncrypt 是否需要加密
 */
+ (NSString *)getDeviceInfo:(NSString * _Nullable )originalInfo needEncrypt:(BOOL)needEncrypt;

@end

NS_ASSUME_NONNULL_END
