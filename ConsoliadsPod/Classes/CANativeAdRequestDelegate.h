//
//  CANativeAdRequestDelegate.h
//  ConsoliMediation
//
//  Created by FazalElahi on 05/09/2019.
//  Copyright © 2019 ConsoliAds. All rights reserved.
//

@class CAMediatedNativeAd;

@protocol CANativeAdRequestDelegate <NSObject>

@optional

- (void)onNativeAdLoaded:(CAMediatedNativeAd*)nativeAd;
- (void)onNativeAdLoadFailed;
- (void)onNativeAdClicked;
- (void)onNativeAdShown;
- (void)onNativeAdFailToShow;
@end
