dbcanFile = 'I-P01/I-P01.dm.parsed'
dbcan = open(dbcanFile, mode='r')
protein1 = 'GH32'
outputFile = open('I-P01/I-P01.GH32.txt', 'w')
contigProtein1 = []
	# Creates blank list
protein1_fa = open('I-P01/I-P01.GH32.faa', 'w')
counter = 0
contigNamesProdigal = []
flag = False

for line1 in dbcan:
	if protein1 in line1:
		outputFile.write(line1)
		contigProtein1.append(line1.split('	')[2])

for i in contigProtein1:
    flag = False
    prodigal = open('/home/GLBRCORG/echiang3/Inulin_MetaG/prodigal/I-P01/I-P01.faa', mode='r')
    for line2 in prodigal:
        if i in line2:
            flag = True
            protein1_fa.write('>'+i+'\n')
            continue
        if '>' in line2 and flag == True:
            prodigal.close()
            break
        if flag == True:
            protein1_fa.write(line2)
        


dbcan.close()
outputFile.close()
protein1_fa.close()