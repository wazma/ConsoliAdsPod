//
//  ConsoliAdsMediationDelegate.h
//  ConsoliAdsMediation
//
//  Created by FazalElahi on 26/10/2018.
//  Copyright © 2018 ConsoliAds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAMediationConstants.h"
#import "CAInAppDetails.h"
#import "CAInAppError.h"

@protocol ConsoliAdsMediationDelegate <NSObject>

@optional
- (void)onConsoliAdsInitializationSuccess:(BOOL)status;
- (void)onErrorGetFromEngine;
- (void)onSyncUserDeviceCompleted:(NSString *)response;

@end

@protocol ConsoliAdsMediationInterstitialAdDelegate <NSObject>

@optional

- (void)onInterstitialAdLoaded:(PlaceholderName)placeholderName;
- (void)onInterstitialAdFailToLoad:(PlaceholderName)placeholderName;
- (void)onInterstitialAdShown:(PlaceholderName)placeholderName;
- (void)onInterstitialAdClicked;
- (void)onInterstitialAdClosed:(PlaceholderName)placeholderName;
- (void)onInterstitialAdFailedToShow:(PlaceholderName)placeholderName;

@end

@protocol ConsoliAdsMediationRewardedAdDelegate <NSObject>

@optional
- (void)onRewardedVideoAdLoaded:(PlaceholderName)placeholderName;
- (void)onRewardedVideoAdFailToLoad:(PlaceholderName)placeholderName;
- (void)onRewardedVideoAdShown:(PlaceholderName)placeholderName;
- (void)onRewardedVideoAdCompleted:(PlaceholderName)placeholderName;
- (void)onRewardedVideoAdClicked;
- (void)onRewardedVideoAdFailToShow:(PlaceholderName)placeholderName;
- (void)onRewardedVideoAdClosed:(PlaceholderName)placeholderName;

@end

@protocol ConsoliAdsMediationInAppDelegate <NSObject>

@optional

- (void)onInAppPurchaseFailed:(CAInAppError*)error;
- (void)onInAppPurchaseSuccess:(CAInAppDetails*)product;
- (void)onInAppPurchaseRestored:(CAInAppDetails*)product;

@end

/*
@protocol ConsoliAdsMediationStaticInterstitialAdDelegate <NSObject>

@optional

- (void)onStaticInterstitialAdLoaded;
- (void)onStaticInterstitialAdShown:(PlaceholderName)placeholderName;
- (void)onStaticInterstitialAdClicked;
- (void)onStaticInterstitialAdClosed;
- (void)onStaticInterstitialAdFailToLoad;
- (void)onStaticInterstitialAdFailedToShow:(PlaceholderName)placeholderName;

@end
*/
