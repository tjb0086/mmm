#! /bin/sh

#Checking to make sure a file was given to process
if [ $# != 1 ]
then
echo "Usage: Please input a list of files when running this script"
exit
fi

#Checking to see if it not only exists, but that it is not an empty file.
if [ -s $1 ]
then
echo "$1 exists and is not empty...Continuing"
else
echo "$1 does not exists or is an empty file...aborting"
exit
fi

#get count of how many files to process
num=`wc -l $1 | awk '{print $1}'`
echo "This program will process $num files"

#store file names into an array
files=(`cat $1`)
echo "The files to process are: ${files[@]}"
# Define the species and subspecies for each file
species_array=(
    ["0018126-240906103802322.csv"]="Mus musculus castaneus"
    ["0018129-240906103802322.csv"]="Mus musculus domesticus"
    ["0018130-240906103802322.csv"]="Mus musculus OR Mus musculus musculus"
    ["0018131-240906103802322.csv"]="Mus musculus molossinus"
    ["0021864-240906103802322.csv"]="Mus spretus spp."
)
# Define the list of museums
museums=("AMNH" "FMNH" "iNaturalist" "KU" "MVZ" "NHMUK" "NMR" "SMF" "USNM" "YPM")
# Initialize the output file for museum counts
echo -e "Species\t${museums[*]}" > museum_count.txt
# Initialize the output file
touch Filtered.txt
echo "Species name\tPercentage filtered" > Filtered.txt
# Iterate through each file in the species_array
for file in "${!species_array[@]}"; do
    # Extract the expected species name for the current file
    expected_species="${species_array[$file]}"

    #confidence check of file existence and non-zero size
     if [ ! -s "${files[$i]}" ]; then
	echo "Warning: One or more files does not exist, skipping to next file"
	continue
    fi

# Filter records that match the expected species and save to an intermediate file
    awk -F'\t' -v species="$expected_species" '$10 ~ species || $11 ~ species' "$file" > "filtered_$file"
    echo "Filtered records for $file saved to filtered_$file"
    
    # Extract header and determine column index for institutionCode
    IFS=$'\t' read -r -a headers < <(head -1 "filtered_$file")
    for i in "${!headers[@]}"; do
        if [[ "${headers[$i]}" == "institutionCode" ]]; then
            inst_col=$((i+1))
            break
        fi
    done
    
    # Initialize counts to zero
    museum_counts=()
    for museum in "${museums[@]}"; do
        museum_counts+=(0)
    done
    
    # Count records per museum
    for museum in "${museums[@]}"; do
        count=$(awk -F'\t' -v col="$inst_col" -v museum="$museum" '$col == museum' "filtered_$file" | wc -l)
        for j in "${!museums[@]}"; do
            if [ "$museum" == "${museums[$j]}" ]; then
                museum_counts[$j]=$count
            fi
        done
    done
    
    # Print the counts to the output file
    echo -e "$expected_species\t${museum_counts[*]}" >> museum_count.txt
done
# Initialize the output file for specimen counts
echo -e "Species\tPRESERVED_SPECIMEN\tHUMAN_OBSERVATION\tOCCURRENCE\tMATERIAL_SAMPLE" > specimen_count.txt

# Process each file for specimen types
for file in "${files[@]}"; do
    expected_species="${species_array[$file]}"
    
    # Ensure filtered file exists
    if [ ! -s "filtered_$file" ]; then
        echo "Filtered file for $file does not exist or is empty...skipping"
        continue
    fi

    # Extract header and determine column index for basisOfRecord
    IFS=$'\t' read -r -a headers < <(head -1 "filtered_$file")
    for i in "${!headers[@]}"; do
        if [[ "${headers[$i]}" == "basisOfRecord" ]]; then
            bor_col=$((i+1))
            break
        fi
    done
    
    # Initialize counts to zero
    specimen_counts=()
    for type in "${specimen_types[@]}"; do
        specimen_counts+=(0)
    done
    
    # Count records per specimen type
    for type in "${specimen_types[@]}"; do
        count=$(awk -F'\t' -v col="$bor_col" -v type="$type" '$col == type' "filtered_$file" | wc -l)
        for j in "${!specimen_types[@]}"; do
            if [ "$type" == "${specimen_types[$j]}" ]; then
                specimen_counts[$j]=$count
            fi
        done
    done
    
    # Print the counts to the output file
    echo -e "$expected_species\t${specimen_counts[*]}" >> specimen_count.txt
done

# Initialize the output file for citizen science records
echo -e "Year\tCount in Mus musculus musculus records" > citizen_count_per_year.txt

# Process each file for iNaturalist records
for file in "${files[@]}"; do
    expected_species="${species_array[$file]}"
    
    # Ensure filtered file exists and the species is Mus musculus musculus
    if [[ "$expected_species" != *"Mus musculus musculus"* ]]; then
        echo "Skipping file $file as it does not contain Mus musculus musculus"
        continue
    fi

    # Extract header and determine column indices for institutionCode and eventDate
    IFS=$'\t' read -r -a headers < <(head -1 "filtered_$file")
    for i in "${!headers[@]}"; do
        if [[ "${headers[$i]}" == "institutionCode" ]]; then
            inst_col=$((i+1))
        elif [[ "${headers[$i]}" == "eventDate" ]]; then
            date_col=$((i+1))
        fi
    done

    # Filter for iNaturalist records and count occurrences per year
    awk -F'\t' -v inst_col="$inst_col" -v date_col="$date_col" -v institution="iNaturalist" \
    '$inst_col == institution {print $date_col}' "filtered_$file" | \
    awk -F'-' '{print $1}' | sort | uniq -c | \
    awk '{print $2"\t"$1}' >> citizen_count_per_year.txt
done
# Initialize the output file for filtered museum counts with locality
echo -e "Species\t${museums[*]}" > museum_count_filtered.txt

# Process each file to count records with locality for each museum
for file in "${files[@]}"; do
    expected_species="${species_array[$file]}"
    
    # Ensure filtered file exists
    if [ ! -s "filtered_$file" ]; then
        echo "Filtered file for $file does not exist or is empty...skipping"
        continue
    fi

    # Extract header and determine column index for institutionCode, basisOfRecord, eventDate, latitude, and longitude
    IFS=$'\t' read -r -a headers < <(head -1 "filtered_$file")
    for i in "${!headers[@]}"; do
        if [[ "${headers[$i]}" == "institutionCode" ]]; then
            inst_col=$((i+1))
        elif [[ "${headers[$i]}" == "decimalLatitude" ]]; then
            lat_col=$((i+1))
        elif [[ "${headers[$i]}" == "decimalLongitude" ]]; then
            long_col=$((i+1))
        fi
    done
    
    # Filter records with locality and keep all columns
    awk -F'\t' -v lat_col="$lat_col" -v long_col="$long_col" '$(lat_col) != "" && $(long_col) != ""' "filtered_$file" > "filtered_lat_long_$file"
    
    # Sorting the file by latitude and longitude using a one-liner
    sort -t$'\t' -k"$lat_col" -k"$long_col" "filtered_lat_long_$file" | uniq > "${species}_lat_long_uniq.txt"
    
    # Initialize counts to zero
    museum_counts=()
    for museum in "${museums[@]}"; do
        museum_counts+=(0)
    done
    
    # Count records per museum for records with locality
    for museum in "${museums[@]}"; do
        count=$(awk -F'\t' -v col="$inst_col" -v museum="$museum" '$col == museum' "${species}_lat_long_uniq.txt" | wc -l)
        for j in "${!museums[@]}"; do
            if [ "$museum" == "${museums[$j]}" ]; then
                museum_counts[$j]=$count
            fi
        done
    done
    
    # Print the counts to the output file
    echo -e "$expected_species\t${museum_counts[*]}" >> museum_count_filtered.txt
done

    #Starting sort all by latitude and longitude
    species=`awk -F'\t' 'NR==2 {print $10, $11}' "filtered_$file" | awk '{print $NF}'`
    echo "This is the mouse species Mus musculus $species"
    
    #code goes here
    mkdir -p $species
    
    # Moving into speices directory 
    cd $species
    
    # Putting the correct dataset in the correct subdirectory
    cp "../filtered_$file" .
    
    # Copying header into new file, removing the header, checking to make sure it worked
    head -1 "filtered_$file" > ${species}_header.txt
    tail -n+2 "filtered_$file" >${species}.txt
    
    tot=`wc -l ${species}.txt | awk '{print $1}'`
    echo "Total: $tot"
    
    # Sorting the file by latitude, then longitude, using a one-liner
    sort -t'\t' -k22 ${species}.txt | uniq | sort -t$'\t' -k23 |uniq > ${species}_lat_long_uniq.txt
    
    # Getting columns (fields) 17 and 18, which should be lat and long using a tab as the field-separator (\t), then grabbing only records
    # that DO NOT (-v) begin (^)with a space (\s), repeated zero or more times (*), until the end of the line ($) [A blank line!] 

    awk -F'\t' '{print $22, $23}' ${species}_lat_long_uniq.txt | grep -v "^\s*$"  > ${species}_lat_long_cleaned.txt
    
    # Counting number of lines in original and filtered files
    filt=`wc -l ${species}_lat_long_cleaned.txt | awk '{print $1}'`
    echo Filtered: $filt
    
    # Using BC calculator (use man bc for syntax and options) to determine percent duplicated records
    peruni=`echo "scale=4; ($filt/$tot)* 100"| bc`
    
    echo "Percent with locality records: $peruni %" 

    echo "$species\t$peruni" >>../Filtered.txt

    #remove intermediate files
    rm ${files[$i]} ${species}_header.txt ${species}.txt ${species}_lat_long_uniq.txt
    
    #move back into the home directory
    cd ../
    
done
#loop ends here

# Moving to the main directory to make concatenated lat,long files
cat ./*/*_lat_long_cleaned.txt | awk -v OFS='\t' -v species="$species" '{print species, $0}' > Lat_Long_combined.txt



