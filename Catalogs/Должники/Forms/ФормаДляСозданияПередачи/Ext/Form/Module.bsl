﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Момент = ТекущаяДатаСеанса();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "Должник");
	РольОтдела = Параметры.РольОтдела;
	ОтделДляПередачи = Передача.ПолучитьОтделДляПередачи(Должник, РольОтдела);
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервере
Функция СоздатьДокументПередачиНаСервере()
	ДокПередача = Документы.ПередачаДолжников.СоздатьДокумент();
	
	ДокПередача.Дата = Момент;
	ДокПередача.Отдел = ОтделДляПередачи;
	ДокПередача.Менеджер = Константы.Менеджер.Получить();
	ДокПередача.СотрМенеджер = Привязка.ПолучитьСотрМенеджера(Должник, Момент);
	ДокПередача.Автор = ПараметрыСеанса.Пользователь;
	
	НоваяСтрока = ДокПередача.Должники.Добавить();
	НоваяСтрока.Должник = Должник;
	
	Попытка
		ДокПередача.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		Сообщить("Не удалось передать должника. " + ОписаниеОшибки(), СтатусСообщения.Внимание);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура СоздатьДокументПередачи(Команда)
	Если ЗначениеЗаполнено(ОтделДляПередачи) = Ложь Тогда
		ПоказатьПредупреждение(, "Не заполнен отдел. Передать невозможно.", 20);
		Возврат;
	КонецЕсли;
	СоздатьДокументПередачиНаСервере();
КонецПроцедуры
