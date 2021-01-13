﻿Процедура ЕстьЛиПривязкаПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	   спрСтатусОбещаниеОплатить=Справочники.Статусы.НайтиПоНаименованию("Обещание оплатить");
	   спрСтатусПрогноз=Справочники.Статусы.НайтиПоНаименованию("Прогноз");
	   спрСтатусОставленаИнформация=Справочники.Статусы.НайтиПоНаименованию("Оставлена информация");
	   спрСотрРезерв=Справочники.Сотрудники.НайтиПоНаименованию("РЕЗЕРВ",Истина);
	   спрСотрПуст=Справочники.Сотрудники.НайтиПоКоду("000000035");
		   
	   
	   
	   
	   Результат=Истина;
	   
	   Если (Контакт.Статус.Наименование=спрСтатусОбещаниеОплатить.Наименование) ИЛИ (Контакт.Статус.Наименование=спрСтатусПрогноз.Наименование) ИЛИ (Контакт.Статус.Наименование=спрСтатусОставленаИнформация.Наименование)   Тогда
		    
		   //  Проверить тек исполнитель - есть привязка
						   
						
						Запрос = Новый Запрос;
						Запрос.Текст = 
							"ВЫБРАТЬ
							|	ПривязкаСотрудникСрезПоследних.Должник КАК Должник,
							|	ПривязкаСотрудникСрезПоследних.Сотрудник КАК Сотрудник
							|ИЗ
							|	РегистрСведений.ПривязкаСотрудник.СрезПоследних(, Должник = &Должник) КАК ПривязкаСотрудникСрезПоследних";
						
						Запрос.УстановитьПараметр("Должник",Контакт.Должник);
						
						РезультатЗапроса = Запрос.Выполнить();
						
						ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
						
					
						кол=ВыборкаДетальныеЗаписи.Количество();
						
						Если кол=0 Тогда
						  // Создать документ Передача должника
						  
						       Результат=Ложь;
						
						КонецЕсли;
						
						Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
							Если ВыборкаДетальныеЗаписи.Сотрудник=спрСотрРезерв Тогда
							    Результат=Ложь;
							
							КонецЕсли;
							
								Если ВыборкаДетальныеЗаписи.Сотрудник=спрСотрПуст Тогда
							    Результат=Ложь;
							
							КонецЕсли;
						
							
							
						КонецЦикла;
						
	   
	   КонецЕсли;
	
	
КонецПроцедуры

Процедура СоздатьПривязкуПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	   спрОтдел=Справочники.Отделы.НайтиПоНаименованию("Call-центр",Истина);
	   спрСотрМенеджер=Справочники.Сотрудники.НайтиПоНаименованию("Марин_Евгений",Истина);
	   
	
	    массивСтр=ПолучитьДоговораДолжников(Контакт.Должник);
		
		НовыйДокумент = Документы.ПередачаДолжников.СоздатьДокумент();
		НовыйДокумент.Отдел=спрОтдел;
		НовыйДокумент.Дата=ТекущаяДата();
		НовыйДокумент.Сотрудник=Контакт.Сотрудник;
		НовыйДокумент.Менеджер=спрСотрМенеджер;
		НовыйДокумент.Автор=спрСотрМенеджер;
		НовыйДокумент.Комментарий="Создан из Контакта - БП";
		НовыйДокумент.Подписан=Истина;
		
		
		Для каждого стр  Из массивСтр Цикл
		
			 новЗапись= НовыйДокумент.Должники.Добавить();
			 новЗапись.Должник=Контакт.Должник;
			 новЗапись.Договор=стр;
		
		КонецЦикла;
		
	    		
		НовыйДокумент.Записать(РежимЗаписиДокумента.Проведение);
		
		
	
	
КонецПроцедуры


&НаСервере
Функция ПолучитьДоговораДолжников(долж)
	
	 массивСтр=Новый Массив;
	
	   
	   
	    			Запрос = Новый Запрос;
					Запрос.Текст = 
						"ВЫБРАТЬ
						|	Договоры.Ссылка КАК Ссылка
						|ИЗ
						|	Справочник.Договоры КАК Договоры
						|ГДЕ
						|	Договоры.Владелец = &Владелец";
					
					Запрос.УстановитьПараметр("Владелец", долж);
					
					РезультатЗапроса = Запрос.Выполнить();
					
					ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
					
					Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
						  
						  массивСтр.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
						   
			            			
						
					КонецЦикла;
					
	Возврат массивСтр;				
					
	

КонецФункции // ()



