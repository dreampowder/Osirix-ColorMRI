//
//  ImageItem.m
//  ColorMRI
//
//  Created by Serdar Coskun on 09/03/2018.
//

#import "ImageItem.h"

@interface ImageItem ()

@end

@implementation ImageItem

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.borderWidth = 0;
    self.view.layer.borderColor = NSColor.whiteColor.CGColor;
    self.colorOverlayView.alphaValue = 0.25f;
    self.colorOverlayView.layer.backgroundColor = NSColor.clearColor.CGColor;
    
}

- (void)setOverlayColor:(NSColor*)color{
    [self.colorOverlayView setWantsLayer:YES];
    self.colorOverlayView.layer.backgroundColor = color.CGColor;
}

- (void)toggleOverlayView:(BOOL)enabled{
    [self setOverlayColor:(enabled)?self.cellColor:NSColor.clearColor];
}

@end
