# -------------------------------------------------------------------------------------------------------------
# 
#     FGT IM-parser for DMD
#               Version 1.0
#     Copyright (C) - A.V.O.  25/09/2018
# 
# -------------------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------------------
#  How it works
# -------------------------------------------------------------------------------------------------------------
# 
#  At the command prompt, type
#  [machine-name]:$ awk -f /path/to/im_parser.awk /path/to/input_csv_file.csv > /path/to/output_csv_file.csv
#
# -------------------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------------------
#  Change log
# -------------------------------------------------------------------------------------------------------------
# 
#  1. 25/09/2018 - 1-st Version 1.0
#  2. 23/11/2018 - 2-nd Version 1.0.1 (format changed)
#  3. 13/12/2018 - 3-rd Version on nov-branch. Reuse on fll FIFA data with separate format of imput file
#
# -------------------------------------------------------------------------------------------------------------

# preprocessor
BEGIN {
	# set def delimiter (TAB) for input file(s)
	FS = "\t";
	# set total_chars_modified = 0; 
	total_chars_modified = 0;
	printf "FGT IM-parser :: (csv/tsv)-file processing is started\n\n";
}

# body
{
	if (NR != 1 ) {
		if (length($4) != 0) {
			# core filter 
			if ($4 !~ /[\d]/) {
				# seve $1 to buffer
				first_field_str = $4;
				
				# === DEBUG ===
				#printf "original: "first_field_str" | "NR"\r\n";				
				# === DEBUG ===

				# replace symbols [\s \. \, \/] for \,
				chars_modified = gsub(/[ |\.|\,|\/]/, ",", first_field_str);
				
				# clean extra \,
				chars_modified += gsub(/\,+/, ",", first_field_str);

				# trim last \,
				chars_modified += gsub(/\,$/, "", first_field_str);
				
				# === DEBUG ===
				#printf "modify "chars_modified" chars : "first_field_str" | "NR"\r\n";
				# === DEBUG ===
				
				# split string to array
				first_field_array_size = split(first_field_str, first_field_array, ",");
				
				for (i in first_field_array) {
					if (i < first_field_array_size) {
						printf $1"\t"$2"\t0.00\t"first_field_array[i]"\t"$5"\n";

					}
					else {
						printf $1"\t"$2"\t"$3"\t"first_field_array[i]"\t"$5"\n";

					}
				}
				row_count++;
				total_chars_modified += chars_modified;
			} else { printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\n"; }
		} else { printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\n"; }
	} else { printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\n"; }
}

# postprocessor
END {
# print results 
	printf ("\n"row_count" row(s) was processed with "total_chars_modified" char(s) modified\n");
}