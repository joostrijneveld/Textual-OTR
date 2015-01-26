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

#import <Foundation/Foundation.h>

#include "Core.h"

@implementation Core

NSString *const otrKeyFile = @"/otr.key";
NSString *const otrFingerprintsFile = @"/otr.fp";
NSString *const otrInstagFile = @"/otr.instag";

NSString *const protocolName = @"IRC";
NSString *accountName = nil;

bool keyed = false;

void init_otr_lib() {
    OTRL_INIT;
}

void init_user_state() {
    int err;
    
    user_state = otrl_userstate_create();
    otrl_instag_read(user_state, [Utils filenameToPath:otrInstagFile]);
    otrl_privkey_read_fingerprints(user_state, [Utils filenameToPath:otrFingerprintsFile], NULL, NULL);

    err = otrl_privkey_read(user_state, [Utils filenameToPath:otrKeyFile]);
    if (err == GPG_ERR_NO_ERROR) {
        keyed = true;
    }
}

otr_error test_key() {
    if (!keyed) {
        return E_NO_PRIVKEY;
    }
    return E_SUCCESS;
}

void generate_key(NSString *accName) {
    void *nkp;
    
    accountName = accName;
    
    otrl_privkey_generate_start(user_state, [accountName UTF8String], [protocolName UTF8String], &nkp);
    otrl_privkey_generate_calculate(nkp);
    otrl_privkey_generate_finish(user_state, nkp, [Utils filenameToPath:otrKeyFile]);
}

otr_error start_otr(IRCClient* client, IRCChannel* channel) {
    otr_error ret;
    
    ret = test_key();
    if (ret) {
        return ret;
    }
//    ctx = otr_find_context(irssi, target, 0);
//    if (ctx && ctx->msgstate == OTRL_MSGSTATE_ENCRYPTED) {
//        return E_ALREADY_STARTED;
//    }
    
    [client sendLine:[NSString stringWithFormat:@"PRIVMSG %@ ?OTRv23", channel.name]];
    return E_SUCCESS;
}

void destruct_user_state() {
    
}

@end