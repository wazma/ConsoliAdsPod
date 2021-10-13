//
//  ConsoliAdsNativeAdAdapter.h
//  ConsoliAdsMediation_Sample
//
//  Created by FazalElahi on 12/09/2019.
//  Copyright © 2019 ConsoliAds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CANativeAdRenderingDelegate.h"
#import "CANativeAdAssetsConstants.h"
#import "CANativeAdRequestDelegate.h"
#import "NativeAdBase.h"
#import "CAConstants.h"
#import "CAManager.h"

@interface ConsoliAdsNativeAdAdapter : NSObject

@property(nonatomic, strong) NSMutableDictionary *nativeAdAssets;

@property(nonatomic, strong) UIView<CANativeAdRenderingDelegate> *nativeAdView;

@property(nonatomic, strong) NativeAdBase *nativeAd;

@property (nonatomic, weak) id<CANativeAdRequestDelegate> delegate;

- (instancetype)initWithConsoliAdsNativeAd:(NativeAdBase *)caNativeAd;

- (void)renderUnifiedAdViewWithAdapter;

- (void)registerViewsForInteractionWithController:(UIViewController*)viewController;

- (void)resetView;

@end
