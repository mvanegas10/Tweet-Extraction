import os
cwd = os.getcwd()

txt = open("%s/tweets.csv" % (cwd))
txt_new = open("%s/tweets_new.txt" % (cwd),'w')

directory = dict()

line = txt.read()
while(line):
    words = line.split(" ")
    for word in words:
        word = word.replace(",","").replace(" ","").replace(".","").replace('"',"")
        directory[word] =  directory.get(word, 0) + 1
    line = txt.read()

items = sorted(directory.iteritems(), key=lambda x: x[1], reverse=True)

for i,item in enumerate(items):
	# print(item[0] + "," + str(item[1]))
	info = item[0].split(" ")
	txt_new.write(info[0] + "," + info[1] + "," + str(item[1]) + "\n")

    