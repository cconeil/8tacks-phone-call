//
//  PlaceholderView.h
//  Tag
//
//  Created by Chris O'Neil on 12/28/13.
//  Copyright (c) 2013 Arbrr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PlaceholderView.h"

@interface PlaceholderView : UIView

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) CGFloat borderWidth;

@end
