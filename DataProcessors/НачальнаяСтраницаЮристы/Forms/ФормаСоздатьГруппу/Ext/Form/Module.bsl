﻿



&НаКлиенте
Процедура СоздатьГруппу(Команда)
	
	
 	 ответ= ЕстьЛиТакаяГруппа(ГруппыДоговоров);
	
	  Если ответ Тогда
	

		  Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопрос",ЭтаФорма);
		  
		  текст="Группа с таким именем уже есть. Добавить в "+ ГруппыДоговоров+" выбранные договора?";

          ПоказатьВопрос(Оповещение, текст,РежимДиалогаВопрос.ДаНет,0,,,); 	
	

		 
		 
	  
	  Иначе
	  
	      СоздатьГруппуНаСервере(); 
		  ЭтаФорма.Закрыть();

	  
	  КонецЕсли;
	 
	
	
	
	
	//ЭтаФорма.Закрыть();
	
КонецПроцедуры





&НаКлиенте
Процедура ПослеОтветаНаВопрос(Результат, Параметры) Экспорт 



		Если Результат = КодВозвратаДиалога.Да Тогда

			      РедактироватьГруппуНаСервере(ГруппыДоговоров);
			       ЭтаФорма.Закрыть();

		Иначе

		      ЭтаФорма.Закрыть();

		КонецЕсли;



КонецПроцедуры



&НаСервере
Процедура РедактироватьГруппуНаСервере(ссылкаСпр)

	          Запрос = Новый Запрос;
					Запрос.Текст = 
						"ВЫБРАТЬ
						|	ГруппыДоговоровЮрист.Ссылка КАК Ссылка
						|ИЗ
						|	Справочник.ГруппыДоговоровЮрист КАК ГруппыДоговоровЮрист
						|ГДЕ
						|	ГруппыДоговоровЮрист.Наименование = &Наименование";
					
					Запрос.УстановитьПараметр("Наименование", ссылкаСпр);
					
					РезультатЗапроса = Запрос.Выполнить();
					
					ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

					ВыборкаДетальныеЗаписи.Следующий();
					
					об= ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
	
					Для каждого стр Из  списокДоговоров Цикл
						
						НайденнаяСтрока= об.ТЧ.Найти(стр.Значение.КрДоговор, "КрДоговор");
				        Если  НайденнаяСтрока=Неопределено Тогда
						       стрСпр=об.ТЧ.Добавить();
							   
							 стрСпр.ВидПродукта=стр.Значение.ВидПродукта;
						     
						     стрСпр.ДатаЗагрузки=стр.Значение.ДатаЗагрузки;
						     
						     стрСпр.ДатаЦессии=стр.Значение.ДатаЦессии;
						     
							 стрСпр.КрДоговор=стр.Значение.КрДоговор;
							 
							 стрСпр.НомерДоговораЦессии=стр.Значение.НомерДоговораЦессии;
							 
							 стрСпр.ФИОДолжника=стр.Значение.ФИОДолжника;
							 
							 стрСпр.Цедент=стр.Значение.Цедент;

							  стрСпр.СуммаЗадолженностиПереданная=стр.Значение.СуммаЗадолженностиПереданная; 
							  
							  
							   //  Создать дело ..
							   
							   
							 Если НЕ ЕстьЛиДелоПоДоговору(стр.Значение.КрДоговор) Тогда   
							  	 
								 новыйЭлементСпискадел=Справочники.СписокДелКредитногоДоговора.СоздатьЭлемент();
								 новыйЭлементСпискадел.Банк=стр.Значение.Цедент;
								 новыйЭлементСпискадел.Владелец=стр.Значение.КрДоговор;
								 новыйЭлементСпискадел.ДатаКредитногоДоговора=стр.Значение.КрДоговор.ДатаФинансирования;
								 новыйЭлементСпискадел.ДатаЦессии=стр.Значение.ДатаЦессии;
								 новыйЭлементСпискадел.Должник=стр.Значение.ФИОДолжника;
					 	         новыйЭлементСпискадел.КредитныйДоговор=стр.Значение.КрДоговор;
								 новыйЭлементСпискадел.НомерЦессии=стр.Значение.НомерДоговораЦессии;
								 новыйЭлементСпискадел.ОтветственныйСотрудник=ПользовательТк;
								 новыйЭлементСпискадел.СтадияДела=СтадияДела;
								 новыйЭлементСпискадел.ДатаСоздания=ТекущаяДата();
								 новыйЭлементСпискадел.СуммаЗадолженностиПереданная=стр.Значение.СуммаЗадолженностиПереданная;
								 новыйЭлементСпискадел.ТипКредита=стр.Значение.ВидПродукта;
								 
								 новыйЭлементСпискадел.Записать();
								 
								 
								 	 структураСуд= ЕстьлиСудКДоговору(стр.Значение.КрДоговор);
										 
										 Если структураСуд.Суд<>Неопределено Тогда
											 
											  новаяЗаписьСудВкладка=Справочники.ВкладкаСудСудебнаяСтадияСписокДел.СоздатьЭлемент();
											  новаяЗаписьСудВкладка.Владелец=новыйЭлементСпискадел.Ссылка;
											  
											  новаяЗаписьСудВкладка.НазваниеСуда=структураСуд.Суд;
											  новаяЗаписьСудВкладка.АдресСудаВкладка=структураСуд.Суд.Адрес;
											  новаяЗаписьСудВкладка.ТипСуда= Строка(структураСуд.Суд.ТипСуда);
											  
											  новаяЗаписьСудВкладка.Записать();
											  
											 
											 
										 
										 КонецЕсли;
										 

								 
								 
							 
							 КонецЕсли;		

							  
						
						КонецЕсли;		
						
						
						
					
					КонецЦикла;
					
					 об.Записать();
					
					
	
	

КонецПроцедуры


&НаСервере
Функция  ЕстьЛиДелоПоДоговору(дог)

	           	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
				// Данный фрагмент построен конструктором.
				// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
				
				Запрос = Новый Запрос;
				Запрос.Текст = 
					"ВЫБРАТЬ
					|	СписокДелКредитногоДоговора.Ссылка КАК Ссылка
					|ИЗ
					|	Справочник.СписокДелКредитногоДоговора КАК СписокДелКредитногоДоговора
					|ГДЕ
					|	СписокДелКредитногоДоговора.Владелец = &Владелец";
				
				Запрос.УстановитьПараметр("Владелец", дог);
				
				РезультатЗапроса = Запрос.Выполнить();
				
				ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
				
				Если ВыборкаДетальныеЗаписи.Количество()>0 Тогда
				
				  Возврат Истина;	
				
				Иначе
				
			      Возврат Ложь;		
				
				КонецЕсли;
				
				
				//Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				//	// Вставить обработку выборки ВыборкаДетальныеЗаписи
				//КонецЦикла;
				
				//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	
	

КонецФункции // ()



&НаСервере
Процедура СоздатьГруппуНаСервере()

	              Если ЗначениеЗаполнено(СтадияДела) Тогда
					  
					    	
						 //новыйЭлемент=Справочники.ГруппыДоговоровЮрист.СоздатьЭлемент(); 
						 //новыйЭлемент.Владелец= ПользовательТк;
						 //новыйЭлемент.Наименование=ГруппыДоговоров;
						 //
						 
						  
							 новыйЭлемент = Справочники.ГруппыДоговоровЮрист.СоздатьЭлемент();
							 новыйЭлемент.Наименование=ГруппыДоговоров;
							 
							 новыйЭлементСсылка = Справочники.ГруппыДоговоровЮрист.ПолучитьСсылку(Новый УникальныйИдентификатор);
							 
							 новыйЭлемент.УстановитьСсылкуНового(новыйЭлементСсылка);
							 
							 новыйЭлемент.Владелец= ПользовательТк;
							 новыйЭлемент.Наименование=ГруппыДоговоров;

						 
						 
						 Для каждого стр  Из списокДоговоров Цикл
						     
						     стрСпр= новыйЭлемент.ТЧ.Добавить();
						     
						     стрСпр.ВидПродукта=стр.Значение.ВидПродукта;
						     
						     стрСпр.ДатаЗагрузки=стр.Значение.ДатаЗагрузки;
						     
						     стрСпр.ДатаЦессии=стр.Значение.ДатаЦессии;
						     
							 стрСпр.КрДоговор=стр.Значение.КрДоговор;
							 
							 стрСпр.НомерДоговораЦессии=стр.Значение.НомерДоговораЦессии;
							 
							 стрСпр.ФИОДолжника=стр.Значение.ФИОДолжника;
							 
							 стрСпр.Цедент=стр.Значение.Цедент;
							 
							 стрСпр.СуммаЗадолженностиПереданная=стр.Значение.СуммаЗадолженностиПереданная;
							 
									  //  Создать дело ..
									 
									 Если НЕ ЕстьЛиДелоПоДоговору(стр.Значение.КрДоговор) Тогда
										 
										 новыйЭлементСпискадел=Справочники.СписокДелКредитногоДоговора.СоздатьЭлемент();
										 новыйЭлементСпискадел.Банк=стр.Значение.Цедент;
										 новыйЭлементСпискадел.Владелец=стр.Значение.КрДоговор;
										 новыйЭлементСпискадел.ДатаКредитногоДоговора=стр.Значение.КрДоговор.ДатаФинансирования;
										 новыйЭлементСпискадел.ДатаЦессии=стр.Значение.ДатаЦессии;
										 новыйЭлементСпискадел.Должник=стр.Значение.ФИОДолжника;
							 	         новыйЭлементСпискадел.КредитныйДоговор=стр.Значение.КрДоговор;
										 новыйЭлементСпискадел.НомерЦессии=стр.Значение.НомерДоговораЦессии;
										 новыйЭлементСпискадел.ОтветственныйСотрудник=ПользовательТк;
										 новыйЭлементСпискадел.СтадияДела=СтадияДела;
										 новыйЭлементСпискадел.ДатаСоздания=ТекущаяДата();
										 новыйЭлементСпискадел.СуммаЗадолженностиПереданная=стр.Значение.СуммаЗадолженностиПереданная;
										 новыйЭлементСпискадел.ТипКредита=стр.Значение.ВидПродукта;
										 
										 новыйЭлементСпискадел.Записать();
										 
										 
										 
										 
										 // обновлю регистр РегистрСведенийПоследнийДокументКредитногоДоговора
										 ФункцииДляОтчетов.ДанныеПоследнегоДокументаПоДоговоруОдному(стр.Значение.КрДоговор);
										 
										 
										 
										 
										 // записать ВкладкаСудСудебнаяСтадияСписокДел если РегистрСведенийСоответствиеСудДоговорИзФайла
										 
										 
										 структураСуд= ЕстьлиСудКДоговору(стр.Значение.КрДоговор);
										 
										 Если структураСуд.Суд<>Неопределено Тогда
											 
											  
											 
											  новаяЗаписьСудВкладка=Справочники.ВкладкаСудСудебнаяСтадияСписокДел.СоздатьЭлемент();
											  
											  новаяЗаписьСудВкладка.Владелец=новыйЭлементСпискадел.Ссылка;
											  
											  новаяЗаписьСудВкладка.НазваниеСуда=структураСуд.Суд;
											  новаяЗаписьСудВкладка.АдресСудаВкладка=структураСуд.Суд.Адрес;
											  
											  
											  новаяЗаписьСудВкладка.ТипСуда= Строка(структураСуд.Суд.ТипСуда);
											  
											  
											  новаяЗаписьСудВкладка.Записать();
											  
											 
											 
										 
										 КонецЕсли;
										 
										 
									 Иначе
										 
										 
										 
										 
										 

										 
									 КонецЕсли;
									 
									 
									 
							 
							
						 
						 КонецЦикла;
						 
						 новыйЭлемент.Записать();

						  
						 
						 ссылкаСпр=новыйЭлемент.Ссылка;
						 

				  	
				  
				  КонецЕсли;  
	            
	                       	

КонецПроцедуры


&НаСервере
Функция ЕстьЛиВкладкаСудСудебнаяСтадияСписокДел()

	

КонецФункции // ()




&НаСервере
Функция ЕстьлиСудКДоговору(дог)
	
	        структураСуд=Новый Структура;
	   
	          	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
				// Данный фрагмент построен конструктором.
				// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
				
				Запрос = Новый Запрос;
				Запрос.Текст = 
					"ВЫБРАТЬ ПЕРВЫЕ 1
					|	РегистрСведенийСоответствиеСудДоговорИзФайла.Договор КАК Договор,
					|	РегистрСведенийСоответствиеСудДоговорИзФайла.Суд КАК Суд,
					|	РегистрСведенийСоответствиеСудДоговорИзФайла.ДатаЗагрузки КАК ДатаЗагрузки
					|ИЗ
					|	РегистрСведений.РегистрСведенийСоответствиеСудДоговорИзФайла КАК РегистрСведенийСоответствиеСудДоговорИзФайла
					|ГДЕ
					|	РегистрСведенийСоответствиеСудДоговорИзФайла.Договор = &Договор
					|
					|УПОРЯДОЧИТЬ ПО
					|	ДатаЗагрузки УБЫВ";
				
				Запрос.УстановитьПараметр("Договор", дог);
				
				РезультатЗапроса = Запрос.Выполнить();
				
				ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
				
				Если ВыборкаДетальныеЗаписи.Количество()>0  Тогда
				     Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					     структураСуд.Вставить("Суд",ВыборкаДетальныеЗаписи.Суд);
					
					
				    КонецЦикла;

				
				Иначе
					
					   структураСуд.Вставить("Суд",Неопределено);
					
				
				КонецЕсли;
				
				
				
								
				//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	              
				
	Возврат структураСуд;			
				
				
	

КонецФункции // ()





&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	  //массивДоговоров=Параметры.данныеГруппаДоговоровСтруктура; 
	  
	  списокДоговоров.ЗагрузитьЗначения(Параметры.данныеГруппаДоговоровСтруктура);
	  
	  ПользовательТк=Параметры.Исполнитель;
	  
	  
	  
	
КонецПроцедуры


&НаСервере
Функция ЕстьЛиТакаяГруппа(имяГруппы)

				  //ПользовательТк  
	
		           Запрос = Новый Запрос;
					Запрос.Текст = 
						"ВЫБРАТЬ
						|	ГруппыДоговоровЮрист.Ссылка КАК Ссылка
						|ИЗ
						|	Справочник.ГруппыДоговоровЮрист КАК ГруппыДоговоровЮрист
						|ГДЕ
						|	ГруппыДоговоровЮрист.Наименование = &Наименование
						|	И ГруппыДоговоровЮрист.Владелец = &Сотрудник";
					
					Запрос.УстановитьПараметр("Наименование", ГруппыДоговоров);
					Запрос.УстановитьПараметр("Сотрудник", ПользовательТк);

					
					РезультатЗапроса = Запрос.Выполнить();
					
					ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
					
					Если ВыборкаДетальныеЗаписи.Количество()=0 Тогда
					  Возврат Ложь;	
						
					Иначе
						
					  Возврат Истина;	
						
				    КонецЕсли;
		 

	

КонецФункции // ()

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("ссылкаСпр", ссылкаСпр);
	
	ОповеститьОВыборе(СписокПараметров);

	
	
	
КонецПроцедуры





