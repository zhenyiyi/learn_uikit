//
//  ViewController.m
//  UIKit
//
//  Created by fenglin on 2019/5/25.
//  Copyright © 2019 quanshi. All rights reserved.
//

#import "ViewController.h"
#import "TCActivityIndicatorView.h"
#import "TCSquareView.h"


@interface ViewController (){
    TCActivityIndicatorView *indicatorView;
    UIImageView *icon;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    indicatorView = [[TCActivityIndicatorView alloc] initWithActivityIndicatorStyle:TCActivityIndicatorViewStyleGray];
//    indicatorView.center = self.view.center;
//    [indicatorView startAnimating];
//    [self.view addSubview:indicatorView];
//
//    [self.view addSubview:[[TCSquareView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)]];
    
    UIImage *image = ActivityIndicatorViewFrameImage([UIColor redColor], 1, 12, 1);
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
    img.image = image;
    NSLog(@"img.transform=%@",NSStringFromCGAffineTransform(img.transform));
    [self.view addSubview:img];
//
//    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 80, 80)];
//    redView.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:redView];
//    NSLog(@"redView.transform=%@",NSStringFromCGAffineTransform(redView.transform)); // [1, 0, 0, 1, 0, 0]
    
    {
        UIImage *image = [UIImage imageNamed:@"icon@2x-80.png"];
        icon = [[UIImageView alloc] initWithFrame:CGRectMake(100, 400, 80, 80)];
        icon.image = image;
        NSLog(@"img.transform=%@",NSStringFromCGAffineTransform(icon.transform));
        [self.view addSubview:icon];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (indicatorView.isAnimating) {
        [indicatorView stopAnimating];
    }else{
        [indicatorView startAnimating];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGAffineTransform translation = CGAffineTransformMakeTranslation(100, 100);
        CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI);
        self->icon.transform = rotation;
    }];
}



@end
