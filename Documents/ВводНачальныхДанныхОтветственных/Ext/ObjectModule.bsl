﻿Процедура ОбработкаПроведения(Отказ, Режим)
	Отказ = ДоступностьИзмененийПоДатеЗапрета(Дата);
	Для Каждого ТекСтрокаДолжники Из Должники Цикл
		// регистр ПривязкаОтветственный 
		Движение = Движения.ПривязкаОтветственный.Добавить();
		Движение.Период 		= Дата;
		Движение.Должник 		= ТекСтрокаДолжники.Должник;
		Движение.Ответственный 	= ТекСтрокаДолжники.Сотрудник;
	КонецЦикла;
КонецПроцедуры

