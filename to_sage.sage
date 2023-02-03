import ast
import os
import zipfile

def load_files(indices=None, genera=None, max_pp_size=None):
    """
    Load files from the database into sage.
    If indices is None, load all indices.
    Otherwise, load only the indices in the list.
    If genera is a list, only load genera from this list.
    If max_pp_size is not None, only load passports with size <= max_pp_size.
    """
    res = {}
    if indices is None:
        indices = list(next(os.walk('.'))[1])
    indices = indices.sort()
    for index in indices:
        res[index] = {}
        for root, dirs, files in os.walk("./"+str(index)):
            genus, signature = root.replace(".","").split("/")[-2:]
            if genera != None and genus != "" and int(genus) not in genera:
                continue
            for file in files:
                if file.endswith(".dat"):
                    file_path = root+"/"+file
                    if max_pp_size != None and get_line_count(file_path) > max_pp_size:
                        continue
                    subgroups = load_subgroups(file_path)
                    monodromy_group = file.replace(".dat","")
                    if genus not in res[index]:
                        res[index][genus] = {}
                    if signature not in res[index][genus]:
                        res[index][genus][signature] = {}                   
                    res[index][genus][signature][monodromy_group] = subgroups
    return res

def count_passports(indices=None, genera=None, max_pp_size=None):
    """
    Count the number of passports for each index.
    """
    counts = {}
    if indices is None:
        indices = list(next(os.walk('.'))[1])
    indices = indices.sort()
    for index in indices:
        count = 0
        for root, dirs, files in os.walk("./"+str(index)):
            genus, signature = root.replace(".","").split("/")[-2:]
            if genera != None and genus != "" and int(genus) not in genera:
                continue
            for file in files:
                if file.endswith(".dat"):
                    file_path = root+"/"+file
                    if max_pp_size != None and get_line_count(file_path) > max_pp_size:
                        continue
                    count += 1
        counts[int(index)] = count
    return counts

def get_line_count(file_path):
    return sum(1 for line in open(file_path)) #Is there a better way?

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

if __name__ == '__main__':
    extract_and_rm_zips() #Unzip and rm zips if they exist
