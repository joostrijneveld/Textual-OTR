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

#include <libotr/proto.h>
#include <libotr/message.h>
#include <libotr/context.h>
#include <libotr/privkey.h>

#import "TextualApplication.h"
#include "Utils.h"

typedef enum {
    E_SUCCESS = 0,
    E_NO_PRIVKEY = 1
} otr_error;

OtrlUserState user_state;

extern NSString *const otrKeyFile;
extern NSString *const otrFingerprintsFile;
extern NSString *const otrInstagFile;

extern NSString *const protocolName;
extern NSString *accountName;

@interface Core : NSObject 

void init_otr_lib();
void init_user_state();
void generate_key(NSString *accName);
otr_error test_key();
otr_error start_otr(IRCClient* client, IRCChannel* channel);

@end