//
//  MediationNativeAdView.h
//  UnitySample
//
//  Created by FazalElahi on 23/09/2019.
//  Copyright © 2019 ConsoliAds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CANativeAdRenderingDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MediationNativeAdView : UIView <CANativeAdRenderingDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *adIconView;
@property (strong, nonatomic) IBOutlet UIView *adCoverMediaView;
@property (strong, nonatomic) IBOutlet UILabel *adTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *adBodyLabel;
@property (strong, nonatomic) IBOutlet UIButton *adCallToActionButton;
@property (strong, nonatomic) IBOutlet UILabel *adSocialContextLabel;
@property (strong, nonatomic) IBOutlet UILabel *sponsoredLabel;
@property (strong, nonatomic) IBOutlet UIView *adOptionsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconAdWidthConstraint;

@end

NS_ASSUME_NONNULL_END
