﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Вставить содержимое обработчика.
	
	  
	   Если Объект.Ссылка.Пустая() Тогда

		       данныеДоговора=НайтиНомерКредитДоговора(Объект.Владелец);
		
		       Объект.НомерКредитногоДоговора=данныеДоговора["НомерДоговора"];
	           Объект.ДатаКредитногоДоговора=данныеДоговора["ДатаФинансирования"];
		       Объект.СуммаКредита=данныеДоговора["СуммаКредита"];
		
		
		       Объект.МестоРожденияДолж=НайтиМестоРожденияДолж(Объект.Владелец);
		
		   
	   КонецЕсли;
 	
	
	   
		
КонецПроцедуры



&НаСервере
Функция НайтиМестоРожденияДолж(долж)

	 //Место рождения
	 
	 местоРождения="";
	 спр=Справочники.ДополнительныеРеквизиты.НайтиПоНаименованию("Место рождения");
	 
	   	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДополнительныеДанные.Наименование КАК Наименование
		|ИЗ
		|	Справочник.ДополнительныеДанные КАК ДополнительныеДанные
		|ГДЕ
		|	ДополнительныеДанные.Владелец = &Владелец
		|	И ДополнительныеДанные.Реквизит = &Реквизит";
	
	Запрос.УстановитьПараметр("Владелец", долж);
	Запрос.УстановитьПараметр("Реквизит", спр);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		местоРождения=ВыборкаДетальныеЗаписи.Наименование;
		
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА


	  Возврат местоРождения;
	 
КонецФункции // ()



&НаСервере
Функция НайтиНомерКредитДоговора(долж)

	    данныеДоговора=Новый Структура;
	
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Договоры.НомерДоговора КАК НомерДоговора,
		|	Договоры.ДатаФинансирования КАК ДатаФинансирования,
		|	Договоры.СуммаКредита КАК СуммаКредита,
		|	Договоры.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Договоры КАК Договоры
		|ГДЕ
		|	Договоры.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец", долж);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		   данныеДоговора.Вставить("НомерДоговора",ВыборкаДетальныеЗаписи.НомерДоговора);
		   данныеДоговора.Вставить("ДатаФинансирования",ВыборкаДетальныеЗаписи.ДатаФинансирования);
		   данныеДоговора.Вставить("СуммаКредита",ВыборкаДетальныеЗаписи.СуммаКредита);
		   
		   данныеДоговора.Вставить("Ссылка",ВыборкаДетальныеЗаписи.Ссылка);
           
		
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	
	
		//данныеДоговора.Вставить("НомерДоговора",ВыборкаДетальныеЗаписи.НомерДоговора);
		//   данныеДоговора.Вставить("ДатаФинансирования",ВыборкаДетальныеЗаписи.ДатаФинансирования);
		//   данныеДоговора.Вставить("СуммаКредита",ВыборкаДетальныеЗаписи.СуммаКредита);
		//   

	 Возврат  данныеДоговора;
	

КонецФункции // ()

&НаКлиенте
Процедура НомерКредитногоДоговораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	
	
	      
	
		 СтандартнаяОбработка=Ложь;
		 
		
		 
	     ДанныеВыбора= Новый СписокЗначений;
		 
		 массив=НайтиНомДоговоров(Объект.Владелец);
		 
		 Для каждого стр Из массив Цикл
			 
			 ДанныеВыбора.Добавить(стр);
		 	
		 
		 КонецЦикла;
		 
			

	
	
КонецПроцедуры


	 
&НаСервере
Функция НайтиНомДоговоров(долж)

	массивНом=Новый Массив;
	
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Договоры.Ссылка КАК НомерДоговора
		|ИЗ
		|	Справочник.Договоры КАК Договоры
		|ГДЕ
		|	Договоры.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец", долж);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		массивНом.Добавить(ВыборкаДетальныеЗаписи.НомерДоговора);
		
	КонецЦикла;
	
	
	
	Возврат  массивНом;
	
	
	

КонецФункции // ()

&НаКлиенте
Процедура НомерКредитногоДоговораОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	
	  данныеД=ДатаКредДоговораиСумма(ВыбранноеЗначение,Объект.Владелец);
	  
	  Объект.ДатаКредитногоДоговора=данныеД["ДатаФинансирования"];
	  
	  Объект.СуммаКредита=данныеД["СуммаКредита"];
	  
	  
	
	
	
КонецПроцедуры



&НаСервере
Функция ДатаКредДоговораиСумма(номерД,долж)

	данныеСтр=Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Договоры.ДатаФинансирования КАК ДатаФинансирования,
		|	Договоры.СуммаКредита КАК СуммаКредита
		|ИЗ
		|	Справочник.Договоры КАК Договоры
		|ГДЕ
		|	Договоры.Владелец = &Владелец
		|	И Договоры.Ссылка = &НомерДоговора";
	
	Запрос.УстановитьПараметр("Владелец", долж);
	Запрос.УстановитьПараметр("НомерДоговора", номерД);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		  данныеСтр.Вставить("ДатаФинансирования",ВыборкаДетальныеЗаписи.ДатаФинансирования);
		  данныеСтр.Вставить("СуммаКредита",ВыборкаДетальныеЗаписи.СуммаКредита);
  	КонецЦикла;
	
	 
	Возврат  данныеСтр;
	

КонецФункции // ()

&НаКлиенте
Процедура НаименованиеСудаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	  адресСуда=НайтиАдресСуда(ВыбранноеЗначение);
	  
	  Объект.АдресСуда=адресСуда;
	
	
	
КонецПроцедуры


&НаСервере
Функция НайтиАдресСуда(значв)

	спр=Справочники.Суды.НайтиПоНаименованию(значв.Наименование);
	
	Возврат спр.Адрес;

КонецФункции // ()

	 
	 
	 
