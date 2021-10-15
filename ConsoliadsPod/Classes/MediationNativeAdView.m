//
//  MediationNativeAdView.m
//  UnitySample
//
//  Created by FazalElahi on 23/09/2019.
//  Copyright © 2019 ConsoliAds. All rights reserved.
//

#import "MediationNativeAdView.h"

@implementation MediationNativeAdView

- (UILabel *)nativeBodyTextLabel
{
    return self.adBodyLabel;
}

- (UILabel *)nativeTitleTextLabel
{
    return self.adTitleLabel;
}

- (UILabel *)nativeAdvertiserTextLabel
{
    return self.sponsoredLabel;
}

- (UIButton *)nativeCallToActionButton
{
    return self.adCallToActionButton;
}

- (UIView *)nativePrivacyInformationIconImageView
{
    return self.adOptionsView;
}

- (UIImageView *)nativeIconImageView
{
    return self.adIconView;
}

- (UIView *)nativeVideoView {
    return self.adCoverMediaView;
}

- (NSLayoutConstraint*)iconAdWidthConstraint {
    return _iconAdWidthConstraint;
}

@end
