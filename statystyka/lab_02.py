import statistics
import numpy as np
from matplotlib import pyplot as plt
import scipy.stats as stats
from scipy.stats import kurtosis, skew

# ==============     ZADANIE 1       ====================
print(f'\n=============== ZADANIE 1 ================\n')

values = [_ for _ in range(1, 7)]
values_avg = statistics.mean(values)
values_med = statistics.median(values)
values_variance = statistics.variance(values)
values_std_dev = statistics.stdev(values)
print(f'Średnia = {values_avg}')
print(f'Mediana = {values_med}')
print(f'Wariancja = {values_variance}')
print(f'Odchylenie standardowe = {values_std_dev}')


# ==============     ZADANIE 2       ====================
print(f'\n=============== ZADANIE 2 ================\n')
size = 100

samples_bernoulli = np.random.choice(
    a=[0, 1],
    size=size,
    p=[1-0.5, 0.5],
)

samples_binomial = np.random.binomial(
    n=10,
    p=0.5,
    size=size,
)

samples_poisson = np.random.poisson(
    3,
    size=size,
)

print(f'Rozkład Bernoulliego: {samples_bernoulli}')
print(f'Rozkład Dwumianowy: {samples_bernoulli}')
print(f'Rozkład Poissona: {samples_poisson}')


# ==============     ZADANIE 3       ====================
print(f'\n=============== ZADANIE 3 ================\n')

bernoulli_avg = statistics.mean(samples_bernoulli)
bernoulli_variance = statistics.variance(samples_bernoulli)
bernoulli_kurtosis = kurtosis(samples_bernoulli)
bernoulli_skew = skew(samples_bernoulli)

print(f'=== Rozkład Bernoulliego ===')
print(f'Średnia = : {bernoulli_avg}')
print(f'Wariancja = : {bernoulli_variance}')
print(f'Kurtoza = : {bernoulli_kurtosis}')
print(f'Skośność = : {bernoulli_skew}')
print('\n\n')

binomial_avg = statistics.mean(samples_binomial)
binomial_variance = statistics.variance(samples_binomial)
binomial_kurtosis = kurtosis(samples_binomial)
binomial_skew = skew(samples_binomial)

print(f'=== Rozkład Dwumianowy ===')
print(f'Średnia = : {binomial_avg}')
print(f'Wariancja = : {binomial_variance}')
print(f'Kurtoza = : {binomial_kurtosis}')
print(f'Skośność = : {binomial_skew}')
print('\n\n')

poisson_avg = statistics.mean(samples_poisson)
poisson_variance = statistics.variance(samples_poisson)
poisson_kurtosis = kurtosis(samples_poisson)
poisson_skew = skew(samples_poisson)

print(f'=== Rozkład Poissona ===')
print(f'Średnia = : {poisson_avg}')
print(f'Wariancja = : {poisson_variance}')
print(f'Kurtoza = : {poisson_kurtosis}')
print(f'Skośność = : {poisson_skew}')
print('\n\n')


# ==============     ZADANIE 4       ====================
print(f'\n=============== ZADANIE 4 ================\n')

fig, axs = plt.subplots(1, 3)
axs[0].hist(samples_bernoulli, color='r')
axs[0].set_title('Rozkład Bernouliego')
axs[1].hist(samples_binomial, color='g')
axs[1].set_title('Rozkład dwumianowy')
axs[2].hist(samples_poisson, color='b')
axs[2].set_title('Rozkład Poissona')
plt.show()


# ==============     ZADANIE 5       ====================
print(f'\n=============== ZADANIE 5 ================\n')

binomial_probabilities = [stats.binom.pmf(k, 20, 0.4) for k in range(20 + 1)]
probabilities_sum = sum(binomial_probabilities)

print(f'Suma Prawdopodobieństw / Czy jest równa 1: {probabilities_sum} / {probabilities_sum == 1}')


# ==============     ZADANIE 6       ====================
print(f'\n=============== ZADANIE 6 ================\n')

samples_normal_100 = np.random.normal(
    loc=0,
    scale=2,
    size=100
)

average_100 = statistics.mean(samples_normal_100)
variance_100 = statistics.variance(samples_normal_100)
kurtosis_100 = stats.kurtosis(samples_normal_100)
skew_100 = stats.skew(samples_normal_100)

samples_normal_200 = np.random.normal(
    loc=0,
    scale=2,
    size=200
)

average_200 = statistics.mean(samples_normal_200)
variance_200 = statistics.variance(samples_normal_200)
kurtosis_200 = stats.kurtosis(samples_normal_200)
skew_200 = stats.skew(samples_normal_200)


print('==== 100 DANYCH ====:')
print(f'Średnia: {average_100}')
print(f'Wariancja: {variance_100}')
print(f'Kurtoza: {kurtosis_100}')
print(f'Skośność: {skew_100}')

print('==== 200 DANYCH ====:')
print(f'Średnia: {average_200}')
print(f'Wariancja: {variance_200}')
print(f'Kurtoza: {kurtosis_200}')
print(f'Skośność: {skew_200}')


# ==============     ZADANIE 7       ====================
print(f'\n=============== ZADANIE 7 ================\n')

size = 100
samples_normal_1 = np.random.normal(
    loc=1,
    scale=2,
    size=size,
)
samples_normal_std = np.random.normal(
    loc=0,
    scale=1,
    size=size,
)
samples_normal_2 = np.random.normal(
    loc=-1,
    scale=0.5,
    size=size,
)

fig1, axs1 = plt.subplots(1, 3)
axs1[0].hist(samples_normal_1, color='r')
axs1[0].set_title('srednia=1;odchylenie=2')
axs1[1].hist(samples_normal_std, color='g')
axs1[1].set_title('Standardowy')
axs1[2].hist(samples_normal_2, color='b')
axs1[2].set_title('srednia=-1;odchylenie=0.5')
plt.show()
