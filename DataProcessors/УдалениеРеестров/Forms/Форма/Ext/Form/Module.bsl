﻿&НаКлиенте
Процедура ОбработатьКомандуФормы(Команда)
	Если Команда.Имя = "ОбезличитьРеестр" Тогда
		ОбезличитьРеестр();
	ИначеЕсли Команда.Имя = "ОчиститьСамРеестр" Тогда
		ОчиститьСамРеестр();
	ИначеЕсли Команда.Имя = "УдалитьВсюИнформациюПоРеестру" Тогда
		УдалитьВсюИнформациюПоРеестру();
	КонецЕсли;
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура УдалитьВсюИнформациюПоРеестру()

	// * Обезличить договора
	// * ПолучитьСписокДолжников в ТЗ
	// * Получить ТЗ Должник-Договор
	// * Получить не удаляемые договора
	
	// * Получить Запрос Должник-Договор
	// * Создать таблицу Не Удаляемых должников
	// * ПолучитьСписок Удаляемых Должников
	// * Обезличить Удаляемых Должников
	//   По списку удаляемых должников получить, обезличить,пометить на удаление 
	// *   Адреса
	// *   Телефоны
	// *   ДоплонительныеДанные 
	
	// * Получить Документ-Обновления реестра, очистить и удалить
	// * Получить Документ-Платежи, очистить и удалить
	// * Получить Документ-Контакты, очистить и удалить
	// * Получить Документ-Обещания, очистить и удалить
	// * Получить Документ-Реестр, очистить и удалить
	// * УдалениеДокументовПередачаДолжников(ТабУдаляемых)
	// * УдалениеДокументовПланирование(ТабУдаляемых)
	
	//   Сделать удаление помеченных объектов
	Если ЗначениеЗаполнено(Реестр) И (УдалитьРеестр = Истина) Тогда
		ПустаяДата = Дата('00010101');
		
		ТабНеУдаляемых = Новый ТаблицаЗначений;
		ТабНеУдаляемых.Колонки.Добавить("Должник");
		
		ТабУдаляемых = Новый ТаблицаЗначений;
		ТабУдаляемых.Колонки.Добавить("Должник");
		
		ТабНеУдалДоговор = Новый ТаблицаЗначений;
		ТабНеУдалДоговор.Колонки.Добавить("Договор");
		
		ТабУдалДоговор = Новый ТаблицаЗначений;
		ТабУдалДоговор.Колонки.Добавить("Договор");
		
		ТабДолжников = Реестр.Должники.Выгрузить(, "Должник");
		ТабДоговоров = Реестр.Должники.Выгрузить(, "Договор");
		ТабДолжникДоговор = Реестр.Должники.Выгрузить(, "Должник, Договор");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обезличивание Договоров - начало - " + ТекущаяДатаСеанса());
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	Реестр.Должники.(
		               |		Договор КАК Договор
		               |	) КАК Должники
		               |ИЗ
		               |	Документ.Реестр КАК Реестр
		               |ГДЕ
		               |	Реестр.Дата МЕЖДУ &НачДата И &КонДата
		               |	И Реестр.Должники.Договор В ИЕРАРХИИ(&ДоговорСп)";
		
		Запрос.УстановитьПараметр("ДоговорСп", ТабДоговоров);
		Запрос.УстановитьПараметр("КонДата", КонецДня(ТекущаяДата()));
		Запрос.УстановитьПараметр("НачДата", (Реестр.Дата + 10));
		
		Результат = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ДолжникиВыборкаДетальныеЗаписи = ВыборкаДетальныеЗаписи.Должники.Выбрать();
			Пока ДолжникиВыборкаДетальныеЗаписи.Следующий() Цикл
				СтрокаДоговор = ТабНеУдалДоговор.Добавить();
				СтрокаДоговор.Договор = ДолжникиВыборкаДетальныеЗаписи.Договор;
				
				СтрокаТабНеУдаляемых = ТабНеУдаляемых.Добавить();
				СтрокаТабНеУдаляемых.Должник = ДолжникиВыборкаДетальныеЗаписи.Договор.Владелец;
			КонецЦикла;
		КонецЦикла;
		
		Н = 0;
		Для Каждого Стр из ТабДоговоров Цикл
			Н = Н+1;	
			ДоговорНеУдаляемый = ТабНеУдалДоговор.Найти(Стр.Договор);
			Если ДоговорНеУдаляемый = Неопределено Тогда
				//Состояние("Договора обезличивание - "+Н);
				Дог = Стр.Договор.ПолучитьОбъект();
				Дог.УстановитьПометкуУдаления(Истина,);
				Дог.Валюта = Справочники.Валюты.ПустаяСсылка();
				Дог.Наименование = "";
				Дог.НомерДоговора = "";
				Дог.ДатаВозникновенияДолга = ПустаяДата;
				Дог.ДатаЕжемесячногоПлатежа = ПустаяДата;
				Дог.ДатаОкончанияДоговора = ПустаяДата;
				Дог.ДатаРасчетаЗадолженности = ПустаяДата;
				Дог.ДатаФинансирования = ПустаяДата;
				Дог.ДлительностьКредита = 0;
				Дог.ДополнительныеСвойства = "";
				Дог.НомерРасчетногоСчета = "";
				Дог.НомерСсудногоСчета = "";
				Дог.СуммаЕжемесячногоПлатежа = 0;
				Дог.СуммаКредита = 0;
				Дог.ТипКредита = Справочники.ТипыКредитов.ПустаяСсылка();
				Дог.Записать();
			КонецЕсли;
		КонецЦикла;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обезличивание Договоров - " + Н + " - " + ТекущаяДатаСеанса());
		
		ТабДоговоровДолжников = ПолучитьДоговораДолжников(ТабДолжников);

		Если Не ТабДоговоровДолжников = Неопределено Тогда 
			// ищем удаляемых должников
			Для Каждого СтрДоговора из ТабДолжникДоговор Цикл
				Для Каждого СтрДД из ТабДоговоровДолжников Цикл
					Если СтрДоговора.Должник = СтрДД.Владелец Тогда
						Если Не СтрДоговора.Договор = СтрДД.Ссылка Тогда
							СтрНе = ТабНеУдаляемых.Добавить();
							СтрНе.Должник = СтрДоговора.Должник;
						КонецЕсли;
					КонецЕсли;	
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
		ТабНеУдаляемых.Свернуть("Должник",);

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Получены НеУдаляемые - " + ТекущаяДатаСеанса());
		Для Каждого СтрД из ТабДолжников Цикл
			Если ТабНеУдаляемых.Найти(СтрД.Должник) = Неопределено Тогда
				СтрД2 = ТабУдаляемых.Добавить();
				СтрД2.Должник = СтрД.Должник;
			КонецЕсли;
		КонецЦикла;	
		ТабУдаляемых.Свернуть("Должник",);
		
		Для Каждого СтрД из ТабДоговоров Цикл
			Если ТабНеУдалДоговор.Найти(СтрД.Договор) = Неопределено Тогда
				СтрД2 = ТабУдалДоговор.Добавить();
				СтрД2.Договор = СтрД.Договор;
			КонецЕсли;
		КонецЦикла;	
		ТабУдалДоговор.Свернуть("Договор",);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Получены Удаляемые - " + ТекущаяДатаСеанса());
		
		Н = 0;
		Для Каждого Стр из ТабУдаляемых Цикл
			Н = Н+1;	
			//Состояние("Должники  обезличивание - "+Н);
			Дог = Стр.Должник.ПолучитьОбъект();
			Дог.УстановитьПометкуУдаления(Истина,);
			Дог.IDДолжника = "";
			Дог.Фамилия = "";
			Дог.Имя = "";
			ДОг.Отчество = "";  
			Дог.Наименование = "";
			Дог.ДатаРождения = ПустаяДата;
			Дог.НомерПаспорта = "";
			Дог.ПаспортКемВыдан = "";
			Дог.ПаспортКогдаВыдан = ПустаяДата;
			Дог.Район = "";
			Дог.Регион = "";
			Дог.Записать();
		КонецЦикла;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обезличивание Должников - "+Н+" - " + ТекущаяДатаСеанса());

		УдалитьТелефоны(ТабУдаляемых);
		УдалитьАдреса(ТабУдаляемых);
		УдалитьДопДанные(ТабУдаляемых);

	КонецЕсли;	
	
	// ТабУдалДоговоров - получить
	
	УдалениеОбновлениеРеестра(ТабУдалДоговор);
	УдалениеПлатежей(ТабУдалДоговор);
	УдалениеДокументовОбещание(ТабУдалДоговор);
	УдалениеДокументовКонтактов(ТабУдаляемых);
	УдалениеДокументовПередачаДолжников(ТабУдаляемых);
	УдалениеДокументовПланирование(ТабУдаляемых);
	
	УдалениеПомеченных();
	УдалитьРеестр = Ложь;
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Удаление Связанной информации Реестра завершено! - " + ТекущаяДатаСеанса());
КонецПроцедуры

Процедура ОчиститьСамРеестр()
	Если ЗначениеЗаполнено(Реестр)и (УдалитьРеестр = Истина) Тогда
		ДокРеестр = Реестр.ПолучитьОбъект();
		Если ДокРеестр = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не найден документ Реестр!");
		Иначе
			Если ДокРеестр.Проведен Тогда
				ДокРеестр.Записать(РежимЗаписиДокумента.ОтменаПроведения);
			КонецЕсли;
			ДокРеестр.УстановитьПометкуУдаления(Истина);
			ДокРеестр.Должники.Очистить();
			ДокРеестр.Записать(РежимЗаписиДокумента.Запись);
			
			УдалениеПомеченных();
			Реестр = Документы.Реестр.ПустаяСсылка();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Удаление реестра завершено!  -  "+ТекущаяДата());
		КонецЕсли;
	КонецЕсли;
	УдалитьРеестр = Ложь;
КонецПроцедуры

Процедура УдалениеПомеченных()
	Попытка
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Начало удаления помеченных объектов - " + ТекущаяДатаСеанса());
		УстановитьМонопольныйРежим(Истина);
		
		Помеченные = НайтиПомеченныеНаУдаление();
		Найденные = 0;
		УдалитьОбъекты(Помеченные, Истина, Найденные);
		
		УстановитьМонопольныйРежим(Ложь);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Окончание удаления помеченных объектов - " + ТекущаяДатаСеанса());
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("К базе подключены пользователи.Монопольный режим установить невозможно!");
	КонецПопытки;
КонецПроцедуры

Процедура УдалениеОбновлениеРеестра(ТабДоговоров)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОбновлениеРеестра.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.ОбновлениеРеестра КАК ОбновлениеРеестра
	               |ГДЕ
	               |	ОбновлениеРеестра.Должники.Договор В ИЕРАРХИИ(&ДоговорСп)";

	Запрос.УстановитьПараметр("ДоговорСп", ТабДоговоров);

	Результат = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Н = 0;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Н = Н + 1;
		//Состояние("Обработка Документов Обновление реестра - "+Н);
		Докум = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		Если Не Докум = Неопределено Тогда
				// По табличной части удалить строки с нашим должником из таблицы
				ТаблицаУдаляемыхСрок = Новый ТаблицаЗначений;
				ТаблицаУдаляемыхСрок.Колонки.Добавить("СтрокаДок");
				Для Каждого СтрДокум из Докум.Должники Цикл
					ТекДоговор = СтрДокум.Договор;
					Если Не ТабДоговоров.Найти(ТекДоговор)=Неопределено Тогда
						СтрД3 = ТаблицаУдаляемыхСрок.Добавить();
						СтрД3.СтрокаДок = СтрДокум;
					КонецЕсли;
				КонецЦикла;
				Для Каждого УдаляемаяСтрока из ТаблицаУдаляемыхСрок Цикл
					Докум.Должники.Удалить(УдаляемаяСтрока.СтрокаДок);
				КонецЦикла;
				Если Докум.Проведен Тогда
					Докум.Записать(РежимЗаписиДокумента.Проведение);
				Иначе
					Докум.Записать(РежимЗаписиДокумента.Запись);
				КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обработано Документов Обновление реестра - " + Н + "  " + ТекущаяДатаСеанса());
КонецПроЦедуры

Процедура ОбезличитьРеестр()
	// * Обезличить договора
	//   Получить не удаляемые договора
	// * ПолучитьСписокДолжников в ТЗ
	// * Получить ТЗ Должник-Договор
	
	// * Получить Запрос Должник-Договор
	// * Создать таблицу Не Удаляемых должников
	// * ПолучитьСписок Удаляемых Должников
	// * Обезличить Удаляемых Должников
	//   По списку удаляемых должников получить, обезличить,пометить на удаление 
	// *   Адреса
	// *   Телефоны
	// *   ДоплонительныеДанные 
	//   Сделать удаление помеченных объектов
	
	Если ЗначениеЗаполнено(Реестр) Тогда
		ПустаяДата = Дата('00010101');
		
		ТабНеУдаляемых = Новый ТаблицаЗначений;
		ТабНеУдаляемых.Колонки.Добавить("Должник");
		
		ТабУдаляемых = Новый ТаблицаЗначений;
		ТабУдаляемых.Колонки.Добавить("Должник");
		
		ТабНеУдалДоговор = Новый ТаблицаЗначений;
		ТабНеУдалДоговор.Колонки.Добавить("Договор");
		
		ТабДолжников      = Реестр.Должники.Выгрузить(,"Должник");
		ТабДоговоров      = Реестр.Должники.Выгрузить(,"Договор");
		ТабДолжникДоговор = Реестр.Должники.Выгрузить(,"Должник,Договор");
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	Реестр.Должники.(
		               |		Договор КАК Договор
		               |	) КАК Должники
		               |ИЗ
		               |	Документ.Реестр КАК Реестр
		               |ГДЕ
		               |	Реестр.Дата МЕЖДУ &НачДата И &КонДата
		               |	И Реестр.Должники.Договор В ИЕРАРХИИ(&ДоговорСп)";
		
		Запрос.УстановитьПараметр("ДоговорСп", ТабДоговоров);
		Запрос.УстановитьПараметр("КонДата",   КонецДня(ТекущаяДатаСеанса()));
		Запрос.УстановитьПараметр("НачДата",   (Реестр.Дата+10));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обезличивание Договоров - начало - " + ТекущаяДатаСеанса());
		
		Результат = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ДолжникиВыборкаДетальныеЗаписи = ВыборкаДетальныеЗаписи.Должники.Выбрать();
			Пока ДолжникиВыборкаДетальныеЗаписи.Следующий() Цикл
				СтрокаДоговор = ТабНеУдалДоговор.Добавить();
				СтрокаДоговор.Договор = ДолжникиВыборкаДетальныеЗаписи.Договор;
				
				СтрокаТабНеУдаляемых = ТабНеУдаляемых.Добавить();
				СтрокаТабНеУдаляемых.Должник = ДолжникиВыборкаДетальныеЗаписи.Договор.Владелец;
			КонецЦикла;
		КонецЦикла;
		
		ТабНеУдалДоговор.Свернуть("Договор",);
		Н = 0;
		ПустаяВалюта = Справочники.Валюты.ПустаяСсылка();
		Для Каждого Стр из ТабДоговоров Цикл
			ДоговорНеУдаляемый = ТабНеУдалДоговор.Найти(Стр.Договор);
			Если ДоговорНеУдаляемый = Неопределено Тогда
				Н = Н+1;
				//Состояние("Договора обезличивание - "+Н);
				Дог = Стр.Договор.ПолучитьОбъект();
				Дог.УстановитьПометкуУдаления(Истина,);
				Дог.Валюта = ПустаяВалюта;
				Дог.Наименование = "";
				Дог.ДатаВозникновенияДолга = ПустаяДата;
				Дог.ДатаЕжемесячногоПлатежа = ПустаяДата;
				Дог.ДатаОкончанияДоговора = ПустаяДата;
				Дог.ДатаРасчетаЗадолженности = ПустаяДата;
				Дог.ДатаФинансирования = ПустаяДата;
				Дог.ДлительностьКредита = 0;
				Дог.ДополнительныеСвойства = "";
				Дог.НомерРасчетногоСчета = "";
				Дог.НомерСсудногоСчета = "";
				Дог.СуммаЕжемесячногоПлатежа = 0;
				Дог.СуммаКредита = 0;
				Дог.ТипКредита = Справочники.ТипыКредитов.ПустаяСсылка();
				Дог.Записать();
			КонецЕсли;
		КонецЦикла;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обезличивание Договоров - " + Н + " - " + ТекущаяДатаСеанса());
		
		ТабДоговоровДолжников = ПолучитьДоговораДолжников(ТабДолжников);

		Если Не ТабДоговоровДолжников = Неопределено Тогда 
			// ищем удаляемых должников
			Для Каждого СтрДоговора из ТабДолжникДоговор Цикл
				Для Каждого СтрДД из ТабДоговоровДолжников Цикл
					Если СтрДоговора.Должник = СтрДД.Владелец Тогда
						Если Не СтрДоговора.Договор = СтрДД.Ссылка Тогда
							СтрНе = ТабНеУдаляемых.Добавить();	
							СтрНе.Должник = СтрДоговора.Должник;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
		ТабНеУдаляемых.Свернуть("Должник");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Получены Не Удаляемые - " + ТекущаяДатаСеанса());
		Для Каждого СтрД из ТабДолжников Цикл
			Если ТабНеУдаляемых.Найти(СтрД.Должник) = Неопределено Тогда
				СтрД2 = ТабУдаляемых.Добавить();
				СтрД2.Должник = СтрД.Должник;
			КонецЕсли;
		КонецЦикла;	
		ТабУдаляемых.Свернуть("Должник");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Получены Удаляемые - " + ТекущаяДатаСеанса());
		Н = 0;
		Для Каждого Стр из ТабУдаляемых Цикл
			Н = Н+1;
			//Состояние("Должники  обезличивание - "+Н);
			Дог = Стр.Должник.ПолучитьОбъект();
			Дог.УстановитьПометкуУдаления(Истина,);
			Дог.IDДолжника = "";
			Дог.ДатаРождения = ПустаяДата;
			Дог.НомерПаспорта = "";
			Дог.ПаспортКемВыдан = "";
			Дог.ПаспортКогдаВыдан = ПустаяДата;
			Дог.Район = "";
			Дог.Регион = "";
			Дог.Записать();
		КонецЦикла;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обезличивание Должников - "+Н+" - " + ТекущаяДатаСеанса());
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обезличивание Контактной информации - начало - " + ТекущаяДатаСеанса());
		УдалитьТелефоны(ТабУдаляемых);
		УдалитьАдреса(ТабУдаляемых);
		УдалитьДопДанные(ТабУдаляемых);
		
	КонецЕсли;
	УдалениеПомеченных();
КонецПроцедуры

Процедура УдалениеПлатежей(ТабДоговоров)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Платежи.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.Платежи КАК Платежи
	               |ГДЕ
	               |	Платежи.Должники.Договор В ИЕРАРХИИ(&ДоговорСп)";

	Запрос.УстановитьПараметр("ДоговорСп", ТабДоговоров);

	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Н = 0;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Н = Н + 1;
		//Состояние("Обработка Документов Платежи - "+Н);
		Докум = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		Если Не Докум = Неопределено Тогда
			ТаблицаУдаляемыхСрок = Новый ТаблицаЗначений;
			ТаблицаУдаляемыхСрок.Колонки.Добавить("СтрокаДок");
			Если Не Докум = Неопределено Тогда
				// По табличной части удалить строки с нашим должником из таблицы
				Для Каждого СтрДокум из Докум.Должники Цикл
					ТекДоговор = СтрДокум.Договор;
					Если Не ТабДоговоров.Найти(ТекДоговор) = Неопределено Тогда
						СтрД3 = ТаблицаУдаляемыхСрок.Добавить();
						СтрД3.СтрокаДок = СтрДокум;
					КонецЕсли;
				КонецЦикла;
				Для Каждого Стр4 из ТаблицаУдаляемыхСрок Цикл
					Докум.Должники.Удалить(Стр4.СтрокаДок);
				КонецЦикла;
				Если Докум.Проведен Тогда
					Докум.Записать(РежимЗаписиДокумента.Проведение);
				Иначе
					Докум.Записать(РежимЗаписиДокумента.Запись);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обработано Документов Платежи - "+Н+ "  "+ТекущаяДатаСеанса());
КонецПроЦедуры

Процедура УдалениеДокументовКонтактов(ТабУдаляемых)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Контакт.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.Контакт КАК Контакт
	               |ГДЕ
	               |	Контакт.Должник В ИЕРАРХИИ(&ДолжникСп)
	               |	И Контакт.Дата МЕЖДУ &НачДата И &КонДата";
	ПустаяДата =  Дата('00010101');
	Запрос.УстановитьПараметр("НачДата", ПустаяДата);
	Запрос.УстановитьПараметр("КонДата", КонецДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("ДолжникСп", ТабУдаляемых);

	ПустойДолжник = Справочники.Должники.ПустаяСсылка();
	Н = 0;
	Результат = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Н = Н + 1;
		//Состояние("Удаление Документов Контакт - "+Н);
		Докум = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		Если Не Докум = Неопределено Тогда
			Если Докум.Проведен Тогда
				Докум.Записать(РежимЗаписиДокумента.ОтменаПроведения);
			КонецЕсли;
			Если Не Докум.ПометкаУдаления Тогда
				Докум.Прочитать();
				Докум.Записать(РежимЗаписиДокумента.Запись);
				//Докум.Записать();
				Докум.Должник = ПустойДолжник;
				Докум.Комментарий = "";
				Докум.Телефоны.Очистить();
				Докум.Адреса.Очистить();
				Докум.Записать();
				Попытка
					Докум.Ссылка.ПолучитьОбъект().УстановитьПометкуУдаления(Истина);
				Исключение
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удален Документ Контакт "+Строка(Докум.Номер)+"  " +Докум.Дата);
				КонецПопытки;
				//Докум.Удалить();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Удалено Документов Контакт - " + Н + "  " + ТекущаяДатаСеанса());
КонецПроцедуры

Процедура УдалениеДокументовОбещание(ТабУдаляемых)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Обещание.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.Обещание КАК Обещание
	               |ГДЕ
	               |	Обещание.Договор В ИЕРАРХИИ(&ДолжникСп)
	               |	И Обещание.Дата МЕЖДУ &НачДата И &КонДата
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Обещание.Ссылка";
	ПустаяДата =  Дата('00010101');
	Запрос.УстановитьПараметр("НачДата", ПустаяДата);
	Запрос.УстановитьПараметр("КонДата", КонецДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("ДолжникСп", ТабУдаляемых);

	ПустойДолжник = Справочники.Должники.ПустаяСсылка();
	Н = 0;
	Результат = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Н = Н + 1;
		ПустойДоговор = Справочники.Договоры.ПустаяСсылка();
		//Состояние("Удаление Документов Обещание - "+Н);
		Докум = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		Если Не Докум = Неопределено Тогда
			Если Докум.Проведен Тогда
				Докум.Записать(РежимЗаписиДокумента.ОтменаПроведения);
			КонецЕсли;
			Докум.УстановитьПометкуУдаления(Истина);
			Докум.Должник = ПустойДолжник;
			//Докум.Договор = ПустойДоговор;
			Докум.Сумма = 0;
			Докум.НомерКвитанции = "";
			Докум.ПереносОбещания.Очистить();
			Докум.Записать();
		КонецЕсли;
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Удалено Документов Обещание - "+Н+ "  "+ТекущаяДатаСеанса());
КонецПроцедуры

Процедура УдалениеДокументовПередачаДолжников(ТабУдаляемых)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПередачаДолжников.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.ПередачаДолжников КАК ПередачаДолжников
	               |ГДЕ
	               |	ПередачаДолжников.Дата МЕЖДУ &НачДата И &КонДата
	               |	И ПередачаДолжников.Должники.Должник В ИЕРАРХИИ(&ДолжникСп)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ПередачаДолжников.Ссылка";
	ПустаяДата = Дата('00010101');
	Запрос.УстановитьПараметр("НачДата", ПустаяДата);
	Запрос.УстановитьПараметр("ДолжникСп", ТабУдаляемых);
	Запрос.УстановитьПараметр("КонДата", КонецДня(ТекущаяДатаСеанса()));

	ПустойДолжник = Справочники.Должники.ПустаяСсылка();
	Н =0;
	Результат = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Н = Н + 1;
		ПустойДоговор = Справочники.Договоры.ПустаяСсылка();
		//Состояние("Изменение Документов ПередачаДолжников - "+Н);
		Докум = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		ТаблицаУдаляемыхСрок = Новый ТаблицаЗначений;
		ТаблицаУдаляемыхСрок.Колонки.Добавить("СтрокаДок");
		Если Не Докум = Неопределено Тогда
			// По табличной части удалить строки с нашим должником из таблицы
			Для Каждого СтрДокум из Докум.Должники Цикл
				ТекДолжник = СтрДокум.Должник;
				Если Не ТабУдаляемых.Найти(ТекДолжник)=Неопределено Тогда
					СтрД3 = ТаблицаУдаляемыхСрок.Добавить();
					СтрД3.СтрокаДок = СтрДокум;
				КонецЕсли;
			КонецЦикла;
			Для Каждого Стр4 из ТаблицаУдаляемыхСрок Цикл
				Докум.Должники.Удалить(Стр4.СтрокаДок);
			КонецЦикла;
			Если Докум.Проведен Тогда
				Докум.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				Докум.Записать(РежимЗаписиДокумента.Запись);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обработано Документов ПередачаДолжников - " + Н + "  " + ТекущаяДатаСеанса());
КонецПроцедуры

Процедура УдалениеДокументовПланирование(ТабУдаляемых)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Планирование.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.Планирование КАК Планирование
	               |ГДЕ
	               |	Планирование.Должники.Должник В ИЕРАРХИИ(&ДолжникСп)
	               |	И Планирование.Дата МЕЖДУ &НачДата И &КонДата
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Планирование.Ссылка";
	ПустаяДата =  Дата('00010101');
	Запрос.УстановитьПараметр("НачДата", ПустаяДата);
	Запрос.УстановитьПараметр("ДолжникСп", ТабУдаляемых);
	Запрос.УстановитьПараметр("КонДата", КонецДня(ТекущаяДатаСеанса()));

	ПустойДолжник = Справочники.Должники.ПустаяСсылка();
	Н =0;
	Результат = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Н = Н + 1;
		ПустойДоговор = Справочники.Договоры.ПустаяСсылка();
		//Состояние("Изменение Документов Планирование - "+Н);
		Докум = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		ТаблицаУдаляемыхСрок = Новый ТаблицаЗначений;
		ТаблицаУдаляемыхСрок.Колонки.Добавить("СтрокаДок");
		Если Не Докум = Неопределено Тогда
			// По табличной части удалить строки с нашим должником из таблицы
			Для Каждого СтрДокум из Докум.Должники Цикл
				ТекДолжник = СтрДокум.Должник;
				Если Не ТабУдаляемых.Найти(ТекДолжник)=Неопределено Тогда
					СтрД3 = ТаблицаУдаляемыхСрок.Добавить();
					СтрД3.СтрокаДок = СтрДокум;
				КонецЕсли;
			КонецЦикла;
			Для Каждого Стр4 Из ТаблицаУдаляемыхСрок Цикл
				Докум.Должники.Удалить(Стр4.СтрокаДок);
			КонецЦикла;
			Если Докум.Проведен Тогда
				Докум.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				Докум.Записать(РежимЗаписиДокумента.Запись);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обработано Документов Планирование - " + Н + "  " + ТекущаяДатаСеанса());
КонецПроцедуры

Функция ПолучитьДоговораДолжников(ТабДолжников)
    ТабДоговоровДолжников = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Договоры.Владелец КАК Владелец,
	|	ПРЕДСТАВЛЕНИЕ(Договоры.Владелец),
	|	Договоры.Ссылка КАК Ссылка,
	|	Договоры.Представление
	|ИЗ
	|	Справочник.Договоры КАК Договоры
	|ГДЕ
	|	Договоры.Владелец В ИЕРАРХИИ(&Владелец1)
	|
	|СГРУППИРОВАТЬ ПО
	|	Договоры.Ссылка,
	|	Договоры.Владелец,
	|	Договоры.Представление";

	Запрос.УстановитьПараметр("Владелец1", ТабДолжников);

	Результат = Запрос.Выполнить();

    ТабДоговоровДолжников = Результат.Выгрузить();
	Если Не ТабДоговоровДолжников= Неопределено Тогда
		ТабДоговоровДолжников.Свернуть("Владелец,Ссылка",);	
	КонецЕсли;
	
	Возврат ТабДоговоровДолжников;
	
КонецФункции

Процедура УдалитьТелефоны(ТабУдаляемых);
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Телефоны.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.Телефоны КАК Телефоны
	               |ГДЕ
	               |	Телефоны.Владелец В ИЕРАРХИИ(&Владелец1)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Телефоны.Ссылка";

	Запрос.УстановитьПараметр("Владелец1", ТабУдаляемых);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пустая = Справочники.ТипыТелефонов.ПустаяСсылка();
	Н = 0;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Н = Н + 1;
		//Состояние("Обезличивание Телефонов - "+Н);
		Спр = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		Спр.УстановитьПометкуУдаления(Истина,);
		Спр.Наименование  = "";
		Спр.Тип = Пустая;
		Спр.Номер = "";
		Спр.Подтверждение = Неопределено;
		Спр.Записать();
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обезличено Телефонов - " + Н);
КонецПроцедуры

Процедура УдалитьАдреса(ТабУдаляемых);
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Адреса.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.Адреса КАК Адреса
	               |ГДЕ
	               |	Адреса.Владелец В ИЕРАРХИИ(&Владелец1)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Адреса.Ссылка";

	Запрос.УстановитьПараметр("Владелец1", ТабУдаляемых);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пустая = Справочники.ТипыАдресов.ПустаяСсылка();
	РегионПустой = Справочники.Регионы.ПустаяСсылка();
	Н = 0;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Н = Н + 1;
		//Состояние("Обезличивание Адресов - "+Н);

		Спр = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		Спр.УстановитьПометкуУдаления(Истина,);
		Спр.Наименование = "";
		Спр.Тип = Пустая;
		Спр.Индекс = "";
		Спр.Адрес = "";
		Спр.Регион = РегионПустой;
		Спр.Записать();
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обезличено Адресов - " + Н);
КонецПроцедуры

Процедура УдалитьДопДанные(ТабУдаляемых);
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДополнительныеДанные.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.ДополнительныеДанные КАК ДополнительныеДанные
	               |ГДЕ
	               |	ДополнительныеДанные.Владелец В ИЕРАРХИИ(&Владелец1)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ДополнительныеДанные.Ссылка";

	Запрос.УстановитьПараметр("Владелец1", ТабУдаляемых);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Н = 0;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Н = Н + 1;
		//Состояние("Обезличивание Доп данные - "+Н);
		Спр = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		Спр.УстановитьПометкуУдаления(Истина,);
		Спр.Наименование = "";
		Спр.Реквизит    = "";
		Спр.Записать();
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обезличено Доп данные - " + Н);
	
КонецПроцедуры

Процедура ПроверитьДоговораНажатие(Элемент)
	Если ЗначениеЗаполнено(Реестр) Тогда
		ПустаяДата =  Дата('00010101');
		
		ТабНеУдаляемых = Новый ТаблицаЗначений;
		ТабНеУдаляемых.Колонки.Добавить("Должник");
		
		ТабУдаляемых = Новый ТаблицаЗначений;
		ТабУдаляемых.Колонки.Добавить("Должник");
		
		ТабНеУдалДоговор = Новый ТаблицаЗначений;
		ТабНеУдалДоговор.Колонки.Добавить("Договор");
		
		ТабДолжников      = Реестр.Должники.Выгрузить(,"Должник");
		ТабДоговоров      = Реестр.Должники.Выгрузить(,"Договор");
		ТабДолжникДоговор = Реестр.Должники.Выгрузить(,"Должник,Договор");
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Реестр.Должники.(
		|		Договор
		|	)
		|ИЗ
		|	Документ.Реестр КАК Реестр
		|ГДЕ
		|	Реестр.Дата МЕЖДУ &НачДата И &КонДата
		|	И Реестр.Должники.Договор В ИЕРАРХИИ(&ДоговорСп)";
		
		Запрос.УстановитьПараметр("ДоговорСп", ТабДоговоров);
		Запрос.УстановитьПараметр("КонДата",   КонецДня(ТекущаяДатаСеанса()));
		Запрос.УстановитьПараметр("НачДата",   (Реестр.Дата+10));
		
		Результат = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ДолжникиВыборкаДетальныеЗаписи = ВыборкаДетальныеЗаписи.Должники.Выбрать();
			Пока ДолжникиВыборкаДетальныеЗаписи.Следующий() Цикл
				//СтрокаДоговор = ТабНеУдалДоговор.Добавить();			
				//СтрокаДоговор.Договор = ДолжникиВыборкаДетальныеЗаписи.Договор;
				//
				//СтрокаТабНеУдаляемых = ТабНеУдаляемых.Добавить();
				//СтрокаТабНеУдаляемых.Должник = ДолжникиВыборкаДетальныеЗаписи.Договор.Владелец;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ДолжникиВыборкаДетальныеЗаписи.Договор.наименование);
			КонецЦикла;
		КонецЦикла;
		
		
		
	КонецЕсли;
КонецПроцедуры

Процедура Кнопка1Нажатие(Элемент)
	ПроверитьДоговораНажатие("");
КонецПроцедуры


