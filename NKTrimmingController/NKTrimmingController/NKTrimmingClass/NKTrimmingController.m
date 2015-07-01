//
//  NKTrimmingController.m
//  NKTrimmingController
//
//  Created by nanoka____ on 2015/06/24.
//  Copyright (c) 2015年 nanoka____. All rights reserved.
//

#import "NKTrimmingController.h"

/*========================================================
 ; NKTrimmingController
 ========================================================*/
@implementation NKTrimmingController{
    UILabel *titleLabel;
    UIButton *closeButton;
    UIImage *originImage;
    UIImageView *moFooterView;
    UIImageView *oTrimmingView;
    UIView *squareView;
    UIView *squareTop;
    UIView *squareButtom;
    UIView *squareLeft;
    UIView *squareRight;
    UIImageView *topCircle;
    UIImageView *buttomCircle;
    UIImageView *leftCircle;
    UIImageView *rightCircle;
    UIView *whiteTop;
    UIView *whiteButtom;
    UIView *whiteLeft;
    UIView *whiteRight;
    id <NKTrimmingControllerDelegate> delegate;
}

/*--------------------------------------------------------
 ; dealloc : 解放
 ;      in :
 ;     out :
 --------------------------------------------------------*/
-(void)dealloc
{
    titleLabel = nil;
    closeButton = nil;
    moFooterView = nil;
    oTrimmingView = nil;
    squareView = nil;
    squareTop = nil;
    squareButtom = nil;
    squareLeft = nil;
    squareRight = nil;
    topCircle = nil;
    buttomCircle = nil;
    leftCircle = nil;
    rightCircle = nil;
    whiteTop = nil;
    whiteButtom = nil;
    whiteLeft = nil;
    whiteRight = nil;
    delegate = nil;
}

/*--------------------------------------------------------
 ; initWithImage : インスタンスの生成
 ;            in : (UIImage *)image
 ;               : (id <NKTrimmingControllerDelegate>)delegate
 ;           out : (instancetype)self
 --------------------------------------------------------*/
-(instancetype)initWithImage:(UIImage *)image delegate:(id <NKTrimmingControllerDelegate>)_delegate
{
    self = [super init];
    if(self){
        originImage = image;
        delegate = _delegate;
        self.title = @"Trimming";
    }
    return self;
}

/*--------------------------------------------------------
 ; viewDidLoad : 初回Viewが読み込まれた時
 ;          in :
 ;         out :
 --------------------------------------------------------*/
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.multipleTouchEnabled = NO;
    self.view.userInteractionEnabled = YES;
    
    //トリミング画像
    float margin = 20;
    float maxHeight;
    if(self.navigationController){
        maxHeight = self.view.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height-self.navigationController.navigationBar.frame.size.height-margin-margin-44;
    }else{
        maxHeight = self.view.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height-margin-margin-44;
    }
    float maxWidth = self.view.frame.size.width-margin*2;
    float trimHeight = (maxWidth*originImage.size.height)/originImage.size.width;
    float trimWidth = maxWidth;
    if(trimHeight > maxHeight){
        trimHeight = maxHeight;
        trimWidth = (trimHeight*originImage.size.width)/originImage.size.height;
    }
    float trimX = margin+(maxWidth-trimWidth)/2;
    float trimY;
    if(self.navigationController){
        trimY = [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.frame.size.height+margin+(maxHeight-trimHeight)/2;
    }else{
        trimY = [UIApplication sharedApplication].statusBarFrame.size.height+margin+(maxHeight-trimHeight)/2;
    }
    oTrimmingView = [[UIImageView alloc] initWithFrame:CGRectMake(trimX, trimY, trimWidth, trimHeight)];
    oTrimmingView.image = originImage;
    [self.view addSubview:oTrimmingView];
    
    //トリミング領域
    squareView = [[UIView alloc] init];
    squareView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    squareView.layer.borderWidth = 1.0;
    [self.view addSubview:squareView];
    //左上
    CGPoint center = oTrimmingView.center;
    float width = oTrimmingView.frame.size.width;
    float height = oTrimmingView.frame.size.height;
    //比率
    if(width > height/__TRIMMING_MIN_RATIO_WIDTH*__TRIMMING_MIN_RATIO_HEIGHT){
        width = height/__TRIMMING_MIN_RATIO_WIDTH*__TRIMMING_MIN_RATIO_HEIGHT;
    }
    if(height > width/__TRIMMING_MIN_RATIO_WIDTH*__TRIMMING_MIN_RATIO_HEIGHT){
        height = width/__TRIMMING_MIN_RATIO_WIDTH*__TRIMMING_MIN_RATIO_HEIGHT;
    }
    //最大サイズ
    if(width > oTrimmingView.frame.size.width){
        width = oTrimmingView.frame.size.width;
    }
    if(height > oTrimmingView.frame.size.height){
        height = oTrimmingView.frame.size.height;
    }
    //最小サイズ
    if(width < __CIRCLE_TOUCH_WIDTH*2+5){
        width = __CIRCLE_TOUCH_WIDTH*2+5;
    }
    if(height < __CIRCLE_TOUCH_WIDTH*2+5){
        height = __CIRCLE_TOUCH_WIDTH*2+5;
    }
    //開始点
    float x = center.x-width/2;
    float y = center.y-height/2;
    //はみ出ないよう調整
    if(x < oTrimmingView.frame.origin.x){
        x = oTrimmingView.frame.origin.x;
    }
    if(y < oTrimmingView.frame.origin.y){
        y = oTrimmingView.frame.origin.y;
    }
    if(x+width > oTrimmingView.frame.origin.x+oTrimmingView.frame.size.width){
        width = oTrimmingView.frame.origin.x+oTrimmingView.frame.size.width-x;
    }
    if(y+height > oTrimmingView.frame.origin.y+oTrimmingView.frame.size.height){
        height = oTrimmingView.frame.origin.y+oTrimmingView.frame.size.height-y;
    }
    squareView.frame = CGRectMake(x, y, width, height);
    
    //白いView設置
    whiteTop = [[UIView alloc] init];
    whiteTop.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    whiteTop.userInteractionEnabled = NO;
    [self.view addSubview:whiteTop];
    whiteButtom = [[UIView alloc] init];
    whiteButtom.backgroundColor = whiteTop.backgroundColor;
    whiteButtom.userInteractionEnabled = NO;
    [self.view addSubview:whiteButtom];
    whiteLeft = [[UIView alloc] init];
    whiteLeft.backgroundColor = whiteTop.backgroundColor;
    whiteLeft.userInteractionEnabled = NO;
    [self.view addSubview:whiteLeft];
    whiteRight = [[UIView alloc] init];
    whiteRight.backgroundColor = whiteTop.backgroundColor;
    whiteRight.userInteractionEnabled = NO;
    [self.view addSubview:whiteRight];
    
    //領域上
    squareTop = [[UIView alloc] initWithFrame:CGRectMake(squareView.frame.origin.x+(squareView.frame.size.width-__CIRCLE_TOUCH_WIDTH)/2,
                                                         squareView.frame.origin.y-__CIRCLE_TOUCH_WIDTH/2,
                                                         __CIRCLE_TOUCH_WIDTH,
                                                         __CIRCLE_TOUCH_WIDTH)];
    squareTop.backgroundColor = [UIColor clearColor];
    squareTop.layer.cornerRadius = __CIRCLE_TOUCH_WIDTH/2;
    [self.view addSubview:squareTop];
    topCircle = [[UIImageView alloc] initWithFrame:CGRectMake((squareTop.frame.size.width-__CIRCLE_DRAW_WIDTH)/2,
                                                              (squareTop.frame.size.height-__CIRCLE_DRAW_WIDTH)/2,
                                                              __CIRCLE_DRAW_WIDTH, __CIRCLE_DRAW_WIDTH)];
    topCircle.backgroundColor = [UIColor whiteColor];
    topCircle.layer.borderColor = [UIColor darkGrayColor].CGColor;
    topCircle.layer.borderWidth = 1.0;
    topCircle.layer.cornerRadius = __CIRCLE_DRAW_WIDTH/2;
    [squareTop addSubview:topCircle];
    
    //領域下
    squareButtom = [[UIView alloc] initWithFrame:CGRectMake(squareView.frame.origin.x+(squareView.frame.size.width-__CIRCLE_TOUCH_WIDTH)/2,
                                                            squareView.frame.origin.y+squareView.frame.size.height-__CIRCLE_TOUCH_WIDTH/2,
                                                            __CIRCLE_TOUCH_WIDTH,
                                                            __CIRCLE_TOUCH_WIDTH)];
    squareButtom.backgroundColor = [UIColor clearColor];
    [self.view addSubview:squareButtom];
    buttomCircle = [[UIImageView alloc] initWithFrame:CGRectMake((squareButtom.frame.size.width-__CIRCLE_DRAW_WIDTH)/2,
                                                                 (squareButtom.frame.size.height-__CIRCLE_DRAW_WIDTH)/2,
                                                                 __CIRCLE_DRAW_WIDTH,
                                                                 __CIRCLE_DRAW_WIDTH)];
    buttomCircle.backgroundColor = [UIColor whiteColor];
    buttomCircle.layer.borderColor = [UIColor darkGrayColor].CGColor;
    buttomCircle.layer.borderWidth = 1.0;
    buttomCircle.layer.cornerRadius = __CIRCLE_DRAW_WIDTH/2;
    [squareButtom addSubview:buttomCircle];
    
    //領域左
    squareLeft = [[UIView alloc] initWithFrame:CGRectMake(squareView.frame.origin.x-__CIRCLE_TOUCH_WIDTH/2,
                                                          squareView.frame.origin.y+(squareView.frame.size.height-__CIRCLE_TOUCH_WIDTH)/2,
                                                          __CIRCLE_TOUCH_WIDTH,
                                                          __CIRCLE_TOUCH_WIDTH)];
    squareLeft.backgroundColor = [UIColor clearColor];
    [self.view addSubview:squareLeft];
    leftCircle = [[UIImageView alloc] initWithFrame:CGRectMake((squareLeft.frame.size.width-__CIRCLE_DRAW_WIDTH)/2,
                                                               (squareLeft.frame.size.height-__CIRCLE_DRAW_WIDTH)/2,
                                                               __CIRCLE_DRAW_WIDTH,
                                                               __CIRCLE_DRAW_WIDTH)];
    leftCircle.backgroundColor = [UIColor whiteColor];
    leftCircle.layer.borderColor = [UIColor darkGrayColor].CGColor;
    leftCircle.layer.borderWidth = 1.0;
    leftCircle.layer.cornerRadius = __CIRCLE_DRAW_WIDTH/2;
    [squareLeft addSubview:leftCircle];
    
    //領域右
    squareRight = [[UIView alloc] initWithFrame:CGRectMake(squareView.frame.origin.x+squareView.frame.size.width-__CIRCLE_TOUCH_WIDTH/2,
                                                           squareView.frame.origin.y+(squareView.frame.size.height-__CIRCLE_TOUCH_WIDTH)/2,
                                                           __CIRCLE_TOUCH_WIDTH,
                                                           __CIRCLE_TOUCH_WIDTH)];
    squareRight.backgroundColor = [UIColor clearColor];
    [self.view addSubview:squareRight];
    rightCircle = [[UIImageView alloc] initWithFrame:CGRectMake((squareRight.frame.size.width-__CIRCLE_DRAW_WIDTH)/2,
                                                                (squareRight.frame.size.height-__CIRCLE_DRAW_WIDTH)/2,
                                                                __CIRCLE_DRAW_WIDTH,
                                                                __CIRCLE_DRAW_WIDTH)];
    rightCircle.backgroundColor = [UIColor whiteColor];
    rightCircle.layer.borderColor = [UIColor darkGrayColor].CGColor;
    rightCircle.layer.borderWidth = 1.0;
    rightCircle.layer.cornerRadius = __CIRCLE_DRAW_WIDTH/2;
    [squareRight addSubview:rightCircle];
    
    //白いView座標
    whiteTop.frame = CGRectMake(0, 0, self.view.frame.size.width, squareTop.frame.origin.y+squareTop.frame.size.height/2);
    whiteButtom.frame = CGRectMake(0, squareButtom.frame.origin.y+squareButtom.frame.size.height/2, self.view.frame.size.width,self.view.frame.size.height-(squareButtom.frame.origin.y+squareButtom.frame.size.height/2));
    whiteLeft.frame = CGRectMake(0, squareTop.frame.origin.y+squareTop.frame.size.height/2, squareLeft.frame.origin.x+squareLeft.frame.size.width/2, (squareButtom.frame.origin.y+squareButtom.frame.size.height/2)-(squareTop.frame.origin.y+squareTop.frame.size.height/2));
    whiteRight.frame = CGRectMake(squareRight.frame.origin.x+squareRight.frame.size.width/2, squareTop.frame.origin.y+squareTop.frame.size.height/2, self.view.frame.size.height-(squareRight.frame.origin.x+squareRight.frame.size.width/2), (squareButtom.frame.origin.y+squareButtom.frame.size.height/2)-(squareTop.frame.origin.y+squareTop.frame.size.height/2));
    
    //フッター
    moFooterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    moFooterView.userInteractionEnabled = YES;
    [self.view addSubview:moFooterView];
    
    //キャンセルボタン
    if(self.navigationController){
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(closeButtonTaped:)];
        [self.navigationItem setRightBarButtonItem:cancelButton animated:YES];
    }else{
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.exclusiveTouch = YES;
        cancelButton.frame = CGRectMake((moFooterView.frame.size.width/2-100)/2,
                                        (moFooterView.frame.size.height-44)/2,
                                        100, 44);
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(closeButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [moFooterView addSubview:cancelButton];
    }
    
    //選択ボタン
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.exclusiveTouch = YES;
    if(self.navigationController){
        selectButton.frame = CGRectMake((moFooterView.frame.size.width-100)/2,
                                        (moFooterView.frame.size.height-44)/2,
                                        100, 44);
    }else{
        selectButton.frame = CGRectMake(moFooterView.frame.size.width/2+(moFooterView.frame.size.width/2-100)/2,
                                        (moFooterView.frame.size.height-44)/2,
                                        100, 44);
    }
    [selectButton setTitle:@"OK" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(selectButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [moFooterView addSubview:selectButton];
}

/*--------------------------------------------------------
 ; touchesBegan : タッチ開始時
 ;           in : (NSSet *)touches
 ;              : (UIEvent *)event
 ;          out :
 --------------------------------------------------------*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([event touchesForView:squareTop]){
        //上
        topCircle.backgroundColor = [UIColor darkGrayColor];
    }else if([event touchesForView:squareButtom]){
        //下
        buttomCircle.backgroundColor = [UIColor darkGrayColor];
    }else if([event touchesForView:squareLeft]){
        //左
        leftCircle.backgroundColor = [UIColor darkGrayColor];
    }else if([event touchesForView:squareRight]){
        //右
        rightCircle.backgroundColor = [UIColor darkGrayColor];
    }
}

/*--------------------------------------------------------
 ; touchesMoved : タッチされたまま動いている時
 ;           in : (NSSet *)touches
 ;              : (UIEvent *)event
 ;          out :
 --------------------------------------------------------*/
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in touches){
        CGPoint move = [touch locationInView:self.view.superview];
        if([event touchesForView:squareView]){
            //中心
            float width = squareView.frame.size.width;
            float height = squareView.frame.size.height;
            float x = move.x-width/2;
            float y = move.y-height/2;

            //左上端座標
            if(x < oTrimmingView.frame.origin.x){
                x = oTrimmingView.frame.origin.x;
            }
            if(y < oTrimmingView.frame.origin.y){
                y = oTrimmingView.frame.origin.y;
            }
            //右下端座標
            if(x+width > oTrimmingView.frame.origin.x+oTrimmingView.frame.size.width){
                x = oTrimmingView.frame.origin.x+oTrimmingView.frame.size.width-width;
            }
            if(y+height > oTrimmingView.frame.origin.y+oTrimmingView.frame.size.height){
                y = oTrimmingView.frame.origin.y+oTrimmingView.frame.size.height-height;
            }
            squareView.frame = CGRectMake(x, y, width, height);
        }else{
            if([event touchesForView:squareTop]){
                //上
                float buttomY = squareView.frame.origin.y+squareView.frame.size.height;
                float x = squareView.frame.origin.x;
                float y = move.y;
                if(y < oTrimmingView.frame.origin.y){
                    //これ以上サイズを伸ばせない
                    y = oTrimmingView.frame.origin.y;
                }
                float width = squareView.frame.size.width;
                float height = buttomY-y;
                if(height < __TRIMMING_MIN_WIDTH){
                    //これ以上サイズを縮めれない
                    height = __TRIMMING_MIN_WIDTH;
                    y = buttomY-height;
                }
                if(height > (width*__TRIMMING_MIN_RATIO_HEIGHT)/__TRIMMING_MIN_RATIO_WIDTH){
                    //これ以上比率を伸ばせない
                    height = (width*__TRIMMING_MIN_RATIO_HEIGHT)/__TRIMMING_MIN_RATIO_WIDTH;
                    y = buttomY-height;
                }
                if(height < (width*__TRIMMING_MIN_RATIO_WIDTH)/__TRIMMING_MIN_RATIO_HEIGHT){
                    //これ以上比率を縮めれない
                    height = (width*__TRIMMING_MIN_RATIO_WIDTH)/__TRIMMING_MIN_RATIO_HEIGHT;
                    y = buttomY-height;
                }
                squareView.frame = CGRectMake(x, y, width, height);
            }else if([event touchesForView:squareButtom]){
                //下
                float x = squareView.frame.origin.x;
                float y = squareView.frame.origin.y;
                float width = squareView.frame.size.width;
                float height = move.y-y;
                if(y+height > oTrimmingView.frame.origin.y+oTrimmingView.frame.size.height){
                    //これ以上伸ばせない
                    height = oTrimmingView.frame.origin.y+oTrimmingView.frame.size.height-y;
                }
                if(height < __TRIMMING_MIN_WIDTH){
                    //これ以上縮めれない
                    height = __TRIMMING_MIN_WIDTH;
                }
                if(height > (width*__TRIMMING_MIN_RATIO_HEIGHT)/__TRIMMING_MIN_RATIO_WIDTH){
                    //これ以上比率を伸ばせない
                    height = (width*__TRIMMING_MIN_RATIO_HEIGHT)/__TRIMMING_MIN_RATIO_WIDTH;
                }
                if(height < (width*__TRIMMING_MIN_RATIO_WIDTH)/__TRIMMING_MIN_RATIO_HEIGHT){
                    //これ以上比率を縮めれない
                    height = (width*__TRIMMING_MIN_RATIO_WIDTH)/__TRIMMING_MIN_RATIO_HEIGHT;
                }
                squareView.frame = CGRectMake(x, y, width, height);
            }else if([event touchesForView:squareLeft]){
                //左
                float rightX = squareView.frame.origin.x+squareView.frame.size.width;
                float x = move.x;
                if(x < oTrimmingView.frame.origin.x){
                    //これ以上伸ばせない
                    x = oTrimmingView.frame.origin.x;
                }
                float y = squareView.frame.origin.y;
                float width = rightX-x;
                float height = squareView.frame.size.height;
                if(width < __TRIMMING_MIN_WIDTH){
                    //これ以上縮めれない
                    width = __TRIMMING_MIN_WIDTH;
                    x = rightX-width;
                }
                if(width > (height*__TRIMMING_MIN_RATIO_HEIGHT)/__TRIMMING_MIN_RATIO_WIDTH){
                    //これ以上比率を伸ばせない
                    width = (height*__TRIMMING_MIN_RATIO_HEIGHT)/__TRIMMING_MIN_RATIO_WIDTH;
                    x = rightX-width;
                }
                if(width < (height*__TRIMMING_MIN_RATIO_WIDTH)/__TRIMMING_MIN_RATIO_HEIGHT){
                    //これ以上比率を縮めれない
                    width = (height*__TRIMMING_MIN_RATIO_WIDTH)/__TRIMMING_MIN_RATIO_HEIGHT;
                    x = rightX-width;
                }
                squareView.frame = CGRectMake(x, y, width, height);
            }else if([event touchesForView:squareRight]){
                //右
                float x = squareView.frame.origin.x;
                float y = squareView.frame.origin.y;
                float width = move.x-x;
                float height = squareView.frame.size.height;
                if(x+width > oTrimmingView.frame.origin.x+oTrimmingView.frame.size.width){
                    //これ以上伸ばせない
                    width = oTrimmingView.frame.origin.x+oTrimmingView.frame.size.width-x;
                }
                if(width < __TRIMMING_MIN_WIDTH){
                    //これ以上縮めれない
                    width = __TRIMMING_MIN_WIDTH;
                }
                if(width > (height*__TRIMMING_MIN_RATIO_HEIGHT)/__TRIMMING_MIN_RATIO_WIDTH){
                    //これ以上比率を伸ばせない
                    width = (height*__TRIMMING_MIN_RATIO_HEIGHT)/__TRIMMING_MIN_RATIO_WIDTH;
                }
                if(width < (height*__TRIMMING_MIN_RATIO_WIDTH)/__TRIMMING_MIN_RATIO_HEIGHT){
                    //これ以上比率を縮めれない
                    width = (height*__TRIMMING_MIN_RATIO_WIDTH)/__TRIMMING_MIN_RATIO_HEIGHT;
                }
                squareView.frame = CGRectMake(x, y, width, height);
            }
        }
        //領域端座標
        squareTop.center = CGPointMake(squareView.frame.origin.x+squareView.frame.size.width/2, squareView.frame.origin.y);
        squareButtom.center = CGPointMake(squareView.frame.origin.x+squareView.frame.size.width/2, squareView.frame.origin.y+squareView.frame.size.height);
        squareLeft.center = CGPointMake(squareView.frame.origin.x, squareView.frame.origin.y+squareView.frame.size.height/2);
        squareRight.center = CGPointMake(squareView.frame.origin.x+squareView.frame.size.width, squareView.frame.origin.y+squareView.frame.size.height/2);
        whiteTop.frame = CGRectMake(0, 0, self.view.frame.size.width, squareTop.frame.origin.y+squareTop.frame.size.height/2);
        whiteButtom.frame = CGRectMake(0, squareButtom.frame.origin.y+squareButtom.frame.size.height/2, self.view.frame.size.width,self.view.frame.size.height-(squareButtom.frame.origin.y+squareButtom.frame.size.height/2));
        whiteLeft.frame = CGRectMake(0, squareTop.frame.origin.y+squareTop.frame.size.height/2, squareLeft.frame.origin.x+squareLeft.frame.size.width/2, (squareButtom.frame.origin.y+squareButtom.frame.size.height/2)-(squareTop.frame.origin.y+squareTop.frame.size.height/2));
        whiteRight.frame = CGRectMake(squareRight.frame.origin.x+squareRight.frame.size.width/2, squareTop.frame.origin.y+squareTop.frame.size.height/2, self.view.frame.size.height-(squareRight.frame.origin.x+squareRight.frame.size.width/2), (squareButtom.frame.origin.y+squareButtom.frame.size.height/2)-(squareTop.frame.origin.y+squareTop.frame.size.height/2));
        break;
    }
}

/*--------------------------------------------------------
 ; touchesEnded : タッチが終了された時
 ;           in : (NSSet *)touches
 ;              : (UIEvent *)event
 ;          out :
 --------------------------------------------------------*/
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    topCircle.backgroundColor = [UIColor whiteColor];
    buttomCircle.backgroundColor = [UIColor whiteColor];
    leftCircle.backgroundColor = [UIColor whiteColor];
    rightCircle.backgroundColor = [UIColor whiteColor];
}

/*--------------------------------------------------------
 ; touchesCancelled : タッチがキャンセルされた時
 ;               in : (NSSet *)touches
 ;                  : (UIEvent *)event
 ;              out :
 --------------------------------------------------------*/
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

/*--------------------------------------------------------
 ; closeButtonTaped : 閉じるボタンが押された
 ;               in : (id)sender
 ;              out :
 --------------------------------------------------------*/
-(void)closeButtonTaped:(id)sender
{
    [delegate trimmingControllerDidCancel:self];
}

/*--------------------------------------------------------
 ; selectButtonTaped : 選択ボタンが押された
 ;                in : (UIButton *)button
 ;               out :
 --------------------------------------------------------*/
-(void)selectButtonTaped:(UIButton *)button
{
    // 画像のクリッピング
    float imageScale = originImage.size.width/oTrimmingView.frame.size.width;
    CGRect scaledRect = CGRectMake((squareView.frame.origin.x-oTrimmingView.frame.origin.x)*imageScale*originImage.scale,
                                   (squareView.frame.origin.y-oTrimmingView.frame.origin.y)*imageScale*originImage.scale,
                                   squareView.frame.size.width*imageScale*originImage.scale,
                                   squareView.frame.size.height*imageScale*originImage.scale);
    CGImageRef clip = CGImageCreateWithImageInRect(originImage.CGImage,scaledRect);
    UIImage *clipedImage = [UIImage imageWithCGImage:clip
                                               scale:originImage.scale
                                         orientation:UIImageOrientationUp];
    CGImageRelease(clip);
    [delegate trimmingController:self didFinishTrimmingImage:clipedImage];
}

@end
