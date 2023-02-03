# A database of subgroups of PSL(2,ℤ)
This database hosts representatives for all subgroups of PSL(2,ℤ) with index < 32 and has been created for our paper [arXiv:2301.02135](https://arxiv.org/abs/2301.02135). A related database for indices < 18 has been computed by [Strömberg](https://github.com/fredstro/noncongruence).

# Structure of the database
The (zipped) folders of this repository represent the indices of the subgroups and the subfolders correspond to the genera. Afterwards we sort the data by the signature of the
corresponding subgroups which is of the form (h, g, n<sub>c</sub>, e<sub>2</sub>, e<sub>3</sub>) for which the variables are given by:
- h: index
- g: genus
- n<sub>c</sub>: amount of cusps
- e<sub>2</sub>: amount of elliptic points of order two
- e<sub>3</sub>: amount of elliptic points of order three

The data is split into passports and the file names correspond to descriptions of the underlying monodromy groups.

# Example usage
To load the database into [Sage](https://www.sagemath.org/), run
```python
sage: load("to_sage.sage")
sage: indices = [i for i in range(2,25)] #Set to None to load all indices, which takes however significant amounts of memory
sage: res = load_files(indices=indices)
```
Additionally, you can filter by the genus and passport size.
