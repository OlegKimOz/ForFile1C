﻿&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииНаСервере()
	Об = РеквизитФормыВЗначение("Объект");
	ЭтоНовый = Об.ЭтоНовый();
	
	
	
	
	
	Если ЭтоНовый Тогда
		Автор = ПараметрыСеанса.Пользователь;
		
	КонецЕсли;
	
	Если (ПараметрыСеанса.Интерфейс = "Коллектор") ИЛИ (ПараметрыСеанса.Интерфейс = "Администратор") Тогда
		Элементы.ГруппаАдреса.Видимость = Истина;
		ЭтаФорма.ТолькоПросмотр = Ложь;
	Иначе //операторы
		Элементы.ГруппаАдреса.Видимость = Ложь;
		Элементы.КомментарийАдминистратора.Доступность = Ложь;
		РазрешеноМенять = ЭтоНовый Или (НачалоДня(ТекущаяДатаСеанса()) = НачалоДня(Объект.Дата));
		ТолькоПросмотр = Не РазрешеноМенять;
		//Элементы.КомментарийСотрудника.Доступность = Не РазрешеноМенять;
		ЭтаФорма.ТолькоПросмотр = ТолькоПросмотр;
	КонецЕсли; 
	
	ЭлементОтбора = СписокОбещаний.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Должник");
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.ПравоеЗначение = Объект.Должник;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДолжника(ДанныеФормы)
	ДокументОбещание = Документы.Обещание.СоздатьДокумент();
	ДокументОбещание.Автор = ПараметрыСеанса.Пользователь;
	ДокументОбещание.Дата = ТекущаяДатаСеанса();
	ДокументОбещание.Должник = Объект.Должник;
	
	ЗначениеВДанныеФормы(ДокументОбещание, ДанныеФормы);
КонецПроцедуры

&НаКлиенте
Процедура ОбещаниеОплаты(Команда)
	Форма = ПолучитьФорму("Документ.Обещание.Форма.ФормаДокумента");
	ДанныеФормы = Форма.Объект;
	УстановитьДолжника(ДанныеФормы); // Заполняем документ на сервере
	КопироватьДанныеФормы(ДанныеФормы, Форма.Объект); // копируем наш объект в объект формы и далее открываем ее
	Форма.Элементы.Сумма.АктивизироватьПоУмолчанию = Истина;
	Форма.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьТелефон(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Владелец", Объект.Должник);
	Форма = ПолучитьФорму("Справочник.Телефоны.Форма.ФормаЭлемента", ПараметрыФормы);
	Форма.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ТелефоныКонтактноеЛицоПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Телефоны.ТекущаяСтрока;
	СтрокаТелефона = Объект.Телефоны.НайтиПоИдентификатору(ТекущаяСтрока);
	РезультатКонтакта = РезультатКонтакта(Строка(СтрокаТелефона.КонтактноеЛицо));
	Если ЗначениеЗаполнено(РезультатКонтакта) Тогда
		СтрокаТелефона.РезультатКонтакта = РезультатКонтакта;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция РезультатКонтакта(СтрокаДляПоиска = "Нет контакта")
	Результат = Справочники.РезультатыКонтактов.НайтиПоНаименованию(СтрокаДляПоиска);
	Возврат Результат;
КонецФункции // ()

&НаКлиенте
Процедура СтатусНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = Новый СписокЗначений;
	
	ДанныеВыбора=СписокНеПред();
	
	
	
КонецПроцедуры


&НаСервере
Функция СписокНеПред()

	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Статусы.Ссылка КАК Ссылка,
		|	Статусы.ВерсияДанных КАК ВерсияДанных,
		|	Статусы.ПометкаУдаления КАК ПометкаУдаления,
		|	Статусы.Код КАК Код,
		|	Статусы.Наименование КАК Наименование,
		|	Статусы.НетКонтакта КАК НетКонтакта,
		|	Статусы.ПрекратитьРаботу КАК ПрекратитьРаботу,
		|	Статусы.ЛимитДнейПланирования КАК ЛимитДнейПланирования,
		|	Статусы.Предопределенный КАК Предопределенный,
		|	Статусы.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
		|ИЗ
		|	Справочник.Статусы КАК Статусы
		|ГДЕ
		|	Статусы.Предопределенный = &Ложь";
	
	Запрос.УстановитьПараметр("Ложь", Ложь);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		ДанныеВыбора.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
		
	КонецЦикла;
	
	
    Возврат  ДанныеВыбора;
	

КонецФункции // ()


&НаСервере
Процедура ОбработкаОповещенияНаСервере(Параметр)
	
	тТелефоны = Объект.Телефоны.Выгрузить();
	
	Если тТелефоны.Найти(Параметр.ТелефонПараметр, "Телефон") = Неопределено Тогда
		запТ= Объект.Телефоны.Добавить();
		запТ.Телефон=Параметр.ТелефонПараметр;
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	 
     ОбработкаОповещенияНаСервере(Параметр);
	 //Модифицированность=Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Вставить содержимое обработчика
	      СтандартнаяОбработка=Ложь;
		  
		  Если  РеквизитФормыВЗначение("Объект").ЭтоНовый() Тогда
			  
			    Объект.Должник=Параметры.ДолжникПараметр;
	        	Объект.ТипКонтакта=Справочники.ТипыКонтактов.ЗвонокИсходящий;
				Объект.Дата= ТекущаяДатаСеанса();
				Объект.Автор=Параметры.АвторПараметр;
				Объект.Сотрудник=Параметры.СотрудникПараметр;

		  	
		  
		  КонецЕсли;
		  
	
				
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// Вставить содержимое обработчика.
		
КонецПроцедуры



