//
//  TCActivityIndicatorView.h
//  UIKit
//
//  Created by fenglin on 2019/5/25.
//  Copyright © 2019 quanshi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TCActivityIndicatorViewStyle) {
    TCActivityIndicatorViewStyleWhiteLarge,
    TCActivityIndicatorViewStyleWhite,
    TCActivityIndicatorViewStyleGray,
};

@interface TCActivityIndicatorView : UIView

- (id)initWithActivityIndicatorStyle:(TCActivityIndicatorViewStyle)style;
- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;


@property BOOL hidesWhenStopped;
@property TCActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (readwrite, nonatomic, retain) UIColor *color;
@end

NS_ASSUME_NONNULL_END
