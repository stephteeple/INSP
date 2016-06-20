/******************************************************
Author: Stephanie Teeple
Created: 20 June 2016
Last Edited: 
Location: 
Description: This script pulls GBD 2015 CoD results for 
neonatal disorders, including the causes: (FILL IN HERE). 
It appends everything into a single dataset and saves it 
locally. It does not prep or format the data. 

Note - this script will only work if you have connection 
to the IHME J: drive. 
********************************************************/

// priming the working environment
clear 
set more off
set maxvar 30000
version 13.0


// discover root 
		if c(os) == "Windows" {
			local j "J:"
		}
		if c(os) == "Unix" {
			local j "/home/j"
		} 

// test arguments

// arguments

// locals 
local age_group_ids 1 2 3 4 5 27 // under-5, early neontal (EN), late neonatal (LN) post neonatal (PN), 1-4yrs and age-standardized

// functions
run "J:\WORK\10_gbd\00_library\functions\get_outputs_helpers\query_table.ado"
run "J:\WORK\10_gbd\00_library\functions\get_location_metadata.ado"
run "J:\WORK\10_gbd\00_library\functions\get_outputs.ado"

// directories


****************************************************************
** Create locals that describe which data you will be downloading
****************************************************************

// Cause_id local 
query_table, table_name(cause) server(modeling-epi-db) database(shared) clear
tempfile data
save `data'

	// congential conditions cause_ids
	keep if regex(acause, "cong") 
	levelsof cause_id, local(cong_cause_id_list)
	use `data', clear

	// neonatal conditions cause_ids
	keep if regex(acause, "neonatal")
	levelsof cause_id, local(neonatal_cause_id_list)

	local cause_id_list `neonatal_cause_id_list' `cong_cause_id_list'

// location_id local - location_ids for only Mexico locations 
get_location_metadata, location_set_id(9) clear
keep if regex(ihme_loc_id, "MEX")
levelsof location_id, local(location_id_list) // this contains the national-level MEX geography in addition to the states



*******************************************************************
** Import GBD 2015 CoD data
*******************************************************************

// prep empty dataset to which we will append 
tempfile cod_data
save `cod_data', emptyok

// begin data import loop 
foreach location_id of local location_id_list {
	foreach cause_id of local cause_id_list {
		di "Importing CoD data for location_id `location_id' and cause_id `cause_id'"
		get_outputs, topic(cause) location_id(`location_id') year_id(all) metric_id(all) age_group_id(1 2 3 4 5 27) 

		// append 
		di "appending"
		append using `cod_data', force 
		save `cod_data', replace 
	}
}




