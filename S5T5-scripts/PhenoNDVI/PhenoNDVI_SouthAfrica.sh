#! /bin/bash

#USER modif
#add directories where SPOT products are to be found
/home/ramona/sen2agri/sen2agri-processors/VegetationStatus/TestScripts/pheno_processing.py --applocation /home/ramona/sen2agri-processors-build --input \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150414_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150414_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150429_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150429_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150504_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150504_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150509_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150509_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150514_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150514_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150519_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150519_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150524_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150524_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150608_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150608_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150613_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150613_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150618_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150618_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150623_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150623_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150628_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150628_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150703_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150703_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150708_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150708_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150718_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150718_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150728_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150728_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150807_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150807_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150817_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150817_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150822_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150822_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150827_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150827_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150901_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150901_N2A_SouthAfricaD0000B0000.xml" \
"/mnt/Sen2Agri_DataSets/L2A/Spot5-T5/SouthAfrica/SPOT5_HRG2_XS_20150911_N2A_SouthAfricaD0000B0000/SPOT5_HRG2_XS_20150911_N2A_SouthAfricaD0000B0000.xml" \
--t0 20150414 --tend 20150911 --outdir /mnt/output/ramona/PhenoNDVI_SouthAfrica
#end of USER modif