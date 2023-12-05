#######     ZADANIE 1       #######

import pandas as pd

df = pd.read_csv('files/MDR_RR_TB_burden_estimates_2023-12-05.csv')
last_column_values = df['e_rr_in_notified_labconf_pulm_hi']
stats = last_column_values.describe()
print(stats)


#######     ZADANIE 2       #######
