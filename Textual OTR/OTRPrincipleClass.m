//
//  OTRPrincipleClass.m
//  Textual OTR
//
//  Created by Joost on 22/01/15.
//  Copyright (c) 2015 Joost. All rights reserved.
//

#import "OTRPrincipleClass.h"

@implementation OTRPrincipleClass

- (NSArray *)subscribedUserInputCommands
{
    return @[@"startotr", @"stopotr"];
}

- (void)userInputCommandInvokedOnClient:(IRCClient *)client
                          commandString:(NSString *)commandString
                          messageString:(NSString *)messageString
{
    [self performBlockOnMainThread:^{
        IRCChannel *c = [mainWindow() selectedChannelOn:client];
        
        if ([c isChannel]) {
            [client printDebugInformation:@"You cannot use OTR in a multiparty context." channel:c];
        }
        else if ([c isPrivateMessage]) {
            if ([commandString isEqualToString:@"STARTOTR"]) {
                [self startOTROnClient:client channel:c];
            }
            else if ([commandString isEqualToString:@"STOPOTR"]) {
                [self stopOTROnClient:client channel:c];
            }
        }
    }];
}

- (void)startOTROnClient:(IRCClient *)client
        channel:(IRCChannel *)c
{
    [client printDebugInformation:@"Initiating OTR.." channel:c];
}

- (void)stopOTROnClient:(IRCClient *)client
        channel:(IRCChannel *)c
{
    [client printDebugInformation:@"Aborted OTR." channel:c];
}

@end
