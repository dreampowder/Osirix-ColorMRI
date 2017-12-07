//
//  ImageSetSelector.m
//  NevitColorizer
//
//  Created by Serdar Coskun on 07/12/2017.
//

#import "ImageSetSelector.h"

#import <JNWCollectionViewCell.h>
#import <JNWCollectionView.h>
#import "GridCell.h"


#import <Accelerate/Accelerate.h>

@interface ImageSetSelector ()<NSTableViewDelegate,NSTableViewDataSource,JNWCollectionViewDataSource,JNWCollectionViewGridLayoutDelegate>

@property (strong) IBOutlet NSTableView* seriesTable;
@property (strong) IBOutlet JNWCollectionView* collectionView;

@property (strong) IBOutlet NSImageView* imgRed;
@property (strong) IBOutlet NSImageView* imgGreen;
@property (strong) IBOutlet NSImageView* imgBlue;
@property (strong) IBOutlet NSImageView* imgSample;

@property (strong) IBOutlet NSPopUpButton* btnRed;
@property (strong) IBOutlet NSPopUpButton* btnGreen;
@property (strong) IBOutlet NSPopUpButton* btnBlue;

@property (strong) IBOutlet NSButton* btnSelectSet;
@property (strong) IBOutlet NSButton* btnApplyColors;

@property (strong) NSDictionary<NSNumber*,NSMutableArray*>* seriesDictionary;

@property (strong) NSMutableArray* selectedImageArray;

- (IBAction)didClickSelectSetButton:(id)sender;
- (IBAction)didClickDoneButton:(id)sender;

@property (strong) DicomSeries* redSeries;
@property (strong) DicomSeries* greenSeries;
@property (strong) DicomSeries* blueSeries;

@end

static NSString* ID_CELL_SERIES = @"ImageSetColumn";
static NSString* ID_CELL_COUNT = @"ImageCountColumn";
static NSString* const identifier = @"CELL";

@implementation ImageSetSelector

-(instancetype)initWithSeriesDictionary:(NSDictionary<NSNumber*,NSMutableArray*>*)seriesDicitonary{
    self = [super initWithWindowNibName:@"ImageSetSelector"];
    if (self){
        self.seriesDictionary = seriesDicitonary;
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    JNWCollectionViewGridLayout *gridLayout = [[JNWCollectionViewGridLayout alloc] init];
    gridLayout.delegate = self;
    gridLayout.itemSize = CGSizeMake(100, 100);
    _collectionView.collectionViewLayout = gridLayout;
    _collectionView.dataSource = self;
    [self.collectionView registerClass:GridCell.class forCellWithReuseIdentifier:identifier];
    [self.collectionView reloadData];
}

#pragma mark <NSTableViewDataSource>

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.seriesDictionary.allKeys.count;
}

- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    
    NSNumber* key = _seriesDictionary.allKeys[row];
    NSMutableArray* array = _seriesDictionary[key];
    if ([tableColumn.identifier isEqualToString:ID_CELL_SERIES ]) {
        return [NSString stringWithFormat:@"Set: %li",row];
    }else{
        return @(array.count).description;
    }
}

#pragma mark <NSTableViewDelegate>
-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    NSInteger selectedRow = [[notification object] selectedRow];
    NSNumber* key = _seriesDictionary.allKeys[selectedRow];
    NSMutableArray* array = _seriesDictionary[key];
    self.selectedImageArray = array;
    [self didClickSelectSetButton:self];
}

#pragma mark <JNWCollectionViewDataSource>

- (CGSize)sizeForItemInCollectionView:(JNWCollectionView *)collectionView {
    return CGSizeMake(100, 100);
}

- (NSUInteger)collectionView:(JNWCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedImageArray.count;
}

- (JNWCollectionViewCell *)collectionView:(JNWCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GridCell *cell = (GridCell *)[collectionView dequeueReusableCellWithIdentifier:identifier];
    DicomSeries* series = [self.selectedImageArray objectAtIndex:indexPath.item];
    cell.image = series.thumbnailImage;
    return cell;
}



- (IBAction)didClickSelectSetButton:(id)sender {
    
    if (!self.selectedImageArray) {
        NSRunInformationalAlertPanel(@"Select Image Set", @"You must select an imageset from the menu on left", @"Ok", 0L, 0L);
    }else{
        DicomSeries* series1 = self.selectedImageArray[0];
        DicomSeries* series2 = self.selectedImageArray[1];
        DicomSeries* series3 = self.selectedImageArray[2];
        
        self.redSeries = series1;
        self.greenSeries = series2;
        self.blueSeries = series3;
        
        [self.imgRed setImage:self.redSeries.thumbnailImage];
        [self.imgGreen setImage:self.greenSeries.thumbnailImage];
        [self.imgBlue setImage:self.blueSeries.thumbnailImage];
        
        [self.imgRed setNeedsLayout:YES];
        
        [self populateRGBButtons];
        [self generateSampleImage];
    }
}

- (void)populateRGBButtons{
    
    [self.btnRed.menu removeAllItems];
    [self.btnGreen.menu removeAllItems];
    [self.btnBlue.menu removeAllItems];
    
    for (DicomSeries* series in self.selectedImageArray) {
        NSMenuItem* item1 = [[NSMenuItem alloc] initWithTitle:series.name action:@selector(didSelectMenuItem:) keyEquivalent:@"red"];
        [item1 setImage:series.thumbnailImage];
        NSMenuItem* item2 = [[NSMenuItem alloc] initWithTitle:series.name action:@selector(didSelectMenuItem:) keyEquivalent:@"green"];
        [item2 setImage:series.thumbnailImage];
        
        NSMenuItem* item3 = [[NSMenuItem alloc] initWithTitle:series.name action:@selector(didSelectMenuItem:) keyEquivalent:@"blue"];
        [item3 setImage:series.thumbnailImage];

        [self.btnRed.menu addItem:item1];
        [self.btnGreen.menu addItem:item2];
        [self.btnBlue.menu addItem:item3];
    }
    self.btnRed.menu.title = @"Red Channel";
    [self.btnRed selectItem:self.btnRed.menu.itemArray[0]];
    [self.btnGreen selectItem:self.btnRed.menu.itemArray[1]];
    [self.btnBlue selectItem:self.btnRed.menu.itemArray[2]];
}

- (void)didSelectMenuItem:(NSMenuItem*)sender{
    
    if ([sender.menu isEqual:self.btnRed.menu]) {
        self.redSeries = [self selectSeriesWithName:self.btnRed.selectedItem.title];
    }
    if ([sender.menu isEqual:self.btnGreen.menu]) {
        self.greenSeries = [self selectSeriesWithName:self.btnGreen.selectedItem.title];
    }
    if ([sender.menu isEqual:self.btnBlue.menu]) {
        self.blueSeries = [self selectSeriesWithName:self.btnBlue.selectedItem.title];
    }
    [self.imgRed setImage:self.redSeries.thumbnailImage];
    [self.imgGreen setImage:self.greenSeries.thumbnailImage];
    [self.imgBlue setImage:self.blueSeries.thumbnailImage];
    [self generateSampleImage];
}

- (DicomSeries*)selectSeriesWithName:(NSString*)name{
    for (DicomSeries* series in self.selectedImageArray) {
        if ([series.name isEqualToString:name]) {
            return series;
        }
    }
    return nil;
}

- (void)generateSampleImage{
    DicomSeries* series1 = self.redSeries;
    DicomSeries* series2 = self.greenSeries;
    DicomSeries* series3 = self.blueSeries;
    
    NSData* redChannel = [self channelDataFromImage:series1.thumbnailImage];
    NSData* greenChannel = [self channelDataFromImage:series2.thumbnailImage];
    NSData* blueChannel = [self channelDataFromImage:series3.thumbnailImage];
    
    self.imgSample.image = [self newImageWithSize:series1.thumbnailImage.size fromRedChannel:redChannel greenChannel:greenChannel blueChannel:blueChannel];
}

- (NSImage*)newImageWithSize:(CGSize)size fromRedChannel:(NSData*)redImageData greenChannel:(NSData*)greenImageData blueChannel:(NSData*)blueImageData
{
    vImage_Buffer redBuffer;
    redBuffer.data = (void*)redImageData.bytes;
    redBuffer.width = size.width;
    redBuffer.height = size.height;
    redBuffer.rowBytes = [redImageData length]/size.height;

    vImage_Buffer greenBuffer;
    greenBuffer.data = (void*)greenImageData.bytes;
    greenBuffer.width = size.width;
    greenBuffer.height = size.height;
    greenBuffer.rowBytes = [greenImageData length]/size.height;

    vImage_Buffer blueBuffer;
    blueBuffer.data = (void*)blueImageData.bytes;
    blueBuffer.width = size.width;
    blueBuffer.height = size.height;
    blueBuffer.rowBytes = [blueImageData length]/size.height;

    size_t destinationImageBytesLength = size.width*size.height*3;
    const void* destinationImageBytes = valloc(destinationImageBytesLength);
    NSData* destinationImageData = [[NSData alloc] initWithBytes:destinationImageBytes length:destinationImageBytesLength];
    vImage_Buffer destinationBuffer;
    destinationBuffer.data = (void*)destinationImageData.bytes;
    destinationBuffer.width = size.width;
    destinationBuffer.height = size.height;
    destinationBuffer.rowBytes = [destinationImageData length]/size.height;

    vImage_Error result = vImageConvert_Planar8toRGB888(&redBuffer, &greenBuffer, &blueBuffer, &destinationBuffer, 0);
    NSImage* image = nil;
    if(result == kvImageNoError)
    {
        //TODO: If you need color matching, use an appropriate colorspace here
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)(destinationImageData));
        CGImageRef finalImageRef = CGImageCreate(size.width, size.height, 8, 24, destinationBuffer.rowBytes, colorSpace, kCGBitmapByteOrder32Big|kCGImageAlphaNone, dataProvider, NULL, NO, kCGRenderingIntentDefault);
        CGColorSpaceRelease(colorSpace);
        CGDataProviderRelease(dataProvider);
        image = [[NSImage alloc] initWithCGImage:finalImageRef size:NSMakeSize(size.width, size.height)];
        CGImageRelease(finalImageRef);
    }
    free((void*)destinationImageBytes);
    return image;
}

- (NSData*)channelDataFromImage:(NSImage*)sourceImage
{
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)[sourceImage TIFFRepresentation], NULL);
    if(imageSource == NULL){return NULL;}
    CGImageRef image = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    CFRelease(imageSource);
    if(image == NULL){return NULL;}
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image);
    CGFloat width = CGImageGetWidth(image);
    CGFloat height = CGImageGetHeight(image);
    size_t bytesPerRow = CGImageGetBytesPerRow(image);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(image);
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, colorSpace, bitmapInfo);
    NSData* data = NULL;
    if(NULL != bitmapContext)
    {
        CGContextDrawImage(bitmapContext, CGRectMake(0.0, 0.0, width, height), image);
        CGImageRef imageRef = CGBitmapContextCreateImage(bitmapContext);
        if(NULL != imageRef)
        {
            data = (NSData*)CFBridgingRelease(CGDataProviderCopyData(CGImageGetDataProvider(imageRef)));
        }
        CGImageRelease(imageRef);
        CGContextRelease(bitmapContext);
    }
    CGImageRelease(image);
    return data;
}

- (IBAction)didClickDoneButton:(id)sender{
    if([self.delegate respondsToSelector:@selector(didSelectRedChannel:greenChannel:blueChannel:)]){
        [self.delegate didSelectRedChannel:self.redSeries greenChannel:self.greenSeries blueChannel:self.blueSeries];
    }
}
@end
