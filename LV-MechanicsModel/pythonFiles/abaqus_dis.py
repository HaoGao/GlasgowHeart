from odbAccess import *
from abaqusConstants import *
from odbMaterial import *
from odbSection import *
#from Numeric import *

#
#myOdb = openOdb(path='LVpassive.odb')
myOdb = openOdb(path='LVpassive.odb')
#
#   root assembly
#
myAssembly = myOdb.rootAssembly
#
#   part instances 
#
# creat variables that refer to the first two steps
secondStep = myOdb.steps['Step-1']

# Read displacement data from the last frame
# of the second steps.
frame2 = secondStep.frames[-1]

##output the field keys 
for fieldName in frame2.fieldOutputs.keys():
    print fieldName

displacement2 = frame2.fieldOutputs['U']
print displacement2
fieldValues=displacement2.values

outfilename="abaqus_displacement.dat"
outfile=open(outfilename,'w')
for v in fieldValues:
	outfile.write('%d\t%6.4f\t%6.4f\t%6.4f \n' % (v.nodeLabel, v.data[0], v.data[1],v.data[2]))
outfile.close()	

print 'displacement outputed'
myOdb.close()
