# TXQuestionManager
问题反馈，支持涂鸦。截图生成二维码，获取设备信息。

### 如何使用
```
  pod 'TXQuestionManager'
```
```
  #import "TXQuestionManager.h"

  [TXQuestionManager sharedInstance].needEncrypt = NO;
  [TXQuestionManager sharedInstance].deviceInfo = @"value=1234567890";
  [[TXQuestionManager sharedInstance] start];
```

### 二维码说明

保存图片到系统相册后，原始截图底部有一个 APP logo 和一个 二维码图片。二维码内容默认包含以下内容，如需其他参数，可通过 deviceInfo 字段设置

- appVersion=app版本号;
- systemVersion=手机系统版本号;
- phoneBrand=手机原始型号;
- buildVersion=build版本号;
- dateStr=截图时间;

[Base64在线解码工具](https://base64.us/)


![涂鸦页面](https://upload-images.jianshu.io/upload_images/674752-cbf0bcece487e9a2.png)

![保存后截图](https://upload-images.jianshu.io/upload_images/674752-80061f46c750abd0.png)


