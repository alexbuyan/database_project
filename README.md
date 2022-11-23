# Проект по БД

## Оглавление

- [Задание 1](https://github.com/alexbuyan/database_project#%D0%B7%D0%B0%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-1)
- [Задание 2](https://github.com/alexbuyan/database_project#%D0%B7%D0%B0%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-2)
- to be continued...

## Предметная область - Детский лагерь

### Задание 1

Сущности:

- Родитель ребенка/Контакт на случай ЧП (у одного родителя может быть несколько детей)
- Ребенок (может поехать на несколько смен и у него несколько, обычно 2, вожатых)
- Смена в лагере (проходит на конкретной базе отдыха, на смене один руководитель, несколько детей, несколько вожатых)
- Руководитель смены (может руководить несколькими сменами в разные моменты времени)
- Вожатый (может поехать на несколько смен, работает с несколькими детьми)
- База отдыха (является площадкой для нескольких смен)
- Лечащий врач (на каждой базе отдыха есть прикрепленный к ней один врач)

### Задание 2

a) [Концептуальная модель](https://github.com/alexbuyan/database_project/blob/main/models/2a.jpg)

b) [Логическая модель]()

БД находится во 2-й нормальной форме

Таблица Родителей/Контактов на случай ЧП будет версионной (SCD2)

c) [Физическая модель]()
