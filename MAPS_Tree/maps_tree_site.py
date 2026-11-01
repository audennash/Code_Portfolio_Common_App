from flask import Flask, request, redirect, make_response

app=Flask(__name__)
hoster="127.0.0.1:8192"
password="password"

@app.before_request
def password_check():
    guessed_password = request.cookies.get("MAPSTreePWD")
    page = request.url.split("http://" + hoster)[1].split("?")[0]
    if guessed_password != password and page != "/password" and page != "/guess_password":
        print("redirect")
        return redirect("/password")

@app.route("/password")
def password_page():
    form = '''<form action="/guess_password" method="GET"><div>
        <label for="password">Enter password:</label>
        <input name="password" id="password" placeholder="password" /></div>'''
    return form

@app.route("/guess_password")
def guess_password():
    print("run")
    if request.args.get("password") == password:
        print("corr")
        resp=make_response('<p>The password was correct!<br><a href = "/">Proceed to website.</a></p>')
        resp.set_cookie("MAPSTreePWD", request.args.get("password"))
        return resp
    else:
        resp=make_response('<p>The password was incorrect.<br><a href ="/password">Try again</a></p>')
        resp.set_cookie("MAPSTreePWD", request.args.get("password"))
        return resp

@app.route("/")
def home():
    description = '''<p>This is the MAPS Tree Website. Its purpose is to show specific as well as broad information about the MAPS program.
    This website currently contains some incorrect information due to data inaccuracies. This will be fixed when possible (probably at the start of the 25-26 school year).
    If you have questions, comments, or want to report a problem/incorrect information, please contact me at audennash@gmail.com.
    The "tree" part of this website comes from the fact that family tree nomenclature is used, such as
    'descendants' (a person's mentees, their mentees' mentees, etc.), 'ancestors' (a person's mentors, their mentors' mentors, etc.), and 'dynasts' (someone who mentored but had no mentor).
    This project was made for APCSP 2024-2025 and was inspired by the <a href = "https://genealogy.math.ndsu.nodak.edu">Mathematics Genealogy Project</a>.</p>'''
    search = '''<br>Enter a student name below, with appropriate captalization, and hypenating multiple last names. Preferred names are typically used over full names.
    <form onsubmit="event.preventDefault(); location.href = '/student/' + encodeURIComponent(this.name.value);">
    <input type="text" name="name" placeholder="Enter student name" required>
    <button type="submit">Search</button></form>'''
    pats = "<p>Here is a list of dynasts (and their number of descendants) to get started:"
    with open("patriarchs", "r") as patriarch_list:
        patriarch_list=eval(patriarch_list.read())
        for index, patriarch in enumerate(patriarch_list):
            if index > 0: pats += ","
            pats += ' <a href = "/student/' + patriarch + '">' + patriarch + " (" + str(patriarch_list[patriarch][3]) + ")" + "</a>"
    return description+search+pats

@app.route("/student/<participant>")
def student_page(participant):
    with open("maps_tree", "r") as maps_tree:
        maps_tree=eval(maps_tree.read())
        try:
            student_info=maps_tree[participant.replace("%20", " ")]
        except:
            return '<p><a href="/">Home</a><br>No such student exists. Maybe you capitalized or hyphenated their name incorrectly, or used the wrong nickname?</p>'
        newline="<br>info"
        student_link='<a href="/student/name">name</a>: yearlist'

        name = newline.replace("info", participant.replace("%20", " "))
        yog=newline.replace("info", "YOG: " + student_info[0])

        mentors=newline.replace("info", "Mentors:")
        for mentor in student_info[1]:
            if len(student_info[1][mentor]) > 1:
                remove_comma = 1
            else:
                remove_comma = 2
            mentors += newline.replace("info", student_link.replace("name", mentor).replace("yearlist", str(tuple(student_info[1][mentor])))[:-remove_comma]+")")
        if len(student_info[1]) == 0:
            mentors += newline.replace("info", "None")

        mentees=newline.replace("info", "Mentees:")
        for mentee in student_info[2]:
            if len(student_info[2][mentee]) > 1:
                remove_comma = 1
            else:
                remove_comma = 2
            mentees += newline.replace("info", student_link.replace("name", mentee).replace("yearlist", str(tuple(student_info[2][mentee])))[:-remove_comma]+")")
        if len(student_info[2]) == 0:
            mentees += newline.replace("info", "None")

        descendants=newline.replace("info", "Descendants: " + str(student_info[3]))
        depth=newline.replace("info", "Depth: " + str(student_info[4]))
        return '<html><body><a href="/">Home</a><p>' + name + yog + "</p><p>" + mentors + "</p><p>" + mentees + "</p><p>" + descendants + depth + '</p></body></html>'

if __name__ == "__main__":
    app.run(port=8192)
