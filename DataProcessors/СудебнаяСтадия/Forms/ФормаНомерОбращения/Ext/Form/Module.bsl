﻿
&НаКлиенте
Процедура Записать(Команда)
	 
	
	     ЗаписатьНаСервере();
		 
		  ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
	КредитныйДоговор=Параметры.КредитныйДоговор;
	
	НомерОбращения=Параметры.НомерОбращения;
	
	СсылкаДокумент=Параметры.СсылкаДокумент;
	
	СтатусОбращения=Параметры.СтатусОбращения;
	
	
	
КонецПроцедуры




&НаСервере
Процедура ЗаписатьНаСервере()

	  // проверю есть ли такая запись 
	  
	   ссылкаСправочник=Неопределено;
	  
	    	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
				// Данный фрагмент построен конструктором.
				// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
				
				Запрос = Новый Запрос;
				Запрос.Текст = 
					"ВЫБРАТЬ
					|	ОбращенияВГАС.Ссылка КАК Ссылка,
					|	ОбращенияВГАС.Наименование КАК Наименование
					|ИЗ
					|	Справочник.ОбращенияВГАС КАК ОбращенияВГАС
					|ГДЕ
					|	ОбращенияВГАС.КредитныйДоговор = &КредитныйДоговор
					|	И ОбращенияВГАС.СсылкаДокумент = &СсылкаДокумент";
				
				Запрос.УстановитьПараметр("КредитныйДоговор", КредитныйДоговор);
				Запрос.УстановитьПараметр("СсылкаДокумент", СсылкаДокумент);
				
				РезультатЗапроса = Запрос.Выполнить();
				
				ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
				
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					// Вставить обработку выборки ВыборкаДетальныеЗаписи
					ссылкаСправочник=ВыборкаДетальныеЗаписи.Ссылка;
				КонецЦикла;
				
				//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

				
				Если ссылкаСправочник<>Неопределено Тогда
				
					 об=ссылкаСправочник.ПолучитьОбъект();
					 
					 об.Наименование=НомерОбращения;
					 
					 об.Записать();
				
				Иначе
					
					
					новаяЗапись=Справочники.ОбращенияВГАС.СоздатьЭлемент();
					новаяЗапись.КредитныйДоговор=КредитныйДоговор;
					новаяЗапись.СсылкаДокумент=СсылкаДокумент;
					
					новаяЗапись.Наименование=НомерОбращения;
					
					новаяЗапись.Записать();
					
					
				
				КонецЕсли;
				
				
				
	        
	

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	
	СписокПараметров = Новый Структура;
	
	СписокПараметров.Вставить("НомерОбращения", НомерОбращения);
	
	
	ОповеститьОВыборе(СписокПараметров);
	

КонецПроцедуры





























