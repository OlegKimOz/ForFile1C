﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ЗагрузкаФайловИзФайловойСистемы

// Продолжение процедуры ФайловаяСистемаКлиент.ПоказатьПомещениеФайла.
Процедура ПоказатьПомещениеФайлаПриПодключенииРасширенияРаботыСФайлами(РасширениеПодключено, Контекст) Экспорт
	
	Диалог               = Контекст.Диалог;
	Интерактивно         = Контекст.Интерактивно;
	ЗагружаемыеФайлы     = Контекст.ЗагружаемыеФайлы;
	ИдентификаторФормы   = Контекст.ИдентификаторФормы;
	ОбработчикЗавершения = Контекст.ОбработчикЗавершения;

	ПараметрыОбработкиРезультата = Новый Структура;
	ПараметрыОбработкиРезультата.Вставить("МножественныйВыбор",   Диалог.МножественныйВыбор);
	ПараметрыОбработкиРезультата.Вставить("ОбработчикЗавершения", ОбработчикЗавершения);
	
	Если РасширениеПодключено Тогда
		
		Если Интерактивно Тогда
			ПомещаемыеФайлы = Новый Массив;
		Иначе
			Диалог = "";
			ПомещаемыеФайлы = ЗагружаемыеФайлы;
		КонецЕсли;
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОбработатьРезультатПомещенияФайлов", ЭтотОбъект, ПараметрыОбработкиРезультата);
		
		Если ЗначениеЗаполнено(ИдентификаторФормы) Тогда
			НачатьПомещениеФайлов(ОписаниеОповещения, ПомещаемыеФайлы, Диалог, Интерактивно, ИдентификаторФормы);
		Иначе
			НачатьПомещениеФайлов(ОписаниеОповещения, ПомещаемыеФайлы, Диалог, Интерактивно);
		КонецЕсли;
		
	Иначе 
		
		Обработчик = Новый ОписаниеОповещения(
			"ОбработатьРезультатПомещенияФайла", ЭтотОбъект, ПараметрыОбработкиРезультата);
			
		Если ЗначениеЗаполнено(ИдентификаторФормы) Тогда
			НачатьПомещениеФайла(Обработчик, , Диалог.ПолноеИмяФайла, Истина, ИдентификаторФормы);
		Иначе
			НачатьПомещениеФайла(Обработчик, , Диалог.ПолноеИмяФайла, Истина);
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

// Завершение помещения файлов.
Процедура ОбработатьРезультатПомещенияФайлов(ПомещенныеФайлы, ПараметрыОбработкиРезультата) Экспорт
	
	ОбработатьРезультатПомещенияФайла(ПомещенныеФайлы <> Неопределено, ПомещенныеФайлы, Неопределено,
		ПараметрыОбработкиРезультата);
	
КонецПроцедуры

// Завершение помещения файла.
Процедура ОбработатьРезультатПомещенияФайла(ВыборВыполнен, АдресИлиРезультатВыбора, ВыбранноеИмяФайла,
		ПараметрыОбработкиРезультата) Экспорт
	
	Если ВыборВыполнен = Истина Тогда
		
		Если ТипЗнч(АдресИлиРезультатВыбора) = Тип("Массив") Тогда
			
			Если ПараметрыОбработкиРезультата.МножественныйВыбор Тогда
				ПомещенныеФайлы = АдресИлиРезультатВыбора;
			Иначе
				
				ПомещенныеФайлы = Новый Структура;
				ПомещенныеФайлы.Вставить("Хранение", АдресИлиРезультатВыбора[0].Хранение);
				ПомещенныеФайлы.Вставить("Имя",      АдресИлиРезультатВыбора[0].Имя);
				
			КонецЕсли;
			
		Иначе
			
			ОписаниеФайла = Новый Структура;
			ОписаниеФайла.Вставить("Хранение", АдресИлиРезультатВыбора);
			ОписаниеФайла.Вставить("Имя",      ВыбранноеИмяФайла);
			
			Если ПараметрыОбработкиРезультата.МножественныйВыбор Тогда
				ПомещенныеФайлы = Новый Массив;
				ПомещенныеФайлы.Добавить(ОписаниеФайла);
			Иначе
				ПомещенныеФайлы = ОписаниеФайла;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		ПомещенныеФайлы = Неопределено;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ПараметрыОбработкиРезультата.ОбработчикЗавершения, ПомещенныеФайлы);
	
КонецПроцедуры

#КонецОбласти

#Область СохранениеФайловВФайловуюСистему

// Продолжение процедуры ФайловаяСистемаКлиент.ПоказатьПолучениеФайлов.
Процедура ПоказатьПолучениеФайловПриПодключенииРасширенияРаботыСФайлами(РасширениеПодключено, Контекст) Экспорт
	
	Интерактивно = Контекст.Интерактивно;
	Диалог = ?(Интерактивно, Контекст.Диалог, Контекст.Диалог.Каталог);
	
	Если РасширениеПодключено Тогда
		
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ОповеститьОЗавершенииПолученияФайлов", ЭтотОбъект, Контекст);
		НачатьПолучениеФайлов(ОповещениеОЗавершении, Контекст.ПолучаемыеФайлы,
			Диалог, Интерактивно);
		
	Иначе
		
		Для Каждого ПолучаемыйФайл Из Контекст.ПолучаемыеФайлы Цикл
			ПолучитьФайл(ПолучаемыйФайл.Хранение, ПолучаемыйФайл.Имя, Истина);
		КонецЦикла;
		
		Если Контекст.ОбработчикЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(Контекст.ОбработчикЗавершения, Неопределено);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.ПоказатьПолучениеФайлов.
Процедура ОповеститьОЗавершенииПолученияФайлов(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.ОбработчикЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОбработчикЗавершения, ПолученныеФайлы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОткрытиеФайлов

// Продолжение процедуры ФайловаяСистемаКлиент.ОткрытьФайл.
Процедура ОткрытьФайлПослеСохранения(СохраненныеФайлы, ПараметрыОткрытия) Экспорт
	
	Если СохраненныеФайлы = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ПараметрыОткрытия.ОбработчикЗавершения, Ложь);
	Иначе
		
		ОписаниеФайла = 
			?(ТипЗнч(СохраненныеФайлы) = Тип("Массив"), 
				СохраненныеФайлы[0], 
				СохраненныеФайлы);
		
		ОбработчикЗавершения = Новый ОписаниеОповещения(
			"ОткрытьФайлПослеЗавершенияРедактирования", ЭтотОбъект, ПараметрыОткрытия);
		
		ОткрытьФайлВПрограммеПросмотра(ОписаниеФайла.Имя, ОбработчикЗавершения, ПараметрыОткрытия.ДляРедактирования);
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.ОткрытьФайл.
// Открывает файл в программе просмотра, ассоциированной с расширением файла в операционной системе.
// Блокирует возможность открытия файлов, расширение которых относятся к исполняемым файлам.
//
// Параметры:
//  ПутьКФайлу        - Строка - полный путь к файлу на диске, который требуется открыть.
//  Оповещение        - ОписаниеОповещения - оповещение о результате открытия.
//                    если оповещение не задано, в случае ошибки будет показано предупреждение.
//   - ПриложениеЗапущено      - Булево - Истина, если внешнее приложение не вызвало ошибок при открытии.
//   - ДополнительныеПараметры - Произвольный - значение, которое было указано при создании объекта ОписаниеОповещения.
//  ДляРедактирования - Булево - Истина, если файл открывается для редактирования, иначе Ложь.
//  
// Пример:
//  ОбщегоНазначенияКлиент.ОткрытьФайлВПрограммеПросмотра(КаталогДокументов() + "test.pdf");
//  ОбщегоНазначенияКлиент.ОткрытьФайлВПрограммеПросмотра(КаталогДокументов() + "test.xlsx");
//
Процедура ОткрытьФайлВПрограммеПросмотра(ПутьКФайлу, Знач Оповещение = Неопределено,
		Знач ДляРедактирования = Ложь)
	
	ФайлИнфо = Новый Файл(ПутьКФайлу);
	
	Контекст = Новый Структура;
	Контекст.Вставить("ФайлИнфо",          ФайлИнфо);
	Контекст.Вставить("Оповещение",        Оповещение);
	Контекст.Вставить("ДляРедактирования", ДляРедактирования);
	
	Оповещение = Новый ОписаниеОповещения(
		"ОткрытьФайлВПрограммеПросмотраПослеПроверкиРасширенияРаботыСФайлами", ЭтотОбъект, Контекст);
	
	ТекстПредложения = НСтр("ru = 'Для открытия файла необходимо установить расширение работы с файлами.'");
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Оповещение, ТекстПредложения, Ложь);
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.ОткрытьФайл.
Процедура ОткрытьФайлВПрограммеПросмотраПослеПроверкиРасширенияРаботыСФайлами(РасширениеПодключено, Контекст) Экспорт
	
	ФайлИнфо = Контекст.ФайлИнфо;
	Если РасширениеПодключено Тогда
		
		Оповещение = Новый ОписаниеОповещения(
			"ОткрытьФайлВПрограммеПросмотраПослеПроверкиСуществования", ЭтотОбъект, Контекст,
			"ОткрытьФайлВПрограммеПросмотраПриОбработкеОшибки", ЭтотОбъект);
		ФайлИнфо.НачатьПроверкуСуществования(Оповещение);
		
	Иначе
		
		ОписаниеОшибки = НСтр("ru = 'Расширение для работы с файлами не установлено, открытие файла невозможно.'");
		ОткрытьФайлВПрограммеПросмотраОповеститьОбОшибке(ОписаниеОшибки, Контекст);
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.ОткрытьФайл.
Процедура ОткрытьФайлВПрограммеПросмотраПослеПроверкиСуществования(Существует, Контекст) Экспорт
	
	ФайлИнфо = Контекст.ФайлИнфо;
	Если Существует Тогда
		 
		Оповещение = Новый ОписаниеОповещения(
			"ОткрытьФайлВПрограммеПросмотраПослеПроверкиЭтоФайл", ЭтотОбъект, Контекст,
			"ОткрытьФайлВПрограммеПросмотраПриОбработкеОшибки", ЭтотОбъект);
		ФайлИнфо.НачатьПроверкуЭтоФайл(Оповещение);
		
	Иначе 
		
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не найден файл, который требуется открыть:
			           |%1'"),
			ФайлИнфо.ПолноеИмя);
		ОткрытьФайлВПрограммеПросмотраОповеститьОбОшибке(ОписаниеОшибки, Контекст);
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.ОткрытьФайл.
Процедура ОткрытьФайлВПрограммеПросмотраПослеПроверкиЭтоФайл(ЭтоФайл, Контекст) Экспорт
	
	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	
	ФайлИнфо = Контекст.ФайлИнфо;
	Если ЭтоФайл Тогда
		
		Если ПустаяСтрока(ФайлИнфо.Расширение) Тогда 
			
			ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Имя файла не содержит расширения:
				           |%1'"),
				ФайлИнфо.ПолноеИмя);
			
			ОткрытьФайлВПрограммеПросмотраОповеститьОбОшибке(ОписаниеОшибки, Контекст);
			Возврат;
			
		КонецЕсли;
		
		Если ЭтоРасширениеИсполняемогоФайла(ФайлИнфо.Расширение) Тогда 
			
			ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Исполняемые файлы открывать запрещено:
				           |%1'"),
				ФайлИнфо.ПолноеИмя);
			
			ОткрытьФайлВПрограммеПросмотраОповеститьОбОшибке(ОписаниеОшибки, Контекст);
			Возврат;
			
		КонецЕсли;
		
		Оповещение          = Контекст.Оповещение;
		ДождатьсяЗавершения = Контекст.ДляРедактирования;
		
		Оповещение = Новый ОписаниеОповещения(
			"ОткрытьФайлВПрограммеПросмотраПослеЗапускаПриложения", ЭтотОбъект, Контекст,
			"ОткрытьФайлВПрограммеПросмотраПриОбработкеОшибки", ЭтотОбъект);
		НачатьЗапускПриложения(Оповещение, ФайлИнфо.ПолноеИмя,, ДождатьсяЗавершения);
		
	Иначе 
		
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не найден файл, который требуется открыть:
			           |%1'"),
			ФайлИнфо.ПолноеИмя);
			
		ОткрытьФайлВПрограммеПросмотраОповеститьОбОшибке(ОписаниеОшибки, Контекст);
		
	КонецЕсли;
	
	// АПК:534-вкл
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.ОткрытьФайл.
Процедура ОткрытьФайлВПрограммеПросмотраПослеЗапускаПриложения(КодВозврата, Контекст) Экспорт 
	
	Оповещение = Контекст.Оповещение;
	
	Если Оповещение <> Неопределено Тогда 
		ПриложениеЗапущено = (КодВозврата = 0);
		ВыполнитьОбработкуОповещения(Оповещение, ПриложениеЗапущено);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.ОткрытьФайл.
Процедура ОткрытьФайлВПрограммеПросмотраПриОбработкеОшибки(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФайлВПрограммеПросмотраОповеститьОбОшибке("", Контекст);
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.ОткрытьФайл.
Процедура ОткрытьФайлПослеЗавершенияРедактирования(ПриложениеЗапущено, ПараметрыОткрытия) Экспорт
	
	Если ПриложениеЗапущено
		И ПараметрыОткрытия.Свойство("АдресДвоичныхДанныхДляОбновления") Тогда
		
		Оповещение = Новый ОписаниеОповещения(
			"ОткрытьФайлПослеОбновленияДанныхВХранилище", ЭтотОбъект, ПараметрыОткрытия);
			
		НачатьПомещениеФайла(Оповещение, ПараметрыОткрытия.АдресДвоичныхДанныхДляОбновления,
			ПараметрыОткрытия.ПутьКФайлу, Ложь);
		
	Иначе
		ВыполнитьОбработкуОповещения(ПараметрыОткрытия.ОбработчикЗавершения, ПриложениеЗапущено);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.ОткрытьФайл.
Процедура ОткрытьФайлПослеОбновленияДанныхВХранилище(ДанныеОбновлены, АдресДанных, ИмяФайла,
		ПараметрыОткрытия) Экспорт
	
	Если ПараметрыОткрытия.Свойство("УдалятьПослеОбновленияДанных") Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ДанныеОбновлены", ДанныеОбновлены);
		ДополнительныеПараметры.Вставить("ПараметрыОткрытия", ПараметрыОткрытия);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОткрытьФайлПослеУдаленияВременногоФайла", ЭтотОбъект, ДополнительныеПараметры);
			
		НачатьУдалениеФайлов(ОписаниеОповещения, ИмяФайла);
		
	Иначе
		ВыполнитьОбработкуОповещения(ПараметрыОткрытия.ОбработчикЗавершения, ДанныеОбновлены);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.ОткрытьФайл.
Процедура ОткрытьФайлПослеУдаленияВременногоФайла(ДополнительныеПараметры) Экспорт
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ПараметрыОткрытия.ОбработчикЗавершения,
		ДополнительныеПараметры.ДанныеОбновлены);
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.ОткрытьФайл.
Процедура ОткрытьФайлВПрограммеПросмотраОповеститьОбОшибке(ОписаниеОшибки, Контекст)
	
	Если Не ПустаяСтрока(ОписаниеОшибки) Тогда 
		ПоказатьПредупреждение(, ОписаниеОшибки);
	КонецЕсли;
	
	ПриложениеЗапущено = Ложь;
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, ПриложениеЗапущено);
	
КонецПроцедуры

// Параметры:
//  Расширение - Строка - свойство Расширение объекта Файл.
//
Функция ЭтоРасширениеИсполняемогоФайла(Знач Расширение)
	
	Расширение = ВРег(Расширение);
	
	// Windows
	Возврат Расширение = ".BAT" // Batch File
		Или Расширение = ".BIN" // Binary Executable
		Или Расширение = ".CMD" // Command Script
		Или Расширение = ".COM" // Приложение MS-DOS
		Или Расширение = ".CPL" // Control Panel Extension
		Или Расширение = ".EXE" // Исполняемый файл
		Или Расширение = ".GADGET" // Binary Executable
		Или Расширение = ".HTA" // HTML Application
		Или Расширение = ".INF1" // Setup Information File
		Или Расширение = ".INS" // Internet Communication Settings
		Или Расширение = ".INX" // InstallShield Compiled Script
		Или Расширение = ".ISU" // InstallShield Uninstaller Script
		Или Расширение = ".JOB" // Windows Task Scheduler Job File
		Или Расширение = ".LNK" // File Shortcut
		Или Расширение = ".MSC" // Microsoft Common Console Document
		Или Расширение = ".MSI" // Windows Installer Package
		Или Расширение = ".MSP" // Windows Installer Patch
		Или Расширение = ".MST" // Windows Installer Setup Transform File
		Или Расширение = ".OTM" // Макрос Microsoft Outlook
		Или Расширение = ".PAF" // Portable Application Installer File
		Или Расширение = ".PIF" // Program Information File
		Или Расширение = ".PS1" // Windows PowerShell Cmdlet
		Или Расширение = ".REG" // Registry Data File
		Или Расширение = ".RGS" // Registry Script
		Или Расширение = ".SCT" // Windows Scriptlet
		Или Расширение = ".SHB" // Windows Document Shortcut
		Или Расширение = ".SHS" // Shell Scrap Object
		Или Расширение = ".U3P" // U3 Smart Application
		Или Расширение = ".VB"  // VBScript File
		Или Расширение = ".VBE" // VBScript Encoded Script
		Или Расширение = ".VBS" // VBScript File
		Или Расширение = ".VBSCRIPT" // Visual Basic Script
		Или Расширение = ".WS"  // Windows Script
		Или Расширение = ".WSF" // Windows Script
	// Linux
		Или Расширение = ".CSH" // C Shell Script
		Или Расширение = ".KSH" // Unix Korn Shell Script
		Или Расширение = ".OUT" // Исполняемый файл
		Или Расширение = ".RUN" // Исполняемый файл
		Или Расширение = ".SH"  // Shell Script
	// MacOS
		Или Расширение = ".ACTION" // Automator Action
		Или Расширение = ".APP" // Исполняемый файл
		Или Расширение = ".COMMAND" // Terminal Command
		Или Расширение = ".OSX" // Исполняемый файл
		Или Расширение = ".WORKFLOW" // Automator Workflow
	// Прочие
		Или Расширение = ".AIR" // Установочный пакет Adobe AIR
		Или Расширение = ".COFFIE" // Сценарий CoffeeScript (JavaScript)
		Или Расширение = ".JAR" // Архив Java
		Или Расширение = ".JS"  // JScript File
		Или Расширение = ".JSE" // JScript Encoded File
		Или Расширение = ".PLX" // Исполняемый файл Perl
		Или Расширение = ".PYC" // Компилированный файл Python
		Или Расширение = ".PYO"; // Оптимизированный код Python
	
КонецФункции

#КонецОбласти

#Область ОткрытьПроводник

// Продолжение процедуры ОбщегоНазначенияКлиент.ОткрытьПроводник.
Процедура ОткрытьПроводникПослеПроверкиРасширенияРаботыСФайлами(РасширениеПодключено, Контекст) Экспорт
	
	ФайлИнфо = Контекст.ФайлИнфо;
	
	Если РасширениеПодключено Тогда
		Оповещение = Новый ОписаниеОповещения(
			"ОткрытьПроводникПослеПроверкиСуществования", ЭтотОбъект, Контекст, 
			"ОткрытьПроводникПриОбработкеОшибки", ЭтотОбъект);
		ФайлИнфо.НачатьПроверкуСуществования(Оповещение);
	Иначе
		ОписаниеОшибки = НСтр("ru = 'Расширение для работы с файлами не установлено, открытие папки не возможно.'");
		ОткрытьПроводникОповеститьОбОшибке(ОписаниеОшибки, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ОткрытьПроводник.
Процедура ОткрытьПроводникПослеПроверкиСуществования(Существует, Контекст) Экспорт 
	
	ФайлИнфо = Контекст.ФайлИнфо;
	
	Если Существует Тогда 
		Оповещение = Новый ОписаниеОповещения(
			"ОткрытьПроводникПослеПроверкиЭтоФайл", ЭтотОбъект, Контекст, 
			"ОткрытьПроводникПриОбработкеОшибки", ЭтотОбъект);
		ФайлИнфо.НачатьПроверкуЭтоФайл(Оповещение);
	Иначе 
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не найдена папка, которую требуется открыть в проводнике:
			           |""%1""'"),
			ФайлИнфо.ПолноеИмя);
		ОткрытьПроводникОповеститьОбОшибке(ОписаниеОшибки, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ОткрытьПроводник.
Процедура ОткрытьПроводникПослеПроверкиЭтоФайл(ЭтоФайл, Контекст) Экспорт 
	
	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	
	ФайлИнфо = Контекст.ФайлИнфо;
	
	Оповещение = Новый ОписаниеОповещения(,,, "ОткрытьПроводникПриОбработкеОшибки", ЭтотОбъект);
	Если ЭтоФайл Тогда
		Если ОбщегоНазначенияКлиент.ЭтоWindowsКлиент() Тогда
			НачатьЗапускПриложения(Оповещение, "explorer.exe /select, """ + ФайлИнфо.ПолноеИмя + """");
		Иначе // Это Linux или MacOS.
			НачатьЗапускПриложения(Оповещение, "file:///" + ФайлИнфо.Путь);
		КонецЕсли;
	Иначе // Это каталог.
		НачатьЗапускПриложения(Оповещение, "file:///" + ФайлИнфо.ПолноеИмя);
	КонецЕсли;
	
	// АПК:534-вкл
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ОткрытьПроводник.
Процедура ОткрытьПроводникПриОбработкеОшибки(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт 
	
	СтандартнаяОбработка = Ложь;
	ОткрытьПроводникОповеститьОбОшибке("", Контекст);
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ОткрытьПроводник.
Процедура ОткрытьПроводникОповеститьОбОшибке(ОписаниеОшибки, Контекст)
	
	Если Не ПустаяСтрока(ОписаниеОшибки) Тогда 
		ПоказатьПредупреждение(, ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОткрытьНавигационнуюСсылку

// Продолжение процедуры ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку.
Процедура ОткрытьНавигационнуюСсылкуПослеПроверкиРасширенияРаботыСФайлами(РасширениеПодключено, Контекст) Экспорт
	
	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	
	НавигационнаяСсылка = Контекст.НавигационнаяСсылка;
	
	Если РасширениеПодключено Тогда
		
		Оповещение          = Контекст.Оповещение;
		ДождатьсяЗавершения = (Оповещение <> Неопределено);
		
		Оповещение = Новый ОписаниеОповещения(
			"ОткрытьНавигационнуюСсылкуПослеЗапускаПриложения", ЭтотОбъект, Контекст,
			"ОткрытьНавигационнуюСсылкуПриОбработкеОшибки", ЭтотОбъект);
		НачатьЗапускПриложения(Оповещение, НавигационнаяСсылка,, ДождатьсяЗавершения);
		
	Иначе
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Расширение для работы с файлами не установлено, переход по ссылке ""%1"" невозможен.'"),
			НавигационнаяСсылка);
		ОткрытьНавигационнуюСсылкуОповеститьОбОшибке(ОписаниеОшибки, Контекст);
	КонецЕсли;
	
	// АПК:534-вкл
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку.
Процедура ОткрытьНавигационнуюСсылкуПослеЗапускаПриложения(КодВозврата, Контекст) Экспорт 
	
	Оповещение = Контекст.Оповещение;
	
	Если Оповещение <> Неопределено Тогда 
		ПриложениеЗапущено = (КодВозврата = 0 Или КодВозврата = Неопределено);
		ВыполнитьОбработкуОповещения(Оповещение, ПриложениеЗапущено);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку.
Процедура ОткрытьНавигационнуюСсылкуПриОбработкеОшибки(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт 
	
	СтандартнаяОбработка = Ложь;
	ОткрытьНавигационнуюСсылкуОповеститьОбОшибке("", Контекст);
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку.
Процедура ОткрытьНавигационнуюСсылкуОповеститьОбОшибке(ОписаниеОшибки, Контекст) Экспорт
	
	Оповещение = Контекст.Оповещение;
	
	Если Оповещение = Неопределено Тогда
		Если Не ПустаяСтрока(ОписаниеОшибки) Тогда 
			ПоказатьПредупреждение(, ОписаниеОшибки);
		КонецЕсли;
	Иначе 
		ПриложениеЗапущено = Ложь;
		ВыполнитьОбработкуОповещения(Оповещение, ПриложениеЗапущено);
	КонецЕсли;
	
КонецПроцедуры

// Проверяет, является ли переданная строка веб ссылкой.
// 
// Параметры:
//  Строка - Строка - переданная ссылка.
//
Функция ЭтоВебСсылка(Строка) Экспорт
	
	Возврат СтрНачинаетсяС(Строка, "http://")  // обычное соединение.
		Или СтрНачинаетсяС(Строка, "https://");// защищенное соединение.
	
КонецФункции

// Проверяет, является ли переданная строка ссылкой на встроенную справку.
// 
// Параметры:
//  Строка - Строка - переданная ссылка.
//
Функция ЭтоСсылкаНаСправку(Строка) Экспорт
	
	Возврат СтрНачинаетсяС(Строка, "v8help://");
	
КонецФункции

// Проверяет, является ли переданная строка допустимой ссылкой по белому списку протоколов.
// 
// Параметры:
//  Строка - Строка - переданная ссылка.
//
Функция ЭтоДопустимаяСсылка(Строка) Экспорт
	
	Возврат СтрНачинаетсяС(Строка, "e1cib/")
		Или СтрНачинаетсяС(Строка, "http:")
		Или СтрНачинаетсяС(Строка, "https:")
		Или СтрНачинаетсяС(Строка, "e1c:")
		Или СтрНачинаетсяС(Строка, "v8help:")
		Или СтрНачинаетсяС(Строка, "mailto:")
		Или СтрНачинаетсяС(Строка, "tel:")
		Или СтрНачинаетсяС(Строка, "skype:");
	
КонецФункции

#КонецОбласти

#Область ЗапуститьПрограмму

// Продолжение процедуры ОбщегоНазначенияКлиент.ЗапуститьПрограмму.
Процедура ЗапуститьПрограммуПослеПроверкиРасширенияРаботыСФайлами(РасширениеПодключено, Контекст) Экспорт
	
	Если РасширениеПодключено Тогда
		
		ТекущийКаталог = Контекст.ТекущийКаталог;
		
		Если ПустаяСтрока(ТекущийКаталог) Тогда
			ЗапуститьПрограммуНачатьЗапуск(Контекст);
		Иначе 
			ФайлИнфо = Новый Файл(ТекущийКаталог);
			Оповещение = Новый ОписаниеОповещения(
				"ЗапуститьПрограммуПослеПроверкиСуществования", ЭтотОбъект, Контекст,
				"ЗапуститьПрограммуПриОбработкеОшибки", ЭтотОбъект);
			ФайлИнфо.НачатьПроверкуСуществования(Оповещение);
		КонецЕсли;
		
	Иначе
		ОписаниеОшибки = НСтр("ru = 'Расширение для работы с файлами не установлено, запуск программы невозможен.'");
		ЗапуститьПрограммуОповеститьОбОшибке(ОписаниеОшибки, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ЗапуститьПрограмму.
Процедура ЗапуститьПрограммуПослеПроверкиСуществования(Существует, Контекст) Экспорт
	
	ТекущийКаталог = Контекст.ТекущийКаталог;
	ФайлИнфо = Новый Файл(ТекущийКаталог);
	
	Если Существует Тогда 
		Оповещение = Новый ОписаниеОповещения(
			"ЗапуститьПрограммуПослеПроверкиЭтоКаталог", ЭтотОбъект, Контекст,
			"ЗапуститьПрограммуПриОбработкеОшибки", ЭтотОбъект);
		ФайлИнфо.НачатьПроверкуЭтоКаталог(Оповещение);
	Иначе 
		СтрокаКоманды = Контекст.СтрокаКоманды;
		
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось запустить программу
			           |%1
			           |по причине:
			           |Не существует каталог, указанный как ТекущийКаталог
			           |%2'"),
			СтрокаКоманды,
			ТекущийКаталог);
		ЗапуститьПрограммуОповеститьОбОшибке(ОписаниеОшибки, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ОткрытьФайлВПрограммеПросмотра.
Процедура ЗапуститьПрограммуПослеПроверкиЭтоКаталог(ЭтоКаталог, Контекст) Экспорт
	
	Если ЭтоКаталог Тогда
		ЗапуститьПрограммуНачатьЗапуск(Контекст);
	Иначе
		СтрокаКоманды = Контекст.СтрокаКоманды;
		ТекущийКаталог = Контекст.ТекущийКаталог;
		
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось запустить программу
			           |%1
			           |по причине:
			           |ТекущийКаталог не является каталогом %2'"),
			СтрокаКоманды,
			ТекущийКаталог);
		ЗапуститьПрограммуОповеститьОбОшибке(ОписаниеОшибки, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ЗапуститьПрограмму.
Процедура ЗапуститьПрограммуНачатьЗапуск(Контекст)
	
	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	
	Если Контекст.ВыполнитьСНаивысшимиПравами Тогда 
		ЗапуститьПрограммуСНаивысшимиПравами(Контекст);
	Иначе
		
		СтрокаКоманды = Контекст.СтрокаКоманды;
		ТекущийКаталог = Контекст.ТекущийКаталог;
		ДождатьсяЗавершения = Контекст.ДождатьсяЗавершения;
		
		Оповещение = Новый ОписаниеОповещения(
			"ЗапуститьПрограммуПослеЗапускаПриложения", ЭтотОбъект, Контекст,
			"ЗапуститьПрограммуПриОбработкеОшибки", ЭтотОбъект);
		НачатьЗапускПриложения(Оповещение, СтрокаКоманды, ТекущийКаталог, ДождатьсяЗавершения);
	КонецЕсли;
	
	// АПК:534-вкл
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ЗапуститьПрограмму.
Процедура ЗапуститьПрограммуПослеЗапускаПриложения(КодВозврата, Контекст) Экспорт 
	
	Оповещение = Контекст.Оповещение;
	Если Оповещение = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Если Контекст.ДождатьсяЗавершения И КодВозврата = Неопределено Тогда
		ОписаниеОшибки = НСтр("ru = 'Произошла неизвестная ошибка при запуске программы.'");
		ЗапуститьПрограммуОповеститьОбОшибке(ОписаниеОшибки, Контекст);
		Возврат;
	КонецЕсли;
	
	Результат = РезультатЗапускаПрограммы();
	Результат.ПриложениеЗапущено = Истина;
	Результат.КодВозврата = КодВозврата;
	Если Контекст.ДождатьсяЗавершения Тогда
		ЗаполнитьРезультатПотока(Результат, Контекст);
	КонецЕсли;
	ВыполнитьОбработкуОповещения(Оповещение, Результат);
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ЗапуститьПрограмму.
Процедура ЗапуститьПрограммуПриОбработкеОшибки(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт 
	
	СтандартнаяОбработка = Ложь;
	ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	ЗапуститьПрограммуОповеститьОбОшибке(ОписаниеОшибки, Контекст);
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ЗапуститьПрограмму.
Процедура ЗапуститьПрограммуОповеститьОбОшибке(ОписаниеОшибки, Контекст)
	
	Оповещение = Контекст.Оповещение;
	Если Оповещение = Неопределено Тогда
		Если Не ПустаяСтрока(ОписаниеОшибки) Тогда
			ПоказатьПредупреждение(, ОписаниеОшибки);
		КонецЕсли;
		Возврат;
	КонецЕсли;
		
	Результат = РезультатЗапускаПрограммы();
	Результат.ОписаниеОшибки = ОписаниеОшибки;
	Если Контекст.ДождатьсяЗавершения Тогда
		ЗаполнитьРезультатПотока(Результат, Контекст);
	КонецЕсли;
	ВыполнитьОбработкуОповещения(Оповещение, Результат);
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ЗапуститьПрограмму.
Функция РезультатЗапускаПрограммы()
	
	Результат = Новый Структура;
	Результат.Вставить("ПриложениеЗапущено", Ложь);
	Результат.Вставить("ОписаниеОшибки", "");
	Результат.Вставить("КодВозврата", -13);
	Результат.Вставить("ПотокВывода", "");
	Результат.Вставить("ПотокОшибок", "");
	
	Возврат Результат;
	
КонецФункции

// Продолжение процедуры ОбщегоНазначенияКлиент.ЗапуститьПрограмму.
Процедура ЗапуститьПрограммуСНаивысшимиПравами(Контекст)
	
#Если ВебКлиент Тогда
	ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не удалось запустить программу
		           |%1
		           |по причине:
		           |Запуск программ с повышением привилегий недоступен в веб-клиенте.'"),
		Контекст.СтрокаКоманды);
	ЗапуститьПрограммуОповеститьОбОшибке(ОписаниеОшибки, Контекст);
#ИначеЕсли МобильныйКлиент Тогда
	ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не удалось запустить программу
		           |%1
		           |по причине:
		           |Запуск программ с повышением привилегий недоступен в мобильном клиенте.'"),
		Контекст.СтрокаКоманды);
	ЗапуститьПрограммуОповеститьОбОшибке(ОписаниеОшибки, Контекст);
#Иначе
	
	Если ОбщегоНазначенияКлиент.ЭтоWindowsКлиент() Тогда 
		ЗапуститьПрограммуСНаивысшимиПравамиWindows(Контекст);
	ИначеЕсли ОбщегоНазначенияКлиент.ЭтоLinuxКлиент() Тогда 
		ЗапуститьПрограммуСНаивысшимиПравамиLinux(Контекст);
	Иначе
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось запустить программу
			           |%1
			           |по причине:
			           |Запуск программ с повышением привилегий доступен только в Windows и Linux.'"),
			Контекст.СтрокаКоманды);
		ЗапуститьПрограммуОповеститьОбОшибке(ОписаниеОшибки, Контекст);
	КонецЕсли;
	
#КонецЕсли
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ЗапуститьПрограмму.
Процедура ЗаполнитьРезультатПотока(Результат, Контекст)
	
#Если Не ВебКлиент Тогда
		
	Если Контекст.ПолучитьПотокВывода
		И Не ПустаяСтрока(Контекст.ИмяФайлаПотокаВывода) Тогда
		Результат.ПотокВывода = ПрочитатьФайлПотока(Контекст.ИмяФайлаПотокаВывода);
	КонецЕсли;
	
	Если Контекст.ПолучитьПотокОшибок
		И Не ПустаяСтрока(Контекст.ИмяФайлаПотокаОшибок) Тогда
		Результат.ПотокОшибок = ПрочитатьФайлПотока(Контекст.ИмяФайлаПотокаОшибок);
	КонецЕсли;
		
#КонецЕсли

КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ЗапуститьПрограмму.
Функция ПрочитатьФайлПотока(ПутьКФайлу)
	
	// АПК:566-выкл - синхронные вызовы вне тонкого клиента
	
#Если ВебКлиент Тогда
	Возврат "";
#Иначе
	ФайлПотока = Новый Файл(ПутьКФайлу);
	Если Не ФайлПотока.Существует() Тогда
		Возврат "";
	КонецЕсли;
	
	ЧтениеФайлаПотока = Новый ЧтениеТекста(ПутьКФайлу);
	Результат = ЧтениеФайлаПотока.Прочитать();
	ЧтениеФайлаПотока.Закрыть();
	
	УдалитьФайлы(ПутьКФайлу);
	
	Возврат ?(Результат = Неопределено, "", Результат);
#КонецЕсли
	
	// АПК:566-вкл
	
КонецФункции

#Если Не ВебКлиент И Не МобильныйКлиент Тогда

// Продолжение процедуры ОбщегоНазначенияКлиент.ЗапуститьПрограмму.
Процедура ЗапуститьПрограммуСНаивысшимиПравамиWindows(Контекст)
	
	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	
	СтрокаКоманды = Контекст.СтрокаКоманды;
	ТекущийКаталог = Контекст.ТекущийКаталог;
	КодировкаИсполнения = Контекст.КодировкаИсполнения;
	
	ДождатьсяЗавершения = Ложь;
	
	ИмяФайлаКоманды = ПолучитьИмяВременногоФайла("run.bat"); // АПК:441 удаляется автоматически после запуска.
	ТекстовыйДокумент = ОбщегоНазначенияСлужебныйКлиентСервер.НовыйФайлЗапускаКомандыWindows(
		СтрокаКоманды, ТекущийКаталог, ДождатьсяЗавершения, КодировкаИсполнения);
	ТекстовыйДокумент.Записать(ИмяФайлаКоманды, КодировкаТекста.OEM);
	
	Попытка
		Оболочка = Новый COMОбъект("Shell.Application");
		// Запуск с передачей глагола действия - повышения привилегий.
		КодВозврата = Оболочка.ShellExecute("cmd", "/c """ + ИмяФайлаКоманды + """",, "runas", 0);
		Оболочка = Неопределено;
	Исключение
		Оболочка = Неопределено;
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		СтандартнаяОбработка = Истина;
		ЗапуститьПрограммуПриОбработкеОшибки(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст);
		Возврат;
	КонецПопытки;
	
	Если КодВозврата = Неопределено Тогда 
		КодВозврата = 0;
	КонецЕсли;
	
	ЗапуститьПрограммуПослеЗапускаПриложения(КодВозврата, Контекст);
	
	// АПК:534-вкл
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ЗапуститьПрограмму.
Процедура ЗапуститьПрограммуСНаивысшимиПравамиLinux(Контекст)
	
	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	
	ТекущийКаталог = Контекст.ТекущийКаталог;
	СтрокаКоманды = Контекст.СтрокаКоманды;
	
	КомандаCПовышениемПривилегий = "pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY " + СтрокаКоманды;
	ДождатьсяЗавершения = Истина;
	
	Оповещение = Новый ОписаниеОповещения(
		"ЗапуститьПрограммуПослеЗапускаПриложения", ЭтотОбъект, Контекст,
		"ЗапуститьПрограммуПриОбработкеОшибки", ЭтотОбъект);
	НачатьЗапускПриложения(Оповещение, КомандаCПовышениемПривилегий, ТекущийКаталог, ДождатьсяЗавершения);
	
	// АПК:534-вкл
	
КонецПроцедуры

#КонецЕсли

#КонецОбласти

#Область ВыборКаталога

// Продолжение процедуры ФайловаяСистемаКлиент.ВыбратьКаталог.
Процедура ВыбратьКаталогПриПодключенииРасширенияРаботыСФайлами(РасширениеПодключено, Контекст) Экспорт
	
	Если Не РасширениеПодключено Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОбработчикЗавершения, "");
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ВыбратьКаталогПриОкончанииВыбора", ЭтотОбъект, Контекст.ОбработчикЗавершения);
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.МножественныйВыбор = Ложь;
	Если Не ПустаяСтрока(Контекст.Заголовок) Тогда
		Диалог.Заголовок = Контекст.Заголовок;
	КонецЕсли;
	
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.ВыбратьКаталог.
Процедура ВыбратьКаталогПриОкончанииВыбора(МассивКаталогов, ОбработчикЗавершения) Экспорт
	
	ПутьККаталогу = 
		?(МассивКаталогов = Неопределено Или МассивКаталогов.Количество() = 0,
			"", 
			МассивКаталогов[0]);
	
	ВыполнитьОбработкуОповещения(ОбработчикЗавершения, ПутьККаталогу);
	
КонецПроцедуры

#КонецОбласти

#Область ПоказатьДиалогВыбора

// Продолжение процедуры ФайловаяСистемаКлиент.ПоказатьДиалогВыбораП.
Процедура ПоказатьДиалогВыбораПриПодключенииРасширенияРаботыСФайлами(РасширениеПодключено, Контекст) Экспорт
	
	Если Не РасширениеПодключено Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОбработчикЗавершения, "");
	КонецЕсли;
	
	Контекст.Диалог.Показать(Контекст.ОбработчикЗавершения);
	
КонецПроцедуры

#КонецОбласти

#Область РасширениеРаботыСФайлами

// Продолжение процедуры ФайловаяСистемаКлиент.НачатьПодключениеРасширенияРаботыСФайлами.
Процедура НачатьПодключениеРасширенияРаботыСФайламиПриУстановкеРасширения(Подключено, Контекст) Экспорт
	
	// Если расширение и так уже подключено, незачем про него спрашивать.
	Если Подключено Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОписаниеОповещенияЗавершение, "ПодключениеНеТребуется");
		Возврат;
	КонецЕсли;
	
	// В веб клиенте под MacOS расширение не доступно.
	Если ОбщегоНазначенияКлиент.ЭтоOSXКлиент() Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОписаниеОповещенияЗавершение);
		Возврат;
	КонецЕсли;
	
	ИмяПараметра = "СтандартныеПодсистемы.ПредлагатьУстановкуРасширенияРаботыСФайлами";
	ПервоеОбращениеЗаСеанс = ПараметрыПриложения[ИмяПараметра] = Неопределено;
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, ПредлагатьУстановкуРасширенияРаботыСФайлами());
	КонецЕсли;
	
	ПредлагатьУстановкуРасширенияРаботыСФайлами = ПараметрыПриложения[ИмяПараметра] Или ПервоеОбращениеЗаСеанс;
	Если Контекст.ВозможноПродолжениеБезУстановки И Не ПредлагатьУстановкуРасширенияРаботыСФайлами Тогда
		
		ВыполнитьОбработкуОповещения(Контекст.ОписаниеОповещенияЗавершение);
		
	Иначе 
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ТекстПредложения", Контекст.ТекстПредложения);
		ПараметрыФормы.Вставить("ВозможноПродолжениеБезУстановки", Контекст.ВозможноПродолжениеБезУстановки);
		ОткрытьФорму(
			"ОбщаяФорма.ВопросОбУстановкеРасширенияРаботыСФайлами", 
			ПараметрыФормы,,,,, 
			Контекст.ОписаниеОповещенияЗавершение);
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.НачатьПодключениеРасширенияРаботыСФайлами.
Процедура НачатьПодключениеРасширенияРаботыСФайламиПриОтветеНаВопросОбУстановке(Действие, ОповещениеОЗакрытии) Экспорт
	
	РасширениеПодключено = (Действие = "РасширениеПодключено" Или Действие = "ПодключениеНеТребуется");
	
#Если ВебКлиент Тогда
	Если Действие = "БольшеНеПредлагать"
		Или Действие = "РасширениеПодключено" Тогда
		
		СистемнаяИнформация = Новый СистемнаяИнформация();
		ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
		ПараметрыПриложения["СтандартныеПодсистемы.ПредлагатьУстановкуРасширенияРаботыСФайлами"] = Ложь;
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
			"НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами", ИдентификаторКлиента, Ложь);
		
	КонецЕсли;
#КонецЕсли
	
	ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, РасширениеПодключено);
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.НачатьПодключениеРасширенияРаботыСФайлами.
Функция ПредлагатьУстановкуРасширенияРаботыСФайлами()
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	Возврат ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами", ИдентификаторКлиента, Истина);
	
КонецФункции

#КонецОбласти

#Область ВременныеФайлы

#Область СоздатьВременныйКаталог

// Продолжение процедуры ФайловаяСистемаКлиент.СоздатьВременныйКаталог.
Процедура СоздатьВременныйКаталогПослеПроверкиРасширенияРаботыСФайлами(РасширениеПодключено, Контекст) Экспорт
	
	Если РасширениеПодключено Тогда
		
		Оповещение = Новый ОписаниеОповещения(
			"СоздатьВременныйКаталогПослеПолученияВременногоКаталога", ЭтотОбъект, Контекст,
			"СоздатьВременныйКаталогПриОбработкеОшибки", ЭтотОбъект);
		
		НачатьПолучениеКаталогаВременныхФайлов(Оповещение);
		
	Иначе
		ОписаниеОшибки = 
			НСтр("ru = 'Расширение для работы с файлами не установлено, создание временного каталога невозможно.'");
		СоздатьВременныйКаталогОповеститьОбОшибке(ОписаниеОшибки, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.СоздатьВременныйКаталог.
Процедура СоздатьВременныйКаталогПослеПолученияВременногоКаталога(ИмяКаталогаВременныхФайлов, Контекст) Экспорт 
	
	Оповещение = Контекст.Оповещение;
	Расширение = Контекст.Расширение;
	
	ИмяКаталога = "v8_" + Строка(Новый УникальныйИдентификатор);
	
	Если Не ПустаяСтрока(Расширение) Тогда 
		ИмяКаталога = ИмяКаталога + "." + Расширение;
	КонецЕсли;
	
	НачатьСозданиеКаталога(Оповещение, ИмяКаталогаВременныхФайлов + ИмяКаталога);
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.СоздатьВременныйКаталог.
Процедура СоздатьВременныйКаталогПриОбработкеОшибки(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт 
	
	СтандартнаяОбработка = Ложь;
	ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	СоздатьВременныйКаталогОповеститьОбОшибке(ОписаниеОшибки, Контекст);
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.СоздатьВременныйКаталог.
Процедура СоздатьВременныйКаталогОповеститьОбОшибке(ОписаниеОшибки, Контекст)
	
	ПоказатьПредупреждение(, ОписаниеОшибки);
	ИмяКаталога = "";
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, ИмяКаталога);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти