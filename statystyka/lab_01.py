import math
import statistics
import matplotlib.pyplot as plt
import pandas as pd


# ==============     ZADANIE 1       ====================
print(f'\n=============== ZADANIE 1 ================\n')

df = pd.read_csv('files/MDR_RR_TB_burden_estimates_2023-12-05.csv')
last_column_values = df['e_rr_in_notified_labconf_pulm_hi']
stats = last_column_values.describe()
print(stats)


# ==============     ZADANIE 2       ====================
print(f'\n=============== ZADANIE 2 ================\n')

df = pd.read_csv('files/Wzrost.csv')
values_list = df.columns.astype(float).tolist()
variance, std_dev = statistics.variance(values_list), statistics.stdev(values_list)
print(f'Wariancja / Odchylenie standardowe: {variance} / {std_dev}')


# ==============     ZADANIE 3       ====================
print(f'\n=============== ZADANIE 3 ================\n')

df = pd.read_csv('files/napoje.csv', sep=';')
pepsi_values = df['pepsi']
stats = pepsi_values.describe()
print(stats)


# ==============     ZADANIE 4       ====================
print(f'\n=============== ZADANIE 4 ================\n')

df = pd.read_csv('files/brain_size.csv', sep=';')

viq_avg = statistics.mean(df['VIQ'])
print(f'Średnia w kolumnie VIQ = {viq_avg}')

df_women = df[df['Gender'] == 'Female']
df_men = df[df['Gender'] == 'Male']

print(f'Liczba kobiet / Liczba mężczyzn: {len(df_women)} / {len(df_men)}')

fig, axs = plt.subplots(1, 3)
axs[0].hist(df['PIQ'], color='r')
axs[0].set_title('PIQ')
axs[1].hist(df['VIQ'], color='g')
axs[1].set_title('VIQ')
axs[2].hist(df['FSIQ'], color='b')
axs[2].set_title('FSIQ')

fig1, axs1 = plt.subplots(1, 3)
axs1[0].hist(df_women['PIQ'], color='r')
axs1[0].set_title('PIQ - Kobiety')
axs1[1].hist(df_women['VIQ'], color='g')
axs1[1].set_title('VIQ - Kobiety')
axs1[2].hist(df_women['FSIQ'], color='b')
axs1[2].set_title('FSIQ - Kobiety')
plt.show()
