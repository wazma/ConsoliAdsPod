//
//  ConsoliAdsNativeAdAdapter.m
//  ConsoliAdsMediation_Sample
//
//  Created by FazalElahi on 12/09/2019.
//  Copyright © 2019 ConsoliAds. All rights reserved.
//

#import "ConsoliAdsNativeAdAdapter.h"
#import "ConsoliAdIOSPlugin.h"
#import "NativeAdBase.h"

@interface ConsoliAdsNativeAdAdapter() {
    CGFloat iconAdwidth;
}

@property (nonatomic, strong) CANativeAdMediaView *caMediaView;
@property (nonatomic, strong) CAAdChoicesView *caAdChoicesview;
@property (nonatomic, strong) UIImageView *appIconView;
@property (nonatomic, weak) UIButton *actionButton;
@property BOOL impressionCount;

@end

@interface UIView (MPGoogleAdMobAdditions)

/// Adds constraints to the receiver's superview that keep the receiver the same size and position
/// as the superview.
- (void)gad_TopRightInSuperview;

@end

@implementation ConsoliAdsNativeAdAdapter

- (instancetype)initWithConsoliAdsNativeAd:(NativeAdBase *)caNativeAd {
    
    if (self = [super init]) {
        
        _nativeAd = caNativeAd;
        iconAdwidth = 0;
        _caMediaView = [[CANativeAdMediaView alloc] initWithFrame:CGRectZero];
        _caAdChoicesview = [[CAAdChoicesView alloc] initWithFrame:CGRectZero];
        
        NSMutableDictionary *assets = [NSMutableDictionary dictionary];
        
        if (caNativeAd.nativeAdTitle) {
            assets[kCAMediationAdTitleKey] = caNativeAd.nativeAdTitle;
        }

        if (caNativeAd.nativeAdSubtitle) {
            assets[kCAGADMAdvertiserKey] = caNativeAd.nativeAdSubtitle;
        }

        if (caNativeAd.nativeAdDescription) {
            assets[kCAMediationAdTextKey] = caNativeAd.nativeAdDescription;
        }
        
        if (caNativeAd.callToActionButtonTitle) {
            assets[kCAMediationAdCTATextKey] = caNativeAd.callToActionButtonTitle;
        }
        
        _nativeAdAssets = assets;
    }
    
    return self;
}

- (void)renderUnifiedAdViewWithAdapter {
    
    if ([self.nativeAdView respondsToSelector:@selector(nativeBodyTextLabel)]) {
        self.nativeAdView.nativeBodyTextLabel.text = _nativeAdAssets[kCAMediationAdTextKey];
    }
    
    if ([self.nativeAdView respondsToSelector:@selector(nativeAdvertiserTextLabel)]) {
        self.nativeAdView.nativeAdvertiserTextLabel.text = _nativeAdAssets[kCAGADMAdvertiserKey];
    }
    
    if ([self.nativeAdView respondsToSelector:@selector(nativeTitleTextLabel)]) {
        self.nativeAdView.nativeTitleTextLabel.text = _nativeAdAssets[kCAMediationAdTitleKey];
    }
    
    if ([self.nativeAdView respondsToSelector:@selector(nativeCallToActionButton)] && self.nativeAdView.nativeCallToActionButton) {
        [self.nativeAdView.nativeCallToActionButton setTitle:_nativeAdAssets[kCAMediationAdCTATextKey] forState:UIControlStateNormal];
        [self.nativeAdView.nativeCallToActionButton setTitle:self.nativeAdView.nativeCallToActionButton.titleLabel.text forState:UIControlStateNormal];
        _actionButton = self.nativeAdView.nativeCallToActionButton;
    }
    
    if ([self.nativeAdView respondsToSelector:@selector(nativeIconImageView)]) {
        
        UIImageView *iconImageView = [self.nativeAdView nativeIconImageView];
        if (_nativeAdAssets[kCAMediationAdIconImageKey]) {
            iconImageView.image = _nativeAdAssets[kCAMediationAdIconImageKey];
        }
        else {
            iconImageView.image = nil;
        }
    }
    
    if ([self.nativeAdView respondsToSelector:@selector(nativePrivacyInformationIconImageView)]) {
        CAAdChoicesView *adOptionsView = _caAdChoicesview;
        adOptionsView.frame = self.nativeAdView.nativePrivacyInformationIconImageView.bounds;
        self.nativeAdView.nativePrivacyInformationIconImageView.userInteractionEnabled = YES;
        [self.nativeAdView.nativePrivacyInformationIconImageView addSubview:adOptionsView];
        self.nativeAdView.nativePrivacyInformationIconImageView.hidden = NO;
    }
    
    if ([self.nativeAdView respondsToSelector:@selector(nativeVideoView)]) {
        UIView *mediaView = _caMediaView;
        UIView *mainImageView = [self.nativeAdView nativeVideoView];
        
        mediaView.frame = mainImageView.bounds;
        mediaView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        mainImageView.userInteractionEnabled = YES;
        
        [mainImageView addSubview:mediaView];
    }
    
    if ([self.nativeAdView respondsToSelector:@selector(iconAdWidthConstraint)]) {
        iconAdwidth = self.nativeAdView.iconAdWidthConstraint.constant;
        self.nativeAdView.iconAdWidthConstraint.constant = 0;
    }
    
}

- (void)registerViewsForInteractionWithController:(UIViewController*)viewController {
    [self.nativeAd registerViewForInteraction:self.nativeAdView mediaView:_caMediaView adChoicesView:_caAdChoicesview adActionView:_actionButton viewController:viewController];
    
    if (!_impressionCount) {
        _impressionCount = true;
        if (self.nativeAd) {
            if ([_delegate respondsToSelector:@selector(onNativeAdShown)]) {
                [_delegate onNativeAdShown];
            }
        }
        else {
            if ([_delegate respondsToSelector:@selector(onNativeAdFailToShow)]) {
                [_delegate onNativeAdFailToShow];
            }
        }
    }
}

- (void)resetView {
    if ([self.nativeAdView respondsToSelector:@selector(iconAdWidthConstraint)]) {
        if (iconAdwidth != 0) {
            self.nativeAdView.iconAdWidthConstraint.constant = iconAdwidth;
        }
    }
}

@end

@implementation UIView (MPGoogleAdMobAdditions)

- (void)gad_TopRightInSuperview {
    UIView *superview = self.superview;
    if (!superview) {
        return;
    }
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1
                                                           constant:0]];
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
}

@end
