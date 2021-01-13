﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.АвторФайлов) Тогда
		ВКачествеАвтораФайлов = "Пользователь";
		Элементы.АвторФайлов.Доступность = Истина;
	Иначе
		ВКачествеАвтораФайлов = "ПланОбмена";
		Элементы.АвторФайлов.Доступность = Ложь;
	КонецЕсли;
	
	Если Не ПустаяСтрока(Объект.Сервис) Тогда
		Если Объект.Сервис = "https://webdav.yandex.com"
			Или Объект.Сервис = "https://webdav.yandex.ru" Тогда
			Сервис = НСтр("ru = 'Яндекс.Диск'");
		ИначеЕсли Объект.Сервис = "https://webdav.4shared.com" Тогда
			Сервис = "4shared.com"
		ИначеЕсли Объект.Сервис = "https://dav.box.com/dav" Тогда
			Сервис = "Box"
		ИначеЕсли Объект.Сервис = "https://dav.dropdav.com" Тогда
			Сервис = "Dropbox"
		КонецЕсли;
	КонецЕсли;
	
	АвтоНаименование = ПустаяСтрока(Объект.Наименование);
	Если Не ПустаяСтрока(Объект.Наименование) Тогда
		Элементы.ВКачествеАвтораФайлов.СписокВыбора[0].Представление =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ВКачествеАвтораФайлов.Заголовок, "(" + Объект.Наименование + ")");
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
		МодульЗапретРедактированияРеквизитовОбъектов = ОбщегоНазначения.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектов");
		МодульЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.Наименование.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не Отказ Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Ссылка, Логин, "Логин");
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Ссылка, Пароль);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УстановитьПривилегированныйРежим(Истина);
	Мандат = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ТекущийОбъект.Ссылка, "Логин, Пароль");
	Логин = Мандат.Логин;
	Пароль = Мандат.Пароль;
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	АвтоНаименование = ПустаяСтрока(Объект.Наименование);
КонецПроцедуры

&НаКлиенте
Процедура СервисПредставлениеПриИзменении(Элемент)
	
	Если Сервис = "Яндекс.Диск" Тогда
		Объект.Сервис = "https://webdav.yandex.com"
	ИначеЕсли Сервис = "4shared.com" Тогда
		Объект.Сервис = "https://webdav.4shared.com"
	ИначеЕсли Сервис = "Box" Тогда
		Объект.Сервис = "https://dav.box.com/dav"
	ИначеЕсли Сервис = "Dropbox" Тогда
		Объект.Сервис = "https://dav.dropdav.com"
	Иначе
		Объект.Сервис = "";
	КонецЕсли;
	
	Если АвтоНаименование Тогда
		Если ЗначениеЗаполнено(Объект.Сервис) Тогда
			Объект.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Синхронизация с %1'"), 
				Элементы.Сервис.СписокВыбора.НайтиПоЗначению(Сервис).Представление);
		Иначе
			Объект.Наименование = "";
		КонецЕсли;	
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ВКачествеАвтораФайловПриИзменении(Элемент)
	
	Объект.АвторФайлов = Неопределено;
	Элементы.АвторФайлов.Доступность = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьНастройки(Команда)
	
	ОчиститьСообщения();
	
	Если Объект.Ссылка.Пустая() Или Модифицированность Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьНастройкиЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Для проверки настроек необходимо записать данные учетной записи. Продолжить?'");
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("Продолжить", НСтр("ru = 'Продолжить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
		Возврат;
	КонецЕсли;
	
	ПроверитьВозможностьСинхронизацииСОблачнымСервисом();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	МодульЗапретРедактированияРеквизитовОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектовКлиент");
	МодульЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьНастройкиЗавершение(РезультатДиалога, ДополнительныеПараметры) Экспорт
	
	Если РезультатДиалога <> "Продолжить" Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьВозможностьСинхронизацииСОблачнымСервисом();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВозможностьСинхронизацииСОблачнымСервисом()
	
	СтруктураРезультата = Неопределено;
	
	ВыполнитьПроверкуПодключения(Объект.Ссылка, СтруктураРезультата);
	
	РезультатПротокол = СтруктураРезультата.РезультатПротокол;
	РезультатТекст = СтруктураРезультата.РезультатТекст;
	
	Если СтруктураРезультата.Отказ Тогда
		
		ТекстПротокола = СтроковыеФункцииКлиентСервер.ИзвлечьТекстИзHTML(РезультатПротокол);
		Если Не ЗначениеЗаполнено(СтруктураРезультата.КодОшибки) Тогда
			
			РезультатДиагностики = ПроверитьСоединение(Объект.Сервис, ТекстПротокола);
			ТекстОшибки          = РезультатДиагностики.ОписаниеОшибки;
			ТекстПротокола       = РезультатДиагностики.ЖурналДиагностики;
			
		ИначеЕсли СтруктураРезультата.КодОшибки = 404 Тогда
			ТекстОшибки = НСтр("ru = 'Проверьте правильность указанной корневой папки.'");
		ИначеЕсли СтруктураРезультата.КодОшибки = 401 Тогда
			ТекстОшибки = НСтр("ru = 'Проверьте правильность введенных логина/пароля.'");
		Иначе
			ТекстОшибки = НСтр("ru = 'Проверьте правильность введенных данных.'");
		КонецЕсли;
		
		ПоказатьПредупреждение(Неопределено, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Проверка параметров учетной записи завершилась с ошибками.
					   |%1
					   |
					   |Технические подробности:
					   |%2'"),
					   ТекстОшибки,
					   ТекстПротокола));
	Иначе
		ПоказатьПредупреждение(Неопределено, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Проверка параметров учетной записи завершилась успешно. 
					   |%1'"),
			РезультатТекст));
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПроверкуПодключения(УчетнаяЗапись, СтруктураРезультата)
	РаботаСФайламиСлужебный.ВыполнитьПроверкуПодключения(УчетнаяЗапись, СтруктураРезультата);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьСоединение(Сервис, ТекстПротокола)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		МодульПолучениеФайловИзИнтернета = ОбщегоНазначения.ОбщийМодуль("ПолучениеФайловИзИнтернета");
		Возврат МодульПолучениеФайловИзИнтернета.ДиагностикаСоединения(Сервис);
	Иначе
		
		Возврат Новый Структура("ОписаниеОшибки, ЖурналДиагностики",
			НСтр("ru = 'Проверьте соединение с сетью Интернет.'"), ТекстПротокола);
			
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ВКачествеАвтораФайловПользовательПриИзменении(Элемент)
	
	Элементы.АвторФайлов.Доступность = Истина;
	
КонецПроцедуры

#КонецОбласти