﻿
Процедура ВыборВариантаЮридическаяСтадияОбработкаВыбораВарианта(ТочкаВыбораВарианта, Результат)
	
	спрОтделСудебнаяСтадия=Справочники.Отделы.НайтиПоНаименованию("Судебная стадия",Истина);
	спрОтделИсполнительноеПроизводство=Справочники.Отделы.НайтиПоНаименованию("Исполнительное производство",Истина);
	спрОтделБАНКРОТСТВО=Справочники.Отделы.НайтиПоНаименованию("БАНКРОТСТВО",Истина);
	спрОтделУмершие=Справочники.Отделы.НайтиПоНаименованию("Умершие",Истина);
	спрОтделЗапросГосударственныхОрганов=Справочники.Отделы.НайтиПоНаименованию("Запрос государственных органов/физических лиц",Истина);
    спрОтделПретензионнаяРабота=Справочники.Отделы.НайтиПоНаименованию("Претензионная Работа",Истина);

	
	
	
	Если ОтделРабота=спрОтделСудебнаяСтадия  Тогда
	    Результат=ТочкаВыбораВарианта.Варианты.СудебнаяСтадия;	
	  
	КонецЕсли;
	
	Если ОтделРабота=спрОтделИсполнительноеПроизводство  Тогда
	    Результат=ТочкаВыбораВарианта.Варианты.ИсполнительноеПроизводство;	
	КонецЕсли;

	  
	
	Если ОтделРабота=спрОтделБАНКРОТСТВО  Тогда
	    Результат=ТочкаВыбораВарианта.Варианты.Банкротство;	
	КонецЕсли;

	
	Если ОтделРабота=спрОтделУмершие  Тогда
	    Результат=ТочкаВыбораВарианта.Варианты.Умершие;	
	КонецЕсли;

	
	Если ОтделРабота=спрОтделЗапросГосударственныхОрганов  Тогда
	    Результат=ТочкаВыбораВарианта.Варианты.ЗапросГосударственныхОргановФизическихЛиц;	
	КонецЕсли;

	
	Если ОтделРабота=спрОтделПретензионнаяРабота  Тогда
	    Результат=ТочкаВыбораВарианта.Варианты.ПретензионнаяРабота;	
	КонецЕсли;

	
	
КонецПроцедуры

Процедура ОтделСудебнаяСтадияПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	
	 	     СтандартнаяОбработка=Ложь;
	  		 Задача=Задачи.ЗадачаПривязкаДолжника.СоздатьЗадачу();
			 Задача.БизнесПроцесс=Ссылка;
			 Задача.ТочкаМаршрута=ТочкаМаршрутаБизнесПроцесса;
			 Задача.Дата=ТекущаяДата();
			 Задача.Наименование="БП_Судебная стадия_"+Должник+"_"+Номер;
			 Задача.Отдел=ОтделРабота;
	
	         Задача.Записать();
	         ФормируемыеЗадачи.Добавить(Задача);
			 
			 
	
КонецПроцедуры






Процедура ПроверкаКонтрольнойДатыПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	   //  сформирую задачу автоматом в Контрольнйю дату не забыть проверить эту дату при записи
	   
	   
	         СтандартнаяОбработка=Ложь;
	  		 Задача=Задачи.ЗадачаПривязкаДолжника.СоздатьЗадачу();
			 Задача.БизнесПроцесс=Ссылка;
			 Задача.ТочкаМаршрута=ТочкаМаршрутаБизнесПроцесса;
			 Задача.Дата=ТекущаяДата();
			 Задача.Наименование="БП_Судебная стадия_55555"+Должник+"_"+Номер;
			 Задача.Отдел=ОтделРабота;
			 Задача.КонтрольнаяДата=Ссылка.ДатаЗавершения;
	         Задача.Записать();
	         ФормируемыеЗадачи.Добавить(Задача);
			 
          	
	
КонецПроцедуры

Процедура ПроверкаКонтрольнойДатыПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	// Пошлю напоминание
	
	
	              
	
	//
	//            СрокНапоминания = НачалоДня(ТекущаяДата());
	//		    НапоминаниеТекст = "Выполнить задание  ----- ";
	//		    ПараметрыНапоминания    = Новый Структура;   
	//		    ПараметрыНапоминания.Вставить("Пользователь",спрПользователь);
	//			ПараметрыНапоминания.Вставить("ВремяСобытия"    , ТекущаяДата());
	//			ПараметрыНапоминания.Вставить("Источник"        , Ссылка);
	//			ПараметрыНапоминания.Вставить("Описание"        , НапоминаниеТекст);
	//			ПараметрыНапоминания.Вставить("СрокНапоминания", СрокНапоминания);
	//			ПараметрыНапоминания.Вставить("СпособУстановкиВремениНапоминания", Перечисления.СпособыУстановкиВремениНапоминания.Периодически);
	//			НапоминанияПользователяСлужебный.ПодключитьНапоминание(ПараметрыНапоминания);
	//			

	
	
	
	
КонецПроцедуры

Процедура РешениеПоДокументуПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	
	         СтандартнаяОбработка=Ложь;
	  		 Задача=Задачи.ЗадачаПривязкаДолжника.СоздатьЗадачу();
			 Задача.БизнесПроцесс=Ссылка;
			 Задача.ТочкаМаршрута=ТочкаМаршрутаБизнесПроцесса;
			 Задача.Дата=ТекущаяДата();
			 Задача.Наименование="БП_Судебная стадия_7777_"+Должник+"_"+Номер;
			 Задача.Отдел=ОтделРабота;
			 Задача.КонтрольнаяДата=Ссылка.ДатаЗавершения;
	         Задача.Записать();
	         ФормируемыеЗадачи.Добавить(Задача);

			 
			 //ОткрытьФорму(
	
	
КонецПроцедуры

Процедура ИсполнительноеПроизводствоПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	  	     СтандартнаяОбработка=Ложь;
	  		 Задача=Задачи.ЗадачаПривязкаДолжника.СоздатьЗадачу();
			 Задача.БизнесПроцесс=Ссылка;
			 Задача.ТочкаМаршрута=ТочкаМаршрутаБизнесПроцесса;
			 Задача.Дата=ТекущаяДата();
			 Задача.Наименование="БП_Исполнительное производство_"+Должник+"_"+Номер;
			 Задача.Отдел=ОтделРабота;
	
	         Задача.Записать();
	         ФормируемыеЗадачи.Добавить(Задача);
			 

		
			 
	
	
КонецПроцедуры

Процедура БанкротствоПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	         СтандартнаяОбработка=Ложь;
	  		 Задача=Задачи.ЗадачаПривязкаДолжника.СоздатьЗадачу();
			 Задача.БизнесПроцесс=Ссылка;
			 Задача.ТочкаМаршрута=ТочкаМаршрутаБизнесПроцесса;
			 Задача.Дата=ТекущаяДата();
			 Задача.Наименование="БП_Банкротство_"+Должник+"_"+Номер;
			 Задача.Отдел=ОтделРабота;
	         Задача.Записать();
	         ФормируемыеЗадачи.Добавить(Задача);
	
КонецПроцедуры

Процедура УмершиеПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	         СтандартнаяОбработка=Ложь;
	  		 Задача=Задачи.ЗадачаПривязкаДолжника.СоздатьЗадачу();
			 Задача.БизнесПроцесс=Ссылка;
			 Задача.ТочкаМаршрута=ТочкаМаршрутаБизнесПроцесса;
			 Задача.Дата=ТекущаяДата();
			 Задача.Наименование="БП_Умершие_"+Должник+"_"+Номер;
			 Задача.Отдел=ОтделРабота;
	         Задача.Записать();
	         ФормируемыеЗадачи.Добавить(Задача);           
	
	
	
КонецПроцедуры

Процедура ЗапросГосударственныхОргановПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
   	         СтандартнаяОбработка=Ложь;
	  		 Задача=Задачи.ЗадачаПривязкаДолжника.СоздатьЗадачу();
			 Задача.БизнесПроцесс=Ссылка;
			 Задача.ТочкаМаршрута=ТочкаМаршрутаБизнесПроцесса;
			 Задача.Дата=ТекущаяДата();
			 Задача.Наименование="БП_Запрос государственных органов_"+Должник+"_"+Номер;
			 Задача.Отдел=ОтделРабота;
	         Задача.Записать();
	         ФормируемыеЗадачи.Добавить(Задача);           
	
	
КонецПроцедуры

Процедура ПретензионнаяРаботаПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	     
	          СтандартнаяОбработка=Ложь;
	  		 Задача=Задачи.ЗадачаПривязкаДолжника.СоздатьЗадачу();
			 Задача.БизнесПроцесс=Ссылка;
			 Задача.ТочкаМаршрута=ТочкаМаршрутаБизнесПроцесса;
			 Задача.Дата=ТекущаяДата();
			 Задача.Наименование="БП_Претензионная работа_"+Должник+"_"+Номер;
			 Задача.Отдел=ОтделРабота;
	         Задача.Записать();
	         ФормируемыеЗадачи.Добавить(Задача);           
	

	
	
	
КонецПроцедуры










  
