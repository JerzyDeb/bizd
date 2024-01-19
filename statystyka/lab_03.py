import numpy as np
import pandas as pd
import scipy.stats as stats
from scipy.stats import shapiro
import statistics

# ==============     ZADANIE 1       ====================
print(f'\n=============== ZADANIE 1 ================\n')

sample = np.random.normal(
    loc=2,
    scale=30,
    size=200
)

t, p = stats.ttest_1samp(sample, 2.5)

print(f't = {t}, p = {p}')

# Niska wartość p sugeruje, że mamy podstawy do odrzucenia hipotezy


# ==============     ZADANIE 2       ====================
print(f'\n=============== ZADANIE 2 ================\n')

df = pd.read_csv('files/napoje.csv', sep=';')
lech = df['lech']
cola = df['cola']
regio = df['regionalne']

lech_t, lech_p = stats.ttest_1samp(lech, 60500)
cola_t, cola_p = stats.ttest_1samp(cola, 222000)
regio_t, regio_p = stats.ttest_1samp(regio, 43500)

print(f'lech_t = {lech_t}, lech_p = {lech_p}')
print(f'cola_t = {cola_t}, cola_p = {cola_p}')
print(f'regio_t = {regio_t}, regio_p = {regio_p}')


# ==============     ZADANIE 3       ====================
print(f'\n=============== ZADANIE 3 ================\n')

df = pd.read_csv('files/napoje.csv', sep=';')

results = {col_name: shapiro(df[col_name]) for col_name in df.columns[2:]}

for col_name, result in results.items():
    if result[1] > 0.05:
        print(f'Zmienna {col_name} wykazuje normalność (p={result[1]})')


# ==============     ZADANIE 4       ====================
print(f'\n=============== ZADANIE 4 ================\n')

df = pd.read_csv('files/napoje.csv', sep=';')
okocim = df['okocim']
lech = df['lech']
fanta = df['fanta ']
regio = df['regionalne']
cola = df['cola']
pepsi = df['pepsi']
okocim_lech_t, okocim_lech_p = stats.ttest_ind(okocim, lech)
fanta_regio_t, fanta_regio_p = stats.ttest_ind(fanta, regio)
cola_pepsi_t, cola_pepsi_p = stats.ttest_ind(cola, pepsi)

print(f'okocim_lech_t = {okocim_lech_t}, okocim_lech_p = {okocim_lech_p}')
print(f'fanta_regio_t = {fanta_regio_t}, fanta_regio_p = {fanta_regio_p}')
print(f'cola_pepsi_t = {cola_pepsi_t}, cola_pepsi_p = {cola_pepsi_p}')


# ==============     ZADANIE 5       ====================
print(f'\n=============== ZADANIE 5 ================\n')

df = pd.read_csv('files/napoje.csv', sep=';')
okocim = df['okocim']
lech = df['lech']
fanta = df['fanta ']
zywiec = df['żywiec']
cola = df['cola']
regio = df['regionalne']
okocim_lech_t, okocim_lech_p = stats.levene(okocim, lech)
fanta_zywiec_t, fanta_zywiec_p = stats.levene(fanta, zywiec)
cola_regio_t, cola_regio_p = stats.levene(cola, regio)

print(f'okocim_lech_t = {okocim_lech_t}, okocim_lech_p = {okocim_lech_p}')
print(f'fanta_zywiec_t = {fanta_zywiec_t}, fanta_zywiec_p = {fanta_zywiec_p}')
print(f'cola_regio_t = {cola_regio_t}, cola_regio_p = {cola_regio_p}')


# ==============     ZADANIE 6       ====================
print(f'\n=============== ZADANIE 6 ================\n')

df = pd.read_csv('files/napoje.csv', sep=';')
regio_2001 = df[df['rok'] == 2001]['regionalne']
regio_2015 = df[df['rok'] == 2015]['regionalne']

regio_t, regio_p = stats.ttest_ind(regio_2001, regio_2015)

print(f'regio_t = {regio_t}, regio_p = {regio_p}')

# p < 0.05 ---> Można odrzucić hipotezę


# ==============     ZADANIE 7       ====================
print(f'\n=============== ZADANIE 7 ================\n')

df = pd.read_csv('files/napoje.csv', sep=';')
drinks_df = df[df['rok'] == 2016]
drinks_after_commercial_df = pd.read_csv('files/napoje_po_reklamie.csv', sep=';')
cola = drinks_df['cola']
cola_after_commercial = drinks_after_commercial_df['cola']
fanta = drinks_df['fanta ']
fanta_after_commercial = drinks_after_commercial_df['fanta ']
pepsi = drinks_df['pepsi']
pepsi_after_commercial = drinks_after_commercial_df['pepsi']

cola_t, cola_p = stats.ttest_rel(cola, cola_after_commercial)
fanta_t, fanta_p = stats.ttest_rel(fanta, fanta_after_commercial)
pepsi_t, pepsi_p = stats.ttest_rel(pepsi, pepsi_after_commercial)

print(f'cola_t = {cola_t}, cola_p = {cola_p}')
print(f'fanta_t = {fanta_t}, fanta_p = {fanta_p}')
print(f'pepsi_t = {pepsi_t}, pepsi_p = {pepsi_p}')

# p > 0.05 ---> Brak powodów do odrzucenia hipotezy

