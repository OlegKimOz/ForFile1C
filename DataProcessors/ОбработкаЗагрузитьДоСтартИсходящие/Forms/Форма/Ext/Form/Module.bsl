﻿
&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
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
Процедура ОбработатьФайл(Команда)
	
      ОбработатьНаСервере();
	  
	  Сообщить("Ок");
	
	
КонецПроцедуры


&НаСервере
Процедура ОбработатьНаСервере()
	
	
	
	   ФайлДанных = ИмяФайла;
	    
	   ФайлЕксел.Прочитать(ИмяФайла,СпособЧтенияЗначенийТабличногоДокумента.Текст);
	    
	   ПЗ = Новый ПостроительЗапроса;

	   ПЗ.ИсточникДанных = Новый ОписаниеИсточникаДанных(ФайлЕксел.Область());

	   ПЗ.ДобавлениеПредставлений = ТипДобавленияПредставлений.НеДобавлять;

	   ПЗ.ЗаполнитьНастройки();

	   ПЗ.Выполнить();

	   ТаблицаЗначений = ПЗ.Результат.Выгрузить();

	   
	    
	      Для каждого стрТабл Из ТаблицаЗначений Цикл
			  
			  СоздатьИсходящийДокумент(стрТабл);
			  
          
			  
			  //стрТабл.Сотрудник
	   
	      КонецЦикла;

	
		
		//НазваниеДокумента
		//
		//НомерКредитногоДоговора
		//
		//РегистрационныйНомер
		//
		//ДатаРегистрации
		
		 //ФИОДолжника
		 //
		 //Сотрудник
		 //
		 //ШПИ
		 //
		 //
		
		
	
КонецПроцедуры


&НаСервере
Процедура СоздатьИсходящийДокумент(стрТабл)

	       должСсылка=Неопределено;
		   договорСсылка=Неопределено;
		   
		     	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
					// Данный фрагмент построен конструктором.
					// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
					
					Запрос = Новый Запрос;
					Запрос.Текст = 
						"ВЫБРАТЬ
						|	Должники.Ссылка КАК ДолжникСсылка,
						|	Договоры.Ссылка КАК ДоговорСсылка
						|ИЗ
						|	Справочник.Договоры КАК Договоры
						|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Должники КАК Должники
						|		ПО Договоры.Владелец = Должники.Ссылка
						|ГДЕ
						|	Должники.Наименование = &Наименование
						|	И Договоры.НомерДоговора ПОДОБНО &НомерДоговора";
					
					Запрос.УстановитьПараметр("Наименование", стрТабл.ФИОДолжника);
					Запрос.УстановитьПараметр("НомерДоговора", СокрЛ(стрТабл.НомерКредитногоДоговора)+"%");

					
					РезультатЗапроса = Запрос.Выполнить();
					
					ВыборкаДолжникДоговор = РезультатЗапроса.Выбрать();
					
					Пока ВыборкаДолжникДоговор.Следующий() Цикл
						// Вставить обработку выборки ВыборкаДетальныеЗаписи
						должСсылка=ВыборкаДолжникДоговор.ДолжникСсылка;
						договорСсылка=ВыборкаДолжникДоговор.ДоговорСсылка;
					КонецЦикла;
					
					//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

					
				Если должСсылка<>Неопределено Тогда
				
					
					     								
								
								
								исполнительПодоно= СокрЛ(стрТабл.Сотрудник);
								индексПробела=Найти(исполнительПодоно," ");
								
								исполнительПодоно=Лев(исполнительПодоно,индексПробела-1);
								
								
								
								
															   	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
								// Данный фрагмент построен конструктором.
								// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
								
								Запрос = Новый Запрос;
								Запрос.Текст = 
									"ВЫБРАТЬ
									|	Сотрудники.Ссылка КАК Ссылка
									|ИЗ
									|	Справочник.Сотрудники КАК Сотрудники
									|ГДЕ
									|	Сотрудники.Наименование ПОДОБНО &Наименование";
								
								Запрос.УстановитьПараметр("Наименование", исполнительПодоно+"%");
								
								РезультатЗапроса = Запрос.Выполнить();
								
								ВыборкаСотрудник = РезультатЗапроса.Выбрать();
								
								Пока ВыборкаСотрудник.Следующий() Цикл
									// Вставить обработку выборки ВыборкаДетальныеЗаписи
									ссылкаСотрудник=ВыборкаСотрудник.Ссылка;
									
									
								КонецЦикла;
								
								//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

								
								
								
								 НачатьТранзакцию();
								
								//Создать элемент справочника ДокументИсходящийДоСтарт
								Попытка
									
								  // Если привязан к дате и договор - то не записываю
															  
															  	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
								// Данный фрагмент построен конструктором.
								// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
								
								Запрос = Новый Запрос;
								Запрос.Текст = 
									"ВЫБРАТЬ
									|	ПередачаДоговоровДоговора.Ссылка КАК Ссылка,
									|	ПередачаДоговоровДоговора.Договор КАК Договор
									|ИЗ
									|	Документ.ПередачаДоговоров.Договора КАК ПередачаДоговоровДоговора
									|ГДЕ
									|	ПередачаДоговоровДоговора.Ссылка.Дата = &Дата
									|	И ПередачаДоговоровДоговора.Ссылка.Сотрудник = &Сотрудник
									|	И ПередачаДоговоровДоговора.Договор = &Договор";
								
								Запрос.УстановитьПараметр("Дата", ДатаСоздания);
								Запрос.УстановитьПараметр("Договор", договорСсылка);
								Запрос.УстановитьПараметр("Сотрудник", ссылкаСотрудник);
								
								РезультатЗапроса = Запрос.Выполнить();
								
								ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
								
								записатьДок=Ложь;
								Если ВыборкаДетальныеЗаписи.Количество()=0 Тогда
								     записатьДок=Истина;
									      	
									 НовыйДокумент = Документы.ПередачаДоговоров.СоздатьДокумент();
									 
									 НовыйДокумент.Автор=ссылкаСотрудник;
					
				                     НовыйДокумент.Дата=ДатаСоздания;
					
					                 НовыйДокумент.Сотрудник=ссылкаСотрудник;
									 
									 	строкаТЧ= НовыйДокумент.Договора.Добавить();
						
						                строкаТЧ.Договор=договорСсылка;
						
						                строкаТЧ.Должник=должСсылка;

								
								КонецЕсли;
								
								
															  
									
								

	
									
							  записьЕсть = Справочники.ДокументИсходящийДоСтарт.НайтиПоРеквизиту("ШПИ",стрТабл.ШПИ);
									
								Если НЕ записьЕсть.Пустая() Тогда
									новаяЗапись = записьЕсть.ПолучитьОбъект();
									новаяЗапись.АдресАдресата=стрТабл.АдресАдресата;
									 новаяЗапись.Адресат=стрТабл.Адресат;
									 новаяЗапись.Должник =должСсылка;
									 новаяЗапись.Договор=договорСсылка;
									 новаяЗапись.СтатусДоставки=стрТабл.СтатусДоставки;
									 
									 Если стрТабл.ДатаСтатуса<>"" Тогда
									 
									 	   новаяЗапись.ДатаСтатуса=СтроковыеФункцииКлиентСервер.СтрокаВДату(стрТабл.ДатаСтатуса);
								     
									 
									 КонецЕсли;
									   									 
									 новаяЗапись.ТипДокумента=Перечисления.ТипДокумента.исх;
									 новаяЗапись.НомерДоговора=стрТабл.НомерКредитногоДоговора;
									 //новаяЗапись.Стадия=Перечисления.СтадияДокумента.СудебноеПроизводство;   //спросить ?
									 новаяЗапись.НазваниеДокумента=стрТабл.НазваниеДокумента;
									 
									 новаяЗапись.РегистрационныйНомер=стрТабл.РегистрационныйНомер;
									   
									 Если стрТабл.ДатаРегистрации<>"" Тогда
									 
									 	   новаяЗапись.ДатаРегистрации=СтроковыеФункцииКлиентСервер.СтрокаВДату(стрТабл.ДатаРегистрации);
	                                                                   								 
									 КонецЕсли;
  
									 
									 новаяЗапись.Исполнитель=ссылкаСотрудник;
									 
									 новаяЗапись.ШПИ=стрТабл.ШПИ;
									 
  									 новаяЗапись.ДатаСоздания=ДатаСоздания;
									 новаяЗапись.Записать();


									
									
								Иначе
									
									 новаяЗаписьNew = Справочники.ДокументИсходящийДоСтарт.СоздатьЭлемент();
									 
									 новаяЗаписьNew.АдресАдресата=стрТабл.АдресАдресата;
									 новаяЗаписьNew.Адресат=стрТабл.Адресат;
									 новаяЗаписьNew.Должник =должСсылка;
									 новаяЗаписьNew.Договор=договорСсылка;
									 новаяЗаписьNew.ТипДокумента=Перечисления.ТипДокумента.исх;
									 новаяЗаписьNew.НомерДоговора=стрТабл.НомерКредитногоДоговора;
									 //новаяЗапись.Стадия=Перечисления.СтадияДокумента.СудебноеПроизводство;   //спросить ?
									 новаяЗаписьNew.НазваниеДокумента=стрТабл.НазваниеДокумента;
									 новаяЗаписьNew.РегистрационныйНомер=стрТабл.РегистрационныйНомер;
									
									 
									 Если стрТабл.ДатаРегистрации<>"" Тогда
									 
										
										 новаяЗаписьNew.ДатаРегистрации=СтроковыеФункцииКлиентСервер.СтрокаВДату(стрТабл.ДатаРегистрации);
									   									 
									 КонецЕсли;
   		 
									 новаяЗаписьNew.Исполнитель=ссылкаСотрудник;
									 новаяЗаписьNew.СтатусДоставки=стрТабл.СтатусДоставки;
									 
									
									  Если стрТабл.ДатаСтатуса<>"" Тогда
									 
										
									     новаяЗаписьNew.ДатаСтатуса=СтроковыеФункцииКлиентСервер.СтрокаВДату(стрТабл.ДатаСтатуса);
									 
									 КонецЕсли;

									 
									 новаяЗаписьNew.ШПИ=стрТабл.ШПИ;
									 
  									 новаяЗаписьNew.ДатаСоздания=ДатаСоздания;
									 
									 новаяЗаписьNew.Записать();
									


									
								КонецЕсли;
								
								Если  записатьДок Тогда
								
									НовыйДокумент.Записать(РежимЗаписиДокумента.Проведение);
								
								КонецЕсли;
									 
									 ЗафиксироватьТранзакцию();
								
								Исключение
									   ОтменитьТранзакцию();
									   ТекстОшибки = ОписаниеОшибки();
									    Сообщить(должСсылка);

									   Сообщить(ТекстОшибки);
									
								КонецПопытки;
								
								
								
					
				
				КонецЕсли;	
					
		   
	
	
	

КонецПроцедуры



	 
	 


