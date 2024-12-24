//
//  DCSubsSelect.h
//  HJControls
//
//  Created by mac on 2022/10/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCSubsSelect : UIView

/*
 * 标题Lab的展示/隐藏；默认YES 展示
 */
@property (nonatomic, assign) BOOL showLabel;


/*
 * 标题Lab的内容
 */
@property (nonatomic, strong) NSString *label;


/*
 * 输入框提示文案; 默认:Please select
 */
@property (nonatomic, strong) NSString *placeholder;


/*
 * isRequired是否必填；默认Yes
 */
@property (nonatomic, assign) BOOL isRequired;


/*
 * isDisable是否禁用；默认No
 */
@property (nonatomic, assign) BOOL isDisable;



//获取输入框的内容
- (NSString *)getInputValue;

//赋值输入框的内容
- (void)setInputValue:(NSString *)text;

//清空输入框的内容
- (void)cleanInputValue;

@end

NS_ASSUME_NONNULL_END
