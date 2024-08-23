//
//  DCMacroHeader.h
//  DITOApp
//
//  Created by 孙全民 on 2022/7/21.
//


// 其他
#define DC_stringFormat(s, ...)     [NSString stringWithFormat:(s),##__VA_ARGS__]

/* HTTP */
#define DC_HTTP_Data                (DC_isNull([res objectForKey:@"data"])?@"":[res objectForKey:@"data"])
#define DC_HTTP_Code                (DC_isNull([res objectForKey:@"code"])?@"":[res objectForKey:@"code"])
#define DC_HTTP_ResultMsg           (DC_isNull([res objectForKey:@"resultMsg"])?@"":[res objectForKey:@"resultMsg"])
#define DC_HTTP_Success             @"200"

#define DC_image(x)                [UIImage imageNamed:x]
// 字体
#define DC_systemFont(size)         [UIFont systemFontOfSize:size]

//颜色
#define DC_UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define DC_RGBA(r,g,b,a)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define DC_RGB(r,g,b)               [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]


//是否为空或是[NSNull null]  非空 return YES
#define kNotNil(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]) && ![_ref isEqual: @""] && ![_ref isEqual: @"<null>"] && ![_ref isEqual: @"(null)"])
#define DC_IsArrEmpty(_ref) (((_ref) == nil) || ([(_ref) isKindOfClass:[NSNull class]]) ||([(_ref) count] == 0))
#define DC_NSSTRING_NOT_NIL(_ref) (((_ref) == nil) || ([(_ref) isKindOfClass:[NSNull class]])) ? @"" : _ref
#define DC_IsStrEmpty(_ref) (((_ref) == nil) || ([(_ref) isKindOfClass:[NSNull class]]) ||([(_ref)isEqualToString:@""]) || ([(_ref) length] == 0))
#define DC_isNull(x)                (!x || [x isKindOfClass:[NSNull class]])

#pragma mark - GCD线程相关

#define GCD_ONCE(block)   static dispatch_once_t onceToken; dispatch_once(&onceToken, block);
#define GCD_GLOBAL(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
#define GCD_MAIN(block)   if([[NSThread currentThread] isMainThread]){block();}else{dispatch_async(dispatch_get_main_queue(),block);}
#define GCD_DELAY(sec,block)  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), block);

//设置圆角
#define DCViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

// View 圆角和加边框
#define VIEW_BORDER_RADIUS(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//view 添加 左右上角圆角
#define ViewBottomLeftAndRightRadius(p_View_Container,Radius)\
{\
UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:p_View_Container.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(Radius,Radius)];\
CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];\
maskLayer.frame = p_View_Container.bounds;\
maskLayer.path = maskPath.CGPath;\
p_View_Container.layer.mask = maskLayer;\
}

#define ViewTopLeftAndRightRadius(p_View_Container,Radius)\
{\
UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:p_View_Container.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(Radius,Radius)];\
CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];\
maskLayer.frame = p_View_Container.bounds;\
maskLayer.path = maskPath.CGPath;\
p_View_Container.layer.mask = maskLayer;\
}


//字体
#define FONT_Regular(x)  [UIFont systemFont(14);:@"PingFangSC-Regular" size:x]
#define FONT_Medium(x)  [UIFont fontWithName:@"PingFangSC-Medium" size:x]
#define FONT_S(x)       [UIFont systemFontOfSize:x]

//颜色
#define DC_HEXCOLOR(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define DC_HEXCOLORALPHA(rgbValue,_alpha)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:_alpha]


#pragma mark - 坐标
#define DC_DCP_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define DC_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define DC_SCREEN_BOUNDS   [UIScreen mainScreen].bounds
/**导航栏高度*/
#define DC_NAV_HEIGHT (DC_SCREEN_HEIGHT >= 812.0 ? 88 : 64)
/**状态栏高度*/
#define DC_STATUS_HEIGHT (DC_SCREEN_HEIGHT >= 812.0 ? 44 : 20)
/**安全区高度*/
#define DC_BOTTOM_SAFE (DC_SCREEN_HEIGHT >= 812.0 ? 34 : 0)
/**tabbar高度*/
#define DC_TABBAR_HEIGHT (DC_SCREEN_HEIGHT >= 812.0 ? 49+34 : 49)

#define DC_NAVIGATION_TOPVIEW_HEIGHT          44.0f


//安全区域高度
#define DC_Safe_Area_Hegiht (DC_SCREEN_HEIGHT>736 ? 34 : 0)

// iPhone X系列适配
//#define iPhoneX_XS        [DCDeviceUtils isIPhoneXorXS]
//#define iPhoneXR_XSMax    [DCDeviceUtils isIPhoneXRorXSMAX]
//#define iPhoneX_Series    [DCDeviceUtils isIPhoneXseries]
//#define iPhoneX           iPhoneX_Series
// 非安全区高度，暂不考虑横屏
#define SAFE_INSETS_TOP       (iPhoneX_Series ? 44 : 20)
#define SAFE_INSETS_BOTTOM    (iPhoneX_Series ? 34 : 0)

// iPhoneX
#define Is_iPhoneX_Or_More ([UIScreen mainScreen].bounds.size.height >= 812)
#define STATUS_BAR_HEIGHT       (Is_iPhoneX_Or_More ? 44.f : 20.f)

// 有效高度，iPhoneX会去除无效的状态栏高度24和tabbar高度34
#define SAFE_SCREEN_H         (iPhoneX_Series ? SCREEN_HEIGHT : SCREEN_HEIGHT-58)

//界面比例适配，按照不同的设备计算高度，字体大小
#define ADAPT_W(v)                         (DC_DCP_SCREEN_WIDTH*(v)/375.0f)
#define ADAPT_H(v)                         ((iPhoneX_Series ? (iPhoneXR_XSMax?736:667) : DC_SCREEN_HEIGHT)*(v)/667.0f)

//底部安全区高度
#define kBottomSafeAreaHeight \
({\
CGFloat heigt = 0;\
UIWindow *window = [UIApplication sharedApplication].keyWindow;\
if (@available(iOS 11.0, *)) {\
heigt = window.safeAreaInsets.bottom;\
}\
(heigt);\
})\
