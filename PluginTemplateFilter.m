//
//  PluginTemplateFilter.m
//  PluginTemplate
//
//  Copyright (c) CURRENT_YEAR YOUR_NAME. All rights reserved.
//

#import "PluginTemplateFilter.h"
#import "ImageSetSelector.h"

@interface PluginTemplateFilter()<ImageSetSelectorDelegate>
@property (strong) ImageSetSelector* windowImageSelector;
@end
@implementation PluginTemplateFilter


- (void) initPlugin
{
    
}

- (long) filterImage:(NSString*) menuName
{
    
    
    
    //    ViewerController    *new2DViewer;
    //    new2DViewer = [self duplicateCurrent2DViewerWindow];
    
    NSMutableArray<DicomSeries*>* seriesArray = @[].mutableCopy;
    
    BrowserController *currentBrowser = [BrowserController currentBrowser];
    NSArray *selectedItems = [currentBrowser databaseSelection];
    for (id item in selectedItems) {
        if ([item isKindOfClass:[DicomStudy class]]) {
            NSArray* listOfSeries = [(DicomStudy*)item imageSeries];
            [seriesArray addObjectsFromArray:listOfSeries];
        }
    }
    
    self.windowImageSelector = [[ImageSetSelector alloc] initWithSeriesArray:seriesArray.copy];
    self.windowImageSelector.delegate = self;
    [self.viewerWindow.window beginSheet:self.windowImageSelector.window completionHandler:nil];
    //    if( new2DViewer) return 0; // No Errors
    //    else return -1;
    return 0;
}

//- (long) filterImage:(NSString*) menuName
//{
//
//    NSArray *pixList = [viewerController pixList: 0];
//    int curSlice = [[viewerController imageView] curImage];
//    DCMPix *curPix = [pixList objectAtIndex: curSlice];
//
//    // Number of Pixels
//    int curPos = [curPix pheight] * [curPix pwidth];
//
//    if( [curPix isRGB]) {
//
//        // get pointer to the first pixel of the image
//        unsigned char *rgbImage = (unsigned char*) [curPix fImage];
//
//        while ( curPos--> 0 )
//        {
//
//            // Reading Pixel
//            short RedValue = rgbImage[curPos*4 +1];
//            short GreenValue = rgbImage[curPos*4 +2];
//            short BlueValue = rgbImage[curPos*4 +3];
//
//            // Writing Pixel
//            rgbImage[curPos*4 +1] = RedValue;
//            rgbImage[curPos*4 +2] = GreenValue;
//            rgbImage[curPos*4 +3] = BlueValue;
//
//        }
//    } else {
//
//        // get pointer to the first pixel of the image
//        float *fImage = [curPix fImage];
//
//        while ( curPos--> 0 )
//        {
//            float GreyValue;
//
//            // Reading Pixel
//            GreyValue = fImage[curPos];
//
//            // Writing Pixel
//            fImage[curPos] = GreyValue;
//
//        }
//    }
//
//    // if you've changed pixel values,
//    // don't forget to update the display
//    [viewerController needsDisplayUpdate];
//
//    return 0;
//}
//
//- (long) filterImage:(NSString*) menuName
//{
//
//    _viewerWindow = [self duplicateCurrent2DViewerWindow];
//    for (id file in _viewerWindow.roiList) {
//        NSRunInformationalAlertPanel(@"Welcome!", [NSString stringWithFormat:@"File: %@",file], @"OK", 0L, 0L);
//    }
//
//
//    NSMutableArray* vcArray = [ViewerController getDisplayed2DViewers];
//
//    ViewerController* vc1 = [vcArray objectAtIndex:0];
//    ViewerController* vc2 = [vcArray objectAtIndex:1];
//    ViewerController* vc3 = [vcArray objectAtIndex:2];
//
//    NSArray *pixList = [viewerController pixList: 0];
//    int curSlice = [[viewerController imageView] curImage];
//
//    DCMPix *curPix = [pixList objectAtIndex: curSlice];
//    NSRunInformationalAlertPanel(@"Welcome!", [NSString stringWithFormat:@"Cırpic Name: %@ ",curPix.generatedName], @"OK", 0L, 0L);
//
//    NSArray *pixList1 = [vc1 pixList: 0];
//    NSArray *pixList2 = [vc2 pixList: 0];
//    NSArray *pixList3 = [vc3 pixList: 0];
//
//    DCMPix *curPix1 = [pixList1 objectAtIndex: curSlice];
//    DCMPix *curPix2 = [pixList2 objectAtIndex: curSlice];
//    DCMPix *curPix3 = [pixList3 objectAtIndex: curSlice];
//
//    [curPix ConvertToRGB:3 :curPix.wl :curPix.ww];
//
//    [curPix1 ConvertToRGB:3 :curPix1.wl :curPix1.ww];
//    [curPix2 ConvertToRGB:3 :curPix2.wl :curPix2.ww];
//    [curPix3 ConvertToRGB:3 :curPix3.wl :curPix3.ww];
//
//    if( [curPix isRGB]) {
//
//        // get pointer to the first pixel of the image
//        unsigned char *rgbImage = (unsigned char*) [curPix fImage];
//
//        unsigned char *rgbImage1 = (unsigned char*) [curPix1 fImage];
//        unsigned char *rgbImage2 = (unsigned char*) [curPix2 fImage];
//        unsigned char *rgbImage3 = (unsigned char*) [curPix3 fImage];
//
//        for (int x = 0; x < [curPix pwidth]; x++)
//            for (int y = 0; y < [curPix pheight]; y++)
//            {
//
//                long curPos = y * [curPix pwidth] + x;
//
//                // Reading Pixels
//                short RedValue = rgbImage1[curPos*4 +1];
//                short GreenValue = rgbImage2[curPos*4 +2];
//                short BlueValue = rgbImage3[curPos*4 +3];
//
//                // Writing Pixels
//                rgbImage[curPos*4 +1] = RedValue;
//                rgbImage[curPos*4 +2] = GreenValue;
//                rgbImage[curPos*4 +3] = BlueValue;
//            }
//
//    } else {
//
//        // get pointer to the first pixel of the image
//        float *fImage = [curPix fImage];
//        for (int x = 0; x < [curPix pwidth] / 2; x++)
//            for (int y = 0; y < [curPix pheight] / 2; y++)
//            {
//
//                int curPos = y * [curPix pwidth] + x;
//
//                // Reading Pixel
//                float GreyValue = fImage[curPos];
//
//                // Writing Pixel
//                fImage[curPos] = 255.0f;
//            }
//
//    }
//
//    // if you've changed pixel values,
//    // don't forget to update the display
//    [viewerController needsDisplayUpdate];
//
//    return 0;
//}
//
//- (void)mergeImagesWithRedChannelImage:(DCMPix*)redChannel
//                     greenChannelImage:(DCMPix*)greenChannel
//                      blueChannelImage:(DCMPix*)bluecChannel{
//
//}

- (void)generateRGBSetWithRedChannel:(DicomSeries*)redSeries
                     andGreenChannel:(DicomSeries*)greenSeries
                      andBlueChannel:(DicomSeries*)blueSeries{
    
    ViewerController    *new2DViewer;
    new2DViewer = [self duplicateCurrent2DViewerWindow];
    
    NSArray *pixList = [new2DViewer pixList: 0];
    
    
//    NSMutableSet* imageSet = [NSMutableSet new];
    
    for (int i = 0;i<pixList.count;i++) {
        
        [new2DViewer setImageIndex:i];
        int curSlice = [[new2DViewer imageView] curImage];
        DCMPix *curPix = [pixList objectAtIndex:curSlice];
        [self convertPixToRGB:curPix Red:redSeries.sortedImages[curSlice] Green:greenSeries.sortedImages[curSlice] Blue:blueSeries.sortedImages[curSlice]];
        [new2DViewer needsDisplayUpdate];
    }
    //    ViewerController    *new2DViewer;
    //    new2DViewer = [self duplicateCurrent2DViewerWindow];
    
}

- (void)convertPixToRGB:(DCMPix*)currentPix
                     Red:(DicomImage*)redImg
                   Green:(DicomImage*)greenImg
                    Blue:(DicomImage*)blueImg{
    
//    DCMPix* currentPix = [DCMPix dcmPixWithImageObj:currentImg];
    [currentPix ConvertToRGB:3 :currentPix.wl :currentPix.ww];
    
    DCMPix* redPix = [DCMPix dcmPixWithImageObj:redImg];
    [redPix ConvertToRGB:3 :redPix.wl :redPix.ww];
    
    DCMPix* greenPix = [DCMPix dcmPixWithImageObj:greenImg];
    [greenPix ConvertToRGB:3 :greenPix.wl :greenPix.ww];
    
    DCMPix* bluePix = [DCMPix dcmPixWithImageObj:blueImg];
    [bluePix ConvertToRGB:3 :bluePix.wl :bluePix.ww];
    
    NSLog(@"current: %f-%f\n\n\nred: %f-%f\n\n\ngreen: %f-%f\n\n\nblur:%f-%f",currentPix.wl,currentPix.ww,redPix.wl,redPix.ww,greenPix.wl,greenPix.ww,bluePix.wl,bluePix.ww);
    
    unsigned char *rgbImage = (unsigned char*) [currentPix fImage];
    unsigned char *redImage = (unsigned char*) [redPix fImage];
    unsigned char *greenImage = (unsigned char*) [greenPix fImage];
    unsigned char *blueImage = (unsigned char*) [bluePix fImage];
    for (int x = 0; x < [currentPix pwidth]; x++){
        for (int y = 0; y < [currentPix pheight]; y++)
        {
            long curPos = y * [currentPix pwidth] + x;
            // Reading Pixels
            short redValue = redImage[curPos*4 +1];
            short greenValue = greenImage[curPos*4 +2];
            short blueValue = blueImage[curPos*4 +3];
            
            // Writing Pixels
            rgbImage[curPos*4 +1] = redValue;
            rgbImage[curPos*4 +2] = greenValue;
            rgbImage[curPos*4 +3] = blueValue;
        }
    }
}

#pragma mark <ImageSetSelectorDelegate>

- (void)didSelectRedChannel:(DicomSeries *)redSeries greenChannel:(DicomSeries *)greenSeries blueChannel:(DicomSeries *)blueSeries{
    [self generateRGBSetWithRedChannel:redSeries andGreenChannel:greenSeries andBlueChannel:blueSeries];
}


@end
