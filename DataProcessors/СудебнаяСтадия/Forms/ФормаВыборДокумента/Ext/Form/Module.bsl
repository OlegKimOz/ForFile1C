﻿&НаКлиенте
Процедура Создать(Команда)
	
	  Оповещение = Новый ОписаниеОповещения("Завершение", ЭтотОбъект); 
	
	 Если  РасширениеНазвания="о процессуальном правопреемстве" Тогда
	     
	       
	       
	       данныеСтруктура=Новый Структура;
		   данныеСтруктура.Вставить("ДоговорСтр",СсылкаДоговор);
		   данныеСтруктура.Вставить("ДолжникФИО",СсылкаДолжникФИО);
		   
		   данныеСтруктура.Вставить("ДатаРожденияДолжника",ДатаРожденияДолжника);
		   
		   данныеСтруктура.Вставить("АдресРегистрацииДолжника",АдресРегистрацииДолжника);
		   
		   данныеСтруктура.Вставить("ПаспортныеДанныеДолжника",ПаспортныеДанныеДолжника);
		   
		    данныеСтруктура.Вставить("ПаспортКемВыдан",ПаспортКемВыдан);
		   
		     данныеСтруктура.Вставить("ПаспортныеДанныеДолжникаДатаВыдачи",ПаспортДатаВыдачи);

		   
		   
		   
		   данныеСтруктура.Вставить("МестоРожденияДолжника",МестоРожденияДолжника);
		   данныеСтруктура.Вставить("НаименованиеПервоначальногоКредитора",НаименованиеПервоначальногоКредитора);
		   данныеСтруктура.Вставить("НомерДоговораЦессии",НомерДоговораЦессии);
		   
		   данныеСтруктура.Вставить("ДатаДоговораЦессии",ДатаДоговораЦессии);
		   
		   данныеСтруктура.Вставить("НомерКредитногоДоговора",НомерКредитногоДоговора);
		   
		   данныеСтруктура.Вставить("ДатаКредитногоДоговора",ДатаКредитногоДоговора);
		   
		   данныеСтруктура.Вставить("НазваниеСуда",НазваниеСуда);
		   
		   данныеСтруктура.Вставить("АдресСудаВкладка",АдресСудаВкладка);
		   
		   данныеСтруктура.Вставить("Исполнитель",Исполнитель);
		   
		   данныеСтруктура.Вставить("НомерСудебногоДела",НомерСудебногоДела); 
		   данныеСтруктура.Вставить("ДатаСудебногоДела",ДатаСудебногоДела); 
		   
		   
		   данныеСтруктура.Вставить("ПервоначальныйНомерКредитДоговора",ПервоначальныйНомерКредитДоговора); 
		   
		   
		   
		   
			   
	       
	 	   ОткрытьФорму("Справочник.ЗаявлениеОПроцессуальномПравопреемстве.Форма.ФормаЭлемента",данныеСтруктура,,,,,Оповещение);

	 
	   КонецЕсли;
	   
	   
	   Если РасширениеНазвания="о выдаче судебного приказа"  Тогда
		   
              данныеСтруктура=Новый Структура;
		   данныеСтруктура.Вставить("ДоговорСтр",СсылкаДоговор);
		   данныеСтруктура.Вставить("ДолжникФИО",СсылкаДолжникФИО);
		   
		   данныеСтруктура.Вставить("ДатаРожденияДолжника",ДатаРожденияДолжника);
		   
		   данныеСтруктура.Вставить("АдресРегистрацииДолжника",АдресРегистрацииДолжника);
		   
		   данныеСтруктура.Вставить("ПаспортныеДанныеДолжника",ПаспортныеДанныеДолжника);
		   данныеСтруктура.Вставить("ПаспортКемВыдан",ПаспортКемВыдан);
		   
		     данныеСтруктура.Вставить("ПаспортныеДанныеДолжникаДатаВыдачи",ПаспортДатаВыдачи);

		   
		   данныеСтруктура.Вставить("МестоРожденияДолжника",МестоРожденияДолжника);
		   данныеСтруктура.Вставить("НаименованиеПервоначальногоКредитора",НаименованиеПервоначальногоКредитора);
		   данныеСтруктура.Вставить("НомерДоговораЦессии",НомерДоговораЦессии);
		   
		   данныеСтруктура.Вставить("ДатаДоговораЦессии",ДатаДоговораЦессии);
		   
		   данныеСтруктура.Вставить("НомерКредитногоДоговора",НомерКредитногоДоговора);
		   
		   данныеСтруктура.Вставить("ДатаКредитногоДоговора",ДатаКредитногоДоговора);
		   
		   данныеСтруктура.Вставить("НазваниеСуда",НазваниеСуда);
		   
		   данныеСтруктура.Вставить("АдресСудаВкладка",АдресСудаВкладка);
		   
		   данныеСтруктура.Вставить("Исполнитель",Исполнитель);
		   
           данныеСтруктура.Вставить("СуммаКредита",СуммаКредита); 
		   
		   данныеСтруктура.Вставить("НомерСудебногоДела",НомерСудебногоДела); 
		   данныеСтруктура.Вставить("ДатаСудебногоДела",ДатаСудебногоДела); 
		   
		   
		   данныеСтруктура.Вставить("ПервоначальныйНомерКредитДоговора",ПервоначальныйНомерКредитДоговора); 
		   данныеСтруктура.Вставить("ПервоначальныйКредитор0",ПервоначальныйКредитор0); 
		   
		   
		   
		   ОткрытьФорму("Справочник.ЗаявлениеОВыдачеСудебногоПриказа.Форма.ФормаЭлемента",данныеСтруктура,,,,,Оповещение);
	   	
	   
	   КонецЕсли;
	   
	   
	 
	
КонецПроцедуры


&НаКлиенте
Процедура Завершение(ЗавершениеЗакрыть, Параметры) Экспорт

	
  	
   ЭтаФорма.Закрыть();
  
  
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	  СсылкаДоговор= Параметры.ДоговорСсылка;
	  СсылкаДолжникФИО=Параметры.ДолжникФИО;
	  ДатаРожденияДолжника=Параметры.ДолжникДатаРожд;
	  АдресРегистрацииДолжника=Параметры.ДолжникАдоес;
	  ПаспортныеДанныеДолжника=Параметры.ДолжникПаспорт;
	  ПаспортДатаВыдачи=Параметры.ДолжникПаспортДатаВыдачи;
	  ПаспортКемВыдан=Параметры.ПаспортКемВыдан;
	  
	  МестоРожденияДолжника=Параметры.ДолжникМестоРождения;
	  НаименованиеПервоначальногоКредитора= Параметры.Кредитор;
	  НомерДоговораЦессии=Параметры.НомерДоговораЦессии;
	  ДатаДоговораЦессии=Параметры.ДатаЦессии;
	  
	  НомерКредитногоДоговора=Параметры.НомерКредитногоДоговора;
	  
	  ДатаКредитногоДоговора=Параметры.ДатаКредитногоДоговора;
	  
	  НазваниеСуда=Параметры.НазваниеСуда;
	  АдресСудаВкладка=Параметры.АдресСудаВкладка;
	  Исполнитель=Параметры.Исполнитель;
	  
	  СуммаКредита=Параметры.СуммаКредита;
	  
	  
	  НомерСудебногоДела=Параметры.НомерСудебногоДела;
	  
	  ДатаСудебногоДела=Параметры.ДатаСудебногоДела;
	  
	  
	  ПервоначальныйКредитор0=Параметры.ПервоначальныйКредитор0;
	  
	  ПервоначальныйНомерКредитДоговора=Параметры.ПервоначальныйНомерКредитДоговора;
	  
	  
	  
	  
	  
	
	
КонецПроцедуры

&НаКлиенте
Процедура НазваниеДокументаПриИзменении(Элемент)
	
	 Если НазваниеДокумента="ЗАЯВЛЕНИЕ"  Тогда
		 Элементы.РасширениеНазвания.СписокВыбора.Очистить();
		 Элементы.РасширениеНазвания.СписокВыбора.Вставить(0,"о процессуальном правопреемстве");
		 Элементы.РасширениеНазвания.СписокВыбора.Вставить(1,"о выдаче судебного приказа");
		 Элементы.РасширениеНазвания.СписокВыбора.Вставить(2,"о предоставлении копии судебного акта");
		 
		 Элементы.РасширениеНазвания.СписокВыбора.Вставить(3,"в суд о возврате госпошлины");
		 Элементы.РасширениеНазвания.СписокВыбора.Вставить(4,"в УФНС о возврате госпошлины");
		 Элементы.РасширениеНазвания.СписокВыбора.Вставить(5,"об оставлении предмета залога за собой");
		 Элементы.РасширениеНазвания.СписокВыбора.Вставить(6,"о выдаче исполнительного листа");
	 
	 КонецЕсли;
	 
	 Если НазваниеДокумента="ЖАЛОБА"  Тогда
		 
		 
		 Элементы.РасширениеНазвания.СписокВыбора.Очистить();
		 Элементы.РасширениеНазвания.СписокВыбора.Вставить(0,"частная");
		 Элементы.РасширениеНазвания.СписокВыбора.Вставить(1,"апелляционная");
		 Элементы.РасширениеНазвания.СписокВыбора.Вставить(2,"кассационная");
		 
		 //Элементы.РасширениеНазвания.СписокВыбора.Вставить(3,"в суд о возврате госпошлины");
	 КонецЕсли;
	 
	 
	  Если НазваниеДокумента="ОТВЕТ"  Тогда
		 
		 
		 Элементы.РасширениеНазвания.СписокВыбора.Очистить();
		 Элементы.РасширениеНазвания.СписокВыбора.Вставить(0,"на запрос суда");
		 Элементы.РасширениеНазвания.СписокВыбора.Вставить(1,"на определение об оставлении заявления/иска без движения ");
		
	 КонецЕсли;

	 
	  Если НазваниеДокумента="ВОЗРАЖЕНИЕ"  Тогда
		 
		 
		 Элементы.РасширениеНазвания.СписокВыбора.Очистить();
		 Элементы.РасширениеНазвания.СписокВыбора.Вставить(0,"на частную жалобу");
		 Элементы.РасширениеНазвания.СписокВыбора.Вставить(1,"на кассационную жалобу");
		 Элементы.РасширениеНазвания.СписокВыбора.Вставить(2,"на отзыв финансового уполномоченного");
		 
		
	 КонецЕсли;

	 
	 
	 
	 
	 
	 
	 
	 
	 
КонецПроцедуры
