//
//  MISItem.h
//  MobileInsight
//
//  Copyright © 2015年 yahoo-corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MISItem : NSObject

/**
 * `MISItem` インスタンスを生成する.
 *
 * @param itemID 商品の識別子.
 * @param quantity 商品の量.
 * @param price 商品の金額.
 * @return `MISItem object.`
 */
+ (nonnull instancetype)itemWithItemID:(nullable NSString *)itemID
                              quantity:(NSUInteger)quantity
                                 price:(CGFloat)price;

@end
