endoFile = 'I-P01.endoinulinase.txt'
exoFile = 'I-P01.exoinulinase.txt'
endo = open(endoFile, mode='r')
exo = open(exoFile, mode='r')
faFile = 'I-P01.GH32.fa'
fa = open(faFile, mode='r')
k01outputFile = open('I-P01.endoinulinase.fa', 'a')
k02outputFile = open('I-P01.exoinulinase.fa', 'a')
counter1 = 0
counter2 = 0
contigNames  = []
flag1 = False
flag2 = False

for line1 in endo:
	flag = False
	print(line1)
	fa = open(faFile, mode='r')
	k01outputFile = open('I-P01.endoinulinase.fa', 'a')
	for line2 in fa:
		if line1 in line2:
			flag = True
			k01outputFile.write(line2)
			print(line2)
			continue
		if '>' in line2 and flag == True:
			k01outputFile.close()
			break
		if flag == True:
			k01outputFile.write(line2)

for line3 in exo:
	flag = False
	print(line1)
	fa = open(faFile, mode='r')
	k02outputFile = open('I-P01.exoinulinase.fa', 'a')
	for line4 in fa:
		if line3 in line4:
			flag = True
			k02outputFile.write(line4)
			print(line4)
			continue
		if '>' in line4 and flag == True:
			k02outputFile.close()
			break
		if flag == True:
			k02outputFile.write(line4)


endo.close()
exo.close()
k01outputFile.close()
k02outputFile.close()
fa.close()
