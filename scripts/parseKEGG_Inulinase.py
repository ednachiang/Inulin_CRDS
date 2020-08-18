KEGGFile = 'I-P01.GH32.kegg.output'
KEGG = open(KEGGFile, mode='r')
faaFile = 'I-P01.GH32.faa'
faa = open(faaFile, mode='r')
ko1 = 'K22245'
ko2 = 'K03332'
ko1Protein = []
ko2Protein = []
k01outputFile = open('I-P01.GH32.kegg.endoinulinase.txt', 'a')
k02outputFile = open('I-P01.GH32.kegg.exoinulinase.txt', 'a')
counter1 = 0
counter2 = 0
contigNames  = []
flag1 = False
flag2 = False

for line1 in KEGG:
	if k01 in line1:
		ko1Protein.append(line1.split('	')[1]
	elif k02 in line1:
		k02Protein.append(line1.split('	')[1]

for line2 in ko1Protein:
	flag1 = FALSE
	print(line2)
	faa = open('I-P01.GH32.faa', mode='r')
	for line3 in faa:
		if line2 in line3:
			flag = True
			k01outputFile.write(line3)
			print(line1)
			continue
		if 


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
