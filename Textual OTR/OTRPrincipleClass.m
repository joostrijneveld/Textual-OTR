/*
 * Textual OTR add-on: OTR support for the Textual IRC client
 *
 * Copyright (C) 2015 Joost Rijneveld <joostrijneveld@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
#import "OTRPrincipleClass.h"
#import "Core.h"

@implementation OTRPrincipleClass

- (NSArray *)subscribedUserInputCommands
{
    return @[@"otr"];
}

- (void)pluginLoadedIntoMemory
{
    // TODO consider calling this on first use rather than on load
    init_otr_lib();
    init_user_state();
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
            if ([commandString isEqualToString:@"OTR"]) {
                [self handleOTRCommand:messageString onClient:client onChannel:c];
            }
            else {
                [client printDebugInformation:commandString channel:c];
            }
        }
    }];
}

- (void)handleOTRCommand:(NSString *)msgString
                onClient:(IRCClient *)client
               onChannel:(IRCChannel *)channel
{
    NSArray *args = [msgString componentsSeparatedByString:@" "];
    if ([args count] == 0) {
        [client printDebugInformation:@"Please supply a command!" channel:channel];
        return;
    }
    NSString *command = args[0];
    if ([command isEqualToString:@"keygen"]) {
        if ([args count] == 1) {
            [client printDebugInformation:@"Please specify an account name." channel:channel];
            return;
        }
        [client printDebugInformation:@"Generating keypair.." channel:channel];
        generate_key(args[1]);
        [client printDebugInformation:@"Done!" channel:channel];
    }
    else {
        [client printDebugInformation:@"That command is not supported!" channel:channel];
    }
}

@end
