#!/usr/bin/env python
# mapper.py
import sys

#--- obtener todas las lineas desde stdin ---
for line in sys.stdin:
    #--- eliminar blancos
    line = line.strip()
    
    #--- dividir la linea entre palabras ---
    data = line.split()
    numerofila = data[0].strip()
    ngram = data[1].strip()
    year = data[2].strip()
    count = data[3].strip()
    
    key = ngram + '-' + year
    
    #--- tuplas de salida [word,1] in formato delimitado por TAB--
    print(key + '\t' + count)