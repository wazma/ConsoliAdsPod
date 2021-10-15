//
//  NativeAdBase.h
//  ConsoliAd
//
//  Created by rehmanaslam on 11/12/2018.
//  Copyright © 2018 FazalElahi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAAdChoicesView.h"
#import "CANativeAdMediaView.h"

@interface NativeAdBase: NSObject

@property(nonatomic, readonly, copy, nullable) NSString *nativeAdSubtitle;
@property(nonatomic, readonly, copy, nullable) NSString *nativeAdTitle;
@property(nonatomic, readonly, copy, nullable) NSString *nativeAdDescription;
@property(nonatomic, readonly, copy, nullable) NSString *callToActionButtonTitle;

- (void)registerViewForInteraction:(nonnull UIView *)adView
                         mediaView:(nonnull CANativeAdMediaView *)mediaView
                     adChoicesView:(nonnull CAAdChoicesView *)adChoicesView
                      adActionView:(nonnull UIView *)adActionView
                    viewController:(nullable UIViewController *)viewController;
@end

@interface NativeAdView : UIView

@property (nonatomic, strong, nonnull) NativeAdBase* nativeAd;
@property (nonatomic, strong, nonnull) IBOutlet CANativeAdMediaView *nativeAdMediaView;
@property (nonatomic, strong, nonnull) IBOutlet UIButton *callToAction;
@property (nonatomic, strong, nonnull) IBOutlet UILabel *nativeAdTitle;
@property (nonatomic, strong, nonnull) IBOutlet UILabel *nativeAdSubtitle;
@property (nonatomic, strong, nonnull) IBOutlet UILabel *nativeAdDescription;
@property (nonatomic, strong, nonnull) IBOutlet CAAdChoicesView *adChoices;

@end
