#import "AppData.h"
@import AdSupport;
@import CoreTelephony;
#import <AppTrackingTransparency/AppTrackingTransparency.h>

// アプリの各種データを取得するクラスです。
@implementation AppData

// バンドルIDを取得
+ (NSString *)bundleId {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

// LAT (Limit Ad Tracking)広告追跡可否 を取得
+ (BOOL)canTracking {
    BOOL isTracking = NO;
    if (@available(iOS 14.0, *)) {
        NSString* idfa = [AppData idfa];
        if (idfa.length != 0 && ![idfa isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
            isTracking = YES;
        }
    } else if (NSClassFromString(@"ASIdentifierManager")) {
        isTracking = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    }
    return isTracking;
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
    CTCarrier *carrier = nil;
    // The CTTelephonyNetworkInfo.serviceSubscriberCellularProviders method crash because of an issue in iOS 12.0
    // It was fixed in iOS 12.1
    if (@available(iOS 12, *)) {
        NSDictionary<NSString *, CTCarrier *> *carriers = nil;
        if (@available(iOS 12.1, *)) {
            carriers = [networkInfo serviceSubscriberCellularProviders];
        } else {
            carriers = [networkInfo valueForKey:@"serviceSubscriberCellularProvider"];
        }
        if (carriers != nil) {
            for (NSString *key in carriers) {
                carrier = carriers[key];
            }
        }
    } else {
        carrier = [networkInfo subscriberCellularProvider];
    }

    NSString *codeInfo = @"";
    if (carrier != nil && carrier.mobileCountryCode != nil) {
        codeInfo = [carrier.mobileCountryCode stringByAppendingString:carrier.mobileNetworkCode];
    }
    return codeInfo;
}

/**
 * Tracking ID acquisition permission request.
 */
+ (void)checkIdfa {
    if (@available(iOS 14.0, *)) {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                    NSLog(@"checkIdfa: authorized");
                } else if (status == ATTrackingManagerAuthorizationStatusDenied) {
                    NSLog(@"checkIdfa: denied");
                } else {
                    NSLog(@"checkIdfa: something else");
                }
                dispatch_semaphore_signal(semaphore);
        }];
        // Wait until there is a reply.
        float INTERVAL_TIME = 0.01f;
        while(dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:INTERVAL_TIME]];
        }
    }
}

@end
