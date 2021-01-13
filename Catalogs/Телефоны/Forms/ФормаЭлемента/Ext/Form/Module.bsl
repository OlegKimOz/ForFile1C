﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Владелец") Тогда
		Объект.Владелец = Параметры.Владелец;
	КонецЕсли;
	
	Об = РеквизитФормыВЗначение("Объект");
	Объект.ЭтоНовый = Об.ЭтоНовый();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНаименование() Экспорт
	Объект.Наименование = СокрЛП(Объект.Номер) + ", " + СокрЛП(Объект.Тип) + " " + глПредставлениеПодтверждения(Объект.Подтверждение);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	ОбновитьНаименование();
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииЭлементовНомера(Элемент)
	ОбновитьНаименование();
КонецПроцедуры
