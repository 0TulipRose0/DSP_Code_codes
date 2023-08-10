import numpy as np

def get_m(polinom: np.array, phase1: np.array, flag: int, shift: int, operation: bool) -> np.array:
    if (len(polinom) != len(phase1)):
        print("Введены неверные исходыне данные.")
        raise SystemExit
    else:
        m = np.array([])
        if(flag):
            print("Генерация фазы для 'case': ")
            print(f"{len(phase1)}'d0: phase <= {len(phase1)}'b", end="")
            for j in range(len(phase1)):
                print(f"{phase1[j]}", sep="", end="")
            print(f";")
        for i in range(1, 2 ** (len(polinom))):
            result = sum(phase1 * polinom) % 2
            m = np.append(m, result)
            phase1[1:] = phase1[:len(phase1) - 1]
            phase1[0] = result
            if(flag):
                print(f"{len(phase1)}'d{i}: phase <= {len(phase1)}'b", end="")
                for j in range(len(phase1)):
                    print(f"{phase1[j]}", sep="", end="")
                print(f";")

        if(shift == 0):
            if(operation == False):
                print(f"Полученная м-последовательность: {m}")
                return m
            else:
                return m
        else:
            if(operation == False):
                print(f"Полученная м-последовательность: {np.roll(m, (-shift))}")
                return np.roll(m, (-shift))
            else:
                return np.roll(m, (-shift))

def summ(arr1: np.array, arr2: np.array) -> np.array:
    result = arr1 + arr2
    for i in range(0, len(result)):
        result[i] = result[i] % 2
    return result

def gold_code(fcha_poly1, fphase1, fcha_poly2, fphase2):
    for i in range(0, 2 ** (len(fcha_poly1))):
        m1_f = get_m(fcha_poly1, fphase1, 0, 0, True)
        m2_f = get_m(fcha_poly2, fphase2, 0, i, True)
        sum_f = summ(m1_f, m2_f)
        print(f"""6'd{i}: begin        
                if(final_gold_code == 63'b""", end = "")
        for j in range(len(sum_f)):
            print(f"{int(sum_f[j])}", sep="", end="")
        print(f") begin", end = "")
        print("""
                shift_state <= shift_state + 1'b1;
                correct_count <= correct_count + 1;
                $display("Shift %0d is correct!", shift_state);
                end else begin
                $display("Error in %0d phase in generator", shift_state);
                $display("You're code is %0b", final_gold_code);
                shift_state <= shift_state + 1'b1;
                end
              end """)




cha_poly_lst1 = [int(x) for x in input("""Введите характеристический многочлен в 2-ичном виде через пробел 
Вводить без учёта первой '1': """).split()]
cha_poly1 = np.asarray(cha_poly_lst1)
phase_lst1 = [int(x) for x in input("Введите фазу в 2-ичном виде через пробел: ").split()]
phase1 = np.asarray(phase_lst1)
shift_mean1 = int(input("Введите значение сдвига m-последовательности: "))
gen1 = int(input("Надо ли генерировать case для 1-ой последовательности?(1 - да, 0 - нет): "))

m1 = get_m(cha_poly1, phase1, gen1, shift_mean1, False) #Первая m-последовательность
print("Длина кода первой послед. :", len(m1))

cha_poly_lst2 = [int(x) for x in input("""Введите характеристический многочлен в 2-ичном виде через пробел 
Вводить без учёта первой '1': """).split()]
cha_poly2 = np.asarray(cha_poly_lst2)
phase_lst2 = [int(x) for x in input("Введите фазу в 2-ичном виде через пробел: ").split()]
phase2 = np.asarray(phase_lst2)
shift_mean2 = int(input("Введите значение сдвига m-последовательности: "))
gen2 = int(input("Надо ли генерировать case для 2-ой последовательности?(1 - да, 0 - нет): "))

m2 = get_m(cha_poly2, phase2, gen2, shift_mean2, False) #Вторая m-последовательность
print("Длина кода второй послед. :", len(m2))

print(f"Итоговый код Голда со сдвигом {shift_mean2}: {summ(m1, m2)}")

gen_gold = int(input(f"Нужно ли генерировать набор кодов голда?(1 - да, 0 - нет): "))
if(gen_gold):
    gold_code(cha_poly1, phase1, cha_poly2, phase2)
else:
    raise SystemExit
