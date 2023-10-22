#!/bin/bash

set -e

if [[ ! -f SMSSpamCollection.arff ]]; then
    echo 'Error: File "SMSSpamCollection.arff" not found.'
    exit 1
fi

echo 'INFO: Adding header for attribute "numChars"...'
awk '{{if ($0 !~ /^spam|^ham/) {if (/^@ATTRIBUTE text string$/) {{print; print "@ATTRIBUTE numChars numeric"; next}1} else {print $0}}}}' SMSSpamCollection.arff >SMSSpamCollection2.arff
echo 'INFO: Calculating data for attribute "numChars"...'
awk -vFPAT='([^,]+)|('\''[^'\'']+'\'')' '/^spam|^ham/ {print $0"," length($2)-2}' SMSSpamCollection.arff >>SMSSpamCollection2.arff

echo 'INFO: Adding header for attribute "containsNumSequence"...'
awk '{{if ($0 !~ /^spam|^ham/) {if (/^@ATTRIBUTE numChars numeric$/) {{print; print "@ATTRIBUTE containsNumSequence {0,1}"; next}1} else {print $0}}}}' SMSSpamCollection2.arff >SMSSpamCollection3.arff
echo 'INFO: Calculating data for attribute "containsNumSequence"...'
awk -vFPAT='([^,]+)|('\''[^'\'']+'\'')' '{if (/^spam|^ham/) {if ($2 ~ /[0-9\s]{5,}/) {print $0","1} else {print $0","0}}}' SMSSpamCollection2.arff >>SMSSpamCollection3.arff

echo 'INFO: Adding header for attribute "containsCurrencySymbol"...'
awk '{{if ($0 !~ /^spam|^ham/) {if (/^@ATTRIBUTE containsNumSequence \{0,1\}$/) {{print; print "@ATTRIBUTE containsCurrencySymbol {0,1}"; next}1} else {print $0}}}}' SMSSpamCollection3.arff >SMSSpamCollection4.arff
echo 'INFO: Calculating data for attribute "containsCurrencySymbol"...'
awk -vFPAT='([^,]+)|('\''[^'\'']+'\'')' '{if (/^spam|^ham/) {if ($2 ~ /[$€฿₵¢₡₲₴₭₾₺₼₦₱£﷼₽₹₪৳₸₮₩¥]/) {print $0","1} else {print $0","0}}}' SMSSpamCollection3.arff >>SMSSpamCollection4.arff

echo 'INFO: Adding header for attribute "numBuzzwords"...'
awk '{{if ($0 !~ /^spam|^ham/) {if (/^@ATTRIBUTE containsCurrencySymbol \{0,1\}$/) {{print; print "@ATTRIBUTE numBuzzwords numeric"; next}1} else {print $0}}}}' SMSSpamCollection4.arff >SMSSpamCollection5.arff
echo 'INFO: Calculating data for attribute "numBuzzwords"...'
awk -v IGNORECASE=1 -vFPAT='([^,]+)|('\''[^'\'']+'\'')' '{if (/^spam|^ham/) {print $0","gsub(/call|free|txt|text|claim|reply|www|prize|won|cash|send|win|urgent/,"",$2)}}' SMSSpamCollection4.arff >>SMSSpamCollection5.arff

echo 'INFO: Adding header for attribute "percentUppercaseLetters"...'
awk '{{if ($0 !~ /^spam|^ham/) {if (/^@ATTRIBUTE numBuzzwords numeric$/) {{print; print "@ATTRIBUTE percentUppercaseLetters numeric"; next}1} else {print $0}}}}' SMSSpamCollection5.arff >SMSSpamCollection6.arff
echo 'INFO: Calculating data for attribute "percentUppercaseLetters"...'
awk -vFPAT='([^,]+)|('\''[^'\'']+'\'')' '{if (/^spam|^ham/) {print $0","gsub(/[A-Z]/,"",$2)/($3-gsub(/\s/,"",$2))}}' SMSSpamCollection5.arff >>SMSSpamCollection6.arff
