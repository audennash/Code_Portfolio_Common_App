# MAPS Tree Overview
This project was inspired by the [Mathematics Genealogy Project](https://www.genealogy.math.ndsu.nodak.edu/), or MGP (which may be down at the time of reading due to the PHP2Shell vulnerability), which is essentially a family tree built from advisor-advisee relationships between mathematicians. The MAPS tree is essentially the same, but is instead built from mentor-mentee relationships in my school's peer mentorship program, MAPS. The MAPS tree takes the form of a website, on which users can search for students, find their mentors and mentees, and see how "deep" they are in the tree. Information about dynasts, mentors who were never mentees (i.e., the uppermost nodes in the tree), is given on the main page, including which dynasts have the most descendants.

Note that the current names in the MAPS tree are obfuscated to protect the identity of students at my school.

# Running the MAPS tree
To run the MAPS tree website, ensure that the appropriate data is in `maps_tree` and `patriarchs`, and run `maps_tree_site.py`. The server will run on `127.0.0.1:8192` and the password will be "password" (these can be changed by modifying the first few lines of `maps_tree_site.py`).

(Note that "patriarch"  is the old word for "dynast"; I couldn't find a gender-neutral term for "somebody at the top of a family tree" at first.)

# Building the MAPS tree
The MAPS tree is built using data from `maps_table` -- which displays year-by-year mentor and mentee relationships --  and `student_list` -- which is used both for verifying data and determining students' year of graduation. To build the MAPS tree, ensure that the correct data is in `maps_table` and `student_list`, and run `tree_builder.py`.

# Obfuscating Student Data
To obfuscate student data, ensure that `maps_table` and `student_list` store valid data, and that `maps_tree` has already been built. Then run `obfuscate.py` to obfuscate data in these files (using the most popular names in the US, taken from `first_names` and `last_names`), and run `tree_analyzer.py` to update `patriarchs`.
