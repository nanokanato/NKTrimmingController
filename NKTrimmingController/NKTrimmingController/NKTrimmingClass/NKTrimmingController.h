//
//  NKTrimmingController.h
//  NKTrimmingController
//
//  Created by nanoka____ on 2015/06/24.
//  Copyright (c) 2015年 nanoka____. All rights reserved.
//
//  画像をトリミングするUIViewControllerのカスタムクラスです。
//  ・UINavigationConrollerにpushして使用する場合
//      pushViewController:で画像選択後のページとして遷移します。
//      トリミングページ下部の「OK」とヘッダーの「Cancel」はdelegateから受け取れます。
//      「OK」の時はトリミング後の画像と自身が送られますのでdismissViewControllerAnimated:で閉じてください。
//      「Cansel」の時は自身を送られますのでdismissViewControllerAnimated:で閉じてください。
//
//  ・UIViewControllerにModalとして使用する場合
//      presentViewController:でモーダルとして遷移します。
//      トリミングページ下部の「OK」と「Cancel」はdelegateから受け取れます。
//      「OK」の時はトリミング後の画像と自身が送られますのでdismissViewControllerAnimated:で閉じてください。
//      「Cansel」の時は自身を送られますのでdismissViewControllerAnimated:で閉じてください。
//
//  ・その他設定項目
//    ・インスタンスの生成
//        initWithImage:delegate:でインスタンスを生成できます。
//        引数のimageでトリミングする画像を指定、delegateでdelegateを指定してください。
//        標準のinitの使用は禁止しています。
//    ・トリミングに使用するボタン
//        トリミングに使用する丸ボタンの設定ができます。
//        __CIRCLE_DRAW_WIDTHが描画サイズ。__CIRCLE_TOUCH_WIDTHがタッチ可能領域サイズです。
//    ・トリミングの最小サイズ、最小比率指定
//        __TRIMMING_MIN_WIDTHで画面サイズ上の最低サイズを指定できます。__CIRCLE_DRAW_WIDTHの分を考慮しないと移動ができなくなったりします。
//        __TRIMMING_MIN_RATIO_WIDTHが最小比率の横サイズ、__TRIMMING_MIN_RATIO_HEIGHTが最小比率の縦サイズです。
//        4:3を最小比率にしたい場合、__TRIMMING_MIN_RATIO_WIDTH = 4;__TRIMMING_MIN_RATIO_HEIGHT = 3;で指定してください。
//        4:3で指定した場合、3:4でも制限されます。
//

#define __CIRCLE_DRAW_WIDTH  30
#define __CIRCLE_TOUCH_WIDTH 44
#define __TRIMMING_MIN_WIDTH 70
#define __TRIMMING_MIN_RATIO_WIDTH  [UIScreen mainScreen].bounds.size.width
#define __TRIMMING_MIN_RATIO_HEIGHT [UIScreen mainScreen].bounds.size.height

#import <UIKit/UIKit.h>
@class NKTrimmingController;

@protocol NKTrimmingControllerDelegate <NSObject>
@optional
-(void)trimmingController:(NKTrimmingController *)trimming didFinishTrimmingImage:(UIImage *)image;
-(void)trimmingControllerDidCancel:(NKTrimmingController *)trimming;
@end

@interface NKTrimmingController : UIViewController
-(instancetype)initWithImage:(UIImage *)image delegate:(id <NKTrimmingControllerDelegate>)delegate;

//initでのインスタンスの生成を禁止する
-(instancetype)init __attribute__((unavailable("init is not available")));
@end
