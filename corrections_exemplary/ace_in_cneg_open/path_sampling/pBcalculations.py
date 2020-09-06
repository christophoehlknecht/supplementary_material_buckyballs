#!/usr/bin/python3.7 -tt

import sys
import re
from operator import itemgetter

def readfile(filename):
  f = open(filename, 'rU')
  file = f.read()
  return file

def readtupels(tupel):
  return(int(tupel[0]))

def getpotentials(file, scheme):
  CHARGES = []
  NPBC_SLV = []
  NPBC_VAC = []
  PBC_SLV = []
  PBC_VAC = []
  FFT_LS = []
  FFT_BM = []
  
  for line in file[1:]:
    templine = line.split()
    if (len(templine) == 0): #for the case that the last line is empty
      break
    CHARGES.append(templine[3])
    NPBC_SLV.append(templine[4])
    NPBC_VAC.append(templine[5])
    PBC_SLV.append(templine[6])
    PBC_VAC.append(templine[7])
    if (scheme == 'BM'):
      FFT_LS.append(templine[8])
      FFT_BM.append(templine[9])
  if (scheme == 'BM'):
    return CHARGES, NPBC_SLV, NPBC_VAC, PBC_SLV, PBC_VAC, FFT_LS, FFT_BM
  elif (scheme == 'LS'):
    return CHARGES, NPBC_SLV, NPBC_VAC, PBC_SLV, PBC_VAC, 0, 0 
  else:
    print('No such scheme: ' + scheme)
    print('Please choose between LS and BM scheme!')
    raise SystemExit

def DGcalculator(chA, chB, condA, condB):
  # ATTENTION, CHARGE OF HOST IS NO MORE HARDCODED HERE!!!
  no_atoms=len(condA)
  DG=0
  for i in range(0, no_atoms):
    DG = DG + (
      (float(chB[i]) - float(chA[i]))/2 * (float(condA[i]) + float(condB[i]))) # NEW in V3: put here dq instead of q (the change of the partial charges instead of the partial charge at lam=1)
  return DG


def main():
  if len(sys.argv) != 4:
    print('USAGE:\n\n ./pBcalculations.py FileA FileB scheme\n')
    print('  FileA ... Output file from dGslv_pbsolv of neutral state')
    print('  FileB ... Output file from dGslv_pbsolv of charged state')
    print('  scheme ... LS or BM')
  else:
    fileA = open(sys.argv[1])  #NEW in V5: reads lines into list instead of file into string
    stateA = fileA.readlines()
    fileA.close()
    fileB = open(sys.argv[2])
    stateB = fileB.readlines()
    fileB.close()
    scheme = sys.argv[3]
    CHARGES_A, NPBC_SLV_A, NPBC_VAC_A, PBC_SLV_A, PBC_VAC_A, FFT_LS_A, FFT_BM_A = getpotentials(stateA, scheme)
    CHARGES_B, NPBC_SLV_B, NPBC_VAC_B, PBC_SLV_B, PBC_VAC_B, FFT_LS_B, FFT_BM_B = getpotentials(stateB, scheme)
    DG_NPBC_SLV = DGcalculator(CHARGES_A, CHARGES_B, NPBC_SLV_A, NPBC_SLV_B)
    DG_NPBC_VAC = DGcalculator(CHARGES_A, CHARGES_B, NPBC_VAC_A, NPBC_VAC_B)
    DG_PBC_SLV = DGcalculator(CHARGES_A, CHARGES_B, PBC_SLV_A, PBC_SLV_B)
    DG_PBC_VAC = DGcalculator(CHARGES_A, CHARGES_B, PBC_VAC_A, PBC_VAC_B)
    if scheme == 'BM':
      DG_FFT_LS = DGcalculator(CHARGES_A, CHARGES_B, FFT_LS_A, FFT_LS_B)
      DG_FFT_BM = DGcalculator(CHARGES_A, CHARGES_B, FFT_BM_A, FFT_BM_B)
      DG_FFT = DG_FFT_LS - DG_FFT_BM #actually, it should be BM-LS, but this is done only for PBC, and this enters into DG_POL as - DG_PBC, it gets -(BM-LS) = LS - BM 
    DG_NPBC = DG_NPBC_SLV - DG_NPBC_VAC
    DG_PBC = DG_PBC_SLV - DG_PBC_VAC
    DG_POL = DG_NPBC - DG_PBC
    print('\n********RESULTS NPBC********\n')
    print('DG_NPBC_SLV [kJ/mol]: ' + str(round(DG_NPBC_SLV, 3)) + '\n')
    print('DG_NPBC_VAC [kJ/mol]: ' + str(round(DG_NPBC_VAC, 3)) + '\n')
    print('DG_NPBC [kJ/mol]: ' + str(round(DG_NPBC, 3)) + '\n')
    print('\n********RESULTS PBC********\n')
    print('DG_PBC_SLV [kJ/mol]: ' + str(round(DG_PBC_SLV, 3)) + '\n')
    print('DG_PBC_VAC [kJ/mol]: ' + str(round(DG_PBC_VAC, 3)) + '\n')
    print('DG_PBC [kJ/mol]: ' + str(round(DG_PBC, 3)) + '\n')
    if scheme == 'BM':
      print('\n********RESULTS FFT PBC********\n')
      print('DG_FFT_LS [kJ/mol]: ' + str(round(DG_FFT_LS, 3)) + '\n')
      print('DG_FFT_BM [kJ/mol]: ' + str(round(DG_FFT_BM, 3)) + '\n')
      print('DG_FFT [kJ/mol]: ' + str(round(DG_FFT, 3)) + '\n')
    print('\n********RESULTS NPBC - PBC********\n')
    if scheme == 'LS':
      print('DGpol [kJ/mol]: ' + str(round(DG_POL, 3)) + '\n')
    if scheme == 'BM':
      print('DGpol [kJ/mol]: ' + str(round(DG_POL + DG_FFT, 3)) + '\n')
    print('**********************\n\n')


  
if __name__ == '__main__':
  main()
  
