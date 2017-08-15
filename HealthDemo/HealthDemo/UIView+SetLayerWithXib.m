//
//  UIView+SetLayerWithXib.m
//  ZuiPaiDang
//
//  Created by fanghao on 16/1/25.
//  Copyright © 2016年 fanghao. All rights reserved.
//

#import "UIView+SetLayerWithXib.h"

@implementation UIView (SetLayerWithXib)
@dynamic borderColor,borderWidth,cornerRadius;
-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
}
@end
