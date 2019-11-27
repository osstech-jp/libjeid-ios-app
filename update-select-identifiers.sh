#!/bin/bash

INFO_PLIST=$1

ENTRY="com.apple.developer.nfc.readersession.iso7816.select-identifiers"
SELECT_IDENTIFIERS=(
    "A00000023101"
    "A00000023102"
    "D392F000260100000001"
    "D3921000310001010402"
    "D3921000310001010408"
)

/usr/libexec/PlistBuddy -c "delete :${ENTRY}" ${INFO_PLIST}
/usr/libexec/PlistBuddy -c "add :${ENTRY} array" ${INFO_PLIST}
for aid in "${SELECT_IDENTIFIERS[@]}" ; do
    /usr/libexec/PlistBuddy -c "add :${ENTRY}: string ${aid}" ${INFO_PLIST}
done

