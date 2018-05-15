//
//  ImageCell.h
//  ColorMRI
//
//  Created by Serdar Coskun on 17.04.2018.
//

#import "JNWCollectionViewCell.h"

@interface ImageCell : JNWCollectionViewCell

@property (nonatomic, strong) IBOutlet NSView* colorOverlayView;
@property (nonatomic, strong) NSColor* cellColor;
@property (nonatomic, strong) IBOutlet NSImageView* imageView;
@property (nonatomic, strong) IBOutlet NSTextField* textField;

- (void)setOverlayColor:(NSColor*)color;
- (void)toggleOverlayView:(BOOL)enabled;

@end
