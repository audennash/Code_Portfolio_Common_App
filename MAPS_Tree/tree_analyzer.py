with open("maps_tree", "r") as maps_tree:
    maps_tree=eval(maps_tree.read())

num_students=len(maps_tree)

def sort_descendants():
    student_list_descendants=[]
    for student in maps_tree:
        student_list_descendants.append([student, maps_tree[student][3]])

    for rep in range(num_students):
        for subrep in range(1, num_students-rep):
            if student_list_descendants[subrep-1][1] > student_list_descendants[subrep][1]: 
                student_list_descendants[subrep-1], student_list_descendants[subrep] = student_list_descendants[subrep], student_list_descendants[subrep-1]
    
    return student_list_descendants

def patriarchs_by_descendants():
    with open("patriarchs", "r") as patriarchs:
        patriarchs=eval(patriarchs.read())
    

    descendant_list=sort_descendants()
    toremove=[]
    for person, descendants in descendant_list:
        if not person in patriarchs:
            toremove.append([person, descendants])
    
    for element in toremove:
        descendant_list.remove(element)

    descendant_list.reverse()
    new_patriarchs={}
    for patriarch, descendants in descendant_list:
        new_patriarchs[patriarch]=patriarchs[patriarch]
    
    with open("patriarchs", "w") as patriarch_file:
        patriarch_file.write(str(new_patriarchs))


def depth_of_person(person):
        depth=0
        for i in maps_tree[person][1]:
            depth=max(depth, depth_of_person(i))
        return depth+1

def sort_depth():
    people_and_depth=[[person, depth_of_person(person)] for person in maps_tree]
    for rep in range(num_students):
        for subrep in range(1, num_students-rep):
            if people_and_depth[subrep-1][1] > people_and_depth[subrep][1]: 
                people_and_depth[subrep-1], people_and_depth[subrep] = people_and_depth[subrep], people_and_depth[subrep-1]
    
    return people_and_depth

print(sort_depth())

if __name__ == "__main__":
    patriarchs_by_descendants()

