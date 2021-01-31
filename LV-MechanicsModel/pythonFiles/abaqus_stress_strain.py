from odbAccess import *
from abaqusConstants import *
from odbMaterial import *
from odbSection import *
from Numeric import *

#
#myOdb = openOdb(path='LVpassive.odb')
myOdb = openOdb(path='heartLVmainG3F60S45P08.odb')
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
#print displacement2
#fieldValues=displacement2.values

#outfilename="C:\\workrelated\CMM paper\huiming-rerun\8mmHg_newBC\\abaqus_displacement.dat"
#outfile=open(outfilename,'w')
#for v in fieldValues:
#	outfile.write('%d\t%6.4f\t%6.4f\t%6.4f \n' % (v.nodeLabel, v.data[0], v.data[1],v.data[2]))
#outfile.close()	

#print 'displacement outputed'
#stressField = frame2.fieldOutputs['S']
#print stressField
stressField = frame2.fieldOutputs['LE']
print stressField
print 'Node sets = ',myAssembly.nodeSets.keys()
print 'Element sets = ',myAssembly.elementSets.keys()

locSet = myAssembly.elementSets[' ALL ELEMENTS']
nodeSet = myAssembly.nodeSets[' ALL NODES']
stressFieldValues = stressField.getSubset(region=locSet).values
nodestressNodeFieldValues = stressField.getSubset(region=nodeSet,position=ELEMENT_NODAL).values
print 'length of the elemStress = %d' %len(stressFieldValues)
print 'length of the nodeStress = %d' %len(nodestressNodeFieldValues)

##stress output for each element
#stressoutfilename="abaqus_extract_stress_element.dat"
#stressoutfile=open(stressoutfilename,'w')
#for v in stressFieldValues:
#	#print v
#	stressoutfile.write('%d\t' % ( v.elementLabel))
#	for component in v.data:
#	    stressoutfile.write('%10.4f\t' % ( component))	
#	stressoutfile.write('%10.4f\t' % ( v.maxPrincipal))
#	stressoutfile.write('%10.4f\t' % ( v.midPrincipal))
#	stressoutfile.write('%10.4f\t' % ( v.minPrincipal))
##	stressoutfile.write('%10.4f\t' % ( v.mid_principle))
##	stressoutfile.write('%10.4f\t' % ( v.min_principle))
#	stressoutfile.write('\n')
#stressoutfile.close()	
#print 'stress outputed'



nodestressoutfilename="abaqus_extract_strain_node.dat"
nodestressoutfile=open(nodestressoutfilename,'w')
for v in nodestressNodeFieldValues:
	nodestressoutfile.write('%d\t' % ( v.nodeLabel))
	for component in v.data:
	    nodestressoutfile.write('%10.4f\t' % ( component))
	nodestressoutfile.write('\n')	
nodestressoutfile.close()	
print 'node strain outputed'




myOdb.close()