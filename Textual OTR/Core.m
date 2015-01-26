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
NSString *const accountName = @"testaccount";

const char* filenameToPath(NSString *fname) {
    return [[NSHomeDirectory() stringByAppendingString:fname] UTF8String];
}

void init_otr_lib() {
    OTRL_INIT;
}

void init_user_state() {
    user_state = otrl_userstate_create();
    otrl_instag_read(user_state, filenameToPath(otrInstagFile));
    otrl_privkey_read_fingerprints(user_state, filenameToPath(otrFingerprintsFile), NULL, NULL);
    otrl_privkey_read(user_state, filenameToPath(otrKeyFile));
}

void generate_key() {
    void *nkp;
    
    otrl_privkey_generate_start(user_state, [accountName UTF8String], [protocolName UTF8String], &nkp);
    otrl_privkey_generate_calculate(nkp);
    otrl_privkey_generate_finish(user_state, nkp, filenameToPath(otrKeyFile));
}

void destruct_user_state() {
    
}

@end