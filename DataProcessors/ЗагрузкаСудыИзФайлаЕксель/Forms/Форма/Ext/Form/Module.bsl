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

	  
	  имяфайлатемп=дирМоиД+"\судадрес.txt";
	  имяэксел=ИмяФайла;
	  
	  
	  ФайлТемп = Новый ЗаписьТекста(имяфайлатемп);
	  
	  загНаимСуда="наименование судебного участка";
	  загАдресСуда="адрес судебного участка";
	  
      ФайлТемп.ЗаписатьСтроку(загНаимСуда);
      ФайлТемп.ЗаписатьСтроку(загАдресСуда);
	  ФайлТемп.ЗаписатьСтроку(ИмяФайла);
	  
      ФайлТемп.Закрыть();
	  
	  
	   программаОбр=дирМоиД+"\ExcelParse.exe 3";
	   
	   WshShell = Новый COMОбъект("WScript.Shell");

	    WshShell.Run(программаОбр,1, 1);

	   

	    //Сообщить(имяфайлатемп);
  
	   имяфайлатемпответ=дирМоиД+"\судадрес_out.txt";
	   
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
	   
	   
	    должДанныет=Новый Структура;
	   
	   Для каждого стрд  Из мСтрокФайла Цикл
		   
		      должДанныет=РазбитьСтроку(стрд);
			  
			  //Сообщить("фио: "-должДанныет.ФИО+"-номер: " + должДанныет.Номер+"-процент:"+должДанныет.ЦенаПокупки);
			  
			  Запись=ТЧ.Добавить();
			  Запись.Наименование=должДанныет.Наименование;
			  Запись.Адрес=должДанныет.Адрес;
			  
			  	   
	   КонецЦикла;
	   
	   
	   
	   
	  
	

	   
	   
	   
	   
	   
	   
	   
	
	
	
	
	
	Сообщить("Ок");
	
КонецПроцедуры

&НаКлиенте
Функция РазбитьСтроку(Стр)

	 должДанные=Новый Структура;

	 позфио=Найти(Стр,":");
	 
	 фиостр=Лев(Стр,позфио-1);
	 
	 должДанные.Вставить("Наименование",фиостр);
	 
	 
	 длинастр=СтрДлина(Стр);
	 
	 числспра=длинастр-позфио;
	 
	 
	 номерстрд=Прав(Стр,числспра);
	 
	 
	 
	 должДанные.Вставить("Адрес",номерстрд);
	 
	 
	 
	 
	 
	 Возврат   должДанные;
КонецФункции // ()

&НаКлиенте
Процедура Записать(Команда)
	// Вставить содержимое обработчика.
	
	
	
	 Для каждого стр  Из ТЧ Цикл
		  
		   //  Записать если такого нет
		 
	  	    ЗаписатьВБазу(стр.Наименование, стр.Адрес);

	  
	  КонецЦикла;

	
	
	
	
	Сообщить("Ок");
	
КонецПроцедуры


&НаСервере
Процедура ЗаписатьВБазу(наме, адрес)

	  спр=Справочники.Суды.НайтиПоНаименованию(наме);
	
	Если спр.Пустая() Тогда
		
		 справсуды = Справочники.Суды.СоздатьЭлемент();
		 
		 справсуды.Наименование = наме;
		 справсуды.Адрес=адрес;
		 
		 справсуды.Записать();
		
	
	КонецЕсли;  
	  
	
	

КонецПроцедуры





