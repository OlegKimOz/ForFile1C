﻿//Признак использования настроек
&НаКлиенте
Перем мИспользоватьНастройки Экспорт;

//Типы объектов, для которых может использоваться обработка.
//По умолчанию для всех.
&НаКлиенте
Перем мТипыОбрабатываемыхОбъектов Экспорт;

&НаКлиенте
Перем мНастройка;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Выполняет обработку объектов.
//
// Параметры:
//  Объект                 - обрабатываемый объект.
//  ПорядковыйНомерОбъекта - порядковый номер обрабатываемого объекта.
//
&НаСервере
Процедура ОбработатьОбъект(Ссылка, ПорядковыйНомерОбъекта, МенеджерЗаписи = Неопределено)

	Если ОбъектПоиска.Тип = "РегистрСведений" Тогда
		СтрокаТаблицы = Ссылка;
		ИмяРегистра = ОбъектПоиска.Имя;
		Объект = МенеджерЗаписи;
		ЗаполнитьЗначенияСвойств(Объект, СтрокаТаблицы);
		Объект.Прочитать();
	Иначе
		Объект = Ссылка.ПолучитьОбъект();
	КонецЕсли; 
	
	//[begin] Added by Sergey. http://infostart.ru/profile/18346/
	//25.03.2012 21:03:04
	Если ЭтаФорма.ИспользоватьРежимЗагрузкиОбменаДанными Тогда
		Объект.ОбменДанными.Загрузка = Истина;
	КонецЕсли; 
	//[end] Added 
	
	Для каждого Реквизит из Реквизиты Цикл
		Если Реквизит.Выбрать Тогда
			Объект[Реквизит.Идентификатор] = Реквизит.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(СписокТабличнаяЧасть) Тогда
		Если ОбработкаСтрок <> "Замена" Тогда
			ПараметрыОтбора = Новый Структура;
			Для каждого Реквизит из РеквизитыТаблицы Цикл
				Если Реквизит.Выбрать Тогда
					ПараметрыОтбора.Вставить(Реквизит.Идентификатор, Реквизит.Значение)
				КонецЕсли;
			КонецЦикла;
			Если ПараметрыОтбора.Количество() > 0 Тогда
				НайденныеСтроки = Объект[СписокТабличнаяЧасть].НайтиСтроки(ПараметрыОтбора);
				Если ОбработкаСтрок = "Добавление" Тогда
					Если НайденныеСтроки.Количество() = 0 Тогда
						ЗаполнитьЗначенияСвойств(Объект[СписокТабличнаяЧасть].Добавить(), ПараметрыОтбора);
					КонецЕсли; 
				ИначеЕсли ОбработкаСтрок = "Удаление" Тогда
					Если НайденныеСтроки.Количество() > 0 Тогда
						Для каждого СтрокаТаблицы Из НайденныеСтроки Цикл
							Объект[СписокТабличнаяЧасть].Удалить(СтрокаТаблицы);
						КонецЦикла;
					КонецЕсли; 
				КонецЕсли; 
			КонецЕсли; 
		Иначе
			Для каждого Реквизит из РеквизитыТаблицы Цикл
				Если Реквизит.Выбрать Тогда
					Для каждого СтрокаТаблицы Из Объект[СписокТабличнаяЧасть] Цикл
						СтрокаТаблицы[Реквизит.Идентификатор] = Реквизит.Значение;
					КонецЦикла; 
				КонецЕсли;
			КонецЦикла;
		КонецЕсли; 
	КонецЕсли; 
	
	Если ЭтаФорма.ЭтоДокумент И ЗначениеЗаполнено(ЭтаФорма.РежимЗаписиДокументаСтрока) Тогда
		Объект.Записать(РежимЗаписиДокумента[ЭтаФорма.РежимЗаписиДокументаСтрока]);
	Иначе
		Объект.Записать();
	КонецЕсли; 

КонецПроцедуры // ОбработатьОбъект()

// Выполняет обработку объектов.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Функция ВыполнитьОбработку() Экспорт
	
	Если ЭтаФорма.РежимРаботы ИЛИ ЭтаФорма.ОбрабатыватьВТранзакции ИЛИ ОбъектПоиска.Тип = "РегистрСведений" Тогда
		Индекс = ВыполнитьОбработкуСервер();
	Иначе                  
		Индикатор = ПолучитьИндикаторПроцесса(НайденныеОбъекты.Количество());
		Для Индекс = 0 По НайденныеОбъекты.Количество() - 1 Цикл
			ОбработатьИндикатор(Индикатор, Индекс + 1);
			
			Объект = НайденныеОбъекты.Получить(Индекс).Значение;
			ОбработатьОбъект(Объект, Индекс);
		КонецЦикла;
		
	КонецЕсли;  //  
	
	Если НЕ ЭтаФорма.ЭтоРегистр И Индекс > 0 Тогда
		ОповеститьОбИзменении(Тип(ОбъектПоиска.Тип + "Ссылка." + ОбъектПоиска.Имя));
	КонецЕсли;
	
	Возврат Индекс;
КонецФункции // вВыполнитьОбработку()

//[begin] Added by Sergey. http://infostart.ru/profile/18346/
//27.03.2012 22:26:55
// Выполняет обработку объектов.
//
// Параметры:
//  Нет.
//
&НаСервере
Функция ВыполнитьОбработкуСервер()
	
	НачатьЗафиксироватьТранзакцию(ЭтаФорма.ОбрабатыватьВТранзакции, Истина);
	
	МенеджерЗаписи = Неопределено;
	НаборЗаписей = Неопределено;
	
	Если ОбъектПоиска.Тип = "РегистрСведений" Тогда
		КоллекцияОбъектов = ПолучитьИзВременногоХранилища(АдресТаблицы);
		МенеджерЗаписи = РегистрыСведений[ОбъектПоиска.Имя].СоздатьМенеджерЗаписи();
		НаборЗаписей = РегистрыСведений[ОбъектПоиска.Имя].СоздатьНаборЗаписей();
	Иначе
		КоллекцияОбъектов = НайденныеОбъекты;
	КонецЕсли; 
	
	Для Индекс = 0 По КоллекцияОбъектов.Количество() - 1 Цикл
		Если ЭтаФорма.ОбрабатыватьВТранзакции И ЭтаФорма.КоличествоОбъектовНаТранзакцию > 0 Тогда
			Если Индекс > 0 И Индекс % ЭтаФорма.КоличествоОбъектовНаТранзакцию = 0 Тогда
				НачатьЗафиксироватьТранзакцию(ЭтаФорма.ОбрабатыватьВТранзакции, Ложь);
				НачатьЗафиксироватьТранзакцию(ЭтаФорма.ОбрабатыватьВТранзакции, Истина);
			КонецЕсли; 
		КонецЕсли; 
		Если ОбъектПоиска.Тип = "РегистрСведений" Тогда
			Объект = КоллекцияОбъектов.Получить(Индекс);
		Иначе
			Объект = КоллекцияОбъектов.Получить(Индекс).Значение;
		КонецЕсли; 
		ОбработатьОбъект(Объект, Индекс, МенеджерЗаписи);
	КонецЦикла;
	НачатьЗафиксироватьТранзакцию(ЭтаФорма.ОбрабатыватьВТранзакции, Ложь);
	
	Возврат Индекс;
КонецФункции // ВыполнитьОбработкуСервер()
//[end] Added 

// Сохраняет значения реквизитов формы.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура СохранитьНастройку() Экспорт

	Если ПустаяСтрока(ТекущаяНастройкаПредставление) Тогда
		Предупреждение("Задайте имя новой настройки для сохранения или выберите существующую настройку для перезаписи.");
	КонецЕсли;

	НоваяНастройка = Новый Структура;
	НоваяНастройка.Вставить("Обработка", ТекущаяНастройкаПредставление);
	НоваяНастройка.Вставить("Прочее", Новый Структура);
	
	РеквизитыДляСохранения = ПолучитьМассивРеквизитов();
	РеквизитыТаблицыДляСохранения = ПолучитьМассивРеквизитовТаблицы();
	
	Для каждого РеквизитНастройки из мНастройка Цикл
		Выполнить("НоваяНастройка.Прочее.Вставить(Строка(РеквизитНастройки.Ключ), " + Строка(РеквизитНастройки.Ключ) + ");");
	КонецЦикла;
	
	ДоступныеОбработки = ЭтаФорма.ВладелецФормы.ДоступныеОбработки;
	ТекущаяДоступнаяНастройка = Неопределено;
	Для Каждого ТекущаяДоступнаяНастройка Из ДоступныеОбработки.ПолучитьЭлементы() Цикл
		Если ТекущаяДоступнаяНастройка.ПолучитьИдентификатор() = Родитель Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
    Если ТекущаяНастройка = Неопределено ИЛИ НЕ ТекущаяНастройка.Обработка = ТекущаяНастройкаПредставление Тогда
		Если ТекущаяДоступнаяНастройка <> Неопределено Тогда
			НоваяСтрока = ТекущаяДоступнаяНастройка.ПолучитьЭлементы().Добавить();
			НоваяСтрока.Обработка = ТекущаяНастройкаПредставление;
			НоваяСтрока.Настройка.Добавить(НоваяНастройка);
			
			Если ТипЗнч(ЭтаФорма.ВладелецФормы.Элементы.ДоступныеОбработки.Родитель) <> Тип("ГруппаФормы") Тогда
				ЭтаФорма.ВладелецФормы.Элементы.ДоступныеОбработки.Родитель = НоваяСтрока.ПолучитьИдентификатор();
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;
	
	Если ТекущаяДоступнаяНастройка <> Неопределено И ТекущаяСтрока > -1 Тогда
		Для Каждого ТекНастройка Из ТекущаяДоступнаяНастройка.ПолучитьЭлементы() Цикл
			Если ТекНастройка.ПолучитьИдентификатор() = ТекущаяСтрока Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ТекНастройка.Настройка.Количество() = 0 Тогда
			ТекНастройка.Настройка.Добавить(НоваяНастройка);
		Иначе
			ТекНастройка.Настройка[0].Значение = НоваяНастройка;
		КонецЕсли;
	КонецЕсли;
	
	ТекущаяНастройка = НоваяНастройка;
	ЭтаФорма.Модифицированность = Ложь;
КонецПроцедуры // вСохранитьНастройку()

&НаСервере
Функция ПолучитьМассивРеквизитов()
	МассивРеквизитов = Новый Массив;
	Для Каждого Стр Из Реквизиты Цикл
		Если НЕ Стр.Выбрать Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураРеквизита = Новый Структура;
		СтруктураРеквизита.Вставить("Выбрать", Стр.Выбрать);
		СтруктураРеквизита.Вставить("Реквизит", Стр.Реквизит);
		СтруктураРеквизита.Вставить("Идентификатор", Стр.Идентификатор);
		СтруктураРеквизита.Вставить("Тип", Стр.Тип);
		СтруктураРеквизита.Вставить("Значение", Стр.Значение);
		
		МассивРеквизитов.Добавить(СтруктураРеквизита);
	КонецЦикла;
	
	Возврат МассивРеквизитов;
КонецФункции

&НаСервере
Функция ПолучитьМассивРеквизитовТаблицы()
	МассивРеквизитов = Новый Массив;
	Для Каждого Стр Из РеквизитыТаблицы Цикл
		Если НЕ Стр.Выбрать Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураРеквизита = Новый Структура;
		СтруктураРеквизита.Вставить("Выбрать", Стр.Выбрать);
		СтруктураРеквизита.Вставить("Реквизит", Стр.Реквизит);
		СтруктураРеквизита.Вставить("Идентификатор", Стр.Идентификатор);
		СтруктураРеквизита.Вставить("Тип", Стр.Тип);
		СтруктураРеквизита.Вставить("Значение", Стр.Значение);
		
		МассивРеквизитов.Добавить(СтруктураРеквизита);
	КонецЦикла;
	
	Возврат МассивРеквизитов;
КонецФункции

&НаСервере
Процедура ЗагрузитьРеквизитыИзМассива(МассивРеквизитов)
	ТЗ = РеквизитФормыВЗначение("Реквизиты");
	
	Для Каждого Стр Из МассивРеквизитов Цикл
		Если НЕ Стр.Выбрать Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Реквизит", Стр.Реквизит);
						
		МассивСтрок = ТЗ.НайтиСтроки(СтруктураПоиска);
		Если МассивСтрок.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ТекСтр = МассивСтрок[0];
		ЗаполнитьЗначенияСвойств(ТекСтр, Стр);
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ТЗ, "Реквизиты");
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьРеквизитыТаблицыИзМассива(МассивРеквизитов)
	ТЗ = РеквизитФормыВЗначение("РеквизитыТаблицы");
	
	Для Каждого Стр Из МассивРеквизитов Цикл
		Если НЕ Стр.Выбрать Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Реквизит", Стр.Реквизит);
						
		МассивСтрок = ТЗ.НайтиСтроки(СтруктураПоиска);
		Если МассивСтрок.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ТекСтр = МассивСтрок[0];
		ЗаполнитьЗначенияСвойств(ТекСтр, Стр);
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ТЗ, "РеквизитыТаблицы");
КонецПроцедуры

// Восстанавливает сохраненные значения реквизитов формы.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура ЗагрузитьНастройку() Экспорт

	Если Элементы.ТекущаяНастройка.СписокВыбора.Количество() = 0 Тогда
		УстановитьИмяНастройки("Новая настройка");
	Иначе
		Если НЕ ТекущаяНастройка.Прочее = Неопределено Тогда
			ЗаполнитьЗначенияСвойств(мНастройка, ТекущаяНастройка.Прочее);
		КонецЕсли;
	КонецЕсли;
	
	РеквизитыДляСохранения = Неопределено;
	РеквизитыТаблицыДляСохранения = Неопределено;

	Для каждого РеквизитНастройки из мНастройка Цикл
		Значение = мНастройка[РеквизитНастройки.Ключ];
		Выполнить(Строка(РеквизитНастройки.Ключ) + " = Значение;");
	КонецЦикла;
	
	Если РеквизитыДляСохранения <> Неопределено И РеквизитыДляСохранения.Количество() Тогда
		ЗагрузитьРеквизитыИзМассива(РеквизитыДляСохранения);
	КонецЕсли;

	ЗагрузитьРеквизитыТабличнойЧастиСервер();
	Если РеквизитыТаблицыДляСохранения <> Неопределено И РеквизитыТаблицыДляСохранения.Количество() Тогда
		ЗагрузитьРеквизитыТаблицыИзМассива(РеквизитыТаблицыДляСохранения);
	КонецЕсли;
	
КонецПроцедуры //вЗагрузитьНастройку()

// Устанавливает значение реквизита "ТекущаяНастройка" по имени настройки или произвольно.
//
// Параметры:
//  ИмяНастройки   - произвольное имя настройки, которое необходимо установить.
//
&НаКлиенте
Процедура УстановитьИмяНастройки(ИмяНастройки = "") Экспорт

	Если ПустаяСтрока(ИмяНастройки) Тогда
		Если ТекущаяНастройка = Неопределено Тогда
			ТекущаяНастройкаПредставление = "";
		Иначе
			ТекущаяНастройкаПредставление = ТекущаяНастройка.Обработка;
		КонецЕсли;
	Иначе
		ТекущаяНастройкаПредставление = ИмяНастройки;
	КонецЕсли;

КонецПроцедуры // вУстановитьИмяНастройки()

// Получает структуру для индикации прогресса цикла.
//
// Параметры:
//  КоличествоПроходов – Число - максимальное значение счетчика;
//  ПредставлениеПроцесса – Строка, "Выполнено" – отображаемое название процесса;
//  ВнутреннийСчетчик - Булево, *Истина - использовать внутренний счетчик с начальным значением 1,
//                    иначе нужно будет передавать значение счетчика при каждом вызове обновления индикатора;
//  КоличествоОбновлений - Число, *100 - всего количество обновлений индикатора;
//  ЛиВыводитьВремя - Булево, *Истина - выводить приблизительное время до окончания процесса;
//  РазрешитьПрерывание - Булево, *Истина - разрешает пользователю прерывать процесс.
//
// Возвращаемое значение:
//  Структура - которую потом нужно будет передавать в метод ЛксОбработатьИндикатор.
//
&НаКлиенте
Функция ПолучитьИндикаторПроцесса(КоличествоПроходов, ПредставлениеПроцесса = "Выполнено", ВнутреннийСчетчик = Истина,
	КоличествоОбновлений = 100, ЛиВыводитьВремя = Истина, РазрешитьПрерывание = Истина) Экспорт 
	
	Индикатор = Новый Структура;
	Индикатор.Вставить("КоличествоПроходов", КоличествоПроходов);
	Индикатор.Вставить("ДатаНачалаПроцесса", ТекущаяДата());
	Индикатор.Вставить("ПредставлениеПроцесса", ПредставлениеПроцесса);
	Индикатор.Вставить("ЛиВыводитьВремя", ЛиВыводитьВремя);
	Индикатор.Вставить("РазрешитьПрерывание", РазрешитьПрерывание);
	Индикатор.Вставить("ВнутреннийСчетчик", ВнутреннийСчетчик);
	Индикатор.Вставить("Шаг", КоличествоПроходов / КоличествоОбновлений);
	Индикатор.Вставить("СледующийСчетчик", 0);
	Индикатор.Вставить("Счетчик", 0);
	Возврат Индикатор;
	
КонецФункции // ЛксПолучитьИндикаторПроцесса()

// Проверяет и обновляет индикатор. Нужно вызывать на каждом проходе индицируемого цикла.
//
// Параметры:
//  Индикатор    – Структура – индикатора, полученная методом ЛксПолучитьИндикаторПроцесса;
//  Счетчик      – Число – внешний счетчик цикла, используется при ВнутреннийСчетчик = Ложь.
//
&НаКлиенте
Процедура ОбработатьИндикатор(Индикатор, Счетчик = 0) Экспорт 
	
	Если Индикатор.ВнутреннийСчетчик Тогда
		Индикатор.Счетчик = Индикатор.Счетчик + 1;
		Счетчик = Индикатор.Счетчик;
	КонецЕсли;
	Если Индикатор.РазрешитьПрерывание Тогда
		ОбработкаПрерыванияПользователя();
	КонецЕсли;
	
	Если Счетчик > Индикатор.СледующийСчетчик Тогда
		Индикатор.СледующийСчетчик = Цел(Счетчик + Индикатор.Шаг);
		Если Индикатор.ЛиВыводитьВремя Тогда
			ПрошлоВремени = ТекущаяДата() - Индикатор.ДатаНачалаПроцесса;
			Осталось = ПрошлоВремени * (Индикатор.КоличествоПроходов / Счетчик - 1);
			Часов = Цел(Осталось / 3600);
			Осталось = Осталось - (Часов * 3600);
			Минут = Цел(Осталось / 60);
			Секунд = Цел(Цел(Осталось - (Минут * 60)));
			ОсталосьВремени = Формат(Часов, "ЧЦ=2; ЧН=00; ЧВН=") + ":" 
			+ Формат(Минут, "ЧЦ=2; ЧН=00; ЧВН=") + ":" 
			+ Формат(Секунд, "ЧЦ=2; ЧН=00; ЧВН=");
			ТекстОсталось = "Осталось: ~" + ОсталосьВремени;
		Иначе
			ТекстОсталось = "";
		КонецЕсли;
		
		Если Индикатор.КоличествоПроходов > 0 Тогда
			ТекстСостояния = ТекстОсталось;
		Иначе
			ТекстСостояния = "";
		КонецЕсли;
		
		Состояние(Индикатор.ПредставлениеПроцесса, Счетчик / Индикатор.КоличествоПроходов * 100, ТекстСостояния);
	КонецЕсли;
	
	Если Счетчик = Индикатор.КоличествоПроходов Тогда
		Состояние(Индикатор.ПредставлениеПроцесса, 100, ТекстСостояния);
	КонецЕсли;
	
КонецПроцедуры // ЛксОбработатьИндикатор()

// Загружает справочник.
//
// Параметры: 
//  Объект         - объект справочник.
//
&НаСервере
Процедура ЗагрузитьСправочник(Объект)

	// Код
	Если Объект.ДлинаКода Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Код";
		НоваяСтрока.Идентификатор = "Код";
		Если Объект.ТипКода = Метаданные.СвойстваОбъектов.ТипКодаСправочника.Число Тогда
			НоваяСтрока.Тип = ОписаниеТипа("Число");
		ИначеЕсли Объект.ТипКода = Метаданные.СвойстваОбъектов.ТипКодаСправочника.Строка Тогда
			НоваяСтрока.Тип = ОписаниеТипа("Строка");
		КонецЕсли;
		НоваяСтрока.Значение = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;

	// Наименование
	Если Объект.ДлинаНаименования Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Наименование";
		НоваяСтрока.Идентификатор = "Наименование";
		НоваяСтрока.Тип           = ОписаниеТипа("Строка");
		НоваяСтрока.Значение      = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;
	
	мМенеджеры = РеквизитФормыВЗначение("ОбъектОбработки").мМенеджеры;

	// Владелец
	Если Объект.Владельцы.Количество() Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Владелец";
		НоваяСтрока.Идентификатор = "Владелец";
		
		МассивТипов = Новый Массив;
		Для каждого Владелец из Объект.Владельцы Цикл
			МассивТипов.Добавить(мМенеджеры[Владелец].ТипСсылки);
		КонецЦикла;
		НоваяСтрока.Тип = Новый ОписаниеТипов(МассивТипов);
		НоваяСтрока.Значение = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;

	// Родитель
	Если Объект.КоличествоУровней > 1 Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Родитель";
		НоваяСтрока.Идентификатор = "Родитель";


		МассивТипов = Новый Массив;
		МассивТипов.Добавить(мМенеджеры[Объект].ТипСсылки);

		НоваяСтрока.Тип = Новый ОписаниеТипов(МассивТипов);
		НоваяСтрока.Значение = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;

	ЗагрузитьРеквизиты(Объект);

КонецПроцедуры // ЗагрузитьСправочник()

// Загружает ЗагрузитьПланВидовХарактеристик.
//
// Параметры: 
//  Объект         - объект справочник.
//
&НаСервере
Процедура ЗагрузитьПланВидовХарактеристик(Объект)

	// Код
	Если Объект.ДлинаКода Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Код";
		НоваяСтрока.Идентификатор = "Код";
		НоваяСтрока.Тип = ОписаниеТипа("Строка");
		НоваяСтрока.Значение = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;

	// Наименование
	Если Объект.ДлинаНаименования Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Наименование";
		НоваяСтрока.Идентификатор = "Наименование";
		НоваяСтрока.Тип           = ОписаниеТипа("Строка");
		НоваяСтрока.Значение      = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;
	
	мМенеджеры = РеквизитФормыВЗначение("ОбъектОбработки").мМенеджеры;
         
	// Родитель
	Если Объект.Имя = "ПланВидовХарактеристик" И Объект.Иерархический Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Родитель";
		НоваяСтрока.Идентификатор = "Родитель";

		МассивТипов = Новый Массив;
		МассивТипов.Добавить(мМенеджеры[Объект].ТипСсылки);

		НоваяСтрока.Тип = Новый ОписаниеТипов(МассивТипов);
		НоваяСтрока.Значение = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;

	ЗагрузитьРеквизиты(Объект);

КонецПроцедуры // ЗагрузитьСправочник()

// Загружает документ.
//
// Параметры: 
//  Объект         - объект документ.
//
&НаСервере
Процедура ЗагрузитьДокумент(Объект)

	// Номер
	Если Объект.ДлинаНомера Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Номер";
		НоваяСтрока.Идентификатор = "Номер";
		Если Объект.ТипНомера = Метаданные.СвойстваОбъектов.ТипНомераДокумента.Число Тогда
			НоваяСтрока.Тип = ОписаниеТипа("Число");
		ИначеЕсли Объект.ТипНомера = Метаданные.СвойстваОбъектов.ТипНомераДокумента.Строка Тогда
			НоваяСтрока.Тип = ОписаниеТипа("Строка");
		КонецЕсли;
		НоваяСтрока.Значение = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;

	// Дата
	НоваяСтрока = Реквизиты.Добавить();
	НоваяСтрока.Реквизит      = "Дата";
	НоваяСтрока.Идентификатор = "Дата";
	НоваяСтрока.Тип           = ОписаниеТипа("Дата");
	НоваяСтрока.Значение      = НоваяСтрока.Тип.ПривестиЗначение();

	ЗагрузитьРеквизиты(Объект);

КонецПроцедуры // ЗагрузитьДокумент()

// Загружает Бизнес процесс.
//
// Параметры: 
//  Объект         - объект документ.
//
&НаСервере
Процедура ЗагрузитьБизнесПроцесс(Объект)

	// Номер
	Если Объект.ДлинаНомера Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Номер";
		НоваяСтрока.Идентификатор = "Номер";
		Если Объект.ТипНомера = Метаданные.СвойстваОбъектов.ТипНомераБизнесПроцесса.Число Тогда
			НоваяСтрока.Тип = ОписаниеТипа("Число");
		ИначеЕсли Объект.ТипНомера = Метаданные.СвойстваОбъектов.ТипНомераБизнесПроцесса.Строка Тогда
			НоваяСтрока.Тип = ОписаниеТипа("Строка");
		КонецЕсли;
		НоваяСтрока.Значение = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;

	// Дата
	НоваяСтрока = Реквизиты.Добавить();
	НоваяСтрока.Реквизит      = "Дата";
	НоваяСтрока.Идентификатор = "Дата";
	НоваяСтрока.Тип           = ОписаниеТипа("Дата");
	НоваяСтрока.Значение      = НоваяСтрока.Тип.ПривестиЗначение();

	ЗагрузитьРеквизиты(Объект);

КонецПроцедуры // ЗагрузитьБизнесПроцесс()

// Загружает задачу.
//
// Параметры: 
//  Объект         - объект справочник.
//
&НаСервере
Процедура ЗагрузитьЗадачу(Объект)

	// Номер
	Если Объект.ДлинаНомера Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Номер";
		НоваяСтрока.Идентификатор = "Номер";
		Если Объект.ТипНомера = Метаданные.СвойстваОбъектов.ТипНомераЗадачи.Число Тогда
			НоваяСтрока.Тип = ОписаниеТипа("Число");
		ИначеЕсли Объект.ТипНомера = Метаданные.СвойстваОбъектов.ТипНомераЗадачи.Строка Тогда
			НоваяСтрока.Тип = ОписаниеТипа("Строка");
		КонецЕсли;
		НоваяСтрока.Значение = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;

	// Наименование
	Если Объект.ДлинаНаименования Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Наименование";
		НоваяСтрока.Идентификатор = "Наименование";
		НоваяСтрока.Тип           = ОписаниеТипа("Строка");
		НоваяСтрока.Значение      = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;
	
	ЗагрузитьРеквизиты(Объект);

КонецПроцедуры // ЗагрузитьЗадачу()

// Загружает регистр сведений.
//
// Параметры: 
//  Объект         - объект метаданных регистра сведений.
//
&НаСервере
Процедура ЗагрузитьРегистрСведений(Объект)

	Если Объект.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Период";
		НоваяСтрока.Идентификатор = "Период";
		НоваяСтрока.Тип           = ОписаниеТипа("Дата");
		НоваяСтрока.Значение      = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли; 
	
	Для каждого ЭлементСтруктуры Из СтруктураИзмерений Цикл
		Реквизит = Объект.Измерения[ЭлементСтруктуры.Ключ];
		Если Реквизит.Тип.Типы().Количество() = 1 Тогда
			Если Реквизит.Тип.СодержитТип(Тип("ХранилищеЗначения")) Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = ?(ПустаяСтрока(Реквизит.Синоним), Реквизит.Имя, Реквизит.Синоним);
		НоваяСтрока.Идентификатор = Реквизит.Имя;
		НоваяСтрока.Тип           = Реквизит.Тип;
		НоваяСтрока.Значение      = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЦикла; //Для каждого  Из   
	
	Для каждого ЭлементСтруктуры Из СтруктураРесурсов Цикл
		Реквизит = Объект.Ресурсы[ЭлементСтруктуры.Ключ];
		Если Реквизит.Тип.Типы().Количество() = 1 Тогда
			Если Реквизит.Тип.СодержитТип(Тип("ХранилищеЗначения")) Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = ?(ПустаяСтрока(Реквизит.Синоним), Реквизит.Имя, Реквизит.Синоним);
		НоваяСтрока.Идентификатор = Реквизит.Имя;
		НоваяСтрока.Тип           = Реквизит.Тип;
		НоваяСтрока.Значение      = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЦикла; //Для каждого  Из   
	
	Для каждого ЭлементСтруктуры Из СтруктураРеквизитов Цикл
		Реквизит = Объект.Реквизиты[ЭлементСтруктуры.Ключ];
		Если Реквизит.Тип.Типы().Количество() = 1 Тогда
			Если Реквизит.Тип.СодержитТип(Тип("ХранилищеЗначения")) Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = ?(ПустаяСтрока(Реквизит.Синоним), Реквизит.Имя, Реквизит.Синоним);
		НоваяСтрока.Идентификатор = Реквизит.Имя;
		НоваяСтрока.Тип           = Реквизит.Тип;
		НоваяСтрока.Значение      = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЦикла; //Для каждого  Из   
	
КонецПроцедуры // ЗагрузитьРегистрСведений()

// Загружает реквизиты справочника или документа.
//
// Параметры: 
//  Объект         - объект справочник или документ.
//
&НаСервере
Процедура ЗагрузитьРеквизиты(Объект)

	Для каждого Реквизит из Объект.Реквизиты Цикл
		Если Реквизит.Тип.Типы().Количество() = 1 Тогда
			Если Реквизит.Тип.СодержитТип(Тип("ХранилищеЗначения")) Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = ?(ПустаяСтрока(Реквизит.Синоним), Реквизит.Имя, Реквизит.Синоним);
		НоваяСтрока.Идентификатор = Реквизит.Имя;
		НоваяСтрока.Тип           = Реквизит.Тип;
		НоваяСтрока.Значение      = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЦикла;

	Для Каждого ТабличнаяЧасть из Объект.ТабличныеЧасти Цикл
		Элементы.СписокТабличнаяЧасть.СписокВыбора.Добавить(ТабличнаяЧасть.Имя, ТабличнаяЧасть.Синоним);
	КонецЦикла;
	
КонецПроцедуры // ЗагрузитьРеквизиты()

// Позволяет создать описание типов на основании строкового представления типа.
//
// Параметры: 
//  ТипСтрокой     - Строковое представление типа.
//
// Возвращаемое значение:
//  Описание типов.
//
&НаСервереБезКонтекста
Функция ОписаниеТипа(ТипСтрокой) Экспорт

	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип(ТипСтрокой));
	КвалификаторДаты = Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя);
	ОписаниеТипов = Новый ОписаниеТипов(МассивТипов, , , КвалификаторДаты);

	Возврат ОписаниеТипов;

КонецФункции // вОписаниеТипа()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если мИспользоватьНастройки Тогда
		УстановитьИмяНастройки();
		ЗагрузитьНастройку();
	Иначе
		Элементы.ТекущаяНастройка.Доступность = Ложь;
		Элементы.СохранитьНастройки.Доступность = Ложь;
	КонецЕсли;
	УстановитьКартинкуСтраниц();
	Если Не ЗначениеЗаполнено(ОбработкаСтрок) Тогда
		ОбработкаСтрок = "Замена";
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Настройка") Тогда
		ТекущаяНастройка = Параметры.Настройка;
	КонецЕсли;
	Если Параметры.Свойство("НайденныеОбъекты") Тогда
		НайденныеОбъекты.ЗагрузитьЗначения(Параметры.НайденныеОбъекты);
	КонецЕсли;
	ТекущаяСтрока = -1;
	Если Параметры.Свойство("ТекущаяСтрока") Тогда
		Если Параметры.ТекущаяСтрока <> Неопределено Тогда
			ТекущаяСтрока = Параметры.ТекущаяСтрока;
		КонецЕсли;
	КонецЕсли;
	Если Параметры.Свойство("Родитель") Тогда
		Родитель = Параметры.Родитель;
	КонецЕсли;
	
	Если Параметры.Свойство("АдресТаблицы") Тогда
		АдресТаблицы = Параметры.АдресТаблицы;
	КонецЕсли;
	
	Элементы.ТекущаяНастройка.СписокВыбора.Очистить();
	Если Параметры.Свойство("Настройки") Тогда
		Для Каждого Строка из Параметры.Настройки Цикл
			Элементы.ТекущаяНастройка.СписокВыбора.Добавить(Строка, Строка.Обработка);
		КонецЦикла;
	КонецЕсли;
	
	ДобавляемыеРеквизиты = Новый Массив();
	Реквизит = Новый РеквизитФормы("ЭтоДокумент", Новый ОписаниеТипов("Булево"), , , Истина);
	ДобавляемыеРеквизиты.Добавить(Реквизит);
	
	Реквизит = Новый РеквизитФормы("ЭтоРегистр", Новый ОписаниеТипов("Булево"), , , Истина);
	ДобавляемыеРеквизиты.Добавить(Реквизит);
	
	ЭтаФорма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	Если Параметры.Свойство("ОбъектПоиска") Тогда
		ОбъектПоиска = Параметры.ОбъектПоиска;
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ОбъектПоиска.Тип + "." + ОбъектПоиска.Имя);
		Если ОбъектПоиска.Тип = "Справочник" Тогда
			ЗагрузитьСправочник(ОбъектМетаданных);
		ИначеЕсли ОбъектПоиска.Тип = "Документ" Тогда
			ЗагрузитьДокумент(ОбъектМетаданных);
		ИначеЕсли ОбъектПоиска.Тип = "БизнесПроцесс" Тогда
			ЗагрузитьБизнесПроцесс(ОбъектМетаданных);
		ИначеЕсли ОбъектПоиска.Тип = "Задача" Тогда
			ЗагрузитьЗадачу(ОбъектМетаданных);
		ИначеЕсли ОбъектПоиска.Тип = "ПланВидовХарактеристик" ИЛИ ОбъектПоиска.Тип = "ПланВидовРасчета" ИЛИ ОбъектПоиска.Тип = "ПланОбмена" Тогда
			ЗагрузитьПланВидовХарактеристик(ОбъектМетаданных);
		КонецЕсли;
		
		Если ОбъектПоиска.Тип = "РегистрСведений" ИЛИ ОбъектМетаданных.ТабличныеЧасти.Количество() = 0 Тогда
			Элементы.ГруппаСтраницыРеквизитыТабличнойЧасти.Видимость = Ложь;
		КонецЕсли; 
		
		Если ОбъектПоиска.Тип = "Документ" Тогда
			
			ЭтаФорма.ЭтоДокумент = Истина;
			Элементы.РежимЗаписиДокументаСтрока.СписокВыбора.Добавить("Запись", "Запись");
			Элементы.РежимЗаписиДокументаСтрока.СписокВыбора.Добавить("Проведение", "Проведение");
			Элементы.РежимЗаписиДокументаСтрока.СписокВыбора.Добавить("ОтменаПроведения", "Отмена проведения");
			ЭтаФорма.РежимЗаписиДокументаСтрока = "Запись";
			Элементы.ГруппаРежимЗаписиДокумента.Видимость = Истина;
			
		ИначеЕсли ОбъектПоиска.Тип = "РегистрСведений" Тогда
			
			ЭтаФорма.ЭтоРегистр = Истина;
			СтруктураИзмерений = Новый Структура;
			Для Каждого Реквизит Из ОбъектМетаданных.Измерения Цикл
				СтруктураИзмерений.Вставить(Реквизит.Имя);
			КонецЦикла; 
			СтруктураРесурсов = Новый Структура;
			Для Каждого Реквизит Из ОбъектМетаданных.Ресурсы Цикл
				СтруктураРесурсов.Вставить(Реквизит.Имя);
			КонецЦикла; 
			СтруктураРеквизитов = Новый Структура;
			Для Каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
				СтруктураРеквизитов.Вставить(Реквизит.Имя);
			КонецЦикла; 
			
			ЗагрузитьРегистрСведений(ОбъектМетаданных);
			
		КонецЕсли; 
	
	КонецЕсли;
	
	//[begin] Added by Sergey. http://infostart.ru/profile/18346/
	//25.03.2012 21:01:51
	ДобавляемыеРеквизиты = Новый Массив();
	Реквизит = Новый РеквизитФормы("ОбрабатыватьВТранзакции", Новый ОписаниеТипов("Булево"), , , Истина);
	ДобавляемыеРеквизиты.Добавить(Реквизит);
	Реквизит = Новый РеквизитФормы("ИспользоватьРежимЗагрузкиОбменаДанными", Новый ОписаниеТипов("Булево"), , "Режим загрузки обмена данными (минимальный контроль)", Истина);
	ДобавляемыеРеквизиты.Добавить(Реквизит);
	ОписаниеТиповЧисло = Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(10,0,ДопустимыйЗнак.Неотрицательный));
	Реквизит = Новый РеквизитФормы("КоличествоОбъектовНаТранзакцию", ОписаниеТиповЧисло, , , Истина);
	ДобавляемыеРеквизиты.Добавить(Реквизит);
	Реквизит = Новый РеквизитФормы("РежимРаботы", Новый ОписаниеТипов("Булево"), , "Обработка объектов на сервере", Истина);
	ДобавляемыеРеквизиты.Добавить(Реквизит);
	
	ЭтаФорма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	Если Параметры.Свойство("ОбрабатыватьВТранзакции") Тогда
		ЭтаФорма.ОбрабатыватьВТранзакции = Параметры.ОбрабатыватьВТранзакции;
	КонецЕсли;
	Если Параметры.Свойство("ИспользоватьРежимЗагрузкиОбменаДанными") Тогда
		ЭтаФорма.ИспользоватьРежимЗагрузкиОбменаДанными = Параметры.ИспользоватьРежимЗагрузкиОбменаДанными;
	КонецЕсли;
	Если Параметры.Свойство("КоличествоОбъектовНаТранзакцию") Тогда
		ЭтаФорма.КоличествоОбъектовНаТранзакцию = Параметры.КоличествоОбъектовНаТранзакцию;
	КонецЕсли;
	Если Параметры.Свойство("РежимРаботы") Тогда
		ЭтаФорма.РежимРаботы = Параметры.РежимРаботы;
	КонецЕсли;
	
	Если Параметры.Свойство("ОбъектПоиска") Тогда
		ЭлементГруппа = Элементы.Вставить("ГруппаРежимРаботы", Тип("ГруппаФормы"),, Элементы.ГруппаКнопки);
		ЭлементГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		ЭлементГруппа.Отображение = ОтображениеОбычнойГруппы.Нет;
		ЭлементГруппа.ОтображатьЗаголовок = Ложь;
		ЭлементГруппа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		ЭлементГруппа.РастягиватьПоГоризонтали = Истина;
			
		Если ОбъектПоиска.Тип <> "РегистрСведений" Тогда
			НовыйЭлемент = Элементы.Добавить("РежимРаботы", Тип("ПолеФормы"), ЭлементГруппа);
			НовыйЭлемент.Вид = ВидПоляФормы.ПолеФлажка;
			НовыйЭлемент.ПутьКДанным = "РежимРаботы";
			НовыйЭлемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
		КонецЕсли; 
		Если ОбъектПоиска.Тип <> "РегистрСведений" И ОбъектПоиска.Тип <> "ПланОбмена" Тогда
			НовыйЭлемент = Элементы.Добавить("ИспользоватьРежимЗагрузкиОбменаДанными", Тип("ПолеФормы"), ЭлементГруппа);
			НовыйЭлемент.Вид = ВидПоляФормы.ПолеФлажка;
			НовыйЭлемент.ПутьКДанным = "ИспользоватьРежимЗагрузкиОбменаДанными";
			НовыйЭлемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
		КонецЕсли; 
	КонецЕсли;
	//[end] Added 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	Если ЭтоАдресВременногоХранилища(АдресТаблицы) Тогда
		УдалитьИзВременногоХранилища(АдресТаблицы);
	КонецЕсли;  // 
КонецПроцедуры

//[begin] Added by Sergey. http://infostart.ru/profile/18346/
//25.03.2012 21:02:14
&НаСервереБезКонтекста
Процедура НачатьЗафиксироватьТранзакцию(ОбрабатыватьВТранзакции, НачалоТранзакции = Ложь)  
	
	Если ОбрабатыватьВТранзакции Тогда
		Если НачалоТранзакции Тогда
			НачатьТранзакцию();
		ИначеЕсли ТранзакцияАктивна() Тогда
			ЗафиксироватьТранзакцию();
		КонецЕсли;  //  
	КонецЕсли; 
	
КонецПроцедуры //НачатьЗафиксироватьТранзакцию
//[end] Added 

&НаКлиенте
Процедура УстановитьКартинкуСтраниц()
	
	СтруктураОтбора = Новый Структура("Выбрать", Истина);
	НайденныеСтроки = Реквизиты.НайтиСтроки(СтруктураОтбора);
	ЗаголовокСтраницы = "Реквизиты";
	Если НайденныеСтроки.Количество() > 0 Тогда
		Если Элементы.ГруппаСтраницыРеквизитыТабличнойЧасти.Картинка <> ВидКартинки.Пустая Тогда
			Элементы.ГруппаСтраницаРеквизиты.Картинка = БиблиотекаКартинок.ЗаписатьИЗакрыть;
		КонецЕсли; 
		Элементы.ГруппаСтраницаРеквизиты.Заголовок = ЗаголовокСтраницы + " (" + XMLСтрока(НайденныеСтроки.Количество()) + ")";
	Иначе
		Элементы.ГруппаСтраницаРеквизиты.Картинка = Новый Картинка;
		Элементы.ГруппаСтраницаРеквизиты.Заголовок = ЗаголовокСтраницы;
	КонецЕсли; 
	
	НайденныеСтроки = РеквизитыТаблицы.НайтиСтроки(СтруктураОтбора);
	ЗаголовокСтраницы = "Реквизиты табличной части";
	Если НайденныеСтроки.Количество() > 0 Тогда
		Если Элементы.ГруппаСтраницыРеквизитыТабличнойЧасти.Картинка <> ВидКартинки.Пустая Тогда
			Элементы.ГруппаСтраницыРеквизитыТабличнойЧасти.Картинка = БиблиотекаКартинок.ЗаписатьИЗакрыть;
		КонецЕсли; 
		Элементы.ГруппаСтраницыРеквизитыТабличнойЧасти.Заголовок = ЗаголовокСтраницы + " (" + XMLСтрока(НайденныеСтроки.Количество()) + ")";
	Иначе
		Элементы.ГруппаСтраницыРеквизитыТабличнойЧасти.Картинка = Новый Картинка;
		Элементы.ГруппаСтраницыРеквизитыТабличнойЧасти.Заголовок = ЗаголовокСтраницы;
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ, ВЫЗЫВАЕМЫЕ ИЗ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ВыполнитьОбработкуКоманда(Команда)
	//[begin] Added by Sergey. http://infostart.ru/profile/18346/
	//25.03.2012 21:02:35
	ОбработаноОбъектов = ВыполнитьОбработку();
	//[end] Added 

	Предупреждение("Обработка <" + СокрЛП(ЭтаФорма.Заголовок) + "> завершена!
				   |Обработано объектов: " + ОбработаноОбъектов + ".")
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиКоманда(Команда)
	СохранитьНастройку();
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяНастройкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	Если НЕ ТекущаяНастройка = ВыбранноеЗначение Тогда

		Если ЭтаФорма.Модифицированность Тогда
			Если Вопрос("Сохранить текущую настройку?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да) = КодВозвратаДиалога.Да Тогда
				СохранитьНастройку();
			КонецЕсли;
		КонецЕсли;

		ТекущаяНастройка = ВыбранноеЗначение;
		УстановитьИмяНастройки();

		ЗагрузитьНастройку();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяНастройкаПриИзменении(Элемент)
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЭлементы(ИмяТаблицы, Выбор)
	
	Таблица = ЭтаФорма[ИмяТаблицы];
	
	Для Каждого Стр Из Таблица Цикл
		Стр.Выбрать = Выбор;
	КонецЦикла;
	
	УстановитьКартинкуСтраниц();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	ВыбратьЭлементы("Реквизиты", Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыбор(Команда)
	ВыбратьЭлементы("Реквизиты", Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеЭлементыТабличнойЧасти(Команда)
	ВыбратьЭлементы("РеквизитыТаблицы", Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыборЭлементовТабличнойЧасти(Команда)
	ВыбратьЭлементы("РеквизитыТаблицы", Ложь);
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыЗначениеОчистка(Элемент, СтандартнаяОбработка)
	Элементы.РеквизитыЗначение.ВыбиратьТип = Истина;
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыЗначениеПриИзменении(Элемент)
	Элементы.Реквизиты.ТекущиеДанные.Выбрать = Истина;
	УстановитьКартинкуСтраниц();
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыВыбратьПриИзменении(Элемент)
	УстановитьКартинкуСтраниц();
КонецПроцедуры

// Обработчик действия "Открытие" поля ввода "Значение" табличного поля "Реквизиты".
//
&НаКлиенте
Процедура РеквизитыЗначениеОткрытие(Элемент, СтандартнаяОбработка)
	
	ТипыФильтра = Элементы.Реквизиты.ТекущиеДанные.Тип;

	МассивТипов = ТипыФильтра.Типы();

	Если МассивТипов.Количество() = 1 И ТипыФильтра.СодержитТип(Тип("Строка")) Тогда
		СтандартнаяОбработка = Ложь;
		Элемент.МногострочныйРежим  = Истина;
		ЗначениеЭлемента = Элементы.Реквизиты.ТекущиеДанные.Значение;
		Если ВвестиСтроку(ЗначениеЭлемента, "Введите значение элемента", , Истина) Тогда
			Элементы.Реквизиты.ТекущиеДанные.Значение = ЗначениеЭлемента;
			Элементы.Реквизиты.ТекущиеДанные.Выбрать = Истина;
		КонецЕсли; 
	КонецЕсли;
	УстановитьКартинкуСтраниц();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьРеквизитыТабличнойЧастиСервер()
	
	Если ЗначениеЗаполнено(СписокТабличнаяЧасть) Тогда
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ОбъектПоиска.Тип + "." + ОбъектПоиска.Имя);
		Если ОбъектМетаданных.ТабличныеЧасти.Найти(СписокТабличнаяЧасть) <> Неопределено Тогда
			РеквизитыТаблицы.Очистить();
			Для каждого Реквизит из ОбъектМетаданных.ТабличныеЧасти[СписокТабличнаяЧасть].Реквизиты Цикл
				Если Реквизит.Тип.Типы().Количество() = 1 Тогда
					Если Реквизит.Тип.СодержитТип(Тип("ХранилищеЗначения")) Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
				НоваяСтрока = РеквизитыТаблицы.Добавить();
				НоваяСтрока.Реквизит      = ?(ПустаяСтрока(Реквизит.Синоним), Реквизит.Имя, Реквизит.Синоним);
				НоваяСтрока.Идентификатор = Реквизит.Имя;
				НоваяСтрока.Тип           = Реквизит.Тип;
				НоваяСтрока.Значение      = НоваяСтрока.Тип.ПривестиЗначение();
			КонецЦикла;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СписокТабличнаяЧастьПриИзменении(Элемент)
	
	ЗагрузитьРеквизитыТабличнойЧастиСервер();
	УстановитьКартинкуСтраниц();
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыТаблицыЗначениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Элементы.РеквизитыТаблицы.ТекущиеДанные.Выбрать = Истина;
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыТаблицыЗначениеОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	Элементы.РеквизитыТаблицы.ТекущиеДанные.Выбрать = Истина;
	УстановитьКартинкуСтраниц();
КонецПроцедуры

// Обработчик действия "Открытие" поля ввода "Значение" табличного поля "Реквизиты".
//
&НаКлиенте
Процедура РеквизитыТаблицыЗначениеОткрытие(Элемент, СтандартнаяОбработка)
	
	ТипыФильтра = Элементы.РеквизитыТаблицы.ТекущиеДанные.Тип;

	МассивТипов = ТипыФильтра.Типы();

	Если МассивТипов.Количество() = 1 И ТипыФильтра.СодержитТип(Тип("Строка")) Тогда
		СтандартнаяОбработка = Ложь;
		Элемент.МногострочныйРежим  = Истина;
		ЗначениеЭлемента = Элементы.РеквизитыТаблицы.ТекущиеДанные.Значение;
		Если ВвестиСтроку(ЗначениеЭлемента, "Введите значение элемента", , Истина) Тогда
			Элементы.РеквизитыТаблицы.ТекущиеДанные.Значение = ЗначениеЭлемента;
			Элементы.РеквизитыТаблицы.ТекущиеДанные.Выбрать = Истина;
		КонецЕсли; 
	КонецЕсли;
	УстановитьКартинкуСтраниц();
	
КонецПроцедуры

// Обработчик действия "ПриАктивизацииЯчейки" табличного поля "Реквизиты".
//
&НаКлиенте
Процедура РеквизитыПриАктивизацииЯчейки(Элемент)
	
	Если Элементы[Элемент.Имя].ТекущиеДанные <> Неопределено 
		И Элемент.ТекущийЭлемент.Имя = Элемент.Имя + "Значение" Тогда
		
		МассивТипов = Элементы[Элемент.Имя].ТекущиеДанные.Тип.Типы();
		Если МассивТипов.Количество() > 1 Тогда
			Элемент.ТекущийЭлемент.ВыбиратьТип = Истина;
		Иначе
			Элемент.ТекущийЭлемент.ВыбиратьТип = Ложь;
		КонецЕсли; 
		Элемент.ТекущийЭлемент.ОграничениеТипа = Элементы[Элемент.Имя].ТекущиеДанные.Тип;
		
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ИНИЦИАЛИЗАЦИЯ МОДУЛЬНЫХ ПЕРЕМЕННЫХ

мИспользоватьНастройки = Истина;

//Реквизиты настройки и значения по умолчанию.
мНастройка = Новый Структура("РеквизитыДляСохранения, РеквизитыТаблицыДляСохранения, СписокТабличнаяЧасть, ОбработкаСтрок, РежимЗаписиДокументаСтрока, РежимРаботы, ИспользоватьРежимЗагрузкиОбменаДанными");

//мНастройка.<Имя реквизита> = <Значение реквизита>;

мТипыОбрабатываемыхОбъектов = "Справочник,Документ,Задача,БизнесПроцесс,ПланВидовХарактеристик,ПланВидовРасчета,ПланОбмена,РегистрСведений";