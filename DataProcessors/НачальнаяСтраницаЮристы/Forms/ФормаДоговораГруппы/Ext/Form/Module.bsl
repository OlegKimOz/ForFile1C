﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Вставить содержимое обработчика
	СписокДоговоров.Параметры.УстановитьЗначениеПараметра("Ссылка",Параметры.ГруппаСсылка);
    ПользовательТк=Параметры.Сотрудник;
	
	 ссылкаГруппаДоговоров=Параметры.ГруппаСсылка;
	
	УстановитьУсловноеОформление(Параметры.ГруппаСсылка);
	
КонецПроцедуры






&НаСервере
Процедура УстановитьУсловноеОформление(ссылкаГруппа)

	
			  массивКрДог=Новый Массив;

	 
				        	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
				// Данный фрагмент построен конструктором.
				// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
				
				Запрос = Новый Запрос;
				Запрос.Текст = 
					"ВЫБРАТЬ
					|	ГруппыДоговоровЮристТЧ.КрДоговор КАК КрДоговор,
					|	ГруппыДоговоровЮристТЧ.ДатаЗагрузки КАК ДатаЗагрузки,
					|	ГруппыДоговоровЮристТЧ.Цедент КАК Цедент,
					|	ГруппыДоговоровЮристТЧ.НомерДоговораЦессии КАК НомерДоговораЦессии,
					|	ГруппыДоговоровЮристТЧ.ДатаЦессии КАК ДатаЦессии,
					|	ГруппыДоговоровЮристТЧ.ВидПродукта КАК ВидПродукта,
					|	ГруппыДоговоровЮристТЧ.СуммаЗадолженностиПереданная КАК СуммаЗадолженностиПереданная,
					|	ГруппыДоговоровЮристТЧ.ФИОДолжника КАК ФИОДолжника
					|ИЗ
					|	Справочник.ГруппыДоговоровЮрист.ТЧ КАК ГруппыДоговоровЮристТЧ
					|ГДЕ
					|	ГруппыДоговоровЮристТЧ.Ссылка = &Ссылка";
				
				Запрос.УстановитьПараметр("Ссылка", ссылкаГруппа);
				
				РезультатЗапроса = Запрос.Выполнить();
				
				ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
				
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					// Вставить обработку выборки ВыборкаДетальныеЗаписи
					структураДанные=Новый Структура;
					
					структураДанные.Вставить("КрДоговор",ВыборкаДетальныеЗаписи.КрДоговор);
					структураДанные.Вставить("ДатаЗагрузки",ВыборкаДетальныеЗаписи.ДатаЗагрузки);
					структураДанные.Вставить("Цедент",ВыборкаДетальныеЗаписи.Цедент);
					структураДанные.Вставить("НомерДоговораЦессии",ВыборкаДетальныеЗаписи.НомерДоговораЦессии);
					структураДанные.Вставить("ДатаЦессии",ВыборкаДетальныеЗаписи.ДатаЦессии);
					структураДанные.Вставить("СуммаЗадолженностиПереданная",ВыборкаДетальныеЗаписи.СуммаЗадолженностиПереданная);
					структураДанные.Вставить("ФИОДолжника",ВыборкаДетальныеЗаписи.ФИОДолжника);
					
					
					 массивКрДог.Добавить(структураДанные);
					 
					 колДел=СколькоДелПоКредДоговору(ВыборкаДетальныеЗаписи.КрДоговор);
					 
					 
					 УсловноеОформлениеСтр(колДел,ВыборкаДетальныеЗаписи.КрДоговор);
					 
										 
					 
					 
					
				КонецЦикла;
				
				//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	
	
               массивДоговоров.ЗагрузитьЗначения(массивКрДог);				
				
				
	
	
	
КонецПроцедуры



&НаСервере
Процедура УсловноеОформлениеСтр(колич,крдог)

	
	//УсловноеОформление.Элементы.Очистить();
	
	ЭлементОформления = СписокДоговоров.УсловноеОформление.Элементы.Добавить();     
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("КрДоговор");   
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;    
	ЭлементОтбора.ПравоеЗначение = крдог;
	ЭлементОтбора.Использование  = Истина;
	Если колич=1 Тогда
	
		    ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.Аквамарин);

	
	КонецЕсли;
	
	Если колич>1 Тогда
	
		    ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.БледноЛиловый);

	
	КонецЕсли;
	
	        готовПеч=Ложь;
							//  Если по договору готов печать - коричневый
							
							     	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
							// Данный фрагмент построен конструктором.
							// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
							
							Запрос = Новый Запрос;
							Запрос.Текст = 
								"ВЫБРАТЬ
								|	ВкладкаСудебноеПроизводствоСудебнаяСтадия.ГотовКГенерацииДокументов КАК ГотовКГенерацииДокументов
								|ИЗ
								|	Справочник.ВкладкаСудебноеПроизводствоСудебнаяСтадия КАК ВкладкаСудебноеПроизводствоСудебнаяСтадия
								|ГДЕ
								|	ВкладкаСудебноеПроизводствоСудебнаяСтадия.Владелец = &Владелец";
							
							Запрос.УстановитьПараметр("Владелец", крдог);
							
							РезультатЗапроса = Запрос.Выполнить();
							
							ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
							
							Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
								// Вставить обработку выборки ВыборкаДетальныеЗаписи
								готовПеч=ВыборкаДетальныеЗаписи.ГотовКГенерацииДокументов;
								
							КонецЦикла;
							
							//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
							
		Если готовПеч Тогда
			
			  ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.Древесный);
			
		
		КонецЕсли;					

  	

КонецПроцедуры




&НаСервере
Функция СколькоДелПоКредДоговору(крДог)

	        
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СписокДелКредитногоДоговора.КредитныйДоговор КАК КредитныйДоговор
		|ИЗ
		|	Справочник.СписокДелКредитногоДоговора КАК СписокДелКредитногоДоговора
		|ГДЕ
		|	СписокДелКредитногоДоговора.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец", крДог);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	колДел=ВыборкаДетальныеЗаписи.Количество();
	
	
	Возврат колДел;
	

КонецФункции // ()










&НаКлиенте
Процедура СписокДоговоровВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	              парамСтруктура=Новый Структура;
	              парамСтруктура.Вставить("тДоговор", Элемент.ТекущиеДанные.КрДоговор);
				  
				  парамСтруктура.Вставить("тДолжник", Элемент.ТекущиеДанные.ФИОДолжника);
				  
				  парамСтруктура.Вставить("тЦедент", Элемент.ТекущиеДанные.Цедент);
				  
				  парамСтруктура.Вставить("тНомерДоговораЦессии", Элемент.ТекущиеДанные.НомерДоговораЦессии);
				  
				  парамСтруктура.Вставить("тДатаЦессии", Элемент.ТекущиеДанные.ДатаЦессии);
				  
				  парамСтруктура.Вставить("тВидПродукта", Элемент.ТекущиеДанные.ВидПродукта);
				  
				  парамСтруктура.Вставить("тСуммаЗадолженностиПереданная", Элемент.ТекущиеДанные.СуммаЗадолженностиПереданная);
				  
				  парамСтруктура.Вставить("тОтветственныйСотрудник", ПользовательТк);
				  
				  парамСтруктура.Вставить("текСтрока", Элемент.ТекущаяСтрока);
				  
				  парамСтруктура.Вставить("номерСтроки", Элемент.ТекущиеДанные.НомерСтроки);
				  
				  парамСтруктура.Вставить("спрГруппадоговоровЮристСсылка", Элемент.ТекущиеДанные.Ссылка);
				  
				  
				  //ДанныеСтр = Элемент.ДанныеСтроки(Элемент.ТекущаяСтрока);
				
				  
				 
	              ОткрытьФорму("Справочник.СписокДелКредитногоДоговора.Форма.ФормаСпискаПарам",парамСтруктура,ЭтаФорма);
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ГенерацияДокументов(Команда)
	
	     ОповещениеОЗакрытии=Новый ОписаниеОповещения("ДанныеДляГенерацииДокументов",ЭтотОбъект); 

		 
		 
		 
		 
		 
		 
		 
		 
		 данныеПоискаСтруктура=Новый Структура;
		 
		 
		 данныеПоискаСтруктура.Вставить("массивДоговоров", массивДоговоров.ВыгрузитьЗначения());
		 данныеПоискаСтруктура.Вставить("Исполнитель", ПользовательТк);
		 
		 
		 
		 
	     ОткрытьФорму("Обработка.НачальнаяСтраницаЮристы.Форма.ФормаГенерацияДокументовГруппы",данныеПоискаСтруктура,ЭтаФорма,,,,ОповещениеОЗакрытии,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	
	
КонецПроцедуры




	 
	 


&НаКлиенте
Процедура ДанныеДляГенерацииДокументов(РезультатЗакрытия,ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия= Неопределено Тогда
	     Возврат;
		
	
	 Иначе
		 
		 Если РезультатЗакрытия.Обновить Тогда
		 
		 	 Оповестить("ОбновитьСписок1",Истина,ЭтаФорма);
			 
			 
		 КонецЕсли;
		 
		  		 
		 
	КонецЕсли;	 
		 
КонецПроцедуры




&НаСервере
Процедура УдалитьСтрокуНаСервере(номерСтр,ссылкаГруппыДоговоровЮрист)
	// Вставить содержимое обработчика.
	
	
	
	об=ссылкаГруппыДоговоровЮрист.ПолучитьОбъект();
	
	об.ТЧ.Удалить(номерСтр-1);
	
	об.Записать();
	
	Элементы.СписокДоговоров.Обновить();
	
		
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиСтруктуруВМассиве(крДог)

	индУдал=0;
	удалЕсть=Ложь;
	
	количВМассиве=массивДоговоров.Количество();
	
	Для индекс=0  По количВМассиве-1  Цикл
		
		Если массивДоговоров[индекс].Значение.КрДоговор=крДог Тогда
			удалЕсть=Истина;
			
			индУдал=индекс;
			
			
		
		КонецЕсли;
	
	КонецЦикла;
	
	Если удалЕсть Тогда
	
		  массивДоговоров.Удалить(индУдал);
	
	КонецЕсли;
	

	
	
КонецПроцедуры
	
	
		
	     
	


&НаКлиенте
Процедура УдалитьСтроку(Команда)
	
	ДанныеСтр = Элементы.СписокДоговоров.ДанныеСтроки(Элементы.СписокДоговоров.ТекущаяСтрока);
	
	//ДанныеСтр.КрДоговор
	
	НайтиСтруктуруВМассиве(ДанныеСтр.КрДоговор);
	
	УдалитьСтрокуНаСервере(ДанныеСтр.НомерСтроки,ДанныеСтр.Ссылка);
	
	Оповестить("ОбновитьГруппуПослеРедактирования",ДанныеСтр.КрДоговор);

	
	
КонецПроцедуры


&НаСервере
Процедура ОбновитьСписокДоговоров()

	        УстановитьУсловноеОформление(ссылкаГруппаДоговоров);

	
	        Элементы.СписокДоговоров.Обновить();


КонецПроцедуры



&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// Вставить содержимое обработчика.
	
	Если ИмяСобытия = "ОбновитьСписокДоговоровГотовКПечати" Тогда
		
			ОбновитьСписокДоговоров();	
		
	КонецЕсли;

	
	
КонецПроцедуры




