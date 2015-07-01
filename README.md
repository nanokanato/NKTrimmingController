NKTrimmingController
=============
http://nanoka.wpcloud.net  

機能
-----
画像をトリミングするUIViewControllerのカスタムクラスです。

○トリミング後に取得できるもの  
`トリミングクラス自身(NKTrimmingController)` `トリミングした画像(UIImage)`  
  
○トリミングに必要なもの  
`トリミングする画像(UIImage)`  

使用方法
-----
トリミング機能を呼び出したいクラスでヘッダーを登録  
```
#import  "NKTrimmingController.h"
```
  
initWithImage:delegate:メソッドでインスタンスを生成します。  
この時delegateに設定したNKTrimmingControllerDelegateからトリミングページの「OK」と「Cancel」を受け取れます。  
「OK」の時はクラス自身とトリミング後の画像を、「Cancel」の時はクラス自身を返します。  
```
    NKTrimmingController *oTrimmingController = [[NKTrimmingController alloc] initWithImage:トリミングする画像 delegate:self];
```
  
あとは生成したoTrimmingControllerをUINavigationControllerクラスのpushViewController:メソッドで追加したり、UIViewControllerクラスのpresentViewController:でモーダルとして表示してください。