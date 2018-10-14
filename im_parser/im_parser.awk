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
		if (length($1) != 0) {
			# core filter 
			if ($1 !~ /[\d]/) {
				# seve $1 to buffer
				first_field_str = $1;
				
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
						printf first_field_array[i]"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t0.00\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\n";
					}
					else {
						printf first_field_array[i]"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\n";
					}
				}
				row_count++;
				total_chars_modified += chars_modified;
			} else { printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\n"; }
		} else { printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\n"; }
	} else { printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\n"; }
}

# postprocessor
END {
# print results 
	printf ("\n"row_count" row(s) was processed with "total_chars_modified" char(s) modified\n");
}