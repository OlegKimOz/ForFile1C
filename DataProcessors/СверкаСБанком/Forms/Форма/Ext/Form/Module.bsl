﻿// ЗагрузитьИзФайла после слияния
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОтметкаСвои = 10; ОтметкаБанк = 1; ОтметкаСовпадающие = ОтметкаСвои + ОтметкаБанк;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьУсловноеОформление();
КонецПроцедуры

&НаСервере
Функция ПолучитьТаблицуДолжников(Отозванные) Экспорт
	Запрос = Новый Запрос;
	ТекстЗапроса = "ВЫБРАТЬ
	               |	ПривязкаОтделСрезПоследних.Должник КАК Должник,
	               |	ПРЕДСТАВЛЕНИЕ(ПривязкаОтделСрезПоследних.Должник) КАК ДолжникПредставление,
	               |	ПривязкаОтделСрезПоследних.Отдел КАК Отдел,
	               |	ПРЕДСТАВЛЕНИЕ(ПривязкаОтделСрезПоследних.Отдел) КАК ОтделПредставление,
	               |	ПривязкаОтделСрезПоследних.СвободныйПул КАК СвободныйПул,
	               |	ПривязкаОтделСрезПоследних.Регистратор КАК Регистратор,
	               |	ПривязкаОтделСрезПоследних.Период КАК ДатаОтзыва,
	               |	Договоры.Ссылка КАК Договор
	               |ИЗ
	               |	РегистрСведений.ПривязкаОтдел.СрезПоследних КАК ПривязкаОтделСрезПоследних
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Договоры КАК Договоры
	               |		ПО ПривязкаОтделСрезПоследних.Должник = Договоры.Владелец
	               |ГДЕ
	               |	ПривязкаОтделСрезПоследних.Отдел.РольОтдела = &РольОтдела";
	Если Отозванные = Ложь Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПривязкаОтделСрезПоследних.Отдел.РольОтдела = &РольОтдела", "ПривязкаОтделСрезПоследних.Отдел.РольОтдела = &РольОтдела");
	КонецЕсли;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("РольОтдела", Перечисления.РольОтдела.Архив);

	Результат = Запрос.Выполнить();
	Возврат Результат.Выгрузить();
КонецФункции

&НаКлиенте
Процедура ОбработатьКомандуФормы(Команда)
	Если Команда.Имя = "ЗагрузитьИзФайла" Тогда
		ЗагрузитьИзФайла();
	ИначеЕсли Команда.Имя = "ПоместитьВОтозванные" Тогда
		ПоместитьВОтозванные();
	ИначеЕсли Команда.Имя = "ПоместитьВАктивные" Тогда
		ПоместитьВАктивные();
	ИначеЕсли Команда.Имя = "ОтозванныеДобавитьИзБазы" Тогда
		ОтозванныеДобавитьИзБазы();
	ИначеЕсли Команда.Имя = "АктивныеДобавитьИзБазы" Тогда
		АктивныеДобавитьИзБазы();
	ИначеЕсли Команда.Имя = "ОтозванныеСвернуть" Тогда
		ОтозванныеСвернуть();
	ИначеЕсли Команда.Имя = "АктивныеСвернуть" Тогда
		АктивныеСвернуть();
	ИначеЕсли Команда.Имя = "АктивныеСвернуть" Тогда
		АктивныеСвернутьСДатойОтзыва();
	ИначеЕсли Команда.Имя = "АктивныеСформироватьПередачу" Тогда
		АктивныеСформироватьПередачу();
	ИначеЕсли Команда.Имя = "ОтозванныеСформироватьПередачу" Тогда
		ОтозванныеСформироватьПередачу();
	КонецЕсли;
КонецПроцедуры

Процедура ЗагрузитьИзФайла()
	ЗагрузкаДолжников = Обработки.ЗагрузкаДанных.Создать();
	ЗагрузкаДолжников.ПробоватьИсправитьНомерДоговора = ПробоватьИсправитьНомерДоговора;
	//
	//Форма = ЗагрузкаДолжников.ПолучитьФорму();
	//Форма.ВладелецФормы = ЭтаФорма;
	//Форма.ОткрытьМодально();
	//
	//Загруженные.Загрузить(ЗагрузкаДолжников.ТаблицаЗначенийЗагрузки.Скопировать());
КонецПроцедуры

&НаСервере
Процедура ПоместитьВОтозванные()
	ВременнаяТЗ = Объект.Загруженные.Выгрузить();
	ВременнаяТЗ.Колонки.Добавить("Отметка");
	ВременнаяТЗ.ЗаполнитьЗначения(ОтметкаБанк, "Отметка");
	
	Объект.Отозванные.Загрузить(ВременнаяТЗ.Скопировать());
КонецПроцедуры

&НаСервере
Процедура ПоместитьВАктивные()
	ВременнаяТЗ = Объект.Загруженные.Выгрузить();
	ВременнаяТЗ.Колонки.Добавить("Отметка");
	ВременнаяТЗ.ЗаполнитьЗначения(ОтметкаБанк, "Отметка");
	
	Объект.Активные.Загрузить(ВременнаяТЗ.Скопировать());
КонецПроцедуры

&НаСервере
Процедура ОтозванныеДобавитьИзБазы()
	ВременнаяТЗ = ПолучитьТаблицуДолжников(Истина);
	ВременнаяТЗ.Колонки.Добавить("Отметка");
	ВременнаяТЗ.ЗаполнитьЗначения(ОтметкаСвои, "Отметка");
	
	Объект.Отозванные.Загрузить(ВременнаяТЗ.Скопировать());
КонецПроцедуры

&НаСервере
Процедура АктивныеДобавитьИзБазы()
	ВременнаяТЗ = ПолучитьТаблицуДолжников(Ложь);
	
	ВременнаяТЗ.Колонки.Добавить("Отметка");
	ВременнаяТЗ.ЗаполнитьЗначения(ОтметкаСвои, "Отметка");
	
	Объект.Активные.Загрузить(ВременнаяТЗ.Скопировать());
КонецПроцедуры

&НаСервере
Процедура ОтозванныеСвернуть()
	ТЗ_Врем = Объект.Отозванные.Выгрузить();
	ТЗ_Врем.Свернуть("Договор, Должник", "Отметка");
	Объект.Отозванные.Загрузить(ТЗ_Врем);
КонецПроцедуры

&НаСервере
Процедура АктивныеСвернуть()
	ТЗ_Врем = Объект.Активные.Выгрузить();
	ТЗ_Врем.Свернуть("Договор, Должник", "Отметка");
	Объект.Активные.Загрузить(ТЗ_Врем);
КонецПроцедуры

&НаСервере
Процедура АктивныеСвернутьСДатойОтзыва()
	ТЗ_Врем = Объект.Отозванные.Выгрузить();
	ТЗ_Врем.Свернуть("Договор, Должник, ДатаОтзыва", "Отметка");
	Объект.Отозванные.Загрузить(ТЗ_Врем);
КонецПроцедуры

&НаКлиенте
Процедура ОтозванныеСформироватьПередачу()
	Форма = ПолучитьФорму("Документ.ПередачаДолжников.ФормаОбъекта");
	ДанныеФормы = Форма.Объект;
	ПередатьНаСервере(ДанныеФормы, "Отозванные"); // Заполняем документ на сервере
	КопироватьДанныеФормы(ДанныеФормы, Форма.Объект); // копируем наш объект в объект формы и далее открываем ее
	Форма.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура АктивныеСформироватьПередачу()
	Форма = ПолучитьФорму("Документ.ПередачаДолжников.ФормаОбъекта");
	ДанныеФормы = Форма.Объект;
	ПередатьНаСервере(ДанныеФормы, "Активные"); // Заполняем документ на сервере
	КопироватьДанныеФормы(ДанныеФормы, Форма.Объект); // копируем наш объект в объект формы и далее открываем ее
	Форма.Открыть();
КонецПроцедуры

&НаСервере
Процедура ПередатьНаСервере(ДанныеФормы, ИмяТаблицыДанных)
	ТаблицаДанных = Объект[ИмяТаблицыДанных];
	ДокументПередачи = Документы.ПередачаДолжников.СоздатьДокумент();
	ДокументПередачи.Автор = ПараметрыСеанса.Пользователь;
	ДокументПередачи.Дата = ТекущаяДатаСеанса();
	ДокументПередачи.Менеджер = ПараметрыСеанса.Пользователь;
	
	Для каждого ТекСтрока Из ТаблицаДанных Цикл
		Копировать = Ложь;
		Если ПоДаннымАгентства И ТекСтрока.Отметка = ОтметкаСвои Тогда
			Копировать = Истина;
		КонецЕсли;
		Если ПоДаннымБанка И ТекСтрока.Отметка = ОтметкаБанк Тогда
			Копировать = Истина;
		КонецЕсли;
		Если Совпадающие И ТекСтрока.Отметка = ОтметкаСовпадающие Тогда
			Копировать = Истина;
		КонецЕсли; 
		Если Копировать Тогда
			СтрокаДокумента = ДокументПередачи.Должники.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДокумента, ТекСтрока);
		КонецЕсли;
	КонецЦикла;
	ЗначениеВДанныеФормы(ДокументПередачи, ДанныеФормы);
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ОтозванныеОписание");
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Отозванные.Отметка");
	ЭлементОтбора.ПравоеЗначение = ОтметкаБанк;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", "По данным банка отозван");
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ОтозванныеОписание");
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Отозванные.Отметка");
	ЭлементОтбора.ПравоеЗначение = ОтметкаСвои;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", "По данным агентства отозван");
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ОтозванныеОписание");
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Отозванные.Отметка");
	ЭлементОтбора.ПравоеЗначение = ОтметкаСовпадающие;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", "По данным агентства и банка совпадает");
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ОтозванныеОписание");
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Отозванные.Отметка");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбора.ПравоеЗначение = ОтметкаБанк;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", "Отклонение. Необходимо рассмотреть подробнее.");
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры
