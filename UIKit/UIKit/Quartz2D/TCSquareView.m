//
//  TCSquareView.m
//  UIKit
//
//  Created by fenglin on 2019/5/25.
//  Copyright © 2019 quanshi. All rights reserved.
//

#import "TCSquareView.h"
#import <QuartzCore/QuartzCore.h>


@implementation TCSquareView

//                                      [UIColor redColor], 1, 12, 1
UIImage *ActivityIndicatorViewFrameImage( UIColor *toothColor, NSInteger frame, NSInteger numberOfFrames, CGFloat scale)
{
    const CGSize frameSize = CGSizeMake(37,37);
    const CGFloat radius = frameSize.width / 2.f;
    const CGFloat TWOPI = M_PI * 2.f;
    const CGFloat numberOfTeeth = 12; // 12 瓣
    const CGFloat toothWidth = 3.5 ;
    
    if (!toothColor) {
        toothColor = [UIColor grayColor];
    }
    /*
     * 参数一: 指定将来创建出来的bitmap的大小
     * 参数二: A Boolean flag indicating whether the bitmap is opaqu
     * 参数三: The scale factor to apply to the bitmap.
     */
    UIGraphicsBeginImageContextWithOptions(frameSize, NO, scale);
    // 返回当前图形上下文
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    // 返回当前转换矩阵
    CGAffineTransform transform1 = CGContextGetCTM(c);
    NSLog(@"transform1-> %@",NSStringFromCGAffineTransform(transform1));
    
    // 更改上下文中用户坐标系统的原点。 坐标系平移
    // first put the origin in the center of the frame. this makes things easier later
    CGContextTranslateCTM(c, radius, radius);
    
    CGAffineTransform transform2 = CGContextGetCTM(c);
    NSLog(@"transform2-> %@",NSStringFromCGAffineTransform(transform2));
    
    // now rotate the entire thing depending which frame we're trying to generate
    // 在上下文中旋转用户坐标系统。
    CGContextRotateCTM(c, frame / (CGFloat)numberOfFrames * TWOPI);
    
    // draw all the teeth
    for (NSInteger toothNumber=0; toothNumber<6; toothNumber++) {
        // set the correct color for the tooth, dividing by more than the number of teeth to prevent the last tooth from being too translucent
        const CGFloat alpha = 0.3 + ((toothNumber / numberOfTeeth) * 0.7);
        [[toothColor colorWithAlphaComponent:alpha] setFill];
        
        // position and draw the tooth
        CGContextRotateCTM(c, 1 / numberOfTeeth * TWOPI);
        [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(-toothWidth/2.f,-radius,toothWidth,ceilf(radius*.54f)) cornerRadius:toothWidth/2.f] fill];
        
       
    }
    
    // hooray!
    UIImage *frameImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return frameImage;
}

- (void)drawRect:(CGRect)rect {
    
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 1);
    
    //获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //矩阵操作
    //注意点：设置矩阵操作必须要在添加绘图信息之前
    //旋转45度
    CGContextRotateCTM(ctx, M_PI_4);
    
      //绘图
    CGContextAddRect(ctx, CGRectMake(0, 0, 100, 100));
    //渲染
    CGContextStrokePath(ctx);
    
}


@end
