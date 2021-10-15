//
//  CAmediatedBannerView.h
//  ConsoliMediation
//
//  Created by saira on 24/10/2019.
//  Copyright © 2019 ConsoliAds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "CAMediationConstants.h"

@protocol CAMediatedBannerAdViewDelegate;

@interface CAMediatedBannerView : UIView

@property (nonatomic , readonly) CGSize customSize;

@property (nonatomic, weak) id<CAMediatedBannerAdViewDelegate> delegate;

- (void)setCustomBannerSize:(CGSize)size;
- (void)destroyBanner;

@end

@protocol CAMediatedBannerAdViewDelegate <NSObject>

@optional

- (void)onBannerAdLoaded:(CAMediatedBannerView*)bannerView;

- (void)onBannerAdLoadFailed:(CAMediatedBannerView*)bannerView;

- (void)onBannerAdClicked;

- (void)onBannerAdRefreshEvent;

@end

