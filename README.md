Capstone Project III: Biological Applications of Regular Expressions

BEFORE STARTING THIS ASSIGNMENT, PLEASE READ ALL OF THE INSTRUCTIONS

Prerequisites
Prior to starting this project, you should feel comfortable constructing regular expressions to parse text
Completion of the Regex Quiz with at least 80% or higher
Completion of Labs 6-7 and a solid understanding of the listed learning objectives
Learning Goals
Get practice using awk and sed with regular expresssions to parse real biological datasets
Get practice completing computing tasks without step-by-step instructions. As mentioned on Capstone Project #2, you will often have a specific scientific goal rather than a set of instructions for how to obtain the results. Here you will get practice building your OWN workflow for a data analysis project.
Reinforcement of the concept of doing projects in a paced setting that involves mutliple sessions working on various pieces and returning after breaks and reflection
As you can see from the rubric for this assignment, you will no longer be graded on your effort, but instead on your output. While you will still turn in your a script, we will not be grading it for commands as was done with Capstone #2. Instead, you will be graded on whether you get the CORRECT answers in your final tables.
Refine existing code to improve efficiency.
Learning Objectives
Reinforce the use of awk to count records in datasets, isolate specific columns, and perform calculations
Reinforce printing tabular outputs from STDOUT
Incrementally build one-liners using pipes either in a script or on the CL
Get practice building regular expressions to match patterns
Revisit previous scripts to refine commands
Practice using ChatGPT to help with scripting
Step-by-Step Instructions
Instructions: Often when dealing with biological problems, you are not given step-by-step instructions as you have gotten used to throughout this course. Instead, you have a specific question that you need to answer and you need to decide which approach is most useful to get the data you need. For your 3rd Capstone Project, I will not tell you the tools you need to accomplish the goals, only what the problems are that you need to solve. As with other assignments, you will need to "show your work". Here that will be via a script (NOT saved history). While you may work in whatever linux environment you wish, if you plan to use sed, please note that it often has unexpected behavior on MacOS. See the Week 8 canvas page for how to get sed to behave on Mac OS.
For Capstone 3, you will be ALLOWED to use the internet and/or ChatGPT. If you use these outside sources, you are required to attribute it appropriately in your readme and include a transcript on any ChatGPT conversation. You are NOT allow to copy and paste the assignment into ChatGPT and you are NOT allowed to use ChatGPT on ANY non-coding parts of the assignment* (e.g. readme files, comment text, and/or reflection questions).

Assignment: This project centers around the use of regular expressions, which we have focused on throughout this module. To complete this assignment, you will continue editing your script from Capstone 2 to build a better workflow for processing museum record datasets. You may edit the original graded script from Capstone 2 directly in your GitHub repository via GitHub Desktop.
Part A:
For this part of the assignment, you are asked to return to your original script that you have been working on throughout the semester. Now that we have wrapped up our command line section of the course, you should feel comfortable refining this script to better filter the dataset of five species museum records provided in CP2.

Start by revisiting your code from Capstone 2. You will edit the script file to make it more efficient and do some additional analysis of these data files.

First, let's improve some of the filter steps to make sure they better process the datasets. For example, you will notice that the awk command I gave you in CP1 resulted in some records not properly filtering for the correct columns. Let's revise this to work properly:

Change awk 'FS="\t" {print $X, $Y} to awk -F'\t' '{print $X,$Y}' and you will notice this fixes this issue. Specifically, the field separator argument is supplied outside of the "program" sent to awk as a command argument to awk instead. This allows it to process ALL lines of the input file as tab-delimited. Whereas the original command did not do this on the first line of the file resulting in words instead of coordinates.

Similarly, look at the man page for the sort command and specify the tab-delimiter when sorting by the latitude and longitudes as well.

Add in an additional confidence check inside of the loop to check that each input file for each species exists and is not empty.

Look over the script and what it is doing to improve efficiency throughout. For example, if in CP2 you stored the command argument as a separate variable, try removing this and simply using the built in variable instead. This is more efficient than making a new variable when you already have one! Similarly, if you get an error message when making directories, add the optional flag to mkidr to silence that error.

Addiitonally, any steps where you are able to use pipes instead of generating temporary files that you then remove should be done to improve efficiency.

Finally, add a column to the final combined output to include the species name in addition to the latitude and longitude coordinates. The final output should have THREE columns and be tab-delimited. This file will be the input to your fourth capstone project!

Part B:
Next, we will sift through the records in more depth than simply calculating the percent with locality information. First, let's make sure that ALL of the records belong to the same species/sub-species. Check that the columns for this information are the same for ALL the records. If they are from a different than what is indicated below, then remove them by saving an intermediate filtered file. Do this step BEFORE filtering for the latitude and longitude coordinate steps in your updated script file (just after removing the header line).

The five species/subspecies that should be in each file are as follows:

File	Species
0018126-240906103802322.csv	Mus musculus castaneus
0018129-240906103802322.csv	Mus musculus domesticus
0018130-240906103802322.csv	Mus musculus OR Mus musculus musculus
0018131-240906103802322.csv	Mus musculus molossinus
0021864-240906103802322.csv	Mus spretus spp.
Tip: Look back at the code used to capture the species name in CP2. This isolated only information on line 2 of the file (the first record), but you should check ALL lines to see if any of the files have extra records from other species/subspecies. You can do this check outside of your script on the command line and then proceed based on those files that are problematic. Note: this will need to be hard-coded to this dataset.

Next, let's make a table of record counts per specific museums (column label: "institutionCode"). See Part C for the formatting and naming conventions for this file. Again, do this on records before filtering for locality information (after filtering for species, but before any other filtering).

To do this, get a count of records from each museum/institution from each subspecies file based on the table below. For any files that have no records from the museums/institutions listed below, simply record a zero in the table. This can be done programmatically in your script using a conditional statement.

Musuem	AMNH	FMNH	iNaturalist	KU	MVZ	NHMUK	NMR	SMF	USNM	YPM
Count in File 0018126-240906103802322.csv										
Count in File 0018129-240906103802322.csv										
Count in File 0018130-240906103802322.csv										
Count in File 0018131-240906103802322.csv										
Count in File 0021864-240906103802322.csv										
Note: the first column should contain the species name from the variable you created in CP2. Not the text here which indicated the values that should in each row.

Now, instead of focusing on the museum source, let's make a table of the types of specimen ("basisOfRecord"). Specifically, let's focus on the following types and make a table for each species file:

Specimen Type	PRESERVED_SPECIMEN	HUMAN_OBSERVATION	OCCURRENCE	MATERIAL_SAMPLE
Count in File 0018126-240906103802322.csv				
Count in File 0018129-240906103802322.csv				
Count in File 0018130-240906103802322.csv				
Count in File 0018131-240906103802322.csv				
Count in File 0021864-240906103802322.csv				
Note: the first column should contain the species name from the variable you created in CP2. Not the text here which indicated the values that should in each row.

Include examples of other types of records in your updated readme for this project.

Next, let's look into the records from citizen science sources (iNaturalist) for ONLY Mus musculus musculus records. For these, let's make a table of the number of records per year made by the public.

Years	Count in Mus musculus musculus records
Year 1	
Year 2	
Year 3	
Year ...	
Year N	
Note: the first column should contain the actual years for these records. The values in the table above are meant as examples.

Finally, we will want to filter for records with locality in those top museums. Let's repeat the Table we made in #3, but only for records with latitude/longitude coordinates. First, remove all records without locality information as you have done before. An important difference is that you will need to KEEP the other columns when you do this in order to make the table below.

Finally, go back and fill in the count for each museum with the updated counts of those with locality records.

Musuem	AMNH	FMNH	iNaturalist	KU	MVZ	NHMUK	NMR	SMF	USNM	YPM
Count in File 0018126-240906103802322.csv										
Count in File 0018129-240906103802322.csv										
Count in File 0018130-240906103802322.csv										
Count in File 0018131-240906103802322.csv										
Count in File 0021864-240906103802322.csv										
Part C:
Congrats on making it through this project! Now that you are done, convert your FOUR tables into text files as you did at the end of Labs 6 and 7.

These files should have SPECIFIC naming conventions listed below. Failure to follow this convention will slow down the grading process as we will use the command diff between our key files and your tables to faciliate quick grading. Manually editing the code to follow unconventional file formats will slow us down significantly in getting these back to you in a timely manner.

Table 1: museum_count.txt
Table 2: specimen_count.txt
Table 3: citizen_count_per_year.txt
Table 4: museum_count_filtered.txt
Upload the four table files to your GitHub repository from Capstone 2.

Upload your updated script to the same respository and final filtered locality records with THREE columns.

Update your README to describe the updated filtering script with the improved computational efficiency. Also describe the additional steps we have done in Part B in your README. Include any other oddities you noticed in the dataset! You can choose to include ONE of the four tables you made and write a description of how you arrived at the information in the table. Attribute any outside sources appropriately.

If you used ChatGPT at ALL during this assignment, upload a copy of the transcript to Canvas along with your zipped repository file and your reflection.

Reflection Questions (5 pts)
Lastly, respond to the following reflection questions, and upload your responses titled NAME_reflection.txt to canvas along with your zipped repository from GitHub. In your reflection, answer the following questions:
Compare the first and last table you made in this project. What do the differences in numbers tell you about each institution and the probability that it will have locality information for the records it includes in the GBIF database? Why do you think some sources of data are more likely to have this information than others?

Thinking back over this project from when you first encountered this dataset in Capstone 1 through to the script you have now made, how do you feel the analysis you have done has improved? Specifically, how does your command history from CP1 compare to the script you made in Capstone 2 and to this script for this third Capstone? How have the changes you made improved computational efficiency and/or reproducibility? Which of the skills you learned made these updates possible?

Now having seen several file formats in this course (e.g. museum records/fasta/VCF/etc), what are some features of various formats you have encountered that lend themselves to different types of data analysis you have done in the course?

This capstone project completes your basic training on the command line. (We will return to it for the final!) The next two questions ask you to reflect on these first 10 weeks of the course:
In the first 3 modules of the course, what topics were not covered that you wish you had learned? It is OK to say you feel like you have learned ENOUGH!

In the beginning of the semester, I made the analogy that this course is like learning a foreign language. Many study abroad students find they lose their language skills when they return home unless they dedicate time to keeping their skills sharp. What are some things YOU could do to continue your training on command line so as not to lose the skills you have learned in the last 10 weeks?
