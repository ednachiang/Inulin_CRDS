eCAMIoutput = 'S-W37.txt'
eCAMI = open(eCAMIoutput, mode='r')
counter1 = 0
protein1 = '3.2.1.7:'
protein2 = '3.2.1.80:'
protein1count = []
protein2count = []
prodigalffn = '/home/GLBRCORG/echiang3/Saline_MetaG/prodigal/S-W37/S-W37.ffn'
prodigal = open(prodigalffn, mode='r')
output1 = open('S-W37.endo.fa', 'w')
output2 = open('S-W37.exo.fa', 'w')
flag1 = False
flag2 = False


for line1 in eCAMI:
	if '>' in line1:
		counter1 = counter1 + 1

print(counter1)

eCAMI = open(eCAMIoutput, mode='r')
for line2 in eCAMI:
	if protein1 in line2:
		protein1count.append(line2.split(' ')[0])

eCAMI = open(eCAMIoutput, mode='r')
for line3 in eCAMI:
	if protein2 in line3:
		protein2count.append(line3.split(' ')[0])

for x in protein1count:
	flag1 = False
	prodigal = open(prodigalffn, mode='r')
	for line3 in prodigal:
		if x in line3:
			flag1 = True
			output1.write(line3)
			continue
		if '>' in line3 and flag1 == True:
			prodigal.close()
			break
		if flag1 == True:
			output1.write(line3)
			continue

for y in protein2count:
	flag2 = False
	prodigal = open(prodigalffn, mode='r')
	for line4 in prodigal:
		if y in line4:
			flag2 = True
			output2.write(line4)
			continue
		if '>' in line4 and flag2 == True:
			prodigal.close()
			break
		if flag2 == True:
			output2.write(line4)
			continue


eCAMI.close()
prodigal.close()
output1.close()
output2.close()