#!/bin/bash

set -e

if [[ ! -f SMSSpamCollection.arff ]]; then
    echo 'Error: File "SMSSpamCollection.arff" not found.'
    exit 1
fi

# Capitalization doesn't matter in these variables:
readonly currencySymbols="$€฿₵¢₡₲₴₭₾₺₼₦₱£﷼₽₹₪৳₸₮₩¥"
readonly buzzwords="call|free|txt|text|claim|reply|www|prize|won|cash|send|win|urgent"
readonly abbreviations="brb|btw|omg|idk|ttyl|omw|smh|lol|tbd|imo|imho|hmu|lmk|og|ftw|nvm|ootd|fwiw|ngl|rq|lykyk|ong|brt|sm|ig|wya|istg|hbu|atm|np|fomo|obv|rn|rofl|stfu|icymi|tldr|tmi|afaik|byob|bogo|jk|jw|tgif|tbh|tbf|fubar|iso|ftfy|gg|bfd|irl|dae|bts|ikr|wyd|idc|idgaf|nbd|tba|afk|abt|iykyk|b4|bc|jic|snafu|gtg|g2g|h8|lmao|iykwim|myob|pov|tlc|hbd|wtf|wysiwyg|fwif|tw"

echo 'INFO: Adding header for attribute "numChars"...'
awk '{{if ($0 !~ /^spam|^ham/) {if (/^@ATTRIBUTE text string$/) {{print; print "@ATTRIBUTE numChars numeric"; next}1} else {print $0}}}}' SMSSpamCollection.arff >SMSSpamCollection2.arff
echo 'INFO: Calculating data for attribute "numChars"...'
awk -vFPAT='([^,]+)|('\''[^'\'']+'\'')' '/^spam|^ham/ {print $0"," length($2)-2}' SMSSpamCollection.arff >>SMSSpamCollection2.arff
echo ''

echo 'INFO: Adding header for attribute "containsNumSequence"...'
awk '{{if ($0 !~ /^spam|^ham/) {if (/^@ATTRIBUTE numChars numeric$/) {{print; print "@ATTRIBUTE containsNumSequence {0,1}"; next}1} else {print $0}}}}' SMSSpamCollection2.arff >SMSSpamCollection3.arff
echo 'INFO: Calculating data for attribute "containsNumSequence"...'
awk -vFPAT='([^,]+)|('\''[^'\'']+'\'')' '{if (/^spam|^ham/) {if ($2 ~ /[0-9\s]{5,}/) {print $0","1} else {print $0","0}}}' SMSSpamCollection2.arff >>SMSSpamCollection3.arff
echo ''

echo 'INFO: Adding header for attribute "containsCurrencySymbol"...'
awk '{{if ($0 !~ /^spam|^ham/) {if (/^@ATTRIBUTE containsNumSequence \{0,1\}$/) {{print; print "@ATTRIBUTE containsCurrencySymbol {0,1}"; next}1} else {print $0}}}}' SMSSpamCollection3.arff >SMSSpamCollection4.arff
echo 'INFO: Calculating data for attribute "containsCurrencySymbol"...'
awk -vFPAT='([^,]+)|('\''[^'\'']+'\'')' '{if (/^spam|^ham/) {if ($2 ~ /['"${currencySymbols}"']/) {print $0","1} else {print $0","0}}}' SMSSpamCollection3.arff >>SMSSpamCollection4.arff
echo ''

echo 'INFO: Adding header for attribute "numBuzzwords"...'
awk '{{if ($0 !~ /^spam|^ham/) {if (/^@ATTRIBUTE containsCurrencySymbol \{0,1\}$/) {{print; print "@ATTRIBUTE numBuzzwords numeric"; next}1} else {print $0}}}}' SMSSpamCollection4.arff >SMSSpamCollection5.arff
echo 'INFO: Calculating data for attribute "numBuzzwords"...'
awk -v IGNORECASE=1 -vFPAT='([^,]+)|('\''[^'\'']+'\'')' '{if (/^spam|^ham/) {print $0","gsub(/('"${buzzwords}"')/,"",$2)}}' SMSSpamCollection4.arff >>SMSSpamCollection5.arff
echo ''

echo 'INFO: Adding header for attribute "percentUppercaseLetters"...'
awk '{{if ($0 !~ /^spam|^ham/) {if (/^@ATTRIBUTE numBuzzwords numeric$/) {{print; print "@ATTRIBUTE percentUppercaseLetters numeric"; next}1} else {print $0}}}}' SMSSpamCollection5.arff >SMSSpamCollection6.arff
echo 'INFO: Calculating data for attribute "percentUppercaseLetters"...'
awk -vFPAT='([^,]+)|('\''[^'\'']+'\'')' '{if (/^spam|^ham/) {print $0","gsub(/[A-Z]/,"",$2)/($3-gsub(/\s/,"",$2))}}' SMSSpamCollection5.arff >>SMSSpamCollection6.arff
echo ''

echo 'INFO: Adding header for attribute "containsURL"...'
awk '{{if ($0 !~ /^spam|^ham/) {if (/^@ATTRIBUTE percentUppercaseLetters numeric$/) {{print; print "@ATTRIBUTE containsURL {0,1}"; next}1} else {print $0}}}}' SMSSpamCollection6.arff >SMSSpamCollection7.arff
echo 'INFO: Calculating data for attribute "containsURL"...'
awk -v IGNORECASE=1 -vFPAT='([^,]+)|('\''[^'\'']+'\'')' '{if (/^spam|^ham/) {if ($2 ~ /http/) {print $0","1} else {print $0","0}}}' SMSSpamCollection6.arff >>SMSSpamCollection7.arff
echo ''

echo 'INFO: Adding header for attribute "numExclamationMark"...'
awk '{{if ($0 !~ /^spam|^ham/) {if (/^@ATTRIBUTE containsURL \{0,1\}$/) {{print; print "@ATTRIBUTE numExclamationMark numeric"; next}1} else {print $0}}}}' SMSSpamCollection7.arff >SMSSpamCollection8.arff
echo 'INFO: Calculating data for attribute "numExclamationMark"...'
awk -vFPAT='([^,]+)|('\''[^'\'']+'\'')' '{if (/^spam|^ham/) {print $0","gsub(/!/,"",$2)}}' SMSSpamCollection7.arff >>SMSSpamCollection8.arff
echo ''

echo 'INFO: Adding header for attribute "numAbbreviations"...'
awk '{{if ($0 !~ /^spam|^ham/) {if (/^@ATTRIBUTE numExclamationMark numeric$/) {{print; print "@ATTRIBUTE numAbbreviations numeric"; next}1} else {print $0}}}}' SMSSpamCollection8.arff >SMSSpamCollection9.arff
echo 'INFO: Calculating data for attribute "numAbbreviations"...'
awk -v IGNORECASE=1 -vFPAT='([^,]+)|('\''[^'\'']+'\'')' '{if (/^spam|^ham/) {print $0","gsub(/\s+('"${abbreviations}"')\s+/,"",$2)}}' SMSSpamCollection8.arff >>SMSSpamCollection9.arff
echo ''

echo 'INFO: Switching header order to make class "class (Nom)" to be selected as default target class by Weka...'
awk '{if ($0 !~ /^spam|^ham/) {if (/^@ATTRIBUTE class \{ham, spam\}$/) {} else {print $0}}}' SMSSpamCollection9.arff | awk '{if (/^@ATTRIBUTE numAbbreviations numeric$/) {{print; print "@ATTRIBUTE class {ham, spam}"; next}1} else {print $0}}' >SMSSpamCollection_complete.arff
echo 'INFO: Apply new atribute order to all datasets...'
awk -vFPAT='([^,]+)|('\''[^'\'']+'\'')' '{if ($0 ~ /^ham|^spam/) {dummy=$1; $1=""; print $0 ","dummy}}' 'OFS=,' SMSSpamCollection9.arff | awk '{print substr($0,2)}' >>SMSSpamCollection_complete.arff
echo ''

echo 'INFO: Done.'
exit 0
