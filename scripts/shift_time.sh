#!/bin/bash

# --- Configuration ---
INPUT_FILE="network.cap"
OUTPUT_FILE="network_shifted.cap"
TARGET_DATE="2009-12-06 10:30:00"

# 1. Get the original timestamp string (date and time) from the capinfos output.
# This is a reliable method for parsing the text.
FIRST_TS_STR=$(capinfos -a "$INPUT_FILE" | grep "First packet time:" | awk '{print $4 " " $5}')

# Check if we successfully extracted the timestamp.
if [ -z "$FIRST_TS_STR" ]; then
    echo "Error: Could not extract the timestamp from '$INPUT_FILE'."
    echo "Please check that 'capinfos' is installed and the file is a valid capture."
    exit 1
fi

# 2. Convert both the original and target times to Unix epoch format using GNU date.
FIRST_TS=$(date -u -d "$FIRST_TS_STR" +%s.%N)
TARGET_TS=$(date -u -d "$TARGET_DATE" +%s)

# 3. Calculate the precise time shift required.
TIME_SHIFT=$(echo "$TARGET_TS - $FIRST_TS" | bc)

# 4. Display the information for verification.
echo "Original start time: $(date -u -d "$FIRST_TS_STR")"
echo "Target start time:   $(date -u -d "$TARGET_DATE")"
echo "Calculated shift:    $TIME_SHIFT seconds"

# 5. Apply the calculated time shift using editcap.
editcap -t "$TIME_SHIFT" "$INPUT_FILE" "$OUTPUT_FILE"

echo "Success! New file created: $OUTPUT_FILE"
echo "Verify the new start time with: capinfos $OUTPUT_FILE"

