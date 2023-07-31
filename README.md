# Коды "Голда"

## Определение
**Коды Голда** — тип псевдослучайных последовательностей. Значимость этих последовательностей происходит из-за их очень низкой взаимной корреляции. Применяются в **CDMA** и **GPS**.

Оптимальные автокорреляционные свойства могут быть получены и для М-последовательностей, однако, для реализации принципа коллективного доступа необходим большой набор кодов одинаковой длины с хорошими взаимокорреляционными свойствами. Поэтому используется особый класс ПШ-последовательностей, который называют последовательностями Голда. Коды Голда не только позволяют получить большой набор последовательностей, но также и однородные и ограниченные значения взаимокорреляционной функции. Коды Голда хорошо подходят для использования в качестве длинных скремблирующих кодов для беспроводного множественного доступа с кодовым разделением каналов (2^18 − 1 кодов Голда для передачи информации от базовой станции к подвижному объекту, и 2^16 кодов усеченной последовательности для обратного направления).

Последовательности Голда могут быть сгенерированы путём суммирования по модулю 2 двух М-последовательностей одинаковой длины. Результирующие Коды Голда имеют ту же самую длину как и исходные М-последовательности.

Ниже приведены предпочтительные пары М-последовательностей для генерации кодов Голда, число сгенерированных кодов Голда равно 2^m+1, где m — длина сдвигового регистра, длина кода равна  N=2^m-1. Нормализованная ВКФ принимает одно из трех значений в зависимости от m.
![codes](https://github.com/0TulipRose0/DSP_Gold_codes/blob/main/pics/Gold_code.png)
> [Взято с Wikipedia](https://ru.wikipedia.org/wiki/Коды_Голда)

## О самих модулях

Файл **main.py** представляет из себя генератор кодов Голда, написанный на языке Python.

Его задача состоит в предварительном моделировании данного модуля и проверки его выходных данных.
Данный файл способен работать с полиномами разной длины, что весьма *удобно*.
Вводятся данные туда через пробел и **без учёта самой первой единицы полвинома**(то же самое относится к модулю на Verilog)!

Файл же, который написан на языке моделирования **SystemVerilog** представляет из себя уже конкретный модуль, который способен бесконечно генерировать на выходе коды Голда. Сначала он генерирует М-последовательность целиком, а затем уже начинает выдавать их на выход.

Также реализована функция цикличного сдвига в обоих модулях. Применяется она ко 2-ой М-последовательности.
## To do list
- [ ] Доработка тестового окружения
- [ ] Уточнение характеристик и выходных данных модуля
