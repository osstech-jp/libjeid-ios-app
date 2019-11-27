#!/bin/sh

INFO_PLIST=$1

/usr/libexec/PlistBuddy -c 'delete :com.apple.developer.nfc.readersession.iso7816.select-identifiers' ${INFO_PLIST}
/usr/libexec/PlistBuddy -c 'add :com.apple.developer.nfc.readersession.iso7816.select-identifiers array' ${INFO_PLIST}
/usr/libexec/PlistBuddy -c 'add :com.apple.developer.nfc.readersession.iso7816.select-identifiers: string A00000023101' ${INFO_PLIST}
/usr/libexec/PlistBuddy -c 'add :com.apple.developer.nfc.readersession.iso7816.select-identifiers: string A00000023102' ${INFO_PLIST}
/usr/libexec/PlistBuddy -c 'add :com.apple.developer.nfc.readersession.iso7816.select-identifiers: string D392F000260100000001' ${INFO_PLIST}
/usr/libexec/PlistBuddy -c 'add :com.apple.developer.nfc.readersession.iso7816.select-identifiers: string D3921000310001010402' ${INFO_PLIST}
/usr/libexec/PlistBuddy -c 'add :com.apple.developer.nfc.readersession.iso7816.select-identifiers: string D3921000310001010408' ${INFO_PLIST}

