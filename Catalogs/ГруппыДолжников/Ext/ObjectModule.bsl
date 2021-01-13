﻿
Процедура ПередЗаписью(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыДолжников.Ссылка
	|ИЗ
	|	Справочник.ГруппыДолжников КАК ГруппыДолжников
	|ГДЕ
	|	ГруппыДолжников.Приоритет = &Приоритет
	|	И ГруппыДолжников.Ссылка <> &Ссылка";
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	Запрос.УстановитьПараметр("Приоритет",Приоритет);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Отказ = Истина;
		#Если Клиент Тогда
			Сообщить("Группа с приоритетом " + Строка(Приоритет) + " уже существует!");
		#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры
