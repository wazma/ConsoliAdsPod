//
//  CAInAppProduct.h
//  ConsoliAd
//
//  Created by saira on 18/12/2020.
//  Copyright © 2020 FazalElahi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAInAppDetails : NSObject

typedef enum : NSUInteger {
    
    KCAInterstitialAd,
    KCAVideoAd,
    KCARewardedAd,
    KCABannerAd,
    KCAConsoliAdsIconAd,
    KCANative,

} CAAdType;



@property(nonatomic) NSString *localizedDescription API_AVAILABLE(ios(3.0), macos(10.7), watchos(6.2));

@property(nonatomic) NSString *localizedTitle API_AVAILABLE(ios(3.0), macos(10.7), watchos(6.2));

@property(nonatomic) NSDecimalNumber *price API_AVAILABLE(ios(3.0), macos(10.7), watchos(6.2));

@property(nonatomic) NSLocale *priceLocale API_AVAILABLE(ios(3.0), macos(10.7), watchos(6.2));

@property(nonatomic) NSString *productIdentifier API_AVAILABLE(ios(3.0), macos(10.7), watchos(6.2));

@property (nonatomic) CAAdType adType;

@end

NS_ASSUME_NONNULL_END
