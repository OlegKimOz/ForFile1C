﻿
&НаКлиенте
Процедура ВыбратьФайлУчрДок(Команда)
	   имяКоманды=Команда.Имя;
	   ЗавершениеОбратныйВызов=Новый ОписаниеОповещения("ЗавершениеОбратныйВызов",ЭтотОбъект,имяКоманды);
	   ПрогрессОбратныйВызов=Новый ОписаниеОповещения("ПрогрессОбратныйВызов",ЭтотОбъект);
	   ПередНачаломОбратныйВызов=Новый ОписаниеОповещения("ПередНачаломОбратныйВызов",ЭтотОбъект);
	   
	   ПараметрыДиалога=Новый ПараметрыДиалогаПомещенияФайлов;
	   
	   ПараметрыДиалога.Фильтр="Все файлы|*.*";
	   
	   НачатьПомещениеФайлаНаСервер(ЗавершениеОбратныйВызов, ПрогрессОбратныйВызов,ПередНачаломОбратныйВызов,,ПараметрыДиалога);
	
	
КонецПроцедуры



&НаКлиенте
Процедура ПередНачаломОбратныйВызов(ПомещаемыйФайл,ОтказОтПомещенияФайла,ДополнительныеПараметры)  Экспорт
	
	   
	   	          ПоказатьОповещениеПользователя("Загрузка файла",,"Начинается загрузка файла "+ПомещаемыйФайл.Имя+" :"+ПомещаемыйФайл.Размер()); 
	
	

КонецПроцедуры


&НаКлиенте
Процедура ЗавершениеОбратныйВызов(ОписаниеПеремещенногоФайла,ДополнительныеПараметры)  Экспорт
	
	
	
	Если ОписаниеПеремещенногоФайла.ПомещениеФайлаОтменено  Тогда
	     Возврат;
		
	
	КонецЕсли;
	
	    Модифицированность=Истина;

		
		Если  ДополнительныеПараметры="ВыбратьФайлУчрДок" Тогда
		
			    новаяСтр=Объект.УчредительныеДокументы.Добавить();
		
				новаяСтр.ИмяФайла=ОписаниеПеремещенногоФайла.СсылкаНаФайл.Файл.ИмяБезРасширения;
				новаяСтр.ТипФайла= ОписаниеПеремещенногоФайла.СсылкаНаФайл.Файл.Расширение;
				новаяСтр.АдресФайла=ОписаниеПеремещенногоФайла.Адрес;

		
		КонецЕсли;
	 
	 
	 Если ДополнительныеПараметры="ВыбратьФайлСвидетельствоОРегистрации" Тогда
	     
	     новаяСтр=Объект.СвидетельствоОРегистрацииЮрЛица.Добавить();
	    
	    новаяСтр.ИмяФайла=ОписаниеПеремещенногоФайла.СсылкаНаФайл.Файл.ИмяБезРасширения;
	    новаяСтр.ТипФайла= ОписаниеПеремещенногоФайла.СсылкаНаФайл.Файл.Расширение;
	    новаяСтр.АдресФайла=ОписаниеПеремещенногоФайла.Адрес;
	

	 	
	 
	 КонецЕсли;
	 
	 
	 
	 Если ДополнительныеПараметры="ВыбратьФайлДоверенностьПред" Тогда
		 
		  Если  Объект.ДоверенностьПредставителя.Количество()>0 Тогда
			  
			      
					 Если ДоверенностьПредДобавить Тогда
					 
					 	    новаяСтр=Объект.ДоверенностьПредставителя.Добавить();
		                    новаяСтр.ИмяФайла=ОписаниеПеремещенногоФайла.СсылкаНаФайл.Файл.ИмяБезРасширения;
					        новаяСтр.ТипФайла= ОписаниеПеремещенногоФайла.СсылкаНаФайл.Файл.Расширение;
					        новаяСтр.АдресФайла=ОписаниеПеремещенногоФайла.Адрес;

								 
					 Иначе
					 
					 	    стрТек= Элементы.ДоверенностьПредставителя.ТекущиеДанные;
							стрТек.ИмяФайла=ОписаниеПеремещенногоФайла.СсылкаНаФайл.Файл.ИмяБезРасширения;
							стрТек.ТипФайла= ОписаниеПеремещенногоФайла.СсылкаНаФайл.Файл.Расширение;
							стрТек.АдресФайла=ОписаниеПеремещенногоФайла.Адрес;

					 
					 КонецЕсли; 
					 
					 
					 
			  
				//стрТек= Элементы.ДоверенностьПредставителя.ТекущиеДанные;
				//стрТек.ИмяФайла=ОписаниеПеремещенногоФайла.СсылкаНаФайл.Файл.ИмяБезРасширения;
				//стрТек.ТипФайла= ОписаниеПеремещенногоФайла.СсылкаНаФайл.Файл.Расширение;
				//стрТек.АдресФайла=ОписаниеПеремещенногоФайла.Адрес;

			  
			  
		  Иначе	   
			  
			  
			    новаяСтр=Объект.ДоверенностьПредставителя.Добавить();
		    
		        новаяСтр.ИмяФайла=ОписаниеПеремещенногоФайла.СсылкаНаФайл.Файл.ИмяБезРасширения;
		        новаяСтр.ТипФайла= ОписаниеПеремещенногоФайла.СсылкаНаФайл.Файл.Расширение;
		        новаяСтр.АдресФайла=ОписаниеПеремещенногоФайла.Адрес;

		  
		  КонецЕсли;
		 
		   
		  		

		
	 	
	 
	 КонецЕсли;
	 
	  Если ДополнительныеПараметры="ВыбратьФайлПодписьПредставителя" Тогда
		  
		  Если Объект.ПодписьПредставителя.Количество()>0  Тогда
		  
			  
			       Если ПодписьПредставителяДобавить Тогда
				   
					     новаяСтр=Объект.ПодписьПредставителя.Добавить();
			             новаяСтр.ИмяФайла=ОписаниеПеремещенногоФайла.СсылкаНаФайл.Файл.ИмяБезРасширения;
					     новаяСтр.ТипФайла= ОписаниеПеремещенногоФайла.СсылкаНаФайл.Файл.Расширение;
					     новаяСтр.АдресФайла=ОписаниеПеремещенногоФайла.Адрес;
					   
				   
				   Иначе
				         стрТек= Элементы.ПодписьПредставителя.ТекущиеДанные;
					     стрТек.ИмяФайла=ОписаниеПеремещенногоФайла.СсылкаНаФайл.Файл.ИмяБезРасширения;
					     стрТек.ТипФайла= ОписаниеПеремещенногоФайла.СсылкаНаФайл.Файл.Расширение;
						 стрТек.АдресФайла=ОписаниеПеремещенногоФайла.Адрес;
				   
				   КонецЕсли;
			    
			  
			  
		  
		  Иначе
			  
			  
			    новаяСтр=Объект.ПодписьПредставителя.Добавить();
			    новаяСтр.ИмяФайла=ОписаниеПеремещенногоФайла.СсылкаНаФайл.Файл.ИмяБезРасширения;
			    новаяСтр.ТипФайла= ОписаниеПеремещенногоФайла.СсылкаНаФайл.Файл.Расширение;
			    новаяСтр.АдресФайла=ОписаниеПеремещенногоФайла.Адрес;

			  
		  	
		  
		  КонецЕсли;
		  
		  
		  
	   		
		
	 КонецЕсли;

	 
	 
		 
		
КонецПроцедуры


&НаКлиенте
Процедура ПослеОтветаНаВопросФайлДоверенностьПред(Результат, Параметры) Экспорт 
          
	   Если Результат = КодВозвратаДиалога.Да Тогда

		   ДоверенностьПредДобавить=Истина;
		    		   
		   
		       имяКоманды=Параметры.КомандаИмя;
			   ЗавершениеОбратныйВызов=Новый ОписаниеОповещения("ЗавершениеОбратныйВызов",ЭтотОбъект,имяКоманды);
			   ПрогрессОбратныйВызов=Новый ОписаниеОповещения("ПрогрессОбратныйВызов",ЭтотОбъект);
			   ПередНачаломОбратныйВызов=Новый ОписаниеОповещения("ПередНачаломОбратныйВызов",ЭтотОбъект);
			   
			   ПараметрыДиалога=Новый ПараметрыДиалогаПомещенияФайлов;
			   
			   ПараметрыДиалога.Фильтр="Все файлы|*.*";
			   
			   
			    НачатьПомещениеФайлаНаСервер(ЗавершениеОбратныйВызов, ПрогрессОбратныйВызов,ПередНачаломОбратныйВызов,,ПараметрыДиалога);

		   
		   

		Иначе

		      ДоверенностьПредДобавить=Ложь;

			   имяКоманды=Параметры.КомандаИмя;
			   ЗавершениеОбратныйВызов=Новый ОписаниеОповещения("ЗавершениеОбратныйВызов",ЭтотОбъект,имяКоманды);
			   ПрогрессОбратныйВызов=Новый ОписаниеОповещения("ПрогрессОбратныйВызов",ЭтотОбъект);
			   ПередНачаломОбратныйВызов=Новый ОписаниеОповещения("ПередНачаломОбратныйВызов",ЭтотОбъект);
			   
			   ПараметрыДиалога=Новый ПараметрыДиалогаПомещенияФайлов;
			   
			   ПараметрыДиалога.Фильтр="Все файлы|*.*";
			   
			   
			    НачатьПомещениеФайлаНаСервер(ЗавершениеОбратныйВызов, ПрогрессОбратныйВызов,ПередНачаломОбратныйВызов,,ПараметрыДиалога);

			  
			   
			  
		КонецЕсли;
       
	
	
	
КонецПроцедуры


	
	
&НаСервере
Функция ПроверитьСуществуетФайл(адрес)

	естьФайл=Ложь;
	данныеФ=Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(адрес));
    Если данныеФ.Получить()<>Неопределено Тогда
	
	   естьФайл=Истина;	
	
	КонецЕсли;
	
	
	Возврат данныеФ;
	
	

КонецФункции // ()






&НаКлиенте
Процедура ПрогрессОбратныйВызов(ПомещаемыйФайл,Помещено,ОтказОтПомещенияФайла,ДополнительныеПараметры)  Экспорт

	         Состояние("Загрузка файла "+ ПомещаемыйФайл.Имя,Помещено);
		   
	   
КонецПроцедуры


   

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	 ОбЪект.Наименование="Документы Форвард -"+Формат(ТекущаяДата(),"ДЛФ=DD");
	
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	   	   Для каждого  стр Из  ТекущийОбъект.УчредительныеДокументы Цикл
		     		   
				Если ЭтоАдресВременногоХранилища(стр.АдресФайла) И НЕ(стр.Записан) Тогда
					
				   данныеФ=Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(стр.АдресФайла));
						 
					Если данныеФ.Получить()<>Неопределено Тогда
					
				       стр.ДанныеФайла=данныеФ;
			 	       УдалитьИзВременногоХранилища(стр.АдресФайла);
					   стр.Записан=Истина;
				
					КонецЕсли;
				КонецЕсли;

			
		   КонецЦикла;
		   
		   
		    Для каждого  стр Из  ТекущийОбъект.СвидетельствоОРегистрацииЮрЛица Цикл
		     		   
		    	Если ЭтоАдресВременногоХранилища(стр.АдресФайла) И НЕ(стр.Записан) Тогда
		    		
		    	   данныеФ=Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(стр.АдресФайла));
		    			 
		    		Если данныеФ.Получить()<>Неопределено Тогда
		    		
		    	       стр.ДанныеФайла=данныеФ;
		     	       УдалитьИзВременногоХранилища(стр.АдресФайла);
		    		   стр.Записан=Истина;
		    	
		    		КонецЕсли;
		    	КонецЕсли;

		   КонецЦикла;
		   

		   
		    Для каждого  стр Из  ТекущийОбъект.ДоверенностьПредставителя Цикл
		     		   
		    	Если ЭтоАдресВременногоХранилища(стр.АдресФайла) И НЕ(стр.Записан) Тогда
		    		
		    	   данныеФ=Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(стр.АдресФайла));
		    			 
		    		Если данныеФ.Получить()<>Неопределено Тогда
		    		
		    	       стр.ДанныеФайла=данныеФ;
		     	       УдалитьИзВременногоХранилища(стр.АдресФайла);
		    		   стр.Записан=Истина;
		    	
		    		КонецЕсли;
		    	КонецЕсли;

		   КонецЦикла;
		   

		   
		    Для каждого  стр Из  ТекущийОбъект.ПодписьПредставителя Цикл
		     		   
		    	Если ЭтоАдресВременногоХранилища(стр.АдресФайла) И НЕ(стр.Записан) Тогда
		    		
		    	   данныеФ=Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(стр.АдресФайла));
		    			 
		    		Если данныеФ.Получить()<>Неопределено Тогда
		    		
		    	       стр.ДанныеФайла=данныеФ;
		     	       УдалитьИзВременногоХранилища(стр.АдресФайла);
		    		   стр.Записан=Истина;
		    	
		    		КонецЕсли;
		    	КонецЕсли;

		   КонецЦикла;
		   
	             

	
	
	
КонецПроцедуры





&НаСервере
Функция УчредительныеДокументыВыборНаСервере(ВыбраннаяСтрока, имяТаблицы)
	
	
	значХран=Неопределено;
	 ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	 
	 Если имяТаблицы="УчредительныеДокументы"  Тогда
	 
	 	     выбрСтрока= ТекущийОбъект.УчредительныеДокументы[ВыбраннаяСтрока];

	 
	 КонецЕсли;
		 
	 Если имяТаблицы="СвидетельствоОРегистрацииЮрЛица"  Тогда
	 
	 	     выбрСтрока= ТекущийОбъект.СвидетельствоОРегистрацииЮрЛица[ВыбраннаяСтрока];

	 
	 КонецЕсли;
		 
	 
	 
	  Если имяТаблицы="ДоверенностьПредставителя"  Тогда
	 
	 	     выбрСтрока= ТекущийОбъект.ДоверенностьПредставителя[ВыбраннаяСтрока];

	 
	 КонецЕсли;

	 
     Если имяТаблицы="ПодписьПредставителя"  Тогда
	 
	 	     выбрСтрока= ТекущийОбъект.ПодписьПредставителя[ВыбраннаяСтрока];

	 
	 КонецЕсли;
	 
	 
	 
	
	 
	 
	 Если выбрСтрока.ДанныеФайла<>Неопределено  Тогда
		 
		  значХран=выбрСтрока.ДанныеФайла.Получить();
	 	
	 
	 КонецЕсли; 
	 
	 
	 
	 
	 
	 
	Возврат значХран; 

	 
	
КонецФункции // ()	

&НаКлиенте
Процедура УчредительныеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	
	   имяТаблицы= Элемент.Имя;
	   значХран= УчредительныеДокументыВыборНаСервере(ВыбраннаяСтрока, имяТаблицы);
	   ИмяКаталогаВрФ="";
	   
	   Если значХран<>Неопределено Тогда
		   
   		       имяФ=Элемент.ТекущиеДанные.ИмяФайла;
			   расш=Элемент.ТекущиеДанные.ТипФайла;
			   
			   //Каталог = КаталогВременныхФайлов();
			   ИмяФайла = имяФ + "."+расш;
			   
			   
			   ИмяПромежуточногоФайла = ПолучитьИмяВременногоФайла(расш);
			   
			   ОбратныйВызов = Новый ОписаниеОповещения("ПолучитьКаталогВременныхФайловЗавершение", ЭтотОбъект);
			   НачатьПолучениеКаталогаВременныхФайлов(ОбратныйВызов);
			   
			   //Если ИмяКаталогаВрФ<>"" Тогда
			   //    
					  //ИмяФайла=ИмяКаталогаВрФ +имяФ + "."+расш;
					  ИмяФайла=имяФ + "."+расш;

				   
			   	      Адрес= ПоместитьВоВременноеХранилище(значХран);
					  
					    ПараметрыДиалога = Новый ПараметрыДиалогаПолученияФайлов;
						ПараметрыДиалога.ВыборКаталога=Истина;
			            ПараметрыДиалога.Заголовок = "НачатьПомещениеФайлаССервер";
						
					  
					    НачатьПолучениеФайлаССервера(Адрес,ИмяФайла,ПараметрыДиалога);
		   
			   
		
		   
	   
	   КонецЕсли;

	
	
	
КонецПроцедуры
	

&НаКлиенте
Процедура ПолучитьКаталогВременныхФайловЗавершение(ИмяКаталогаВременныхФайлов, ДополнительныеПараметры) Экспорт
	
	ИмяКаталогаВрФ=ИмяКаталогаВременныхФайлов;
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлСвидетельствоОРегистрации(Команда)
	
	   имяКоманды=Команда.Имя;
	  
	
	   ЗавершениеОбратныйВызов=Новый ОписаниеОповещения("ЗавершениеОбратныйВызов",ЭтотОбъект,имяКоманды);
	   ПрогрессОбратныйВызов=Новый ОписаниеОповещения("ПрогрессОбратныйВызов",ЭтотОбъект);
	   ПередНачаломОбратныйВызов=Новый ОписаниеОповещения("ПередНачаломОбратныйВызов",ЭтотОбъект);
	   
	   ПараметрыДиалога=Новый ПараметрыДиалогаПомещенияФайлов;
	   
	   ПараметрыДиалога.Фильтр="Все файлы|*.*";
	   
	   НачатьПомещениеФайлаНаСервер(ЗавершениеОбратныйВызов, ПрогрессОбратныйВызов,ПередНачаломОбратныйВызов,,ПараметрыДиалога);
	  

	
	
КонецПроцедуры

&НаКлиенте
Процедура СвидетельствоОРегистрацииЮрЛицаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	   имяТаблицы= Элемент.Имя;
	   значХран= УчредительныеДокументыВыборНаСервере(ВыбраннаяСтрока, имяТаблицы);
	   ИмяКаталогаВрФ="";
	   
	   Если значХран<>Неопределено Тогда
		   
   		       имяФ=Элемент.ТекущиеДанные.ИмяФайла;
			   расш=Элемент.ТекущиеДанные.ТипФайла;
			   
			   //Каталог = КаталогВременныхФайлов();
			   ИмяФайла = имяФ + "."+расш;
			   
			   
			   ИмяПромежуточногоФайла = ПолучитьИмяВременногоФайла(расш);
			   
			   ОбратныйВызов = Новый ОписаниеОповещения("ПолучитьКаталогВременныхФайловЗавершение", ЭтотОбъект);
			   НачатьПолучениеКаталогаВременныхФайлов(ОбратныйВызов);
			   
			   //Если ИмяКаталогаВрФ<>"" Тогда
			   //    
					  //ИмяФайла=ИмяКаталогаВрФ +имяФ + "."+расш;
					  ИмяФайла=имяФ + "."+расш;

				   
			   	      Адрес= ПоместитьВоВременноеХранилище(значХран);
					  
					    ПараметрыДиалога = Новый ПараметрыДиалогаПолученияФайлов;
						ПараметрыДиалога.ВыборКаталога=Истина;
			            ПараметрыДиалога.Заголовок = "НачатьПомещениеФайлаССервер";
						
					  
					    НачатьПолучениеФайлаССервера(Адрес,ИмяФайла,ПараметрыДиалога);
		   
			   
		
		   
	   
	   КонецЕсли;

	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлДоверенностьПред(Команда)
	
	
	 Если Объект.ДоверенностьПредставителя.Количество()>0  Тогда
	 
	 	 структураПараметры=Новый Структура;
		 
		 структураПараметры.Вставить("КомандаИмя",Команда.Имя);
		 
	
	     Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопросФайлДоверенностьПред",ЭтаФорма,структураПараметры);
					 
		 текст="Добавить в таблицу Доверенность Представителя файл - Да. Или Заменить (выделенный) - Нет ?";  
					 
         ПоказатьВопрос(Оповещение, текст,РежимДиалогаВопрос.ДаНет,0,,,);

	 
	 Иначе
	 
			   имяКоманды=Команда.Имя;
			   ЗавершениеОбратныйВызов=Новый ОписаниеОповещения("ЗавершениеОбратныйВызов",ЭтотОбъект,имяКоманды);
			   ПрогрессОбратныйВызов=Новый ОписаниеОповещения("ПрогрессОбратныйВызов",ЭтотОбъект);
			   ПередНачаломОбратныйВызов=Новый ОписаниеОповещения("ПередНачаломОбратныйВызов",ЭтотОбъект);
			   
			   ПараметрыДиалога=Новый ПараметрыДиалогаПомещенияФайлов;
			   
			   ПараметрыДиалога.Фильтр="Все файлы|*.*";
			   
			   
			  
			   
			   
			    НачатьПомещениеФайлаНаСервер(ЗавершениеОбратныйВызов, ПрогрессОбратныйВызов,ПередНачаломОбратныйВызов,,ПараметрыДиалога);

	 
	 КонецЕсли;
	
	   	
	
	     
	
	  	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлПодписьПредставителя(Команда)
	
	
	  Если Объект.ПодписьПредставителя.Количество()>0 Тогда
	  
		 структураПараметры=Новый Структура;
		 
		 структураПараметры.Вставить("КомандаИмя",Команда.Имя);
		 
	
	     Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопросФайлПодписьПредставителя",ЭтаФорма,структураПараметры);
					 
		 текст="Добавить в таблицу Подпись Представителя файл - Да.  Или  Заменить (выделенный) - Нет ?";  
					 
         ПоказатьВопрос(Оповещение, текст,РежимДиалогаВопрос.ДаНет,0,,,);

		  
		  
	  
	  Иначе
	  
		  
		   имяКоманды=Команда.Имя;
		   ЗавершениеОбратныйВызов=Новый ОписаниеОповещения("ЗавершениеОбратныйВызов",ЭтотОбъект,имяКоманды);
		   ПрогрессОбратныйВызов=Новый ОписаниеОповещения("ПрогрессОбратныйВызов",ЭтотОбъект);
		   ПередНачаломОбратныйВызов=Новый ОписаниеОповещения("ПередНачаломОбратныйВызов",ЭтотОбъект);
		   
		   ПараметрыДиалога=Новый ПараметрыДиалогаПомещенияФайлов;
		   
		   ПараметрыДиалога.Фильтр="Все файлы|*.*";
		   
		   НачатьПомещениеФайлаНаСервер(ЗавершениеОбратныйВызов, ПрогрессОбратныйВызов,ПередНачаломОбратныйВызов,,ПараметрыДиалога);
			  
		  
	  
	  КонецЕсли;
	
	
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросФайлПодписьПредставителя(Результат, Параметры) Экспорт 
  

	Если Результат = КодВозвратаДиалога.Да Тогда
		 ПодписьПредставителяДобавить=Истина;
		
		 
		   имяКоманды=Параметры.КомандаИмя;
			   ЗавершениеОбратныйВызов=Новый ОписаниеОповещения("ЗавершениеОбратныйВызов",ЭтотОбъект,имяКоманды);
			   ПрогрессОбратныйВызов=Новый ОписаниеОповещения("ПрогрессОбратныйВызов",ЭтотОбъект);
			   ПередНачаломОбратныйВызов=Новый ОписаниеОповещения("ПередНачаломОбратныйВызов",ЭтотОбъект);
			   
			   ПараметрыДиалога=Новый ПараметрыДиалогаПомещенияФайлов;
			   
			   ПараметрыДиалога.Фильтр="Все файлы|*.*";
			   
			   
			    НачатьПомещениеФайлаНаСервер(ЗавершениеОбратныйВызов, ПрогрессОбратныйВызов,ПередНачаломОбратныйВызов,,ПараметрыДиалога);

		 
		 
		
	Иначе	
		
		ПодписьПредставителяДобавить=Ложь;
		
		
		  имяКоманды=Параметры.КомандаИмя;
			   ЗавершениеОбратныйВызов=Новый ОписаниеОповещения("ЗавершениеОбратныйВызов",ЭтотОбъект,имяКоманды);
			   ПрогрессОбратныйВызов=Новый ОписаниеОповещения("ПрогрессОбратныйВызов",ЭтотОбъект);
			   ПередНачаломОбратныйВызов=Новый ОписаниеОповещения("ПередНачаломОбратныйВызов",ЭтотОбъект);
			   
			   ПараметрыДиалога=Новый ПараметрыДиалогаПомещенияФайлов;
			   
			   ПараметрыДиалога.Фильтр="Все файлы|*.*";
			   
			   
			    НачатьПомещениеФайлаНаСервер(ЗавершениеОбратныйВызов, ПрогрессОбратныйВызов,ПередНачаломОбратныйВызов,,ПараметрыДиалога);

		
		
	КонецЕсли;
	
	
	
КонецПроцедуры




&НаКлиенте
Процедура ДоверенностьПредставителяВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	   имяТаблицы= Элемент.Имя;
	   значХран= УчредительныеДокументыВыборНаСервере(ВыбраннаяСтрока, имяТаблицы);
	   ИмяКаталогаВрФ="";

	    Если значХран<>Неопределено Тогда
		   
   		       имяФ=Элемент.ТекущиеДанные.ИмяФайла;
			   расш=Элемент.ТекущиеДанные.ТипФайла;
			   
			   //Каталог = КаталогВременныхФайлов();
			   ИмяФайла = имяФ + "."+расш;
			   
			   
			   ИмяПромежуточногоФайла = ПолучитьИмяВременногоФайла(расш);
			   
			   ОбратныйВызов = Новый ОписаниеОповещения("ПолучитьКаталогВременныхФайловЗавершение", ЭтотОбъект);
			   НачатьПолучениеКаталогаВременныхФайлов(ОбратныйВызов);
			   
			   //Если ИмяКаталогаВрФ<>"" Тогда
			   //    
					  //ИмяФайла=ИмяКаталогаВрФ +имяФ + "."+расш;
					  ИмяФайла=имяФ + "."+расш;

				   
			   	      Адрес= ПоместитьВоВременноеХранилище(значХран);
					  
					    ПараметрыДиалога = Новый ПараметрыДиалогаПолученияФайлов;
						ПараметрыДиалога.ВыборКаталога=Истина;
			            ПараметрыДиалога.Заголовок = "НачатьПомещениеФайлаССервер";
						
					  
					    НачатьПолучениеФайлаССервера(Адрес,ИмяФайла,ПараметрыДиалога);
		   
			   
		
		   
	   
	   КонецЕсли;
  
	   
	
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписьПредставителяВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	    имяТаблицы= Элемент.Имя;
	   значХран= УчредительныеДокументыВыборНаСервере(ВыбраннаяСтрока, имяТаблицы);
	   ИмяКаталогаВрФ="";

	    Если значХран<>Неопределено Тогда
		   
   		       имяФ=Элемент.ТекущиеДанные.ИмяФайла;
			   расш=Элемент.ТекущиеДанные.ТипФайла;
			   
			   //Каталог = КаталогВременныхФайлов();
			   ИмяФайла = имяФ + "."+расш;
			   
			   
			   ИмяПромежуточногоФайла = ПолучитьИмяВременногоФайла(расш);
			   
			   ОбратныйВызов = Новый ОписаниеОповещения("ПолучитьКаталогВременныхФайловЗавершение", ЭтотОбъект);
			   НачатьПолучениеКаталогаВременныхФайлов(ОбратныйВызов);
			   
			   //Если ИмяКаталогаВрФ<>"" Тогда
			   //    
					  //ИмяФайла=ИмяКаталогаВрФ +имяФ + "."+расш;
					  ИмяФайла=имяФ + "."+расш;

				   
			   	      Адрес= ПоместитьВоВременноеХранилище(значХран);
					  
					    ПараметрыДиалога = Новый ПараметрыДиалогаПолученияФайлов;
						ПараметрыДиалога.ВыборКаталога=Истина;
			            ПараметрыДиалога.Заголовок = "НачатьПомещениеФайлаССервер";
						
					  
					    НачатьПолучениеФайлаССервера(Адрес,ИмяФайла,ПараметрыДиалога);
		   
			   
		
		   
	   
	   КонецЕсли;
  

	
	
	
	
КонецПроцедуры













