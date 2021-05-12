# ILP mini-HYPER
An ILP implementation in prolog through the use of mini-HYPER for CS3520 Symbolic programming class. 

Contributer Names: 
- Arxeous - Aaron Gonzalez
- Moyenne - Ian Heffernan
- ana569 - Ana Barcenas
# Installation 
## Install SWI-prolog
Follow instructions of installation for your respective operating system:
https://www.swi-prolog.org/download/stable
## Clone
Clone the repository into whatever directory you choose by running
```
git clone https://github.com/arxeous/ILP-HYPER.git
```
# How To Run
1. Open the miniHYPER.pl file with the SWI-prolog IDE either through the command line
```
swipl miniHYPER.pl
```
or by loading the application and clicking the following 
```
File > Consult > Choose file > miniHYPER.pl
```
3. Load anyone of the the provided easy.pl, medium.pl or hard.pl knowledge base files provided in this project, or your own appropriately formatted knowledge base (read report for more details) by typing: 
```
?- ['filename.pl'].
```
4. Run the program to find the target hypothesis by using 
```
?- induce(H).
```

