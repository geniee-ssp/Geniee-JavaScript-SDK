#import <Foundation/Foundation.h>

@interface AppData : NSObject

+ (NSString *)bundleId;
+ (BOOL)canTracking;
+ (NSString *)idfa;
+ (NSString *)carrierCode;

@end
