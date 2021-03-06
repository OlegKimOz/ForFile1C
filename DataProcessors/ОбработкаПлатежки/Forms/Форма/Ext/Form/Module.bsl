﻿#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.АвтоЗаголовок = Ложь;
	ЭтаФорма.Заголовок = ЗаголовокФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

&НаКлиенте
Функция ОткрытьФайлДанных(ИмяФайла, Ошибка = "") Экспорт
	Перем ФД;
	Попытка
		ФД = Новый COMОбъект("Excel.Application");
		ФД.Workbooks.Open(ИмяФайла);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		
		ФД = Неопределено;
	КонецПопытки;
	
	Возврат ФД;
	
КонецФункции

&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	//ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	//ДиалогВыбораФайла.Заголовок				= "Выберите файл для загрузки:";
	//ДиалогВыбораФайла.ПолноеИмяФайла			= ИмяФайла;
	//ДиалогВыбораФайла.Фильтр					= "Текст (*.txt)|*.txt";
	//ДиалогВыбораФайла.Расширение				= "txt";
	//ДиалогВыбораФайла.МножественныйВыбор		= Ложь;
	//ДиалогВыбораФайла.ПредварительныйПросмотр	= Ложь;
	//ДиалогВыбораФайла.Показать(Новый ОписаниеОповещения("ПослеВыбораФайла", ЭтаФорма));
	ДиалогВыбФайла 	 = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбФайла.Заголовок				= "Выберите файл для загрузки:";
	ДиалогВыбФайла.ПолноеИмяФайла			= ИмяФайла;
	ДиалогВыбФайла.Фильтр					= "Excel (*.xlsx)|*.xls*";
	ДиалогВыбФайла.Расширение				= "xlsx";
	ДиалогВыбФайла.МножественныйВыбор		= Ложь;
	ДиалогВыбФайла.ПредварительныйПросмотр	= Ложь;
	ДиалогВыбФайла.Показать(Новый ОписаниеОповещения("ПослеВыбораФайла", ЭтаФорма));
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораФайла(ВыбранныеФайлы, ДопПарметры) Экспорт
	
	Если ЗначениеЗаполнено(ВыбранныеФайлы) И ВыбранныеФайлы.Количество() > 0 Тогда
		ИмяФайла = ВыбранныеФайлы[0];
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайл(Команда)
	
	Ошибка = "";
	
	ФайлВыгрузки = Новый Файл(ИмяФайла);
	Если ФайлВыгрузки.Существует() = Ложь Тогда
		ПоказатьПредупреждение(, "Не удалось открыть файл данных.");
		Возврат;
	КонецЕсли;
	
	ФайлДанных = ОткрытьФайлДанных(ИмяФайла, Ошибка);

	Если ФайлДанных = Неопределено Тогда
		ПоказатьПредупреждение(, "Не удалось открыть файл данных.");
		Возврат;
	КонецЕсли;
	
	ВсегоСтрок = ФайлДанных.Cells(1,1).SpecialCells(11).Row;
	ВсегоКолонокВФайле = ФайлДанных.Cells(1,1).SpecialCells(11).Column;
	МассивДанных = ФайлДанных.Range(ФайлДанных.Cells(1, 1), ФайлДанных.Cells(ВсегоСтрок, ВсегоКолонокВФайле)).Value.Выгрузить();
	
	ПрочитатьДанныеНаСервере(МассивДанных);
	
	Элементы.ФормаПроверитьРаспознавание.КнопкаПоУмолчанию = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьРаспознавание(Команда)
	
	ЗаполнитьДолжников();
	ЗаполнитьИмена();
	ОбработатьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникЗамен(Команда)
	
	ОткрытьФорму("Справочник.ЗаменыДляПоиска.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура Напечатать(Команда)
	
	ТабличныйДокумент = НапечататьОбработкуВыписки(Команда.Имя);
	
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("ОбработкаВыписки");
	ОписаниеПечатнойФормы = УправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, "ОбработкаВыписки"); 
	ОписаниеПечатнойФормы.ТабличныйДокумент = ТабличныйДокумент;

	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

&НаСервере
Процедура ЗаполнитьИмена()
	
	СписокИмен.Очистить();
	СписокПолныхЗамен.Очистить();
	
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Должники.Имя КАК Имя,
		|	Должники.Имя КАК ЧтоМенять,
		|	ЛОЖЬ КАК Замена
		|ИЗ
		|	Справочник.Должники КАК Должники
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗаменыДляПоиска.Наименование,
		|	ЗаменыДляПоиска.ЧтоМенять,
		|	ИСТИНА
		|ИЗ
		|	Справочник.ЗаменыДляПоиска КАК ЗаменыДляПоиска
		|ГДЕ
		|	ЗаменыДляПоиска.ПометкаУдаления = ЛОЖЬ";
	Запрос = Новый Запрос(ТекстЗапроса);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.Замена Тогда
			СписокПолныхЗамен.Добавить(Выборка.ЧтоМенять, Выборка.Имя);
		Иначе
			СписокИмен.Добавить(ВРег(Выборка.ЧтоМенять), Выборка.Имя);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДолжников()
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	РеестрДолжники.Договор КАК Договор,
		|	МАКСИМУМ(РеестрДолжники.Ссылка.Дата) КАК Дата
		|ПОМЕСТИТЬ ВТ_РеестрыДаты
		|ИЗ
		|	Документ.Реестр.Должники КАК РеестрДолжники
		|
		|СГРУППИРОВАТЬ ПО
		|	РеестрДолжники.Договор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РеестрДолжники.Договор КАК Договор,
		|	РеестрДолжники.Должник КАК Должник,
		|	РеестрДолжники.Ссылка КАК Ссылка,
		|	РеестрДолжники.Ссылка.НомерДляПечати КАК Номер,
		|	РеестрДолжники.Ссылка.Представление КАК Представление,
		|	РеестрДолжники.Ссылка.Банк КАК Банк
		|ПОМЕСТИТЬ ВТ_Реестры
		|ИЗ
		|	Документ.Реестр.Должники КАК РеестрДолжники
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_РеестрыДаты КАК ВТ_РеестрыДаты
		|		ПО РеестрДолжники.Договор = ВТ_РеестрыДаты.Договор
		|			И РеестрДолжники.Ссылка.Дата = ВТ_РеестрыДаты.Дата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Должники.Ссылка КАК Должник,
		|	Должники.Наименование КАК ДолжникФИО,
		|	Должники.Фамилия КАК Фамилия,
		|	Должники.Имя КАК Имя,
		|	Должники.Отчество КАК Отчество,
		|	Договоры.НомерДоговора КАК НомерДоговора,
		|	Договоры.Статус КАК Статус,
		|	Договоры.СуммаКредита КАК СуммаКредита,
		|	Договоры.Ссылка КАК Договор,
		|	ВТ_Реестры.Ссылка КАК Реестр,
		|	ВТ_Реестры.Номер КАК НомерРеестра,
		|	ВТ_Реестры.Представление КАК Представление,
		|	ВТ_Реестры.Банк.Наименование КАК БанкНаименование
		|ИЗ
		|	Справочник.Договоры КАК Договоры
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Должники КАК Должники
		|		ПО Договоры.Владелец = Должники.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Реестры КАК ВТ_Реестры
		|		ПО Договоры.Ссылка = ВТ_Реестры.Договор";
	Запрос = Новый Запрос(ТекстЗапроса);
	ВыгрузкаДолжники = Запрос.Выполнить().Выгрузить();
	Объект.ТаблицаДолжники.Загрузить(ВыгрузкаДолжники);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДанныеНаСервере(МассивДанных)
	
	КоличествоСтрок = МассивДанных[0].Количество();
	
	ПерваяСтрока = 11;
	КолонкаДата = 1;
	КолонкаБанк = 2;
	КолонкаБИК = 5;
	КолонкаСумма = 8;
	КолонкаНазначение = 9;
	
	ТаблицаДанных.Очистить();
	Для НомерСтроки = ПерваяСтрока По КоличествоСтрок - 1 Цикл
		СтрокаДанных = ТаблицаДанных.Добавить();
		
		ДатаМассива = МассивДанных[КолонкаДата][НомерСтроки]; // "24.12.2020"	Строка
		МассивЭлементовДаты = СтрРазделить(ДатаМассива, ".");
		Если МассивЭлементовДаты.Количество() = 3 Тогда
			ДатаОперации = Дата(МассивЭлементовДаты[2], МассивЭлементовДаты[1], МассивЭлементовДаты[0]);
		Иначе
			ДатаОперации = ТекущаяДатаСеанса();
		КонецЕсли;
		
		СтрокаДанных.ДатаОперации = ДатаОперации;
		СтрокаДанных.СуммаПлатежа = МассивДанных[КолонкаСумма][НомерСтроки];
		СтрокаДанных.Банк = МассивДанных[КолонкаБанк][НомерСтроки];
		Если СтрНайти(ВРЕГ(СтрокаДанных.Банк), "УФК") > 0 Тогда
			СтрокаДанных.ОтметкаФССП = "ДА УФК";
		Иначе
			СтрокаДанных.ОтметкаФССП = "нет УФК";
		КонецЕсли;
		СтрокаДанных.НазначениеПлатежа = МассивДанных[КолонкаНазначение][НомерСтроки];
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция НайтиДолжникаТЗ(СтруктураПоиска);
	
	Должник = Справочники.Должники.ПустаяСсылка();
	Договор = Справочники.Договоры.ПустаяСсылка();
	НомерРеестра = "";
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Должник", Должник);
	СтруктураВозврата.Вставить("Договор", Договор);
	СтруктураВозврата.Вставить("НомерРеестра", НомерРеестра);
	
	ФИО = СтрШаблон("%1%2%3", СтруктураПоиска.Фамилия, СтруктураПоиска.Имя, СтруктураПоиска.Отчество);
	Если СокрЛП(ФИО) = "" Тогда
		Возврат СтруктураВозврата;
	КонецЕсли;
	
	ФИО = СтрШаблон("%%%1 %2 %3%%", СтруктураПоиска.Фамилия, СтруктураПоиска.Имя, СтруктураПоиска.Отчество);
	ФИО_ВРЕГ = СтрШаблон("%1 %2 %3", ВРег(СтруктураПоиска.Фамилия), ВРег(СтруктураПоиска.Имя), ВРег(СтруктураПоиска.Отчество));
	ФИО_Норм = СтрШаблон("%1 %2 %3", ТРег(СтруктураПоиска.Фамилия), ТРег(СтруктураПоиска.Имя), ТРег(СтруктураПоиска.Отчество));
	
	НайденныеСтроки = Объект.ТаблицаДолжники.НайтиСтроки(Новый Структура("ДолжникФИО", ФИО_ВРЕГ));
	
	НомерДоговора = СтруктураПоиска.НомерДоговора;
	
	Если НайденныеСтроки.Количество() = 0 Тогда
		НайденныеСтроки = Объект.ТаблицаДолжники.НайтиСтроки(Новый Структура("ДолжникФИО", ФИО_Норм));
		Если НайденныеСтроки.Количество() = 1 Тогда
			Должник = НайденныеСтроки[0].Должник;
			Договор = НайденныеСтроки[0].Договор;
			НомерРеестра = НайденныеСтроки[0].НомерРеестра;
		ИначеЕсли НайденныеСтроки.Количество() > 1 Тогда
			ДолжникиСоответствие = Новый Соответствие;
			ДоговораСоответствие = Новый Соответствие;
			
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				ДолжникиСоответствие.Вставить(НайденнаяСтрока.Должник);
				ДоговораСоответствие.Вставить(НайденнаяСтрока.Договор, НомерДоговора);
			КонецЦикла;
			
			Если ДолжникиСоответствие.Количество() = 1 Тогда
				Должник = НайденныеСтроки[0].Должник;
			КонецЕсли;
			
			Если ДоговораСоответствие.Количество() = 1 Тогда
				Договор = НайденныеСтроки[0].Договор;
			ИначеЕсли ЗначениеЗаполнено(НомерДоговора) Тогда
				Для Каждого ДоговорСоответсвия Из ДоговораСоответствие Цикл
					Если ВРег(СокрЛП(ДоговорСоответсвия.Значение)) = ВРег(СокрЛП(НомерДоговора)) Тогда
						Договор = ДоговорСоответсвия.Ключ;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				Если Договор = НайденнаяСтрока.Договор Тогда
					НомерРеестра = НайденнаяСтрока.НомерРеестра;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
	ИначеЕсли НайденныеСтроки.Количество() > 1 Тогда
		ДолжникиСоответствие = Новый Соответствие;
		ДоговораСоответствие = Новый Соответствие;
		
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			ДолжникиСоответствие.Вставить(НайденнаяСтрока.Должник);
			ДоговораСоответствие.Вставить(НайденнаяСтрока.Договор);
		КонецЦикла;
		
		Если ДолжникиСоответствие.Количество() = 1 Тогда
			Должник = НайденныеСтроки[0].Должник;
		КонецЕсли;
		
		Если ДоговораСоответствие.Количество() = 1 Тогда
			Договор = НайденныеСтроки[0].Договор;
		ИначеЕсли ЗначениеЗаполнено(НомерДоговора) Тогда
			Для Каждого ДоговорСоответсвия Из ДоговораСоответствие Цикл
				Если ВРег(СокрЛП(ДоговорСоответсвия.Значение)) = ВРег(СокрЛП(НомерДоговора)) Тогда
					Договор = ДоговорСоответсвия.Ключ;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Если Договор = НайденнаяСтрока.Договор Тогда
				НомерРеестра = НайденнаяСтрока.НомерРеестра;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Должник = НайденныеСтроки[0].Должник;
		Договор = НайденныеСтроки[0].Договор;
		НомерРеестра = НайденныеСтроки[0].НомерРеестра;
	КонецЕсли;
	
	СтруктураВозврата.Вставить("Должник", Должник);
	СтруктураВозврата.Вставить("Договор", Договор);
	СтруктураВозврата.Вставить("НомерРеестра", НомерРеестра);
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаСервере
Функция НапечататьОбработкуВыписки(ИмяКоманды)
	
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	Макет = ОбъектОбработки.ПолучитьМакет("МакетЕсть");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	
	ТабличныйДокумент.Вывести(ОбластьШапка);
	
	Для каждого СтрокаВыписки Из ТаблицаДанных Цикл
		Если ИмяКоманды = "НапечататьТоЧтоЕстьВ1С" Тогда
			Если 	ЗначениеЗаполнено(СтрокаВыписки.Должник) И
					ЗначениеЗаполнено(СтрокаВыписки.Договор) И
					ЗначениеЗаполнено(СтрокаВыписки.НомерРеестра) Тогда
				ОбластьСтрока.Параметры.Заполнить(СтрокаВыписки);
				ТабличныйДокумент.Вывести(ОбластьСтрока);
			КонецЕсли;
		Иначе
			Если 	ЗначениеЗаполнено(СтрокаВыписки.Должник) И
					ЗначениеЗаполнено(СтрокаВыписки.Договор) И
					ЗначениеЗаполнено(СтрокаВыписки.НомерРеестра) Тогда
				Продолжить;
			Иначе
				ОбластьСтрока.Параметры.Заполнить(СтрокаВыписки);
				ТабличныйДокумент.Вывести(ОбластьСтрока);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ТолькоПросмотр = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаСервере
Процедура ОбработатьДанные()
	
	Для Каждого СтрокаДанных Из ТаблицаДанных Цикл
		СтрокаТекста = СтрокаДанных.НазначениеПлатежа;
		
		Для Каждого ЭлементПолнойЗамены Из СписокПолныхЗамен Цикл
			Если СтрНайти(ВРег(СтрокаТекста), ВРег(ЭлементПолнойЗамены.Значение)) > 0 Тогда
				СтрокаТекста = СтрЗаменить(СтрокаТекста, ЭлементПолнойЗамены.Значение, ЭлементПолнойЗамены.Представление);
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		СтрокаТекста = УбратьСимволы(СтрокаТекста);
		
		МассивЭлементовСтроки = СтрРазделить(СтрокаТекста, " ", Ложь);
		МаксимальныйИндекс = МассивЭлементовСтроки.ВГраница();
		Для Сч = 0 По МаксимальныйИндекс Цикл
			ЭлементМассива = МассивЭлементовСтроки.Получить(Сч);
			Если СписокИмен.НайтиПоЗначению(ВРег(ЭлементМассива)) = Неопределено Тогда
				Если ЭлементМассива = "КД№" Тогда
					Если (Сч + 1) <= МаксимальныйИндекс Тогда
						НомерДоговора = МассивЭлементовСтроки.Получить(сч + 1);
						СтрокаДанных.НомерДоговора = НомерДоговора;
					КонецЕсли;
				Иначе
					Продолжить;
				КонецЕсли;
			Иначе
				СтрокаДанных.Имя = ЭлементМассива;
				// может быть такое что фамилия похожа на имя
				// Саид Зульфия Фаатовна
				Если (Сч + 1) <= МаксимальныйИндекс Тогда
					Имя = МассивЭлементовСтроки.Получить(сч + 1);
					Если СписокИмен.НайтиПоЗначению(ВРег(Имя)) <> Неопределено Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
				
				Если Сч > 0 Тогда
					Фамилия = МассивЭлементовСтроки.Получить(сч - 1);
					Если СписокИмен.НайтиПоЗначению(ВРег(Фамилия)) <> Неопределено Тогда
						СтрокаДанных.Фамилия = СписокИмен.НайтиПоЗначению(ВРег(Фамилия)).Представление;
					Иначе
						СтрокаДанных.Фамилия = Фамилия;
					КонецЕсли;
				КонецЕсли;
				
				Если (Сч + 1) <= МаксимальныйИндекс Тогда
					Отчество = МассивЭлементовСтроки.Получить(сч + 1);
					Если СписокИмен.НайтиПоЗначению(ВРег(Отчество)) <> Неопределено Тогда
						СтрокаДанных.Отчество = СписокИмен.НайтиПоЗначению(ВРег(Отчество)).Представление;
					Иначе
						СтрокаДанных.Отчество = Отчество;
					КонецЕсли;
				КонецЕсли;
				
				//Прервать;
			КонецЕсли;
		КонецЦикла;
		
		СтруктураПоиска = Новый Структура("Фамилия, Имя, Отчество, НомерДоговора");
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаДанных);
		
		РезультатПоиска = НайтиДолжникаТЗ(СтруктураПоиска);
		ЗаполнитьЗначенияСвойств(СтрокаДанных, РезультатПоиска);
		
	КонецЦикла;
	
КонецПроцедуры // ПрочитатьФайл()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЗаголовокФормы()
	
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	Комментарий = ТекОбъект.Метаданные().Комментарий;
	НовыйЗаголовок = ТекОбъект.Метаданные().Синоним + ?(ЗначениеЗаполнено(Комментарий), " (" + Комментарий + ")", "");
	Возврат НовыйЗаголовок;
	
КонецФункции

&НаСервере
Функция УбратьСимволы(СтрокаССимволами)
	
	СтрокаДанных = СтрокаССимволами;
	
	СтрокаДанных = СтрЗаменить(СтрокаДанных, "КД N ", 	"КД№ ");
	СтрокаДанных = СтрЗаменить(СтрокаДанных, "КД №", 	"КД№ ");
	СтрокаДанных = СтрЗаменить(СтрокаДанных, "К/Д №", 	"КД№ ");
	СтрокаДанных = СтрЗаменить(СтрокаДанных, "к.д. ", 	"КД№ ");
	СтрокаДанных = СтрЗаменить(СтрокаДанных, "КД N ", 	"КД№ ");
	СтрокаДанных = СтрЗаменить(СтрокаДанных, "кд ", 	"КД№ ");
	СтрокаДанных = СтрЗаменить(СтрокаДанных, "КД ", 	"КД№ ");
	
	СтрокаДанных = СтрЗаменить(СтрокаДанных, "(", " ");
	СтрокаДанных = СтрЗаменить(СтрокаДанных, ")", " ");
	СтрокаДанных = СтрЗаменить(СтрокаДанных, "*", " ");
	СтрокаДанных = СтрЗаменить(СтрокаДанных, "//", " ");
	СтрокаДанных = СтрЗаменить(СтрокаДанных, """", " ");
	СтрокаДанных = СтрЗаменить(СтрокаДанных, "'", " ");
	СтрокаДанных = СтрЗаменить(СтрокаДанных, ":", " ");
	СтрокаДанных = СтрЗаменить(СтрокаДанных, ";", " ");
	СтрокаДанных = СтрЗаменить(СтрокаДанных, ",", " ");
	СтрокаДанных = СтрЗаменить(СтрокаДанных, ".", " ");
	
	Пока СтрНайти(СтрокаДанных, "  ") > 0 Цикл 
		СтрокаДанных = СтрЗаменить(СтрокаДанных, "  ", " ");
	КонецЦикла;
	
	Возврат СтрокаДанных;
	
КонецФункции // ()

#КонецОбласти

#Область Инициализация

#КонецОбласти