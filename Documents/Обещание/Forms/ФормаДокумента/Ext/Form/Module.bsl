﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбъектДок = РеквизитФормыВЗначение("Объект");
	Если ОбъектДок.ЭтоНовый() Тогда
		Объект.Автор = ПараметрыСеанса.Пользователь;
		Объект.ДатаСоздания = ТекущаяДатаСеанса();
		УстановитьДоговор();
	Иначе
		Элементы.Дата.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДолжникПриИзменении(Элемент)
	УстановитьДоговор();
КонецПроцедуры

&НаСервере
Процедура УстановитьДоговор()
	
	СписокДоговоров = ОбщийМодульИнформация.ПолучитьДоговорыДолжника(Объект.Должник);
	Если СписокДоговоров.Количество() > 0 Тогда
		Объект.Договор = СписокДоговоров[0];
	КонецЕсли;
	
КонецПроцедуры
