﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЭтаФорма.Параметры.Свойство("Поиск") Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список);
		
		СтрокаПоиска = ЭтаФорма.Параметры.Поиск;
		
		ГруппаОтбора = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИЛИ;
		ГруппаОтбора.Представление = "Отбор из формы";
		
		РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
		
		Результат = ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора, 
			"Владелец.Наименование", ВидСравненияКомпоновкиДанных.Содержит, СтрокаПоиска, "Должник", ,РежимОтображения);
		Результат = ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора, 
			"НомерДоговора", ВидСравненияКомпоновкиДанных.Содержит, СтрокаПоиска, "Договор", ,РежимОтображения);
	КонецЕсли;
	
КонецПроцедуры
