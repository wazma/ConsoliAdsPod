//
//  CAMediationConstants.h
//  ConsoliAdsMediation
//
//

#ifndef CAMediationConstants_h
#define CAMediationConstants_h

typedef enum : NSUInteger {
    MainMenu = 1,
    SelectionScene = 2,
    FinalScene = 3,
    OnSuccess = 4,
    OnFailure = 5,
    OnPause = 6,
    StoreScene = 7,
    Gameplay = 8,
    MidScene1 = 9,
    MidScene2 = 10,
    MidScene3 = 11,
    AppExit = 12,
    LoadingScene1 = 13,
    LoadingScene2 = 14,
    onReward = 15,
    SmartoScene = 16,
    Activity1 = 17,
    Activity2 = 18,
    Activity3 = 19,
    Activity4 = 20,
    Activity5 = 21,
    OptionA = 22,
    OptionB = 23,
    OptionC = 24,
    Settings = 25,
    About = 26,
    Default = 27    
}PlaceholderName;

typedef enum : NSInteger {
    
    Banner = 1,             //320x50
    MediumRectangle = 2,    //300x100
    IABBanner = 3,          //468x60
    Leaderboard = 4,        //728x90
    SmartBanner = 5,        //screenwidth
    LargeBanner = 6         //320x100
    
}BannerSize;


#endif /* CAMediationConstants_h */
