 //
//  PlaceholderView.m
//  Tag
//
//  Created by Chris O'Neil on 12/28/13.
//  Copyright (c) 2013 Arbrr. All rights reserved.
//

#import "PlaceholderView.h"



@interface PlaceholderView()

@property CGFloat radius;
@property (nonatomic, strong) CATextLayer *textLayer;

@end


@implementation PlaceholderView
@synthesize borderWidth, borderColor, text, textColor;

- (id)initWithFrame:(CGRect)frame {
    
    // NOTE: use a sqare size here.
    if (frame.size.height != frame.size.width) {
        [NSException raise:@"Not a square" format:@"The PlaceholderView must be a square"];
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        self.radius = self.frame.size.height / 2; // or we could have used width.
        [self style];
    }
    return self;
}

-(void)style {
    
    // defaults
    self.borderWidth = 2.0;
    self.borderColor = [UIColor lightBlueColor];
    self.textColor = [UIColor lightBlueColor];
    self.text = @"";
    
    // layer
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.cornerRadius = self.radius;
    
    // text layer
    float offset = self.layer.frame.size.height / 5;
    self.textLayer = [[CATextLayer alloc] init];
    self.textLayer.contentsScale = kContentScale;
    self.textLayer.frame = CGRectMake(0, offset, self.radius * 2, self.radius * 2 - offset);
    self.textLayer.string = self.text;
    self.textLayer.alignmentMode = kCAAlignmentCenter;
    self.textLayer.foregroundColor = self.textColor.CGColor;
    self.textLayer.fontSize = self.radius;
    
    [self.textLayer setFont:kFontHelveticaNeueThin];
    [self.layer addSublayer:self.textLayer];
}

#pragma mark Override Setter Methods
-(void)setBorderColor:(UIColor *)borderColor_ {
    self->borderColor = borderColor_;
    self.layer.borderColor = self.borderColor.CGColor;
}

-(void)setBorderWidth:(CGFloat)borderWidth_ {
    self->borderWidth = borderWidth_;
    self.layer.borderWidth = self.borderWidth;
}

-(void)setTextColor:(UIColor *)textColor_ {
    self->textColor = textColor_;
    self.textLayer.foregroundColor = self.textColor.CGColor;
}

-(void)setText:(NSString *)text_ {
    self->text = text_;
    self.textLayer.string = self.text;
}


@end
