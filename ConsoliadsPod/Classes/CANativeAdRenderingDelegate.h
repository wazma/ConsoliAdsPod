//
//  CANativeAdRenderingDelegate.h
//  ConsoliMediation
//
//  Created by FazalElahi on 12/09/2019.
//  Copyright © 2019 ConsoliAds. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CANativeAdRenderingDelegate <NSObject>

@optional

- (UILabel *)nativeTitleTextLabel;
- (UILabel *)nativeBodyTextLabel;
- (UILabel *)nativeAdvertiserTextLabel;
- (UIImageView *)nativeIconImageView;
- (UIView *)nativeVideoView;
- (UIButton *)nativeCallToActionButton;
- (UIView *)nativePrivacyInformationIconImageView;
- (NSLayoutConstraint*)iconAdWidthConstraint;

@end
