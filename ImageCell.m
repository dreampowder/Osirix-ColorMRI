//
//  ImageCell.m
//  ColorMRI
//
//  Created by Serdar Coskun on 17.04.2018.
//

#import "ImageCell.h"

@implementation ImageCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    self.colorOverlayView.alphaValue = 0.25f;
    self.colorOverlayView.layer.backgroundColor = NSColor.clearColor.CGColor;
    // Drawing code here.
}

- (void)setOverlayColor:(NSColor*)color{
    [self.colorOverlayView setWantsLayer:YES];
    self.colorOverlayView.layer.backgroundColor = color.CGColor;
}

- (void)toggleOverlayView:(BOOL)enabled{
    [self setOverlayColor:(enabled)?self.cellColor:NSColor.clearColor];
}


@end
