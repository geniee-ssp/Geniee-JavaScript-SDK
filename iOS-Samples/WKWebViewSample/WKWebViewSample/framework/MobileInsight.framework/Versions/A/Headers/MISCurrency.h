//
//  MISCurrency.h
//  MobileInsight
//
//  Copyright (c) 2015年 yahoo-corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MISCurrency : NSObject

/// --------------------------------------------------------------------------------------
/// @Hard Currency
/// --------------------------------------------------------------------------------------

/**
* `JPY`レートがセットされた`MISCurrency`インスタンスを返す.
*
* @return `MISCurrency` object.
*/
+ (nonnull instancetype)JPY;

/**
 * `KRW`レートがセットされた`MISCurrency`インスタンスを返す.
 *
 * @return `MISCurrency` object.
 */
+ (nonnull instancetype)KRW;

/**
 * `CNY`レートがセットされた`MISCurrency`インスタンスを返す.
 *
 * @return `MISCurrency` object.
 */
+ (nonnull instancetype)CNY;

/**
 * `US`レートがセットされた`MISCurrency`インスタンスを返す.
 *
 * @return `MISCurrency` object.
 */
+ (nonnull instancetype)USD;

/**
 * `SGD`レートがセットされた`MISCurrency`インスタンスを返す.
 *
 * @return `MISCurrency` object.
 */
+ (nonnull instancetype)SGD;

/**
 * `IDR`レートがセットされた`MISCurrency`インスタンスを返す.
 *
 * @return `MISCurrency` object.
 */
+ (nonnull instancetype)IDR;

/**
 * `EUR`レートがセットされた`MISCurrency`インスタンスを返す.
 *
 * @return `MISCurrency` object.
 */
+ (nonnull instancetype)EUR;

/**
 * `GBP`レートがセットされた`MISCurrency`インスタンスを返す.
 *
 * @return `MISCurrency` object.
 */
+ (nonnull instancetype)GBP;

/**
 * 引数に入力された値でハードカレンシーの設定がされた`MISCurrency`インスタンスを返す.
 *
 * @param currency 通貨レートの文字列.
 * @return `MISCurrency` object.
 */
+ (nonnull instancetype)hardCurrency:(nonnull NSString *)currency;

/// --------------------------------------------------------------------------------------
/// @Soft Currency
/// --------------------------------------------------------------------------------------

/**
 * 引数に入力された値でソフトカレンシーの設定がされた`MISCurrency`インスタンスを返す.
 *
 * @param currency 仮想通貨の文字列.
 * @return `MISCurrency` object.
 */
+ (nonnull instancetype)softCurrency:(nonnull NSString *)currency;

@end
