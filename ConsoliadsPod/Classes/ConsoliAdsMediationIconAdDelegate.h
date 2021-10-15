//
//  ConsoliAdsMediationIconAdDelegate.h
//  ConsoliAdsMediation
//
//  Created by saira on 18/12/2019.
//  Copyright © 2019 ConsoliAds. All rights reserved.
//


@protocol ConsoliAdsMediationIconAdDelegate <NSObject>

-(void) onIconAdShownEvent;
-(void) onIconAdFailedToShownEvent;
-(void) onIconAdRefreshEvent;
-(void) onIconAdClosedEvent;
-(void) onIconAdClickEvent;

@end
