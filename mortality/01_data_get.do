/******************************************************
Author: Stephanie Teeple
Created: 20 June 2016
Last Edited: 
Location: 


********************************************************/

// priming the working environment
clear all
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
local out_dir "C:\Users\steeple\Desktop\INSP\data"

