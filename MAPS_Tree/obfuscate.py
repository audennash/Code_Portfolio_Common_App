from csv import reader, writer

def csvtolist(sheet):
    with open(sheet, "r") as csvfile:
        return list(reader(csvfile))

def listtocsv(sheet, data):
    with open(sheet, "w", newline="") as csvfile:
        writer(csvfile).writerows(data)

maps_table = csvtolist("maps_table") 
student_list = csvtolist("student_list") 

maps_tree={}
maps_tree_text=""
with open("maps_tree", "r") as maps_tree_file:
    maps_tree_text=maps_tree_file.read()
    maps_tree=eval(maps_tree_text)
    maps_tree_file.close()

first_names=[]
last_names=[]

with open("first_names", "r") as first_names_file:
    first_names=[first_name_info.split(",")[0] for first_name_info in first_names_file.read().split("\n")]

with open("last_names", "r") as last_names_file:
    last_names=[last_name_info.split("\t")[1] for last_name_info in last_names_file.read().split("\n")]

aliases={}
alias_count=0
total_students=len(student_list)-1
for index, student_info in enumerate(student_list[1:]):
    print(index, student_info)
    full_name=student_info[1]+" "+student_info[2]
    if full_name in maps_tree or int(student_info[3]) >= 2015:
        aliases[full_name]=first_names[alias_count]+" "+last_names[alias_count%200]
        print(student_list[alias_count+1])
        student_list[alias_count+1][0]=first_names[alias_count]
        student_list[alias_count+1][1]=first_names[alias_count]
        student_list[alias_count+1][2]=last_names[alias_count%200] 
        alias_count += 1
    else:
        del student_list[alias_count+1]

print(aliases)

for row_number, row_data in enumerate(maps_table[2:]):
    for column_number, student in enumerate(row_data):
        if student != "": maps_table[row_number+2][column_number]=aliases[student]



listtocsv("student_list", student_list)
listtocsv("maps_table", maps_table)