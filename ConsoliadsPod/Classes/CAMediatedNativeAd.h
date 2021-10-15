//
//  CAMediatedNativeAd.h
//  ConsoliMediation
//
//  Created by FazalElahi on 05/09/2019.
//  Copyright © 2019 ConsoliAds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CANativeAdRenderingDelegate.h"

NS_ASSUME_NONNULL_BEGIN


@interface CAMediatedNativeAd : NSObject

@property (strong, nonatomic, nullable) NSString *title;
@property (strong, nonatomic, nullable) NSString *subtitle;
@property (strong, nonatomic, nullable) NSString *caption;
@property (strong, nonatomic, nullable) NSString *callToAction;
@property (strong, nonatomic, nullable) NSString *socialContext;
@property (strong, nonatomic, nullable) NSString *sponsoredText;
@property (strong, nonatomic, nullable) NSString *body;
@property (strong, nonatomic, nullable) NSString *store;
@property (strong, nonatomic, nullable) NSString *price;
@property (strong, nonatomic, nullable) UIView *iconView;
@property (strong, nonatomic, nullable) NSDecimalNumber *starRating;
@property (strong, nonatomic, nullable) NSString *advertiser;
@property (strong, nonatomic, nullable) UIView *mediaView;
@property (readonly, nonatomic, nonnull) NSString *placementTag;

@property (nonatomic , weak) id nativeAd;


- (void)registerViewForInteractionWithNativeAdView:(UIView<CANativeAdRenderingDelegate>*)nativeAdView;
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
