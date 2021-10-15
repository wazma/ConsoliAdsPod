//
//  IconAdView.h
//  ConsoliAd
//
//  Created by rehmanaslam on 14/12/2018.
//  Copyright © 2018 FazalElahi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ConsoliAdsIconAdSizes.h"
#import "IconAdDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class IconAd;
@class ConsoliAdSDK;

@interface IconAdView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *iconAdImageView;

- (instancetype)initWithAd:(IconAd*)ad delegate:(id<IconAdDelegate>)delegate;
- (void)setAnimationType:(CAIconAnimationTypes)animationType animationDuration:(BOOL)isInfinite;
- (void)destroyIconAd;

@end

NS_ASSUME_NONNULL_END
