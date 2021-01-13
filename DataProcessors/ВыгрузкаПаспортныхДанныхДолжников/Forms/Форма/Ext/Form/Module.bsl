﻿
&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДиалогВыбФайла 	 = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбФайла.Заголовок				= "Выберите файл для загрузки:";
	ДиалогВыбФайла.ПолноеИмяФайла			= ИмяФайла; //АДРЕС
	//ДиалогВыбФайла.Фильтр					= "Excel (*.xlsx)|*.xls*";
	//ДиалогВыбФайла.Расширение				= "xlsx";
	ДиалогВыбФайла.МножественныйВыбор		= Ложь;
	ДиалогВыбФайла.ПредварительныйПросмотр	= Ложь;
	ДиалогВыбФайла.Показать(Новый ОписаниеОповещения("ПослеВыбораФайла", ЭтаФорма));
	
КонецПроцедуры



&НаКлиенте
Процедура ПослеВыбораФайла(ВыбранныеФайлы, ДопПарметры) Экспорт
	Если ЗначениеЗаполнено(ВыбранныеФайлы) и ВыбранныеФайлы.Количество() > 0 Тогда
		 ИмяФайла = ВыбранныеФайлы[0];
		
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПрочитатьФайлНаСервере()
	
	   //ФайлДанных = ИмяФайла;
	    ТЧ.Очистить(); 

		
	   ФайлЕксел.Прочитать(ИмяФайла,СпособЧтенияЗначенийТабличногоДокумента.Текст);
		
       ПЗ = Новый ПостроительЗапроса;

	   ПЗ.ИсточникДанных = Новый ОписаниеИсточникаДанных(ФайлЕксел.Область());

	   ПЗ.ДобавлениеПредставлений = ТипДобавленияПредставлений.НеДобавлять;

	   ПЗ.ЗаполнитьНастройки();

	   ПЗ.Выполнить();

	   ТаблицаЗначений = ПЗ.Результат.Выгрузить();
	   
	      Для каждого стр Из ТаблицаЗначений Цикл
					
			  Если  стр.ФИО<>"" и стр.Номеркредитногодоговора <>""  Тогда
		            стртч= ТЧ.Добавить();
					стртч.НомерДоговора=стр.Номеркредитногодоговора;
					стртч.ФИО=стр.ФИО;
					
					данныеДолж=ПолучитьНомерПаспорта(стр.ФИО,стр.Номеркредитногодоговора);
					стртч.НомерПаспорта=данныеДолж.НомерПаспорта;
					стртч.КемВыдан=данныеДолж.ПаспортКемВыдан;
					Если данныеДолж.ПаспортКогдаВыдан<>Дата("00010101000000") Тогда
					
                              стртч.КогдаВыдан=Формат(данныеДолж.ПаспортКогдаВыдан,"ДФ=dd.MM.yyyy");
					
                	
					
					КонецЕсли;
					 
					
                				   
				  
			
			 КонецЕсли;
  
					
	   
    	   КонецЦикла;
	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНомерПаспорта(долж,дог)

	  должникСпр=Неопределено;
	  
	  должДанные=Новый Структура;
	
	     	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
				// Данный фрагмент построен конструктором.
				// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
				
				Запрос = Новый Запрос;
				Запрос.Текст = 
					"ВЫБРАТЬ
					|	Должники.Ссылка КАК Ссылка,
					|	Должники.НомерПаспорта КАК НомерПаспорта,
					|	Должники.ПаспортКемВыдан КАК ПаспортКемВыдан,
					|	Должники.ПаспортКогдаВыдан КАК ПаспортКогдаВыдан
					|ИЗ
					|	Справочник.Должники КАК Должники
					|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Договоры КАК Договоры
					|		ПО (Договоры.Владелец = Должники.Ссылка)
					|ГДЕ
					|	Должники.Наименование = &Наименование
					|	И Договоры.НомерДоговора = &НомерДоговора";
				
				Запрос.УстановитьПараметр("Наименование", долж);
				Запрос.УстановитьПараметр("НомерДоговора", дог);
				
				РезультатЗапроса = Запрос.Выполнить();
				
				ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
				
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					// Вставить обработку выборки ВыборкаДетальныеЗаписи
					должникСпр=ВыборкаДетальныеЗаписи.Ссылка;
					должДанные.Вставить("НомерПаспорта",ВыборкаДетальныеЗаписи.НомерПаспорта);
					должДанные.Вставить("ПаспортКемВыдан",ВыборкаДетальныеЗаписи.ПаспортКемВыдан);
					должДанные.Вставить("ПаспортКогдаВыдан",ВыборкаДетальныеЗаписи.ПаспортКогдаВыдан);
					
					
					
					
				КонецЦикла;
				
				//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	     Возврат должДанные;

КонецФункции // ()

	   

&НаКлиенте
Процедура ПрочитатьФайл(Команда)
	ПрочитатьФайлНаСервере();
КонецПроцедуры

&НаСервере
Функция	ПечатьНаСервере()
	// Вставить содержимое обработчика.
	 ТабДокумент=Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб=Истина;
	ТабДокумент.ТолькоПросмотр=Истина;

	
	ОтчетОбъект = РеквизитФормыВЗначение("Объект");
	
    Макет =  ОтчетОбъект.ПолучитьМакет("Макет"); 
	ОбластьШапка=Макет.ПолучитьОбласть("Шапка");
	
	 ОбластьШапка=Макет.ПолучитьОбласть("Шапка");
	
	
    ТабДокумент.Вывести(ОбластьШапка);

	 Для каждого Стр  Из ТЧ  Цикл
          ОбластьСтрока=Макет.ПолучитьОбласть("Строка");

		  
		  ОбластьСтрока.Параметры.номерДоговора=Стр.НомерДоговора;
		  
		  ОбластьСтрока.Параметры.фио=Стр.ФИО;
		  
		  ОбластьСтрока.Параметры.номерПаспорта=Стр.НомерПаспорта;
		  
		  ОбластьСтрока.Параметры.кемВыдан=Стр.КемВыдан;
		  ОбластьСтрока.Параметры.когдаВыдан=Стр.КогдаВыдан;
		  
		  
		  
		  ТабДокумент.Вывести(ОбластьСтрока);
		  
		  
	  КонецЦикла;	
	
	  
	  
	   Возврат  ТабДокумент;
	
	
	
КонецФункции

&НаКлиенте
Процедура Печать(Команда)
	
    ТабДокумент=ПечатьНаСервере(); 
	
    ТабДокумент.Показать("Данные паспортов");

КонецПроцедуры
