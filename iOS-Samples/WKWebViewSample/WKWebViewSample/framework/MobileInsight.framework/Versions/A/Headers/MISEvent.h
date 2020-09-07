//
//  MISEvent.h
//  MobileInsight
//
//  Copyright (c) 2015年 yahoo-corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MISItem.h"
#import "MISCurrency.h"

/**
 * `share`eventの`contentID`で使われるENUM.
 */
typedef NS_ENUM(NSUInteger, MISEventContentType) {
    MISEventContentFacebook = 1,
    MISEventContentTwitter = 2,
    MISEventContentEvernote = 3,
    MISEventContentPocket = 4,
    MISEventContentMixi = 5,
    MISEventContentTumblr = 6,
    MISEventContentHatebu = 7,
    MISEventContentGooglePlus = 8,
    MISEventContentLine = 9,
    MISEventContentPinterest = 10,
    MISEventContentOthers = 99
};

@interface MISEvent : NSObject

/// --------------------------------------------------------------------------------------
/// @event
/// --------------------------------------------------------------------------------------

/**
 * `start session`.
 * アプリ起動時のイベント.
 *
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)startSessionEvent;

/**
 * `view product`.
 * 商品詳細画面を表示するイベント.
 *
 * @param currency `MISCurrency` object.
 * @param items `MISItem`の配列. 商品情報.
 * @param newCustomer 初回購入者であれば`YES`, そうでなければ`NO`.
 * @param inDate 開始日. YYYY-MM-DD形式.
 * @param outDate 終了日. YYYY-MM-DD形式.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)viewProductEventWithCurrency:(nullable MISCurrency *)currency
                                               items:(nullable NSArray<MISItem *> *)items
                                         newCustomer:(BOOL)newCustomer
                                              inDate:(nullable NSString *)inDate
                                             outDate:(nullable NSString *)outDate;

/**
 * `add cart`.
 * 商品をカートに追加した時のイベント.
 *
 * @param currency `MISCurrency` obect.
 * @param items `MISItem`の配列. 商品情報.
 * @param newCustomer 初回購入者であれば`YES`, そうでなければ`NO`.
 * @param inDate 開始日. YYYY-MM-DD形式.
 * @param outDate 終了日. YYYY-MM-DD形式.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)addCartEventWithCurrency:(nullable MISCurrency *)currency
                                           items:(nullable NSArray<MISItem *> *)items
                                     newCustomer:(BOOL)newCustomer
                                          inDate:(nullable NSString *)inDate
                                         outDate:(nullable NSString *)outDate;

/**
 * `view basket`.
 * カートリストを閲覧した時のイベント.
 *
 * @param currency `MISCurrency` object.
 * @param items `MISItem`の配列. 商品情報.
 * @param newCustomer 初回購入者であれば`YES`, そうでなければ`NO`.
 * @param inDate 開始日. YYYY-MM-DD形式.
 * @param outDate 終了日. YYYY-MM-DD形式.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)viewBasketEventWithCurrency:(nullable MISCurrency *)currency
                                              items:(nullable NSArray<MISItem *> *)items
                                        newCustomer:(BOOL)newCustomer
                                             inDate:(nullable NSString *)inDate
                                            outDate:(nullable NSString *)outDate;

/**
 * `checkout`.
 * 商品購入確認時のイベント.
 *
 * @param currency `MISCurrency` object.
 * @param items `MISItem`の配列. 商品情報.
 * @param newCustomer 初回購入者であれば`YES`, そうでなければ`NO`.
 * @param inDate 開始日. YYYY-MM-DD形式.
 * @param outDate 終了日. YYYY-MM-DD形式.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)checkOutEventWithCurrency:(nullable MISCurrency *)currency
                                            items:(nullable NSArray<MISItem *> *)items
                                      newCustomer:(BOOL)newCustomer
                                           inDate:(nullable NSString *)inDate
                                          outDate:(nullable NSString *)outDate;

/**
 * `purchase`.
 * 商品購入時のイベント.
 *
 * @param currency `MISCurrency` object.
 * @param items `MISItem`の配列. 商品情報.
 * @param orderID 注文番号.
 * @param newCustomer 初回購入者であれば`YES`, そうでなければ`NO`.
 * @param inDate 開始日. YYYY-MM-DD形式.
 * @param outDate 終了日. YYYY-MM-DD形式.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)purchaseEventWithCurrency:(nonnull MISCurrency *)currency
                                            items:(nonnull NSArray<MISItem *> *)items
                                          orderID:(nullable NSString *)orderID
                                      newCustomer:(BOOL)newCustomer
                                           inDate:(nullable NSString *)inDate
                                          outDate:(nullable NSString *)outDate;

/**
 * `payment info`.
 * 支払い明細画面を表示するイベント.
 *
 * @param currency `MISCurrency` object.
 * @param items `MISItem`の配列. 商品情報.
 * @param newCustomer 初回購入者であれば`YES`, そうでなければ`NO`.
 * @param inDate 開始日. YYYY-MM-DD形式.
 * @param outDate 終了日. YYYY-MM-DD形式.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)paymentInfoEventWithCurrency:(nullable MISCurrency *)currency
                                               items:(nullable NSArray<MISItem *> *)items
                                         newCustomer:(BOOL)newCustomer
                                              inDate:(nullable NSString *)inDate
                                             outDate:(nullable NSString *)outDate;

/**
 * `add favorite`.
 * お気に入り追加時のイベント.
 *
 * @param currency `MISCurrency` object.
 * @param items `MISItem`の配列. 商品情報.
 * @param newCustomer 初回購入者であれば`YES`, そうでなければ`NO`.
 * @param inDate 開始日. YYYY-MM-DD形式.
 * @param outDate 終了日. YYYY-MM-DD形式.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)addFavoriteEventWithCurrency:(nullable MISCurrency *)currency
                                               items:(nullable NSArray<MISItem *> *)items
                                         newCustomer:(BOOL)newCustomer
                                              inDate:(nullable NSString *)inDate
                                             outDate:(nullable NSString *)outDate;

/**
 * `search`.
 * 検索時のイベント.
 *
 * @param query 検索ワード.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)searchEventWithQuery:(nullable NSString *)query;

/**
 * `share`.
 * シェア時のイベント.
 *
 * @param method メソッド名.
 * @param contentName シェアしたコンテンツ名.
 * @param contentType どんなアクションか.
 * @param contentID シェアで利用したアプリ. `MISEventContentType`のENUM値.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)shareEventWithMethod:(nullable NSString *)method
                                 contentName:(nullable NSString *)contentName
                                 contentType:(nullable NSString *)contentType
                                   contentID:(MISEventContentType)contentID;

/**
 * `review`.
 * レビュー時のイベント.
 *
 * @param rate レビュー数.
 * @param contentName レビューしたコンテンツ名.
 * @param contentType どんなアクションか.
 * @param contentID 識別子.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)reviewEventWithRate:(NSUInteger)rate
                                contentName:(nullable NSString *)contentName
                                contentType:(nullable NSString *)contentType
                                  contentID:(nullable NSString *)contentID;

/**
 * `sign up`.
 * サインアップ時のイベント.
 *
 * @param method メソッド名.
 * @param success 成功なら`YES`、失敗なら`NO`.
 * @param status ユーザのステータス.
 * @return `MISEvent` object.
 *
 */
+ (nonnull instancetype)signUpEventWithMethod:(nullable NSString *)method
                                      success:(BOOL)success
                                       status:(nullable NSString *)status;

/**
 * `login`.
 * ログイン時のイベント.
 *
 * @param method メソッド名.
 * @param success 成功なら`YES`、失敗なら`NO`.
 * @param status ユーザのステータス.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)loginEventWithMethod:(nullable NSString *)method
                                     success:(BOOL)success
                                      status:(nullable NSString *)status;

/**
 * `invite`.
 * 招待時のイベント.
 *
 * @param method メソッド名.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)inviteEventWithMethod:(nullable NSString *)method;

/**
 * `start level`.
 * ゲームイベントのスタート時のイベント.
 *
 * @param event イベント名.
 * @param level スタート時のレベル.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)startLevelEventWithEvent:(nullable NSString *)event
                                           level:(NSUInteger)level;

/**
 * `end level`.
 * ゲームイベントのエンド時のイベント.
 *
 * @param event イベント名.
 * @param achievement エンド時のレベル.
 * @param success 成功なら`YES`、失敗なら`NO`.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)endLevelEventWithEvent:(nullable NSString *)event
                                   achievement:(NSUInteger)achievement
                                       success:(BOOL)success;

/**
 * `tutorial`.
 * チュートリアルのイベント.
 *
 * @param contentID 識別子.
 * @param success 成功なら`YES`、失敗なら`NO`.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)tutorialEventWithContentID:(nullable NSString *)contentID
                                           success:(BOOL)success;

/**
 * `deeplink`.
 * ディープリンク流入のイベント.
 * `application:openURL:options:`からの起動測定イベント.
 *
 * @param scheme URLスキーム.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)deeplinkEventWithURLScheme:(nullable NSString *)scheme;

/**
 * `custom1`.
 * 任意のカスタムイベント1.
 *
 * @param value1 任意の値1.
 * @param value2 任意の値2.
 * @param value3 任意の値3.
 * @param value4 任意の値4.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)customEvent1WithValue1:(nullable NSString *)value1
                                        value2:(nullable NSString *)value2
                                        value3:(nullable NSString *)value3
                                        value4:(nullable NSString *)value4;

/**
 * `custom2`.
 * 任意のカスタムイベント2.
 *
 * @param value1 任意の値1.
 * @param value2 任意の値2.
 * @param value3 任意の値3.
 * @param value4 任意の値4.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)customEvent2WithValue1:(nullable NSString *)value1
                                        value2:(nullable NSString *)value2
                                        value3:(nullable NSString *)value3
                                        value4:(nullable NSString *)value4;

/**
 * `custom3`.
 * 任意のカスタムイベント3.
 *
 * @param value1 任意の値1.
 * @param value2 任意の値2.
 * @param value3 任意の値3.
 * @param value4 任意の値4.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)customEvent3WithValue1:(nullable NSString *)value1
                                        value2:(nullable NSString *)value2
                                        value3:(nullable NSString *)value3
                                        value4:(nullable NSString *)value4;

/**
 * `reservation`.
 * 予約完了時のイベント.
 *
 * @param currency `MISCurrency` object.
 * @param items `MISItem`の配列. 商品情報.
 * @param orderID 注文番号.
 * @param newCustomer 初回購入者であれば`YES`, そうでなければ`NO`.
 * @param inDate 開始日. YYYY-MM-DD形式.
 * @param outDate 終了日. YYYY-MM-DD形式.
 * @return `MISEvent` object.
 */
+ (nonnull instancetype)reservationEventWithCurrency:(nonnull MISCurrency *)currency
                                               items:(nonnull NSArray<MISItem *> *)items
                                             orderID:(nullable NSString *)orderID
                                         newCustomer:(BOOL)newCustomer
                                              inDate:(nullable NSString *)inDate
                                             outDate:(nullable NSString *)outDate;
@end
