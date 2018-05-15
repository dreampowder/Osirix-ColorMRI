//
//  AspectFillImageView.m
//  ColorMRI
//
//  Created by Serdar Coskun on 23/03/2018.
//

#import "AspectFillImageView.h"

@implementation AspectFillImageView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
}
    
- (void)setImage:(NSImage *)image{
    self.layer = [[CALayer alloc] init];
    self.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.layer.contents = image;
    [self setWantsLayer:YES];
    super.image = image;
}

@end
