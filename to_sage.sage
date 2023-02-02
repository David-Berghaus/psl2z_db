import ast
import os
import zipfile

def load_files(indices=None):
    """
    Load files from the database into sage.
    If indices is None, load all indices.
    Otherwise, load only the indices in the list.
    """
    extract_and_rm_zips()
    res = {}
    if indices is None:
        indices = list(next(os.walk('.'))[1])
    for index in indices:
        res[index] = {}
        for root, dirs, files in os.walk("./"+str(index)):
            for file in files:
                if file.endswith(".dat"):
                    subgroups = load_subgroups(root+"/"+file)
                    genus, signature = root.replace(".","").split("/")[-2:]
                    monodromy_group = file.replace(".dat","")
                    if genus not in res[index]:
                        res[index][genus] = {}
                    if signature not in res[index][genus]:
                        res[index][genus][signature] = {}                   
                    res[index][genus][signature][monodromy_group] = subgroups
    return res

def extract_and_rm_zip(file):
    #Extract
    with zipfile.ZipFile(file, 'r') as zip_ref:
        zip_ref.extractall(".")
    #Delete
    os.remove(file)

def extract_and_rm_zips():
    for root, dirs, files in os.walk("."):
        for file in files:
            if file.endswith(".zip"):
                extract_and_rm_zip(file)

def load_subgroups(file_path):
    subgroups = []
    with open(file_path, 'r') as f:
        lines = f.readlines()
        for line in lines:
            perm_1, perm_2 = line.split(";") #Perms are now strings
            perm_1, perm_2 = ast.literal_eval(perm_1), ast.literal_eval(perm_2) #Perms are now lists
            perm_1, perm_2 = Permutation(perm_1), Permutation(perm_2) #Perms are now permutations
            subgroups.append((perm_1,perm_2))
    return subgroups
