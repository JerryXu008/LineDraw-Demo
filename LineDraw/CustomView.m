//
//  CustomView.m
//  xiangDuiYueShu
//
//  Created by song on 15/2/4.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "CustomView.h"
#import <CoreText/CoreText.h>

@interface CustomView()
@property (nonatomic) CTFramesetterRef framesetter;
@property(nonatomic) NSMutableAttributedString *attributedString;
@end
@implementation CustomView
-(void)awakeFromNib{

    
_framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedString);

}
CTFontRef CTFontCreateFromUIFont(UIFont *font)
{
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName,
                                            font.pointSize,
                                            NULL);
    return ctFont;
}



- (NSAttributedString *)attributedString
{
      NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"123456789"];
      _attributedString = string;
    
    NSRange remainingRange = NSMakeRange(0, [string length]);
    [string addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor redColor].CGColor range:remainingRange];
    
    
    
//    NSNumber *underline = [NSNumber numberWithInt:kCTUnderlineStyleSingle];
//    [string addAttribute:(id)kCTUnderlineStyleAttributeName
//                              value:(id)underline
//                              range:NSMakeRange(5, 5)];
    UIFont *font=[UIFont systemFontOfSize:20];
    CTFontRef ctFont = CTFontCreateFromUIFont(font);
    //字体
    [string addAttribute:(id)kCTFontAttributeName
                              value:(__bridge id)ctFont
                              range:remainingRange];
    CFRelease(ctFont);
    //加点段落间距
    float paragraphLeading=0;
   // float par=0;
    CTParagraphStyleSetting settings[]={
   // {kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &par},
    {kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &paragraphLeading},
    
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 1);
    [string addAttribute:(id)kCTParagraphStyleAttributeName
                              value:(__bridge id)paragraphStyle
                              range:remainingRange];
    CFRelease(paragraphStyle);
    
    return _attributedString;
}


void RunDelegateDeallocCallback( void* refCon ){
    
}

CGFloat RunDelegateGetAscentCallback( void *refCon ){
    return  0;
   }

CGFloat RunDelegateGetDescentCallback(void *refCon){
    NSString *imageName = (__bridge NSString *)refCon;
    return [UIImage imageNamed:imageName].size.height;

}

CGFloat RunDelegateGetWidthCallback(void *refCon){
    NSString *imageName = (__bridge NSString *)refCon;
    return [UIImage imageNamed:imageName].size.width;
}
- (void)prepareContext:(CGContextRef)context forRun:(CTRunRef)run {
    CFDictionaryRef attributes = CTRunGetAttributes(run);
    
    // Set font
    CTFontRef runFont = CFDictionaryGetValue(attributes,
                                             kCTFontAttributeName);
    CGFontRef cgFont = CTFontCopyGraphicsFont(runFont, NULL);
    CGContextSetFont(context, cgFont);
    CGContextSetFontSize(context, CTFontGetSize(runFont));
    CFRelease(cgFont);
    
    // Set color
    UIColor *color = CFDictionaryGetValue(attributes,
                                          NSForegroundColorAttributeName);
    CGContextSetFillColorWithColor(context, color.CGColor);
}

- (NSMutableData *)glyphDataForRun:(CTRunRef)run {
    NSMutableData *data;
    CFIndex glyphsCount = CTRunGetGlyphCount(run);
    const CGGlyph *glyphs = CTRunGetGlyphsPtr(run);
    size_t dataLength = glyphsCount * sizeof(*glyphs);
    if (glyphs) {
        data = [NSMutableData dataWithBytesNoCopy:(void*)glyphs
                                           length:dataLength freeWhenDone:NO];
    }
    else {
        data = [NSMutableData dataWithLength:dataLength];
        CTRunGetGlyphs(run, CFRangeMake(0, 0), data.mutableBytes);
    }
    return data;
}

- (NSMutableData *)advanceDataForRun:(CTRunRef)run {
    NSMutableData *data;
    CFIndex glyphsCount = CTRunGetGlyphCount(run);
    const CGSize *advances = CTRunGetAdvancesPtr(run);
    size_t dataLength = glyphsCount * sizeof(*advances);
    if (advances) {
        data = [NSMutableData dataWithBytesNoCopy:(void*)advances
                                           length:dataLength
                                     freeWhenDone:NO];
    }
    else {
        data = [NSMutableData dataWithLength:dataLength];
        CTRunGetAdvances(run, CFRangeMake(0, 0), data.mutableBytes);
    }
    return data;
}


-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//    
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);//设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
//    
//    CGAffineTransform flipVertical = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
//    CGContextConcatCTM(context, flipVertical);//将当前context的坐标系进行flip
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//    CGContextTranslateCTM(context, 0, self.bounds.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);

    
    
        
    
    
//    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attributedString);
//    
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGRect bounds = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
//    CGPathAddRect(path, NULL, bounds);
//    
//    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter,CFRangeMake(0, 0), path, NULL);
//    CTFrameDraw(ctFrame, context);
//    
//    
//    CFRelease(ctFrame);
//    CFRelease(path);
//    CFRelease(ctFramesetter);

    
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFTypeRef)self.attributedString);
   
    
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    CFIndex runCount = CFArrayGetCount(runs);
    int ii=0;
    for (CFIndex runIndex = 0; runIndex < runCount; ++runIndex)
    {
          CTRunRef run = CFArrayGetValueAtIndex(runs, runIndex);
         [self prepareContext:context forRun:run];
        // Fetch the glyphs as a CGGlyph* array
        NSMutableData *glyphsData = [self glyphDataForRun:run];
        CGGlyph *glyphs = [glyphsData mutableBytes];
        
        // Fetch the advances as a CGSize* array. An advance is the
        // distance from one glyph to another.
        NSMutableData *advancesData = [self advanceDataForRun:run];
        CGSize *advances = [advancesData mutableBytes];

        
        
        CFIndex glyphCount = CTRunGetGlyphCount(run);
        for (CFIndex glyphIndex = 0;
             glyphIndex < glyphCount ;
             ++glyphIndex) {

            
            CGContextSaveGState(context);
           
            
            
           
            CGContextTranslateCTM(context,
                                  ii* (advances[glyphIndex].width), 10);
             //方法一
            CGContextTranslateCTM(context, 0, (advances[glyphIndex].height+10));
             CGContextScaleCTM(context, 1.0, -1.0);
             //方法二
             //翻转180度
//             CGContextRotateCTM(context, M_PI);
//             CGContextTranslateCTM(context, 0, -10);
          
            
            CGContextShowGlyphsAtPoint(context, 0, 0,
                                       &glyphs[glyphIndex], 1);
            
            CGContextRestoreGState(context);

            
            ii++;
        
        }
        
        
        
      
    
    }
    
    
    CFRelease(line);
    
        

    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    //[super drawRect:rect];
//    [[UIColor greenColor] set];
//    CGContextRef context=UIGraphicsGetCurrentContext();
//    
//    
//   
//    
//     CGMutablePathRef mainPath=CGPathCreateMutable();
//    // CGPathAddRect(mainPath, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
////       CGPathRef path1=CGPathCreateWithRect(CGRectMake(20, self.bounds.size.height-25, self.bounds.size.width-20, 25),NULL);
////     CGPathAddPath(mainPath, NULL, path1);
//    CGPathRef path2=CGPathCreateWithRect(CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height-25),NULL);
//    CGPathAddPath(mainPath, NULL, path2);
////
////    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
////    CGContextTranslateCTM(context, 0, self.bounds.size.height);
////    CGContextScaleCTM(context, 1.0, -1.0);
//
//  //  CGPathAddRect(mainPath, NULL, CGRectMake(0, -110, self.bounds.size.width, self.bounds.size.height-110));
//      //CGPathAddRect(mainPath, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//    CGContextTranslateCTM(context, 0, self.bounds.size.height);
//    CGContextScaleCTM(context, 1.0, -1);
//
//    
//    CTFrameRef drawFrame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), mainPath, NULL);
//    
//    
//    
//    CTFrameDraw(drawFrame, context);
//     //看看行信息
//    
//   NSArray *lines=(__bridge NSArray *) CTFrameGetLines(drawFrame);
//    NSInteger lineCount=[lines count];
//    CGPoint origins[lineCount];
//    
//    CTFrameGetLineOrigins(drawFrame, CFRangeMake(0, 0), origins);
//    for(int i=0;i<lineCount;i++){
//        NSLog(@"x=%f,y=%f\n",origins[i].x,origins[i].y);
//        CGPoint baselineOrigin = origins[i];
//        //int height=CGRectGetHeight(self.frame);
//         baselineOrigin.y = CGRectGetHeight(self.frame) - baselineOrigin.y;
//         CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
//        
//        
//        
//        CGFloat ascent, descent;
//        
//        CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
//        NSLog(@"ascent=%f,descent=%f\n",ascent,descent);
//        
//        CGRect lineFrame = CGRectMake(baselineOrigin.x, baselineOrigin.y - ascent, lineWidth, ascent + descent);
//        
//        CFRange lineRange= CTLineGetStringRange(line);
//        
//        
//        
//        CFArrayRef runs = CTLineGetGlyphRuns(line);//获取line中包含所有run的数组,我的理解是返回几种属性类型，通过applyStyle方法添加进去的
//        
//        for(CFIndex j=0;j<CFArrayGetCount(runs);j++)
//        {
//            CTRunRef run=CFArrayGetValueAtIndex(runs, j);
//            NSDictionary *attributes=(__bridge NSDictionary*)CTRunGetAttributes(run);
//            
//            
//            
//            CGRect runBounds;
//            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
//            runBounds.size.height = ascent + descent;
//
//            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
//            runBounds.origin.x = baselineOrigin.x + self.frame.origin.x + xOffset;
//            runBounds.origin.y = baselineOrigin.y + lineFrame.size.height;
//
//            
//        }
//        
//        
//        
//        int ii=0;
//    }
//    
//    
//    
//    
//    CFRelease(drawFrame);
//    CGPathRelease(mainPath);
//   
//   // [self getLineRectFromNSRange:NSMakeRange(0, 1)];



}
//得到包含range的那一行的Rect
- (CGRect)getLineRectFromNSRange:(NSRange)range
{
    CGMutablePathRef mainPath = CGPathCreateMutable();
   
        CGPathAddRect(mainPath, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
        
    CTFrameRef ctframe = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), mainPath, NULL);
    CGPathRelease(mainPath);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(ctframe);
    NSInteger lineCount = [lines count];
    CGPoint origins[lineCount];
    if (lineCount != 0)
    {
        for (int i = 0; i < lineCount; i++)
        {
            CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
            CFRange lineRange= CTLineGetStringRange(line);
            if (range.location >= lineRange.location && (range.location + range.length)<= lineRange.location+lineRange.length)
            {
                CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), origins);
                CGPoint origin = origins[i];
                CGFloat ascent,descent,leading;
                CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
                origin.y = self.frame.size.height-(origin.y);
                CFRelease(ctframe);
                CGRect lineRect = CGRectMake(origin.x, origin.y+descent-(ascent+descent+1), lineWidth, ascent+descent+1);
                return lineRect;
            }
        }
    }
    CFRelease(ctframe);
    return CGRectMake(-1, -1, -1, -1);
}


@end
