// The Textual OTR addon provides OTR support for the Textual IRC client
// Copyright (C) 2015 Joost Rijneveld <joostrijneveld@gmail.com>

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
