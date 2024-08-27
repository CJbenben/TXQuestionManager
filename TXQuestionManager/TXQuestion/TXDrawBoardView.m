//
//  TXDrawBoardView.m
//  LYHM
//
//  Created by chenxiaojie on 2023/3/16.
//  Copyright © 2023 chenxiaojie. All rights reserved.
//

#import "TXDrawBoardView.h"

@implementation TXBezierPath

@end

@interface TXDrawBoardView ()
/// 记录新增画笔路径
@property (nonatomic, strong) NSMutableArray <TXBezierPath *> *addBeziPathAry;
/// 记录撤销画笔路径
@property (nonatomic, strong) NSMutableArray <TXBezierPath *> *revokeBeziPathAry;

@end

@implementation TXDrawBoardView

#pragma mark - Public Method
// 撤销
- (void)revokeAction {
    if(self.addBeziPathAry.count){
        [self.revokeBeziPathAry addObject:[self.addBeziPathAry lastObject]];
        [self.addBeziPathAry removeObjectAtIndex:self.addBeziPathAry.count-1];
        [self setNeedsDisplay];
    }
}

// 清空
- (void)removeAction {
    [self.addBeziPathAry removeAllObjects];
    [self setNeedsDisplay];
}

// 恢复
- (void)resumeAction {
    if (self.revokeBeziPathAry.count) {
        [self.addBeziPathAry addObject:[self.revokeBeziPathAry lastObject]];
        [self.revokeBeziPathAry removeLastObject];
        [self setNeedsDisplay];
    }
}

// 保存
- (void)saveAction {
    UIImage *currentImg = [self captureImageFromView:self];
    UIImageWriteToSavedPhotosAlbum(currentImg, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
}

#pragma mark - Private Method
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = @"保存失败";
    if (!error) {
        message = @"成功保存到相册";
    } else {
        message = [error description];
    }
    NSLog(@"message is %@",message);
}

- (UIImage *)captureImageFromView:(UIView *)view {
    CGRect screenRect = view.bounds;
    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.lineColor = [UIColor redColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.addBeziPathAry.count) {
        for (TXBezierPath *path in self.addBeziPathAry) {
            if (path.isErase) {
                [self.backgroundColor setStroke];
            } else {
                [path.lineColor setStroke];
            }
            path.lineCapStyle = kCGLineCapRound;
            path.lineJoinStyle = kCGLineCapRound;
            if (path.isErase) {
                path.lineWidth = 10;    //   这里可抽取出来枚举定义
                [path strokeWithBlendMode:kCGBlendModeDestinationIn alpha:1.0];
            } else {
                path.lineWidth = 3;
                [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
            }
            [path stroke];
        }
    }
    [super drawRect:rect];
}

#pragma mark - 画画
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 新增画笔时，移除所有撤销画笔
    if (self.revokeBeziPathAry.count) {
        [self.revokeBeziPathAry removeAllObjects];
    }
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    self.bezierPath = [[TXBezierPath alloc] init];
    self.bezierPath.lineColor = self.lineColor;
    self.bezierPath.isErase = self.isErase;
    [self.bezierPath moveToPoint:currentPoint];
    
    [self.addBeziPathAry addObject:self.bezierPath];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint previousPoint = [touch previousLocationInView:self];
    CGPoint midP = midpoint(previousPoint,currentPoint);
    [self.bezierPath addQuadCurveToPoint:currentPoint controlPoint:midP];
    [self setNeedsDisplay];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint previousPoint = [touch previousLocationInView:self];
    CGPoint midP = midpoint(previousPoint,currentPoint);
    [self.bezierPath addQuadCurveToPoint:currentPoint   controlPoint:midP];
    [self setNeedsDisplay];
}

static CGPoint midpoint(CGPoint p0, CGPoint p1) {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}

- (NSMutableArray<TXBezierPath *> *)addBeziPathAry {
    if(!_addBeziPathAry){
        _addBeziPathAry = [NSMutableArray array];
    }
    return _addBeziPathAry;
}

- (NSMutableArray<TXBezierPath *> *)revokeBeziPathAry {
    if(!_revokeBeziPathAry){
        _revokeBeziPathAry = [NSMutableArray array];
    }
    return _revokeBeziPathAry;
}

@end
