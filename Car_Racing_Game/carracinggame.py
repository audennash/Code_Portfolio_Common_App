from shapes2 import * #First, make sure things don't disappear when car gets too close to z = 0, then make car opaque. Then add windows. Then fix car in position and add road to rotate around it. Add physics to road. Add hitboxes
import keyboard
from  math import *
from time import sleep, time
carx = 0  # set defaullt car position
cary = 350
carz = -1
caryaw = 0
carpitch =-0.5 #set default car rotation
carroll = 0
wheelangle = 0
WINX = 1000 #make window
WINY = 500
carmain = [50, 6, 150, 6, 150, 4.25, 300, 3.5, 300, 1, 50, 1]
winmain = [-150, 275, 150, 275, 150, 150, -150, 150]
cubemain = [-175, 50, -175, 400, 175, 400, 175, 50]
cubevertices = []
for i in range(2):
    for j in range(4):
        cubevertices.append(cubemain[j*2])
        cubevertices.append(cubemain[j*2+1])
        cubevertices.append(i*350+175+2000)
win = GraphWin("Car Racing Game", WINX, WINY)

def cartesiantocode(x, y, width=WINX, height=WINY):
     #converts cartesian coordinates to code coordinates
    x+=width/2
    y-=height/2
    y=-y
    return x, y
def project(x, y, z): #for a 3d cartesian coordinate, gives the cartesian coordinates to render it on a 2d screen
    z = max(0, z)
    try:
        return x/z, y/z
    except:
        return x/0.0000000001, y/0.0000001
def rotate(point2, yaw, pitch, roll, center = [0, 0, 0]): #rotates a point around a center with a chosen, yaw, pitch, and roll
    point2[0] = -(center[0]-point2[0]) #makes points relative to the center, instead of (0, 0, 0)
    point2[1] = -(center[1]-point2[1])
    point2[2] = -(center[2]-point2[2])

    xfr = point2[0]*cos(yaw)-point2[2]*sin(yaw) #rotate a point that is x and y dist from (0,0) angle theta around (0, 0), do this for each perspective of the cube (x/z, y/z, x/y)
    yfr = point2[1]
    zfr = point2[0]*sin(yaw)+point2[2]*cos(yaw)

    xsr=xfr
    ysr = yfr*cos(pitch)-zfr*sin(pitch)
    zsr = yfr*sin(pitch)+zfr*cos(pitch)
 
    xtr = xsr*cos(roll)-ysr*sin(roll)
    ytr=xsr*sin(roll)+ysr*cos(roll)
    ztr=zsr

    return xtr+center[0], ytr+center[1], ztr+center[2] #make points relative to (0, 0) instead of the center after rotation
def rotate_spherical(point2, yaw, pitch, center = [0, 0, 0]):
    point2[0] = -(center[0]-point2[0]) #makes points relative to the center, instead of (0, 0, 0)
    point2[1] = -(center[1]-point2[1])
    point2[2] = -(center[2]-point2[2])
    
    totaldist = sqrt(point2[0]**2+point2[1]**2+point2[2]**2)
    yaw2 = atan(point2[2]/point2[0])
    pitch2 = acos(point2[1]/totaldist)

    
    return totaldist*sin(pitch+pitch2)*cos(yaw+yaw2)+center[0], totaldist*cos(pitch+pitch2)+center[1], totaldist*sin(pitch+pitch2)*sin(yaw+yaw2)+center[2]
carvertices=[]
for i in range(len(carmain)):
    carvertices.append(-175+floor(i/6)*350)
    carvertices.append(carmain[(i%6)*2])
    carvertices.append(carmain[(i%6)*2+1])
winvertices = []
for i in range(int(len(winmain)/2)):
    winvertices.append(winmain[i*2])
    winvertices.append(winmain[i*2+1])
    winvertices.append(1)
running = True
carpolys = []
winpoly = Polygon(2, 3)
carvertices2D = []
newlines = []
oldlines = []
for i in range(12):
    rotatedvertices=rotate([carvertices[i*3], carvertices[i*3+1], carvertices[i*3+2]*200], caryaw, carpitch, carroll, [0 ,175, 600])
    projectedcarvertices = project(rotatedvertices[0]-carx, rotatedvertices[1]-cary, rotatedvertices[2]/200- carz)
    projectedcarvertices = cartesiantocode(projectedcarvertices[0], projectedcarvertices[1])
    carvertices2D.append(projectedcarvertices[0])
    carvertices2D.append(projectedcarvertices[1])
for i in range(2):
    carpolys.append(Polygon(*[carvertices2D[i*12+j] for j in range (12)]))
for i in range (5):
    carpolys.append(Polygon(carvertices2D[i*2+2], carvertices2D[i*2+3], carvertices2D[i*2], carvertices2D[i*2+1], carvertices2D[i*2+12], carvertices2D[i*2+13], carvertices2D[i*2+14], carvertices2D[i*2+15]))
for i in carpolys:
    i.setFill("LightBlue1")
winverticesrotated = []
for i in range(4):
    winverticesspun = rotate([winvertices[i*3], winvertices[i*3+1], winvertices[i*3+2]*200], caryaw, carpitch, carroll, [0, 175, 600])
    winverticesrotated.append(winverticesspun[0])
    winverticesrotated.append(winverticesspun[1])
    winverticesrotated.append(winverticesspun[2])
winvertices2d = []
for i in range(4):
    projectedwinv = project(winverticesrotated[i*3]-carx, winverticesrotated[i*3+1]-cary, winverticesrotated[i*3+2]/200-carz)
    projectedwinv = cartesiantocode(*projectedwinv)
    winvertices2d.append(projectedwinv[0])
    winvertices2d.append(projectedwinv[1])
winpoly = Polygon(*winvertices2d)
winpoly.setFill("grey")
carpolys.append(winpoly)
oldsteeringline = Segment(500, 250, 500, 50)
oldsteeringline.draw(win)
fps = Text(50, 50, "0")
finish = 0
start = 1
carpolys2 = []
oldcarpolys = []
newstuff = []
oldstuff = []
oldv = 0
while running==True:
    fps.undraw()
    try:
        fps = Text(50, 50, int(1/(finish-start)))
    except:
        2

    fps.draw(win)
    start = time()
    

    if keyboard.is_pressed("w"): #keyboard controls to move/rotate car
        v = 10
    if keyboard.is_pressed("d"):
        wheelangle+=pi/180
    if keyboard.is_pressed("s"):
        v = -10
    if keyboard.is_pressed("a"):
        wheelangle-=pi/180
    if wheelangle <-pi/4:
        wheelangle = -pi/4
    if wheelangle >pi/4:
        wheelangle = pi/4
    if (not keyboard.is_pressed("w")) and (not keyboard.is_pressed("s")):
        v = 0
    
    for i in range(6):
        point = carmain[i*2+1]*200
        point = point*cos(caryaw)+carz
        xmin = -175*sin(caryaw)+carx
        xmax = 175*sin(caryaw)+carx
        '''for j in range(2):
            if (point >= 2000*(j+1)+175 and point<=2000*(j+1)+525):
                if (xmin>=-175 and xmax+175 <=175):
                    if v != 0:
                        if oldv == 0 or v/abs(v)== oldv:
                            oldv = v/abs(v)
                            v = 0
                            
                        else:
                            2'''
                            
                    
    try:
        r = 900 / tan(wheelangle)
        a=(v**2)/r
        theta = a/v
        zchangeraw = r*sin(theta)
        xchangeraw = r*(1-cos(theta))
        zchange = cos(caryaw)*(zchangeraw+xchangeraw)
        xchange = sin(caryaw)*(zchangeraw+xchangeraw)
    except:
        zchange = v
        xchange = 0
        theta = 0
    if zchange < 0:
        2
    carx += xchange
    carz+= zchange
    caryaw += theta
    vertices2d = []
    for i in range(8): #convert vertices of the cube to 2d by rotating them, then projecting them, then convert them from cartesian to code coordinates, then add them to the list
        rotatedvertices=rotate([cubevertices[i*3]-carx, cubevertices[i*3+1]-cary, cubevertices[i*3+2]-carz+2000], caryaw, carpitch, carroll, [0, 0, 0])
        newvertices = project(rotatedvertices[0], rotatedvertices[1], (rotatedvertices[2])/200)
        ''' print(cubevertices[i*3]-carx+, cubevertices[i*3+1]-cary, cubevertices[i*3+2]-carz, end = " 2 ")
        print(rotatedvertices[0], rotatedvertices[1], rotatedvertices[2], end = " 3 ")
        print(caryaw, carpitch)'''
        #print(carz+1200, cubevertices[i*3+2]+2000, cary+50, cubevertices[i*3+1])
        newvertices = cartesiantocode(newvertices[0], newvertices[1])
        vertices2d.append(newvertices[0])
        vertices2d.append(newvertices[1])
    for j in range(2): #do this for each part of the cube (zdist = 4 and zdist = 6)
        for i in range(3): #draw lines from each vertex to the next counterclockwise
            x1 = vertices2d[i*2+j*8]
            y1 = vertices2d[i*2+1+j*8]
            x2 = vertices2d[i*2+2+j*8]
            y2=vertices2d[i*2+3+j*8]
            #print(x1, y1, x2, y2)
            newlines.append(Segment(x1, y1, x2, y2))
        newlines.append(Segment(vertices2d[6+j*8], vertices2d[7+j*8], vertices2d[0+j*8], vertices2d[1+j*8 ])) #connect final vertice to first
    for i in range(4):
        newlines.append(Segment(vertices2d[i*2], vertices2d[i*2+1], vertices2d[i*2+8], vertices2d[i*2+9])) #connect zdist = 4 to zdist = 6 part f cube
    

    for i in range(8): #convert vertices of the cube to 2d by rotating them, then projecting them, then convert them from cartesian to code coordinates, then add them to the list
        rotatedvertices=rotate([cubevertices[i*3]-carx, cubevertices[i*3+1]-cary, cubevertices[i*3+2]-carz+4000], caryaw, carpitch, carroll, [0, 0, 0])
        newvertices = project(rotatedvertices[0], rotatedvertices[1], (rotatedvertices[2])/200)
        newvertices = cartesiantocode(newvertices[0], newvertices[1])
        vertices2d.append(newvertices[0])
        vertices2d.append(newvertices[1])
    for j in range(2): #do this for each part of the cube (zdist = 4 and zdist = 6)
        for i in range(3): #draw lines from each vertex to the next counterclockwise
            x1 = vertices2d[i*2+j*8+16]
            y1 = vertices2d[i*2+17+j*8]
            x2 = vertices2d[i*2+18+j*8]
            y2=vertices2d[i*2+19+j*8]
            newlines.append(Segment(x1, y1, x2, y2))
        newlines.append(Segment(vertices2d[22+j*8], vertices2d[23+j*8], vertices2d[16+j*8], vertices2d[17+j*8 ])) #connect final vertice to first
    for i in range(4):
        newlines.append(Segment(vertices2d[i*2+16], vertices2d[i*2+17], vertices2d[i*2+24], vertices2d[i*2+25])) #connect zdist = 4 to zdist = 6 part f cube
    
    for  i in range (1, 6):
        if i<5:
            polytoappend = Polygon(carvertices2D[i*2+2], carvertices2D[i*2+3], carvertices2D[i*2], carvertices2D[i*2+1], carvertices2D[i*2+12], carvertices2D[i*2+13], carvertices2D[i*2+14], carvertices2D[i*2+15])
            polytoappend.setFill("LightBlue1")
        else:
            polytoappend = Polygon(*winvertices2d)
            polytoappend.setFill("grey")

        carpolys2.append(polytoappend)
        
    mid = time()
    for i in newlines:
        newstuff.append(i)
    checkpoint1 = time()-mid
    for i in carpolys2:
        newstuff.append(i)
    carpolys2 = []
    newlines = []
    checkpoint2 = time()-mid
    try:
        for i in newstuff: #draw the new lines
            i.draw(win)
    except:
        2
    checkpoint3 = time()-mid
    for i in oldstuff: #undraw the old lines
        i.undraw()
    checkpoint4 = time()-mid
    oldstuff= newstuff #makes new lines the old lines
    newstuff = []
    checkpoint5 = time()-mid


    
    steeringlinex = 0*cos(-wheelangle)-200*sin(-wheelangle)
    steeringliney = 0*sin(-wheelangle)+200*cos(-wheelangle)
    steeringlinex, steeringliney = cartesiantocode(steeringlinex, steeringliney)
    steeringline = Segment(500, 250, steeringlinex, steeringliney)
    steeringline.draw(win)
    oldsteeringline.undraw()
    oldsteeringline = steeringline
    steeringline = None
    
    
    
    '''
        print("i:", i)
        igetpoints = i.getPoints()
        
        print("igetpoints:", igetpoints)
        print("igetpointsgetx:", igetpoints[0].getX(), "igetpointsgety:", igetpoints[0].getY())
        temp = i.clone()
        print("temp:", temp)
        pointsfornow = temp.getPoints()
        print("pointsfornowfirst:", pointsfornow)
        pointsfornow = [pointsfornow[0].getX().getX(), pointsfornow[0].getX().getY(), pointsfornow[0].getY().getX(), pointsfornow[0].getY().getY(), pointsfornow[1].getX().getX(), pointsfornow[1].getX().getY(), pointsfornow[1].getY().getX(), pointsfornow[1].getY().getY()]
        print("pointsfornowsecond:", pointsfornow)

        temp = Polygon(*pointsfornow)
        if count == 3:
            temp.setFill("grey")
        else:
            temp.setFill("LightBlue1")
        temp.draw(win)
        i.undraw()
        i = temp
        '''

    if win.isClosed(): running=False
    finish = time()



