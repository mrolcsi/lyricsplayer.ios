//
//  Lyrics.m
//  Lyrics Player
//
//  Created by Matusinka Roland on 2014.04.20..
//  Copyright (c) 2014 Matusinka Roland. All rights reserved.
//

#import "Lyrics.h"

@implementation Lyrics

-(id)initFromLRC:(NSString*) lrc{
    if (self = [super init]){
        //TODO
    }
    return self;
}

-(id)initFromHTML:(NSString*) html{
    if (self = [super init]){
        //get raw lrc from html body
        NSArray *htmlLines = [html componentsSeparatedByString:@"\n"];
        
        [self parseLRCArray:htmlLines];
        
    }
    return self;
}

-(void)parseLRCString:(NSString *)lrc{
    
}

-(void)parseLRCArray:(NSArray*)lrc{
    
    //get lines with LRC tag
    NSString *regexp = @"(\[[0-9]{2}:[0-9]{2}[.][0-9]{2}])";
    
    for (NSString *item in lrc){
        if ([item hasPrefix:@"["]){
            NSString *line =[item stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexp options:0 error:&error];
            // Check error here... (maybe the regex pattern was malformed)
            
            NSRange range = [regex rangeOfFirstMatchInString:line
                                                                options:0
                                                                  range:NSMakeRange(0, [line length])]; // Check full string
            
            if (range.location==1){
                //valid line
                //parse time to integer
                //add to lines array
            }
        }
    }
    

    
    
    return;
}




@end
