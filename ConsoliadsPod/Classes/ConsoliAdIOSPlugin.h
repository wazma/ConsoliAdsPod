//
//  ConsoliAdIOSPlugin.h
//  ConsoliAds
//
//  Created by FazalElahi on 06/02/2017.
//  Copyright © 2017 FazalElahi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ConsoliSDKAdsDelegate.h"
#import "ConsoliAdsBannerTypes.h"
#import "NativeAdBase.h"
#import "ConsoliAdsIconAdSizes.h"
#import "IconAdDelegate.h"
#import "BannerAdDelegate.h"
#import "CAIconAdView.h"

@interface ConsoliAdIOSPlugin : NSObject

+ (instancetype)sharedPlugIn;

- (BOOL)initWithKey:(NSString*)appKey andDelegate:(id<ConsoliSDKAdsDelegate>)adelegate userConsent:(BOOL)consent devMode:(BOOL)isDevMode;

- (BOOL)showInterstitial:(NSString*)scene withRootViewController:(UIViewController *)viewController;

- (void)showIconAd:(NSString*)scene iconAdView:(CAIconAdView*)iconAdView withAdSize:(CAIconAdSize)adSize delegate:(id<IconAdDelegate>)delegate;

- (void)loadInterstitialForScene:(NSString*)scene;

- (void)requestRewardedVideoAdForScene:(NSString*)scene;

- (BOOL)isRewardedVideoAvailable:(NSString*)scene;

- (BOOL)isInterstitialLoaded:(NSString*)scene;

- (BOOL)showRewardedVideoAdForScene:(NSString*)scene withRootViewController:(UIViewController*)viewController;

- (NativeAdBase*)showNative:(NSString*)scene;

- (BOOL)showBanner:(NSString*)scene withUIView:(UIView *)view withAdSize:(CABannerAdSize)adSize withAdPosition:(CAAdPosition)adPosition andDelegate:(id<BannerAdDelegate>)bannerDelegate;

- (void)hideBannerFromView:(UIView *)view;

@end
