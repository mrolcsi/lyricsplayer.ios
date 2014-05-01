//
//  SongList.m
//  Lyrics Player
//
//  Created by Matusinka Roland on 2014.04.07..
//  Copyright (c) 2014 Matusinka Roland. All rights reserved.
//

#import "SongList.h"
#import "Song.h"
#import "SongListCell.h"

@implementation SongList

-(id)initWithTestData{
    self = [super init];
    if (self){
//        Song *vivalavida = [[Song alloc]initWithArtist:@"Coldplay"
//                                                 Title:@"Viva la Vida"
//                                                 Album:@"Viva la Vida or Death And All His Friends"
//                                            CoverImage:[UIImage imageNamed:@"coldplay-vivalavida.jpg"]
//                                DurationInMilliseconds:244218];
//        Song *thriftshop = [[Song alloc]initWithArtist:@"Macklemore & Ryan Lewis"
//                                                 Title:@"Thrift Shop"
//                                                 Album:@"The Heist"
//                                            CoverImage:[UIImage imageNamed:@"macklemore-thriftshop.jpg"]
//                                DurationInMilliseconds:234448];
//        Song *clarity = [[Song alloc]initWithArtist:@"Zedd feat. Foxes"
//                                              Title:@"Clarity (Album Version)"
//                                              Album:@"Clarity"
//                                         CoverImage:[UIImage imageNamed:@"zedd-clarity.jpg"]
//                             DurationInMilliseconds:271426];
//        Song *digitalLove = [[Song alloc]initWithArtist:@"Daft Punk"
//                                                  Title:@"Digital Love"
//                                                  Album:@"Discovery"
//                                             CoverImage:[UIImage imageNamed:@"daftpunk-discovery.jpg"]
//                                  DurationInMilliseconds:300277];
        
//        _songs = [[NSMutableArray alloc] initWithObjects:vivalavida, thriftshop, clarity, digitalLove, nil];
        //init with filename

        Song *vivalavida=[[Song alloc]initWithFile:[[NSBundle mainBundle] pathForResource:@"Coldplay - Viva la Vida.mp3" ofType:nil]];
        
        _songs =[[NSMutableArray alloc]initWithObjects:vivalavida, nil];
        

    }
    return self;
}

-(void)addSong:(Song *) song{
    if (_songs) [_songs addObject:song];
}

-(void)removeSong:(Song *) song{
    if (_songs) [_songs removeObject:song];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_songs count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SongCell";
    
    SongListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (!cell) {
        cell = [[SongListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Song *song = [_songs objectAtIndex:indexPath.row];
    
    cell.lblArtist.text = song.artist;
    cell.lblTitle.text = song.title;
    cell.imgCover.image = song.cover;
    cell.lblDuration.text = [song getTotalTimeString];
    
    return cell;
}

@end
