﻿
&НаКлиенте
Процедура ДолжникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	
	
	  ОповещениеОЗакрытии=Новый ОписаниеОповещения("ДанныеДляПоиска",ЭтотОбъект);
	  
	  
	  
	  ОткрытьФорму("Справочник.Должники.Форма.ФормаВыбораРегион",,ЭтаФорма,,,,ОповещениеОЗакрытии,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	

	  
	  
	   
	
КонецПроцедуры


&НаКлиенте
Процедура ДанныеДляПоиска(РезультатЗакрытия,ДополнительныеПараметры) Экспорт

	 		 Если РезультатЗакрытия= Неопределено Тогда
		        Возврат;
		
		     Иначе
			  
				 Должник=РезультатЗакрытия.Наименование;
				 ДолжникВыбор=РезультатЗакрытия.Ссылка;
				 
				 
				 
			 КонецЕсли;

	
	
	
		 КонецПроцедуры

&НаКлиенте
Процедура Привязать(Команда)
	
	      ПривязатьНаСервере();
		  Сообщить("Ок");
			 
КонецПроцедуры


&НаСервере
Процедура ПривязатьНаСервере()
     
	  спрДоговор=КредитныйДоговор.ПолучитьОбъект();
	  
	  спрДоговор.Владелец=ДолжникВыбор;
	  
	  спрДоговор.Записать();
	
	

КонецПроцедуры

