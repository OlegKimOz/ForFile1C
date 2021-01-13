﻿Процедура ОбработкаПроведения(Отказ, Режим)
	Перем ДатаОбещания;
	
	//Отказ = ДоступностьИзмененийПоДатеЗапрета(Дата);
	
	Если ДатаПереноса = '00010101' Тогда
		ДатаОбещания = Дата;
	Иначе	
		ДатаОбещания = ДатаПереноса;
	КонецЕсли; 
	
	Движение = Движения.Обещания.Добавить();
	Движение.Период 		= ДатаОбещания;
	Движение.Сотрудник		= Привязка.ПолучитьСотрудника(Должник,Дата);
	Движение.Должник 		= Должник;
	// +Крылов 2011.03.25
	Движение.Договор 		= Договор;
	// -Крылов 2011.03.25
	Движение.Сумма 			= Сумма;
	Движение.Количество		= 1;
	Если Подтверждение Тогда
		Движение.Подтверждено = Сумма;
	КонецЕсли; 
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	ПереносОбещания.Сортировать("ДатаОбещания Возр");
	
	//Убрать пустые строки
	Ном = 0;
	Пока Ном < (ПереносОбещания.Количество() - 1) Цикл
		Если ПереносОбещания[Ном].ДатаОбещания = '00010101' Тогда
			ПереносОбещания.Удалить(Ном);
			Продолжить;
		КонецЕсли; 
		Ном = Ном + 1;
	КонецЦикла; 
	
	// Записать в реквизит шапки последнюю дату переноса обещания
	Если ПереносОбещания.Количество() = 0 Тогда
		ДатаПереноса = '00010101'; 
	Иначе	
		ДатаПереноса = ПереносОбещания[ПереносОбещания.Количество() - 1].ДатаОбещания; 
	КонецЕсли; 
	
	// +Крылов 2011.03.25
	Если НЕ ЗначениеЗаполнено(Договор) Тогда
		Отказ = Истина;
		#Если Клиент Тогда
		Сообщить("Не заполнен договор!")
		#КонецЕсли
	КонецЕсли;
	// -Крылов 2011.03.25
	
КонецПроцедуры
