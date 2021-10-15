//
//  ConsoliMediation.h
//  ConsoliMediation
//
//  Created by FazalElahi on 19/10/2018.
//  Copyright © 2018 ConsoliAds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConsoliAdsMediationDelegate.h"
#import "CANativeAdRequestDelegate.h"
#import <UIKit/UIKit.h>
#import "CAMediatedBannerView.h"
#import "ConsoliAdsMediationIconAdDelegate.h"
#import "CAIconAdView.h"
#import "CAMediationConstants.h"

@interface ConsoliAdsMediation : NSObject

@property (nonatomic , retain) NSString * _Nonnull bundleVersion;
@property (nonatomic , retain) NSString * _Nonnull asMoreAppsURL;
@property (nonatomic , retain) NSString * _Nonnull asRateUsURL;
@property (nonatomic , retain) NSString * _Nonnull supportEmail;

+ (ConsoliAdsMediation*_Nonnull)sharedInstance ;

- (void)initialize:(BOOL)isDevMode boolUserConsent:(BOOL)userConsent viewController:(UIViewController *_Nullable)viewControler userSignature:(NSString*_Nullable)userSignature;
- (void)loadInterstitial;
- (void)showInterstitial:(PlaceholderName)placeholderName viewController:(UIViewController*_Nonnull)viewController;
- (void)showInterstitial:(UIViewController*_Nonnull)viewController;
- (void)showRewardedVideo:(PlaceholderName)placeholderName viewController:(UIViewController* _Nonnull)viewController;
- (void)showRewardedVideo:(UIViewController* _Nonnull)viewController;
- (void)hideAllAds;
- (void)loadRewarded;
- (BOOL)isInterstitialAvailable;
- (BOOL)isInterstitialAvailable:(PlaceholderName)placeholderName;
- (BOOL)isRewardedVideoAvailable;
- (BOOL)isRewardedVideoAvailable:(PlaceholderName)placeholderName;
- (void)setDelegate:(id<ConsoliAdsMediationDelegate>_Nonnull)delegate;
- (void)setInterstitialAdDelegate:(id<ConsoliAdsMediationInterstitialAdDelegate>_Nonnull)delegate;
- (void)setRewardedAdDelegate:(id<ConsoliAdsMediationRewardedAdDelegate>_Nonnull)delegate;
- (void)addAdmobTestDevice:(NSString *_Nonnull)deviceId;
- (void)loadNativeAdInViewController:(UIViewController *_Nonnull)viewController
                         placeholder:(PlaceholderName)placeholderName
                            delegate:(id<CANativeAdRequestDelegate>_Nonnull)delegate;

- (void)loadNativeAdInViewController:(UIViewController *_Nonnull)viewController
                            delegate:(id<CANativeAdRequestDelegate>_Nonnull)delegate;

- (void)showBanner:(PlaceholderName)placeholderName bannerView:(CAMediatedBannerView*_Nonnull)bannerView viewController:(UIViewController*_Nullable)viewController;

- (void)showBanner:(CAMediatedBannerView*_Nonnull)bannerView viewController:(UIViewController*_Nullable)viewController;

- (void)showIconAd:(PlaceholderName)placeholderName iconAdView:(CAIconAdView*_Nonnull)iconAdView delegate:(id<ConsoliAdsMediationIconAdDelegate>_Nonnull)delegate;

- (void)showIconAd:(CAIconAdView*_Nonnull)iconAdView delegate:(id<ConsoliAdsMediationIconAdDelegate>_Nonnull)delegate;

- (void)setInAppAdDelegate:(id<ConsoliAdsMediationInAppDelegate>_Nonnull)delegate;

- (void)loadInterstitial:(PlaceholderName)placeholderName;

- (void)loadRewarded:(PlaceholderName)placeholderName;

@end
