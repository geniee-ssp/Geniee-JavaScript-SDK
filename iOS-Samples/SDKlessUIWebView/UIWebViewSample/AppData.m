#import "AppData.h"
@import AdSupport;
@import CoreTelephony;

// アプリの各種データを取得するクラスです。
@implementation AppData

// バンドルIDを取得
+ (NSString *)bundleId {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

// LAT (Limit Ad Tracking)広告追跡可否 を取得
+ (BOOL)canTracking {
    if (NSClassFromString(@"ASIdentifierManager")) {
        return [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    }
    return NO;
}

// IDFAを取得
+ (NSString *)idfa {
    if (NSClassFromString(@"ASIdentifierManager")) {
        return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    return @"";
}

// キャリアを取得
+ (NSString *)carrierCode {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    if (!carrier.mobileCountryCode) {
        return @"";
    }
    return [carrier.mobileCountryCode stringByAppendingString:carrier.mobileNetworkCode];
}

@end
