﻿
&НаКлиенте
Процедура Обработать(Команда)
		
		стрДолж=ПолучитьКолонки(Объект.ИмяШаблона);

        стрДоговор=ПолучитьКолонкиДоговор(Объект.ИмяШаблона);

		стрАдрес=ПолучитьКолонкиАдрес(Объект.ИмяШаблона);
		
		
	  загодин=Ложь;
	 
	  фамилия= стрДолж["Фамилия"];
	  
	  имя=стрДолж["Имя"];
	  отчество=стрДолж["Отчество"];
	  
	  
	  Если фамилия=имя Тогда
	      //Значит  один заголовок для Должника
	      должникЗаг=фамилия;
	      загодин=Истина;
	  Иначе
	      
		   //должникЗаг= стрДолж["Фамилия"]+" "+стрДолж["Имя"]+" "+ стрДолж["Отчество"];
	  КонецЕсли;	  
	    
	  
	     массивЗаг=Новый Массив;

	  
	  
		   Для каждого стр Из стрДолж Цикл
		  
			  Если стр.Ключ<>"Имя" И стр.Ключ<>"Отчество" Тогда
				  
				   массивЗаг.Добавить(стр);
			  
			  КонецЕсли;
		  
		  КонецЦикла;

		  
		   Для каждого стр Из стрДоговор Цикл
	  
			  
			   массивЗаг.Добавить(стр);
		  	
		  
	       КонецЦикла;

		   
		     Для каждого стр Из стрАдрес Цикл
	  
		      
		  
			   массивЗаг.Добавить(стр);
			   
			   СписокПолей.Добавить(стр.Ключ);

			   
		  
      	  КонецЦикла;
		  
		  
		  
		        // запишу врем файл и передам его  обработчику
	  
     	   Shell = Новый COMОбъект("WScript.Shell");
           дирМоиД=Shell.SpecialFolders.Item("MyDocuments");

		   имяэксел=Объект.ИмяФайла;
		   
		   Если Х2=Истина  Тогда
			   
		        прогрпуть="D:\public\Distr";
		 
		        имяфайлатемп=прогрпуть+"\должадрес.txt";

		    	
		    	имяфайлатемпответ=прогрпуть+"\должадрес_out.txt";

		    	 программаОбр=прогрпуть+"\ParseExcel86.exe";
		   
		   Иначе
			   
			   имяфайлатемп=дирМоиД+"\должадрес.txt";
			   
			   имяфайлатемпответ=дирМоиД+"\должадрес_out.txt";

			   программаОбр=дирМоиД+"\ExcelParse.exe";
			   
		   КонецЕсли; 
		   
		   

			   ФайлТемп = Новый ЗаписьТекста(имяфайлатемп);
			   
			   Для каждого масстр Из массивЗаг  Цикл
				   
				 ФайлТемп.ЗаписатьСтроку(масстр.Значение);   
				 
			   
			   КонецЦикла;
			   
			   ФайлТемп.ЗаписатьСтроку(Объект.ИмяФайла);
			   
			   ФайлТемп.Закрыть();

			   
			   
			   
			   
			 программаОбр=программаОбр+" "+"8";
			 
			 
	    	 Shell.Run(программаОбр,0, 1);

			 
			 // код 240 символа
			 
			 //  обработаем вернувшийся файл     долждопд_out.txt
			 
			 
			   
	   
			   мСтрокФайла = Новый Массив();

			   
			   ВыбранныйФайл = Новый Файл(имяфайлатемпответ);
			   Если ВыбранныйФайл.Существует() Тогда
				   
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
		 
	  		ПостроитьТаблицу(массивЗаг);
			
			
			 должДанныет=Новый Структура;
			  
			  
			  Для каждого стрд  Из мСтрокФайла Цикл
				  
				     должДанныет=РазбитьСтроку(стрд,массивЗаг);
				   
				   	Запись=ТЧ.Добавить();
				     Для каждого мстр Из должДанныет Цикл
						 
						стрк=мстр.Ключ; 
					
						
						Запись[Строка(стрк)]=мстр.Значение; 	
					 
					 КонецЦикла;
				   
				  
				  
			  КонецЦикла;

	       
	
	
	
 КонецПроцедуры
 
 
 &НаКлиенте
Функция РазбитьСтроку(стрк,массивзаг)

   должДанные=Новый Структура;

	
	Разделитель = Символ(240);
    Строки = СтрЗаменить(стрк, Разделитель, Символы.ПС);
    Для Индекс = 1 По СтрЧислоСтрок(Строки) Цикл
		
		темпстр=массивзаг[Индекс-1].Ключ;
				
		
		должДанные.Вставить(темпстр,СтрПолучитьСтроку(Строки, Индекс));
		
    КонецЦикла;
	
	
	
	Возврат должДанные; 	

КонецФункции // ()

		  
		  


&НаСервере
Функция ПостроитьТаблицу(СтрМ)

	
	КС = Новый КвалификаторыСтроки(150);
    Массив = Новый Массив;
    Массив.Добавить(Тип("Строка"));
    ОписаниеТиповС = Новый ОписаниеТипов(Массив, , КС);

	
	 ТЗ = РеквизитФормыВЗначение("ТЧ");
	
	 //ТЗ = Новый ТаблицаЗначений;
	 
	 
	 инд=0;
     Для каждого мас Из СтрМ Цикл
		  
		  //инд=инд+1;
		  //строк=Строка(инд);
		  //
    	  ТЗ.Колонки.Добавить(мас.Ключ,ОписаниеТиповС,Строка(мас.Значение),150);
		  
     	
     
     КонецЦикла;
     
     
     //Опишем массив реквизитов
    МассивРеквизитов = Новый Массив;
    МассивТипаВыбора = Новый Массив;
    МассивТипаВыбора.Добавить(Тип("ТаблицаЗначений"));
    ОписаниеТипаВыбора = Новый ОписаниеТипов(МассивТипаВыбора);
    
    //Добавим в массив реквизитов таблицу значений
    МассивРеквизитов.Добавить(Новый РеквизитФормы("ДанныеФайла", ОписаниеТипаВыбора));
  
	//Добавим в массив реквизитов колонки таблицы
	Для Каждого Колонка Из ТЗ.Колонки Цикл
		
		МассивРеквизитов.Добавить(Новый РеквизитФормы(Колонка.Имя, Колонка.ТипЗначения, "ТЧ"));
		
	КонецЦикла;
  
    ИзменитьРеквизиты(МассивРеквизитов);
    
     //Добавим Таблицу на форму
    ТаблицаДанныхФайла             = Элементы.Добавить("ТаблицаДанныхФайла", Тип("ТаблицаФормы"));
    ТаблицаДанныхФайла.ПутьКДанным = "ТЧ";
    ТаблицаДанныхФайла.Отображение = ОтображениеТаблицы.Список;
	ТаблицаДанныхФайла.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
	
    //Добавим колонки
    Для Каждого Колонка Из ТЗ.Колонки Цикл
        НовыйЭлемент = Элементы.Добавить(Колонка.Имя, Тип("ПолеФормы"), ТаблицаДанныхФайла);
        НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
        НовыйЭлемент.ПутьКДанным = "ТЧ." + Колонка.Имя;
		НовыйЭлемент.Заголовок=Колонка.Заголовок;
		
    КонецЦикла;  
    ЗначениеВРеквизитФормы(ТЗ,"ТЧ");
    
    	 
	
	
КонецФункции // ()



&НаСервере
Функция ПолучитьКолонкиАдрес(стр)

	    должАдрес=Новый Структура;
		
		 	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ШаблоныФайловАдреса.Реквизит КАК Реквизит,
		|	ШаблоныФайловАдреса.Заголовки КАК Заголовки
		|ИЗ
		|	Справочник.ШаблоныФайлов.Адреса КАК ШаблоныФайловАдреса
		|ГДЕ
		|	ШаблоныФайловАдреса.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", стр);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		должАдрес.Вставить(ВыборкаДетальныеЗаписи.Реквизит,ВыборкаДетальныеЗаписи.Заголовки);
		
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	
	Возврат должАдрес;
	
		

КонецФункции // ()



&НаСервере
Функция ПолучитьКолонки(стр)

		
	//    Получить должника Колонку
	
	должФИО=Новый Структура;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ШаблоныФайловДолжники.Реквизит КАК Реквизит,
		|	ШаблоныФайловДолжники.Заголовки КАК Заголовки
		|ИЗ
		|	Справочник.ШаблоныФайлов.Должники КАК ШаблоныФайловДолжники
		|ГДЕ
		|	ШаблоныФайловДолжники.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", стр);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
	    должФИО.Вставить(ВыборкаДетальныеЗаписи.Реквизит,ВыборкаДетальныеЗаписи.Заголовки);
	 
		
	КонецЦикла;

	
	Возврат должФИО;
	  
	
	

КонецФункции // ()


&НаСервере
Функция ПолучитьКолонкиДоговор(стр)

	должДоговор=Новый Структура;

	
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ШаблоныФайловДоговоры.Реквизит КАК Реквизит,
		|	ШаблоныФайловДоговоры.Заголовки КАК Заголовки
		|ИЗ
		|	Справочник.ШаблоныФайлов.Договоры КАК ШаблоныФайловДоговоры
		|ГДЕ
		|	ШаблоныФайловДоговоры.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", стр);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		   должДоговор.Вставить(ВыборкаДетальныеЗаписи.Реквизит,ВыборкаДетальныеЗаписи.Заголовки);
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА


	Возврат должДоговор;
	
	
КонецФункции // ()



&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
			// Вставить содержимое обработчика.
	ДиалогВыбФайла 	 = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбФайла.Заголовок				= "Выберите файл для загрузки:";
	ДиалогВыбФайла.ПолноеИмяФайла			= Объект.ИмяФайла; //АДРЕС
	ДиалогВыбФайла.Фильтр					= "Excel (*.xlsx)|*.xls*";
	ДиалогВыбФайла.Расширение				= "xlsx";
	ДиалогВыбФайла.МножественныйВыбор		= Ложь;
	ДиалогВыбФайла.ПредварительныйПросмотр	= Ложь;
	ДиалогВыбФайла.Показать(Новый ОписаниеОповещения("ПослеВыбораФайла", ЭтаФорма));
	

	
КонецПроцедуры


&НаКлиенте
Процедура ПослеВыбораФайла(ВыбранныеФайлы, ДопПарметры) Экспорт
	Если ЗначениеЗаполнено(ВыбранныеФайлы) и ВыбранныеФайлы.Количество() > 0 Тогда
		 Объект.ИмяФайла = ВыбранныеФайлы[0];
		
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура Записать(Команда)
	
		
	  отвОтСерв= ЗаписьНаСервере ();
	  
	   	Для каждого стр Из отвОтСерв Цикл
		
			Если стр<>"" Тогда
			  Сообщить(стр);
			КонецЕсли;  
	
	    КонецЦикла;

	
	Сообщить("Ок");
КонецПроцедуры


&НаСервере
Функция ЗаписьНаСервере ()

	
	 отвМассив=Новый Массив; 
	 
   НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
   
    Сч = 0;

	остаткЗап=ТЧ.Количество();
	 
	колЗап=ТЧ.Количество(); 
	Для каждого стрД  Из ТЧ Цикл
		
				 
		
		             допДанныеАдресСтруктура=Новый Структура;
		 
					 Для каждого сппол  Из СписокПолей  Цикл
						 
						 допДанныеАдресСтруктура.Вставить(сппол.Значение,стрД[сппол.Значение]);
						 
					 
					 КонецЦикла;

					 
					 
			 Если  ПрефиксДоговора Тогда
				 
				номДоговора=стрД.НомерДоговора+СокрЛП(Префикс); 
			 Иначе 	
				 
				 номДоговора= стрД.НомерДоговора;
			 КонецЕсли;		 
					 
							 
					 
					 
		
		    соб=ЗаписьАдресНВКИ (стрД.Фамилия, номДоговора, допДанныеАдресСтруктура);
			
			Если соб<>"" Тогда
			
				  отвМассив.Добавить(соб);
			
			КонецЕсли;
			
		    				
	  Сч = Сч + 1;
		//Если колЗап<100 Тогда
		//    ЗафиксироватьТранзакцию();
		//	//НачатьТранзакцию();
		//
		//КонецЕсли;
	  
	    Если Сч = 100 Тогда
	    	ЗафиксироватьТранзакцию();
			НачатьТранзакцию();
			Сч=0;
	    КонецЕсли;	
		
		Если колЗап-Сч<100 Тогда
		
			  ЗафиксироватьТранзакцию();
			  НачатьТранзакцию();
		КонецЕсли;
		
		
		Если остаткЗап<=100 Тогда
		
			  ЗафиксироватьТранзакцию();
			  НачатьТранзакцию();
		КонецЕсли;
		
		
		
		остаткЗап=остаткЗап-1;
		
		
    КонецЦикла;


  Возврат  отвМассив;


КонецФункции // ()




&НаСервере
Функция ЗаписьАдресНВКИ (долж, номердог,строкадан)

	
	//НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);

	
	// если нет отчества
	  
	  массивФИО=новый Массив();
	  
	  массивФИО=СтрРазделить(долж," ");
	  
	  Если массивФИО.Количество()=2 Тогда
		  
		  долж=СтрЗаменить(долж," ","  ");
	  	
	  
	  КонецЕсли;
	  
	
    собвозвр="";
	
	должникСсылка=Неопределено;
	адресСсылка=Неопределено;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Должники.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Договоры КАК Договоры
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Должники КАК Должники
		|		ПО Договоры.Владелец = Должники.Ссылка
		|ГДЕ
		|	Договоры.НомерДоговора = &НомерДоговора
		|	И Должники.Наименование ПОДОБНО &Наименование";
	
	Запрос.УстановитьПараметр("Наименование", долж);
	Запрос.УстановитьПараметр("НомерДоговора", номердог);
	
	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		должникСсылка=ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
	
	
		  // попробую по договору найти ссылку
		  
				 Если должникСсылка=Неопределено Тогда
				 
									   	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
							// Данный фрагмент построен конструктором.
							// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
							
							Запрос = Новый Запрос;
							Запрос.Текст = 
								"ВЫБРАТЬ
								|	Договоры.Владелец КАК Владелец,
								|	Договоры.НомерДоговора КАК НомерДоговора
								|ИЗ
								|	Справочник.Договоры КАК Договоры
								|ГДЕ
								|	Договоры.НомерДоговора = &НомерДоговора";
							
							Запрос.УстановитьПараметр("НомерДоговора", номердог);
							
							РезультатЗапроса = Запрос.Выполнить();
							
							ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
							
							
							кол=ВыборкаДетальныеЗаписи.Количество();
							
							Если кол=1 Тогда
								
								  ВыборкаДетальныеЗаписи.Следующий();
								
								  должникСсылка=ВыборкаДетальныеЗаписи.Владелец;
								  
							КонецЕсли;
							
								//Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
								//	// Вставить обработку выборки ВыборкаДетальныеЗаписи
								//КонецЦикла;
								//
							//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

					 
				 
				 КонецЕсли; 
				  
	
	
    	  Если должникСсылка<>Неопределено Тогда

			  
			  
			  
			  
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	Адреса.Ссылка КАК Ссылка
				|ИЗ
				|	Справочник.Адреса КАК Адреса
				|ГДЕ
				|	Адреса.Владелец = &Владелец
			    |	И Адреса.Тип.Наименование = &Наименование";
			
			Запрос.УстановитьПараметр("Владелец", должникСсылка);
			Запрос.УстановитьПараметр("Наименование", "Регистрации");

			
			РезультатЗапроса = Запрос.Выполнить();
			
			Выборка = РезультатЗапроса.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				// Вставить обработку выборки ВыборкаДетальныеЗаписи
				адресСсылка=Выборка.Ссылка;
				
			КонецЦикла;
			
			
					Если адресСсылка<>Неопределено  Тогда
					
					   адрОб=адресСсылка.ПолучитьОбъект();	 
					   
					   Для каждого сппол  Из СписокПолей  Цикл
						   
						  стрА=Строка(сппол);  
						   
								Если сппол.Значение="Регион" Тогда
									
									// записать регион
									 кодРегиона="";
									 ссылкаРегион=Неопределено;
									 
									  	
											Запрос = Новый Запрос;
											Запрос.Текст = 
												"ВЫБРАТЬ
												|	КодыРегионовФССП.КодРегионаФССП КАК КодРегионаФССП,
												|	КодыРегионовФССП.Наименование КАК Наименование
												|ИЗ
												|	Справочник.КодыРегионовФССП КАК КодыРегионовФССП";
											
											РезультатЗапроса = Запрос.Выполнить();
											
											Выборка = РезультатЗапроса.Выбрать();
											
											Пока Выборка.Следующий() Цикл
												
												индРег=Найти(Выборка.Наименование,строкадан[стрА]);
												
												Если индРег<>0  Тогда
													
													кодРегиона=Выборка.КодРегионаФССП;
													
												
												КонецЕсли;
												
												// Вставить обработку выборки ВыборкаДетальныеЗаписи
											КонецЦикла;
											
											
											Если кодРегиона<>"" Тогда
												
												    	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
															// Данный фрагмент построен конструктором.
															// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
															
															Запрос = Новый Запрос;
															Запрос.Текст = 
																"ВЫБРАТЬ
																|	Регионы.Ссылка КАК Ссылка,
																|	Регионы.Наименование КАК Наименование
																|ИЗ
																|	Справочник.Регионы КАК Регионы
																|ГДЕ
																|	Регионы.КодРегионаФССП = &КодРегионаФССП";
															
															Запрос.УстановитьПараметр("КодРегионаФССП", кодРегиона);
															
															РезультатЗапроса = Запрос.Выполнить();
															
															ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
															
															Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
																// Вставить обработку выборки ВыборкаДетальныеЗаписи
																ссылкаРегион=ВыборкаДетальныеЗаписи.Ссылка;
																
															КонецЦикла;
															
															//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

																										
																									
											КонецЕсли;
											
											Если ссылкаРегион<>Неопределено Тогда
												
												
												адрОб[стрА]= ссылкаРегион;
											
											КонецЕсли;
											
											
								Иначе			
											
									 адрОб[стрА]=строкадан[стрА];
				
									 
								КонецЕсли;   
								   
												 
           						 
						 
					   КонецЦикла;
					   
					     адрОб.Записать();
					   
					
					КонецЕсли;
					
			  
			  
			  
	      Иначе
			   
			   //Сообщить("Нет в базе такого должника - "+долж + " или нет такого договора " + номердог);
			   
			   собвозвр="Нет в базе такого должника - "+долж + " или нет такого договора " + номердог; 
			   
		  КонецЕсли;
		
	
  //  
  //ЗафиксироватьТранзакцию();	
  //
   Возврат собвозвр;

КонецФункции // ()


