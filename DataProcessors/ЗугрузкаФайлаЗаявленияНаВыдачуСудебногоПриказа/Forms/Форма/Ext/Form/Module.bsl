﻿
&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	ДиалогВыбФайла 	 = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбФайла.Заголовок				= "Выберите файл для загрузки:";
	ДиалогВыбФайла.ПолноеИмяФайла			= ИмяФайла; //АДРЕС
	ДиалогВыбФайла.Фильтр					= "Excel (*.xlsx)|*.xls*";
	ДиалогВыбФайла.Расширение				= "xlsx";
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

&НаКлиенте
Процедура Старт(Команда)
	// Вставить содержимое обработчика.
	
	  Shell = Новый COMОбъект("WScript.Shell");
	  дирМоиД=Shell.SpecialFolders.Item("MyDocuments");

	  
	  //имяфайлатемп=дирМоиД+"\заявнаыдсуд.txt";
	  //имяэксел=ИмяФайла;
	  //
	  //
	  //ФайлТемп = Новый ЗаписьТекста(имяфайлатемп);
	  //
	  //загДоговора="№ кредитного договора / кредитной карты";
	  //загДолжник="ФИО";
	  //загГоспошлина="госпошлина";
	  //загСудНаме="Полное наименование суда";
	  //загАдресСуда="Адрес суда, включая индекс";
	  //
	  //
	  //
	  //
	  //ФайлТемп.ЗаписатьСтроку(загДоговора);
	  //ФайлТемп.ЗаписатьСтроку(загДолжник);
	  //
	  //ФайлТемп.ЗаписатьСтроку(загГоспошлина);
	  //ФайлТемп.ЗаписатьСтроку(загСудНаме);
	  //ФайлТемп.ЗаписатьСтроку(загАдресСуда);
	  //
	  //
	  //
	  //ФайлТемп.ЗаписатьСтроку(ИмяФайла);
	  //
	  //ФайлТемп.Закрыть();
	  //
	  //
	  // программаОбр=дирМоиД+"\ExcelParse.exe 4";
	  // 
	  // WshShell = Новый COMОбъект("WScript.Shell");

	  //  WshShell.Run(программаОбр,1, 1);

	 
//
	    //Сообщить(имяфайлатемп);
  
	   имяфайлатемпответ=дирМоиД+"\заявнаыдсуд_out.txt";
	   
	   
	     мСтрокФайла = Новый Массив();

	   
	   ВыбранныйФайл = Новый Файл(имяфайлатемпответ);
	   Если ВыбранныйФайл.Существует() Тогда
	       
	       
	    	   											
	    									//прочитать строку считывает одну строку из файла
	    									//если достигнут конец файла, то возвращается значение НЕОПРЕДЕЛЕНО
	    									
	    							 
	    			ПрочитанныйТекст = Новый ЧтениеТекста(имяфайлатемпответ, КодировкаТекста.UTF8);
	    										
	    			Строка = ПрочитанныйТекст.ПрочитатьСтроку();
	    										//а не был ли файл пуст?
	    			Если Строка <> Неопределено Тогда
	    			     мСтрокФайла.Добавить(Строка);
	    			КонецЕсли;
	    			
	    			Пока Строка <> Неопределено Цикл
	                   Строка = ПрочитанныйТекст.ПрочитатьСтроку();
	    			     Если Строка <> Неопределено Тогда
	    			          мСтрокФайла.Добавить(Строка);
	    			     КонецЕсли;
	    			КонецЦикла;


	       
	   КонецЕсли;
	   
	   
	   должДанныет=Новый Массив;
	   
	   Для каждого стрд  Из мСтрокФайла Цикл
	       
	    	  должДанныет=РазбитьСтроку(стрд);
	    	  
	    	  
	    	  Запись=ТЧ.Добавить();
	    	  
	    	  
	    	  Запись.Должник=должДанныет.Должник;
	    	    
	    	  Запись.Договор=должДанныет.Договор;
	    	  
	    	  Запись.Госпошлина=должДанныет.Госпошлина;
	    	    
	    	  Запись.НаименованиеСуда=должДанныет.НаименованиеСуда;
	    	  
	    	  Запись.АдресСуда=должДанныет.АдресСуда;
	    	  
	    	  
	    	  	   
	   КонецЦикла;
	   
	  
	
	
	Сообщить("Ок");
	
КонецПроцедуры



&НаКлиенте
Функция РазбитьСтроку(Стр)

	 должДанные=Новый Структура;

  	         поздог=Найти(Стр,":");
	 
			 договорстр=Лев(Стр,поздог-1);
			 
			 должДанные.Вставить("Договор",договорстр);
			 
			 
			 //оставшееся часть
			 
			 Оставшчасть=Прав(Стр,СтрДлина(Стр)-поздог);
			 
			 позфио=Найти(Оставшчасть,":");
			 
			 фиостр=Лев(Оставшчасть,позфио-1);
			 
			 должДанные.Вставить("Должник",фиостр);
			 
			 
			 //оставшееся часть
			 
			 Оставшчасть1=Прав(Оставшчасть,СтрДлина(Оставшчасть)-позфио);
			 
			 позгоспош=Найти(Оставшчасть1,":");
			 
			 госпошстр=Лев(Оставшчасть1,позгоспош-1);
			 
			 должДанные.Вставить("Госпошлина",госпошстр);
			 
			 
			 
			  //оставшееся часть
			 
			 Оставшчасть2=Прав(Оставшчасть1,СтрДлина(Оставшчасть1)-позгоспош);
			 
			 познаименсуда=Найти(Оставшчасть2,":");
			 
			 наименсудастр=Лев(Оставшчасть2,познаименсуда-1);
			 
			 должДанные.Вставить("НаименованиеСуда",наименсудастр);
			 
			 
			 
			  //оставшееся часть
			 
			 Оставшчасть3=Прав(Оставшчасть2,СтрДлина(Оставшчасть2)-познаименсуда);
			 
			 
			 //позадрессуда=Найти(Оставшчасть3,":");
			 
			 //адрессудастр=Лев(Оставшчасть3,позадрессуда-1);
			 
			 
			 
			 должДанные.Вставить("АдресСуда",Оставшчасть3);
			 
			 
			 	 
	 
	 
	 Возврат   должДанные;
КонецФункции 

&НаКлиенте
Процедура Записать(Команда)
	// Вставить содержимое обработчика.
	
	  Для каждого стр  Из ТЧ Цикл
		  
		     Если стр.Должник<>"" Тогда
			 
			 	  ЗаписатьВБазу(стр.Должник, стр.Договор,стр.Госпошлина,стр.НаименованиеСуда,стр.АдресСуда);

			 
			 КонецЕсли;
		 
			   

	  
	  КонецЦикла;

	
	
	Сообщить("Будет");
	
	
КонецПроцедуры


&НаСервере
Процедура ЗаписатьВБазу(долж, догов,госпошл,намесуда,адрессуда)

	
	//спр=Справочники.ЗаявлениеНаВыдачуСудебногоПриказа.НайтиПоРеквизиту("НомерКредитногоДоговора",догов);
	
	//   Найти владельца у кого такой договар
	
	
	
	естьдог= ЕстьЛиТакаяЗапись(НайтиВладельца(долж,догов), НайтиДоговор(догов,НайтиВладельца(долж,догов)));
	
	
	Если НЕ естьдог Тогда
		
		 справ = Справочники.ЗаявлениеНаВыдачуСудебногоПриказа.СоздатьЭлемент();
		 
		 справ.Наименование=НайтиВладельца(долж,догов);
		 
		 справ.Владелец=НайтиВладельца(долж,догов);
		 
		 
		  Если намесуда<>"" Тогда
			  
			  справ.НаименованиеСуда=НайтиСуд(намесуда,адрессуда);
		  	
		  
		  КонецЕсли;
		    
		 
		 
			
		 
		 справ.АдресСуда=адрессуда;
		 
		 справ.НомерКредитногоДоговора=НайтиДоговор(догов,НайтиВладельца(долж,догов));
		 
		 ссылкаДоговор= справ.НомерКредитногоДоговора;
		 
		 
		 данКред=НайтиСуммуКредита(ссылкаДоговор);
		 
		 справ.СуммаКредита=данКред["СуммаКредита"];

		 
		 справ.ДатаКредитногоДоговора=данКред["ДатаФинансирования"];

		 справ.АдресРегистрацииДолжника=НайтиАдресДолж(НайтиВладельца(долж,догов));
		 
		 
		 справ.МестоРожденияДолж=НайтиМестоРожденияДолж(НайтиВладельца(долж,догов));

		 справ.СуммаГосПошлины=госпошл;
		 
		 
		 справ.Записать();
		
	
	КонецЕсли;  
	  
	

КонецПроцедуры


&НаСервере
Функция ЕстьЛиТакаяЗапись(долж, догов)
	
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	догесть=Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаявлениеНаВыдачуСудебногоПриказа.Владелец КАК Владелец,
		|	ЗаявлениеНаВыдачуСудебногоПриказа.НомерКредитногоДоговора КАК НомерКредитногоДоговора
		|ИЗ
		|	Справочник.ЗаявлениеНаВыдачуСудебногоПриказа КАК ЗаявлениеНаВыдачуСудебногоПриказа
		|ГДЕ
		|	ЗаявлениеНаВыдачуСудебногоПриказа.НомерКредитногоДоговора = &НомерКредитногоДоговора
		|	И ЗаявлениеНаВыдачуСудебногоПриказа.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец", долж);
	Запрос.УстановитьПараметр("НомерКредитногоДоговора", догов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	кол=ВыборкаДетальныеЗаписи.Количество();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	Если кол>0 Тогда
	
		   догесть=Истина;
	
	КонецЕсли;
	
	Возврат догесть;
	

КонецФункции // ()



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
Функция НайтиАдресДолж(долж)

	  адресРег="";
	
	      	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Адреса.Адрес КАК Адрес
		|ИЗ
		|	Справочник.Адреса КАК Адреса
		|ГДЕ
		|	Адреса.Владелец = &Владелец
		|	И Адреса.Тип.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Владелец", долж);
	Запрос.УстановитьПараметр("Наименование", "Регистрации");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		адресРег=ВыборкаДетальныеЗаписи.Адрес;
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	Возврат  адресРег;
	

КонецФункции // ()




&НаСервере
Функция НайтиСуммуКредита(догов)

	
	данКред=Новый Структура;
	
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Договоры.СуммаКредита КАК СуммаКредита,
		|	Договоры.ДатаФинансирования КАК ДатаФинансирования
		|ИЗ
		|	Справочник.Договоры КАК Договоры
		|ГДЕ
		|	Договоры.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", догов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		
		данКред.Вставить("СуммаКредита",ВыборкаДетальныеЗаписи.СуммаКредита);
		данКред.Вставить("ДатаФинансирования",ВыборкаДетальныеЗаписи.ДатаФинансирования);
		
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	Возврат данКред;
	 
	

КонецФункции // ()



&НаСервере
Функция НайтиДоговор(догов,должВлад)

	      	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Договоры.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Договоры КАК Договоры
		|ГДЕ
		|	Договоры.Владелец = &Владелец
		|	И Договоры.НомерДоговора = &НомерДоговора";
	
	Запрос.УстановитьПараметр("Владелец", должВлад);
	Запрос.УстановитьПараметр("НомерДоговора", догов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		договорСсылка=ВыборкаДетальныеЗаписи.Ссылка;
		
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	//договорСсылка=ВыборкаДетальныеЗаписи.Ссылка;

	
    Возврат договорСсылка; 
	
КонецФункции // ()



&НаСервере
Функция НайтиСуд(наме,адр)

	
  
	
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Суды.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Суды КАК Суды
		|ГДЕ
		|	Суды.Наименование Подобно &Наименование";
	
	Запрос.УстановитьПараметр("Наименование", наме);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	колз=ВыборкаДетальныеЗаписи.Количество();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
	  намеСсылка=ВыборкаДетальныеЗаписи.Ссылка;	
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
	
	
	Если колз=0 Тогда
		
		 Если наме<>Неопределено Тогда
		 
		 	  
			 НовыйЭлемент = Справочники.Суды.СоздатьЭлемент(); 
			 
			 НовыйЭлемент.Наименование=наме;
			 
			 НовыйЭлемент.Адрес=адр;
			 
			 НовыйЭлемент.Записать();
			 
			 намеСсылка=НовыйЭлемент;
			 
		 
		 КонецЕсли;
		
		 
	КонецЕсли;
	
	

	Возврат  намеСсылка;

КонецФункции // ()




&НаСервере
Функция НайтиВладельца(долж,дог)

	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Должники.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ДолжникиД
		|ИЗ
		|	Справочник.Должники КАК Должники
		|ГДЕ
		|	Должники.Наименование = &Наименование
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДолжникиД.Ссылка КАК Ссылка
		|ИЗ
		|	ДолжникиД КАК ДолжникиД
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Договоры КАК Договоры
		|		ПО ДолжникиД.Ссылка = Договоры.Владелец
		|ГДЕ
		|	Договоры.НомерДоговора = &НомерДоговора";
	
	Запрос.УстановитьПараметр("Наименование", долж);
	Запрос.УстановитьПараметр("НомерДоговора", дог);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		 должСсылка=ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА






			  //должСсылка=ВыборкаДетальныеЗаписи.Ссылка;

	
	
	

	Возврат  должСсылка;

	
КонецФункции // ()







