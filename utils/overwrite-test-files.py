import subprocess
import csv
import os
import sys

def setupProjects():
    global data
    global original_data
    data = []
    original_data = []
    with open("/DyPyBench/text/github-url.txt", "r") as csv_file:
        csvReader = csv.reader(csv_file, delimiter=" ")
        for index, row in enumerate(csvReader):
            temp=[]
            temp.append(index + 1)
            temp.append(row[0].split("/")[-1].split(".git")[0])
            temp.append(row[0])
            data.append(temp)
            original_data.append(row)

def get_project_name(proj_no):
    for value in data:
        no, name, url = value
        if(proj_no == no):
            return name

def get_project_no(proj_name):
    for value in data:
        no, name, url = value
        if(proj_name == name):
            return str(no)


if __name__ == '__main__':

    setupProjects()
    path = '/DyPyBench/overwrite_files'
    # Apply exactly the overwrites listed in text/overwrites.txt. This used to
    # iterate os.listdir(path) and crash on the first folder not in
    # github-url.txt (websockets, python-ftfy), so which overwrites got applied
    # depended on the filesystem's directory order. overwrites.txt is the set
    # the published dypybench:projects image ended up with.
    with open("/DyPyBench/text/overwrites.txt", "r") as f:
        override_folder = [line.strip() for line in f if line.strip()]

    for dir in override_folder:
        p1 = os.path.join(path, dir)
        no = get_project_no(dir)
        if no is None or not os.path.isdir(p1):
            sys.exit('ERROR: overwrite "' + dir + '" has no project in github-url.txt or no folder in ' + path)
        p2 = '/DyPyBench/../Project/project' + no
        command = 'cp -r ' + p1 + '/. ' + p2 + '/.'
        print(command)
        subprocess.run([command
            ], shell=True, stderr=subprocess.STDOUT, check=True)
