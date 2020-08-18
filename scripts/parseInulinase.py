dbcanFile = 'test.txt'
dbcan = open(dbcanFile, mode='r')
protein1 = 'GH32'
outputFile = open('output.txt', 'a')
contigProtein1 = []
	# Creates blank list
protein1_fa = open('protein.fa', 'a')
counter = 0
contigNamesProdigal = []
flag = False

for line1 in dbcan:
	if protein1 in line1:
		outputFile.write(line1)
		contigProtein1.append(line1.split('	')[2])

for i in contigProtein1:
    flag = False
    print(i)
    prodigal = open('test.fnn', mode='r')
    for line2 in prodigal:
        if i in line2:
            flag = True
            protein1_fa.write('>'+i+'\n')
            print(i)
            continue
        if '>' in line2 and flag == True:
            prodigal.close()
            break
        if flag == True:
            protein1_fa.write(line2)
        


dbcan.close()
outputFile.close()
protein1_fa.close()
