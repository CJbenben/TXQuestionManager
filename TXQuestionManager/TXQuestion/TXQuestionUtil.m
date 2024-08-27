//
//  TXQuestionUtil.m
//  LYHM
//
//  Created by chenxiaojie on 2023/3/16.
//  Copyright © 2023 chenxiaojie. All rights reserved.
//

#import "TXQuestionUtil.h"
#import <sys/utsname.h>

@implementation TXQuestionUtil

#pragma mark - Public Method
+ (UIImage *)imageWithScreenshot {
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [self currentOrientation];
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(image);
    return [UIImage imageWithData:imageData];
}

+ (UIImage *)captureImageFromView:(UIView *)view imageRect:(CGRect)imageRect {
    int scale = [UIScreen mainScreen].scale;
    CGRect rect = imageRect;
    rect.origin.x *= scale;
    rect.origin.y *= scale;
    rect.size.width *= scale;
    rect.size.height *= scale;
    UIGraphicsBeginImageContextWithOptions(imageRect.size, YES, scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef cgImage = CGImageCreateWithImageInRect(snapshotImage.CGImage, rect);
    UIImage * newImage = [UIImage imageWithCGImage:cgImage];
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)loadQRCodeImgWithStr:(NSString *)qrcodeStr {
    NSData *img_data = [qrcodeStr dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:img_data forKey:@"inputMessage"];
    CIImage *img_CIImage = [filter outputImage];
    return [self changeImageSizeWithCIImage:img_CIImage andSize:180];
}

+ (void)saveImgToSystemAlbumWithImage:(UIImage *)image {
    if (image == nil) {
        NSLog(@"需要保存图片为空");
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^(void) {
        if (image) {
            UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        }
    });
}

+ (NSString *)getDeviceInfo:(NSString *)originalInfo needEncrypt:(BOOL)needEncrypt {
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *phoneBrand = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSString *buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSString *dateStr = [self formatDateToStringDate:[NSDate date] formatStr:@"yyyy-MM-dd HH-mm-ss"];
    NSString *devieceInfo = [NSString stringWithFormat:@"appVersion=%@;\nsystemVersion=%@;\nphoneBrand=%@;\nbuildVersion=%@;\ndateStr=%@;\n", appVersion, systemVersion, phoneBrand, buildVersion, dateStr];
    if (originalInfo.length) {
        devieceInfo = [NSString stringWithFormat:@"%@\n%@", devieceInfo, originalInfo];
    }
    if (needEncrypt) {
        NSData *data = [devieceInfo dataUsingEncoding:NSUTF8StringEncoding];
        NSData *base64Data = [data base64EncodedDataWithOptions:0];
        return [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
    }
    return devieceInfo;
}

#pragma mark - Private Method
+ (UIInterfaceOrientation)currentOrientation {
    UIWindow *keyWindow = [UIApplication sharedApplication].windows.firstObject;
    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = (UIWindowScene *)keyWindow.windowScene;
        if (windowScene) {
            return windowScene.interfaceOrientation;
        }
    } else {
        return [UIApplication sharedApplication].statusBarOrientation;
    }
    return UIInterfaceOrientationUnknown;
}

//拉伸二维码图片，使其清晰
+ (UIImage *)changeImageSizeWithCIImage:(CIImage *)ciImage andSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存相册失败, error = %@, contextInfo = %@", error, contextInfo);
    } else {
        NSLog(@"保存相册成功");
    }
}

+ (NSString *)formatDateToStringDate:(NSDate *)date formatStr:(NSString *)formatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatStr];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

@end
