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
    
    

    ViewerController    *new2DViewer;

    new2DViewer = [self duplicateCurrent2DViewerWindow];

    //Here we are trying to decide which series are eligable for putting into RGB Channels.
    //Image series are grouped by their image count, and if there are more than or equal to 3 image sets with same count
    //imageset is eligable.
    NSMutableDictionary<NSNumber*,NSMutableArray*>* possibleSeries = @{}.mutableCopy;
    NSMutableDictionary<NSNumber*,NSMutableArray*>* tempSeries = @{}.mutableCopy;
    BrowserController *currentBrowser = [BrowserController currentBrowser];
    NSArray *selectedItems = [currentBrowser databaseSelection];
    for (id item in selectedItems) {
        if ([item isKindOfClass:[DicomStudy class]]) {
            NSArray* listOfSeries = [(DicomStudy*)item imageSeries];
            for (DicomSeries* imageSeries in listOfSeries) {
                
                NSNumber* seriesKey = @(imageSeries.images.count);
                if(![tempSeries objectForKey:seriesKey]){
                    [tempSeries setObject:@[imageSeries].mutableCopy forKey:seriesKey];
                }else{
                    [tempSeries[seriesKey] addObject:imageSeries];
                }
            }
        }
    }
    for (NSNumber* key in tempSeries.allKeys) {
        NSMutableArray* array = tempSeries[key];
        if (array.count>=3) {
            possibleSeries[key] = array;
        }
    }
    
    self.windowImageSelector = [[ImageSetSelector alloc] initWithSeriesDictionary:possibleSeries];
    self.windowImageSelector.delegate = self;
    [self.viewerWindow.window beginSheet:self.windowImageSelector.window completionHandler:nil];
    if( new2DViewer) return 0; // No Errors
    else return -1;
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

#pragma mark <ImageSetSelectorDelegate>

- (void)didSelectRedChannel:(DicomSeries *)redSeries greenChannel:(DicomSeries *)greenSeries blueChannel:(DicomSeries *)blueSeries{
    
}

@end
