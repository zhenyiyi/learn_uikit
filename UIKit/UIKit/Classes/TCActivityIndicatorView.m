//
//  TCActivityIndicatorView.m
//  UIKit
//
//  Created by fenglin on 2019/5/25.
//  Copyright © 2019 quanshi. All rights reserved.
//

#import "TCActivityIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

static CGSize TCActivityIndicatorViewStyleSize(TCActivityIndicatorViewStyle style)
{
    if (style == TCActivityIndicatorViewStyleWhiteLarge) {
        return CGSizeMake(37,37);
    } else {
        return CGSizeMake(20,20);
    }
}

static UIImage *UIActivityIndicatorViewFrameImage(TCActivityIndicatorViewStyle style, UIColor *toothColor, NSInteger frame, NSInteger numberOfFrames, CGFloat scale)
{
    const CGSize frameSize = TCActivityIndicatorViewStyleSize(style);
    const CGFloat radius = frameSize.width / 2.f;
    const CGFloat TWOPI = M_PI * 2.f;
    const CGFloat numberOfTeeth = 12; // 12 瓣
    const CGFloat toothWidth = (style == UIActivityIndicatorViewStyleWhiteLarge)? 3.5 : 2;
    
    if (!toothColor) {
        toothColor = (style == UIActivityIndicatorViewStyleGray)? [UIColor grayColor] : [UIColor whiteColor];
    }
    /*
     * 参数一: 指定将来创建出来的bitmap的大小
     * 参数二: A Boolean flag indicating whether the bitmap is opaqu
     * 参数三: The scale factor to apply to the bitmap.
     */
    UIGraphicsBeginImageContextWithOptions(frameSize, NO, scale);
    // 返回当前图形上下文
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    // 更改上下文中用户坐标系统的原点。 坐标系平移
    // first put the origin in the center of the frame. this makes things easier later
    CGContextTranslateCTM(c, radius, radius);
    
    // now rotate the entire thing depending which frame we're trying to generate
    // 在上下文中旋转用户坐标系统。
    CGContextRotateCTM(c, frame / (CGFloat)numberOfFrames * TWOPI);
    
    // draw all the teeth
    for (NSInteger toothNumber=0; toothNumber<numberOfTeeth; toothNumber++) {
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

@implementation TCActivityIndicatorView {
    BOOL _animating;
    TCActivityIndicatorViewStyle _activityIndicatorViewStyle;
    BOOL _hidesWhenStopped;
}

- (id)initWithActivityIndicatorStyle:(TCActivityIndicatorViewStyle)style
{
    CGRect frame = CGRectZero;
    frame.size = TCActivityIndicatorViewStyleSize(style);
    
    if ((self=[super initWithFrame:frame])) {
        _animating = NO;
        self.activityIndicatorViewStyle = style;
        self.hidesWhenStopped = YES;
        self.opaque = NO;
        self.contentMode = UIViewContentModeCenter;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [self initWithActivityIndicatorStyle:TCActivityIndicatorViewStyleWhite])) {
        self.frame = frame;
    }
    
    return self;
}

- (CGSize)sizeThatFits:(CGSize)aSize
{
    return TCActivityIndicatorViewStyleSize(self.activityIndicatorViewStyle);
}

- (void)setActivityIndicatorViewStyle:(TCActivityIndicatorViewStyle)style
{
    @synchronized (self) {
        if (_activityIndicatorViewStyle != style) {
            _activityIndicatorViewStyle = style;
            [self setNeedsDisplay];
            
            if (_animating) {
                [self startAnimating];    // this will reset the images in the animation if it was already animating
            }
        }
    }
}

- (TCActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    @synchronized (self) {
        return _activityIndicatorViewStyle;
    }
}

- (void)setHidesWhenStopped:(BOOL)hides
{
    @synchronized (self) {
        _hidesWhenStopped = hides;
        
        if (_hidesWhenStopped) {
            self.hidden = !_animating;
        } else {
            self.hidden = NO;
        }
    }
}

- (BOOL)hidesWhenStopped
{
    @synchronized (self) {
        return _hidesWhenStopped;
    }
}

- (void)_startAnimation
{
    @synchronized (self) {
        const NSInteger numberOfFrames = 12;
        const CFTimeInterval animationDuration = 0.8;
        
        NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:numberOfFrames];
        
        for (NSInteger frameNumber=0; frameNumber<numberOfFrames; frameNumber++) {
            [images addObject:(__bridge id)UIActivityIndicatorViewFrameImage(_activityIndicatorViewStyle, self.color, frameNumber, numberOfFrames, self.contentScaleFactor).CGImage];
        }
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        animation.calculationMode = kCAAnimationDiscrete;
        animation.duration = animationDuration;
        animation.repeatCount = HUGE_VALF;
        animation.values = images;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeBoth;
        
        [self.layer addAnimation:animation forKey:@"contents"];
    }
}

- (void)_stopAnimation
{
    @synchronized (self) {
        [self.layer removeAnimationForKey:@"contents"];
        
        self.layer.contents = (id)UIActivityIndicatorViewFrameImage(self.activityIndicatorViewStyle, self.color, 0, 1, self.contentScaleFactor).CGImage;
        
        if (self.hidesWhenStopped) {
            self.hidden = YES;
        }
    }
}

- (void)startAnimating
{
    @synchronized (self) {
        _animating = YES;
        self.hidden = NO;
        [self performSelectorOnMainThread:@selector(_startAnimation) withObject:nil waitUntilDone:NO];
    }
}

- (void)stopAnimating
{
    @synchronized (self) {
        _animating = NO;
        [self performSelectorOnMainThread:@selector(_stopAnimation) withObject:nil waitUntilDone:NO];
    }
}

- (BOOL)isAnimating
{
    @synchronized (self) {
        return _animating;
    }
}

- (void)didMoveToWindow
{
    if (!self.isAnimating) {
        [self _stopAnimation];  // resets the contents to the first frame if needed
    }
}

@end

