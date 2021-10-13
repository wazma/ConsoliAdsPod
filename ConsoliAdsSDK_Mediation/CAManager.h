//
//  CAManager.h
//  ObjectiveC-AdNetworks
//
//  Created by rehmanaslam on 15/10/2018.
//  Copyright © 2018 rehmanaslam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdNetworkManager.h"
#import "CAMediationConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAManager : AdNetworkManager

+ (CAManager*)sharedManager ;
- (void)initializeWithAppKey:(NSString *)appKey consent:(BOOL)userConsent delegate:(id)delegate;
- (void)setRequestState:(PlaceholderName)placeholder networkName:(AdNetworkName)adNetworkName state:(RequestState)state;
+ (NSString*)getSdkVersion;
+ (NSDictionary*)getInAppVersion;

@end

NS_ASSUME_NONNULL_END
