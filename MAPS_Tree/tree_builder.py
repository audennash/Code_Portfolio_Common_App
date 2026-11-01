from csv import reader

def csvtolist(sheet):
    with open(sheet, "r") as csvfile:
        return list(reader(csvfile))

maps_table = csvtolist("maps_table")
student_list = csvtolist("student_list")

def getYOG(student):
    for student_row in student_list: #for each student (row) in the list of students
        if student.split(" ")[0] == student_row[1] and student.split(" ")[1] == student_row[2]: #if the inputted student name (first and last), split about the space in their name (all last names are hyphenate and no students have two names) matches the first and last name of an entry in the student list
            return student_row[4] #return their year of graduation

mentors=[] #initialize a list of people who mentored (all patriarchs mentored)
for row in maps_table[2:]: #for each row in the table (that has mentor-mentee pairings)
    for mentor in row[::2]: #for every mentor in this row (mentors only appear in even-numbered columns if the leftmost 1 is 0)
        if not mentor in mentors: mentors.append(mentor) #append this mentor to the list of mentors

for row in maps_table: #for each row in the table
    for student in row[1::2]: #for each mentee (who appears in odd-numbered columns)
        if student in mentors: mentors.remove(student) #if the student is both a mentee and a mentor, remove them
    
patriarchs = mentors #what remains in the list of mentors is all mentors who were not mentees, or in other words patriarchs, so this list is returned

maps_tree={} #initialize a tree to store mentor_mentee_relationships

for student in patriarchs: 
    maps_tree[student] = [getYOG(student), {}, {}] #by the above comment, patriarchs must be added first

for column_pair in range(len(maps_table[0])//2): #iterates through each pair of columns (which contains mentor and mentee pairings)
    for row in range(2, len(maps_table)): #for each row in these columns that has mentor-mentee pairings
        mentor = maps_table[row][column_pair*2] #the mentor is in the left column of the pair
        mentee = maps_table[row][column_pair*2+1] #the mentee is on the right

        if not mentor == "": #if the pair of columns is not blank
            if mentor in maps_tree: #if the mentor is in the tree
                if mentee in maps_tree[mentor][2]: #if the mentee is already listed as having been mentored by the mentor
                    maps_tree[mentor][2][mentee].append(int(maps_table[0][column_pair*2])) #add the year that the mentorship occured to the list of years that the mentor mentored the mentee
                else: #if the mentee is not already listed as having been mentored by the mentor
                    maps_tree[mentor][2][mentee] = [int(maps_table[0][column_pair*2])] #intiate a list in the mentor's mentee dictionary, and in this list, put the year that the mentorship occured
            else: #if the mentor is not in the tree
                maps_tree[mentor] = [getYOG(mentor), {}, {mentee: [int(maps_table[0][column_pair*2])]}] #add the mentor's list as described above (in the action section of this function's overarching comments), and add the mentee as described immediately above

#the below code ensures that all mentees (even if they did not mentor) are kept in the tree, but appended after their mentors
for mentor in list(maps_tree): #for each mentor in the maps tree (compressed into a list of the mentor names, as only mentors have been added)
    for mentee in maps_tree[mentor][2]: #for each mentee in the mentor's mentee dictionary
        if mentee in maps_tree: #if the mentee is in the tree
            maps_tree[mentee][1][mentor] = maps_tree[mentor][2][mentee] #in the mentee's mentor dictionary, add an entry for the mentor with all the years that the mentor mentored them
        else: #if the mentee is not in the tree
            maps_tree[mentee] = [getYOG(mentee), {mentor:maps_tree[mentor][2][mentee]}, {}] #create an entry for them, and add the mentor's entry to their mentor dictionary as described immediately above

for person in reversed(list(maps_tree)): #for the name of each person in the tree (going backwards)
    descendants=0 #initialize their descendants at 0

    for mentee in maps_tree[person][2]: #for each mentee in their mentee dictionary
        descendants += maps_tree[mentee][3] + 1 #take their number of descendants and add one (to count the mentee), due to the append statement below, the descendants value will be the third index in the mentee's entry in the maps_tree dictionary
    
    maps_tree[person].append(descendants) #append this person's descendants to their entry in maps_tree

for person in maps_tree: #for the name of each person in the tree
    depth = 0 #initialize their depth as zero
    for mentor in maps_tree[person][1]: #for each of their mentors
        depth = max(depth, maps_tree[mentor][4]) #see if the mentor's depth (the fourth item in the mentor's maps_tree entry) is greater than the depth of all previous mentors (or if depth=0 then simply this mentors depth)
    depth += 1 #add 1 to depth, as this person is one deeper in the tree than their mentor
    maps_tree[person].append(depth) #append the depth to this person's maps_tree entry

with open("patriarchs", "w") as patriarchs_file: #open a file with the ability to write to it
    patriarch_dict={} #initialize a dictionary of patriarchs
    for patriarch in patriarchs: #for each patriarch
        patriarch_dict[patriarch] = maps_tree[patriarch] #make an entry for them in the patriarch dictionary equal to their entry in their maps tree dictionary
    patriarchs_file.write(str(patriarch_dict)) #save the dictionary to the patriarch dictionary file
    patriarchs_file.close() #close the file

with open("maps_tree", "w") as tree_file: #open a file with the ability to write to it
    tree_file.write(str(maps_tree)) #save the mapsa_tree to it
    tree_file.close() #close to the file
