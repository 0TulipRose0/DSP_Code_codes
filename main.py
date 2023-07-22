import numpy as np

def get_m(polinom: np.array, phase1: np.array) -> np.array:
    if (len(polinom) != len(phase1)):
        print("Введены неверные исходыне данные.")
    else:
        m = np.array([])
        for i in range(0, 2 ** (len(polinom)) - 1):
            result = sum(phase1 * polinom) % 2
            m = np.append(m, result)
            phase1[1:] = phase1[:len(phase1) - 1]
            phase1[0] = result

        else:
            print(f"Полученная м-последовательность: {m}")
            return m

def summ(arr1: np.array, arr2: np.array) -> np.array:
    result = arr1 + arr2
    for i in range(0, len(result)):
        result[i] = result[i] % 2
    return result


cha_poly_lst1 = [int(x) for x in input("""Введите характеристический многочлен в 2-ичном виде через пробел 
Вводить без учёта первой '1': """).split()]
cha_poly1 = np.asarray(cha_poly_lst1)
phase_lst1 = [int(x) for x in input("Введите фазу в 2-ичном виде через пробел: ").split()]
phase1 = np.asarray(phase_lst1)

m1 = get_m(cha_poly1, phase1) #Первая m-последоватедьность
print("Длина кода первой послед. :", len(m1))

cha_poly_lst2 = [int(x) for x in input("""Введите характеристический многочлен в 2-ичном виде через пробел 
Вводить без учёта первой '1': """).split()]
cha_poly2 = np.asarray(cha_poly_lst2)
phase_lst2 = [int(x) for x in input("Введите фазу в 2-ичном виде через пробел: ").split()]
phase2 = np.asarray(phase_lst2)

m2 = get_m(cha_poly2, phase2) #Первая m-последоватедьность
print("Длина кода первой послед. :", len(m2))

shift_mean = int(input("Введите значение сдвига м-последовательности: "))
m2 = np.roll(m2, shift_mean)
print(f"Итоговый код Голда со сдвигом {shift_mean}: {summ(m1, m2)}")