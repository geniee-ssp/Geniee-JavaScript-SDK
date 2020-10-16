#import <Foundation/Foundation.h>

@interface AppData : NSObject

+ (NSString *)bundleId;
+ (BOOL)canTracking;
+ (NSString *)idfa;
+ (NSString *)carrierCode;

+(void)checkIdfa;

@end
