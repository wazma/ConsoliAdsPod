//
//  BannerAdDelegate.h
//  ConsoliAd
//
//  Created by rehmanaslam on 12/11/2018.
//  Copyright © 2018 FazalElahi. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import <UIKit/UIKit.h>
//#import "BannerAdDelegate.h"
//#import "BannerAdView.h"

@protocol BannerAdDelegate <NSObject>

- (void) bannerAdShown:(NSString *)scene;
- (void) bannerAdRefreshed:(NSString *)scene;
- (void) bannerAdShownFailed:(NSString *)scene error:(NSString *)error;
- (void) bannerAdClicked:(NSString *)scene;
- (void) bannerAdClosed:(NSString *)scene;

@end


