
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка=Ложь;
	
	
	
		  
	
	
	Если  Параметры.Свойство("ДоговорСтр") Тогда
		      Объект.Владелец=Параметры.ДоговорСтр;
			  Объект.НомерКредитногоДоговора=Параметры.ДоговорСтр.НомерДоговора;
			  Объект.ДатаКредитногоДоговора=Параметры.ДоговорСтр.ДатаФинансирования;
			  
	
	КонецЕсли;
	
	Если  Параметры.Свойство("ДолжникФИО") Тогда
		      Объект.ФИОДолжника=Параметры.ДолжникФИО;
			  
  	КонецЕсли;
	
	
	Если  РеквизитФормыВЗначение("Объект").ЭтоНовый() Тогда
		
		      Объект.ДатаСоздания=ТекущаяДата();
        	  Объект.Наименование="Заявления о праве преемственности";


		     Объект.ДатаРожденияДолжника=Параметры.ДатаРожденияДолжника;
	 
			 Объект.АдресРегистрацииДолжника=Параметры.АдресРегистрацииДолжника;

			 Объект.ПаспортныеДанныеДолжника=Параметры.ПаспортныеДанныеДолжника;
			 
			 
			 Объект.МестоРожденияДолжника=Параметры.МестоРожденияДолжника;
			 
			 Объект.НаименованиеПервоначальногоКредитора=Параметры.НаименованиеПервоначальногоКредитора;
			 
			 Объект.НомерДоговораЦессии=Параметры.НомерДоговораЦессии;
			 
			 Объект.ДатаДоговораЦессии=Параметры.ДатаДоговораЦессии;
			 
			 Объект.ТипДокумента=Перечисления.ТипДокумента.исх;
			 
			 Объект.СтадияДокумента=Перечисления.СтадияДокумента.СП;
			 
			 Объект.НаименованиеСуда=Параметры.НазваниеСуда;
			 
             Объект.АдресСуда=Параметры.АдресСудаВкладка;
			 
			 Объект.Исполнитель=Параметры.Исполнитель;
			
			 
			 
	  Иначе
		  
		   Если   ЗначениеЗаполнено(Объект.НазваниеЗаявителя) Тогда
		          ЮридическийАдресЗаявителя=Объект.НазваниеЗаявителя.ЮридическийАдрес;
	              EmailЗаявителя=Объект.НазваниеЗаявителя.ЭлектронныйАдрес;
	              Телефон=Объект.НазваниеЗаявителя.Телефон;
		   	
		   
		   КонецЕсли;
		     
			 
		  
      КонецЕсли;
	  
	
		 
	 
	
	
		
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПрисоединенныеФайлыНажатие(Элемент)
	
	  Если Не Объект.Ссылка.Пустая() Тогда
		  
		    пармСтр=Новый Структура;
		    пармСтр.Вставить("Владелец",Объект.Ссылка);
		    пармСтр.Вставить("ВладелецФайла",Объект.Ссылка);
			
		    ФормаПрисоедФайлы= ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы",пармСтр,Объект.Ссылка);
		  
		  
	  	
	  Иначе 
		  Сообщить("Еще не записан документ, нажмите Записать");
		  
	  КонецЕсли;
	
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура НазваниеЗаявителяОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	
	 НайтиДанныеПолучателя(ВыбранноеЗначение);

	 
	
КонецПроцедуры

&НаСервере
Процедура НайтиДанныеПолучателя(значпор)

	ЮридическийАдресЗаявителя=значпор.ЮридическийАдрес;
	EmailЗаявителя=значпор.ЭлектронныйАдрес;
	Телефон=значпор.Телефон;
	
	
	

КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	  ДвоичныеДанные=ПолучитьФайлИзХран();

	    Если ДвоичныеДанные<>Неопределено  Тогда
			
			Попытка
			
				
				имяД=Строка(Объект.Исполнитель)+"_ЗаявлениеОПроцессуальномПравопреемстве";
				  
				 
				//Shell = Новый COMОбъект("WScript.Shell");
				//дирМоиД=Shell.SpecialFolders.Item("MyDocuments");
				//
				
				//ИмяФайла=дирМоиД+"\"+имяД+".docx"; 	
				
				
				
							
				ИмяФайла=Строка(КаталогВременныхФайлов())+имяД+".docx";
				
				ВыбранныйФайл = Новый Файл(ИмяФайла);
				Если ВыбранныйФайл.Существует() Тогда
					
					УдалитьФайлы(ВыбранныйФайл);
					
				
				КонецЕсли; 

				ДвоичныеДанные.Записать(ИмяФайла);
				
				 MSWord = новый COMОбъект("Word.Application");
				 //Передаем текущие параметры форм в MSWord
				 MSWord.Documents.Open(ИмяФайла);	
				 MSWordDoc = MSWord.ActiveDocument();

				 
				   MSWordDoc.Bookmarks("НаименованиеСуда").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Строка(Объект.НаименованиеСуда));
				   
				   //АдресСуда
				   MSWordDoc.Bookmarks("АдресСуда").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.АдресСуда);
				   
				   //ФИОДолжника
				   MSWordDoc.Bookmarks("ФИОДолжника").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Строка(Объект.ФИОДолжника));
				 
					//ДолжникаДатаРождения
	  		       MSWordDoc.Bookmarks("ДолжникаДатаРождения").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаРожденияДолжника;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   MSWordDoc.Application.Selection.TypeText(дат);
				   
					//ДолжникАдрес
				   MSWordDoc.Bookmarks("ДолжникАдрес").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.АдресРегистрацииДолжника);
				 
                 
					//СудПоле
				   MSWordDoc.Bookmarks("СудПоле").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Строка(Объект.НаименованиеСуда)+" ");
				   
				   
				  // НомерДелаВСуде
				   MSWordDoc.Bookmarks("НомерДелаВСуде").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.НомерСудебногоДела);
				   
				   //ПервоначальныйКредитор
				   MSWordDoc.Bookmarks("ПервоначальныйКредитор").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   MSWordDoc.Application.Selection.TypeText(Объект.НаименованиеПервоначальногоКредитора+" ");
				 
				   
				   //ФИОДолжникПоле
				   MSWordDoc.Bookmarks("ФИОДолжникПоле").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Строка(Объект.ФИОДолжника));
				 
				   //НомерКредитногоДоговора
				   MSWordDoc.Bookmarks("НомерКредитногоДоговора").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.НомерКредитногоДоговора);
				   
				   //ДатаКредитногоДоговора
				   MSWordDoc.Bookmarks("ДатаКредитногоДоговора").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаКредитногоДоговора;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   MSWordDoc.Application.Selection.TypeText(дат);
				   
					
				   //ПервоначальныйКредитор_Между
				    MSWordDoc.Bookmarks("ПервоначальныйКредитор_Между").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Строка(Объект.НаименованиеПервоначальногоКредитора)+" ");

				   
				   //НомерЦессии
				   MSWordDoc.Bookmarks("НомерЦессии").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.НомерДоговораЦессии+" ");
				 

				   //ДатаЦессии
				    MSWordDoc.Bookmarks("ДатаЦессии").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаДоговораЦессии;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   MSWordDoc.Application.Selection.TypeText(дат);
				   
				   
					//НомерКредитногоДоговора_Между
				   MSWordDoc.Bookmarks("НомерКредитногоДоговора_Между").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.НомерКредитногоДоговора);
				 
				   
				   //ДатаКредитногоДоговора_Между
				    MSWordDoc.Bookmarks("ДатаКредитногоДоговора_Между").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаКредитногоДоговора;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   MSWordDoc.Application.Selection.TypeText(дат);
				  
				   
				   //ПервоначальныйКредитор_М_между
				     MSWordDoc.Bookmarks("ПервоначальныйКредитор_М_между").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.НаименованиеПервоначальногоКредитора+" ");

				   
				   //ФИОДолжника_Между
				     MSWordDoc.Bookmarks("ФИОДолжника_Между").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Строка(Объект.ФИОДолжника));
				 

				   //НомерЦессии_Переход
				    MSWordDoc.Bookmarks("НомерЦессии_Переход").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.НомерДоговораЦессии+" ");

				   //ДатаЦессии_Переход
				     MSWordDoc.Bookmarks("ДатаЦессии_Переход").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаДоговораЦессии;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   MSWordDoc.Application.Selection.TypeText(дат);
				
				   
				   //ПервоначальныйКредитор_Также
				   MSWordDoc.Bookmarks("ПервоначальныйКредитор_Также").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.НаименованиеПервоначальногоКредитора+" ");

				   //НомерДелаВСуде_Прошу
				   MSWordDoc.Bookmarks("НомерДелаВСуде_Прошу").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.НомерСудебногоДела);
				   
				   //ДатаДелаВСуде
				   MSWordDoc.Bookmarks("ДатаДелаВСуде").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаСудебногоДела;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   MSWordDoc.Application.Selection.TypeText(дат);


				   //ПервоначальныйКредитор_Прошу
				   MSWordDoc.Bookmarks("ПервоначальныйКредитор_Прошу").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.НаименованиеПервоначальногоКредитора+" ");

				   
				   //ФИОДолжника_Прошу
				   MSWordDoc.Bookmarks("ФИОДолжника_Прошу").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Строка(Объект.ФИОДолжника));

				   
				   //НомерКредитногоДоговора_Прошу
				     MSWordDoc.Bookmarks("НомерКредитногоДоговора_Прошу").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.НомерКредитногоДоговора);
				 
				   //ДатаКредитногоДоговора_Прошу
				      MSWordDoc.Bookmarks("ДатаКредитногоДоговора_Прошу").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаКредитногоДоговора;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   длина=СтрДлина(дат);
				   дат=Лев(дат,длина-2);
				   MSWordDoc.Application.Selection.TypeText(дат);
				  
				   
				   //ПервоначальныйКредитор_Прошу_2
				    MSWordDoc.Bookmarks("ПервоначальныйКредитор_Прошу_2").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.НаименованиеПервоначальногоКредитора+" ");

				   
				   
				   //НомерЦессии_Приложение
				   MSWordDoc.Bookmarks("НомерЦессии_Приложение").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.НомерДоговораЦессии+" ");

				   
				   //ДатаЦессии_Приложение
				        MSWordDoc.Bookmarks("ДатаЦессии_Приложение").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаДоговораЦессии;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   длина=СтрДлина(дат);
				   дат=Лев(дат,длина-2);
                   MSWordDoc.Application.Selection.TypeText(дат);
				

				   //НомерЦессии_Приложение_Выписка
				     MSWordDoc.Bookmarks("НомерЦессии_Приложение_Выписка").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.НомерДоговораЦессии+" ");

				   
				   //ДатаЦессии_Приложение_Выписка
				          MSWordDoc.Bookmarks("ДатаЦессии_Приложение_Выписка").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаДоговораЦессии;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   длина=СтрДлина(дат);
				   дат=Лев(дат,длина-2);
                   MSWordDoc.Application.Selection.TypeText(дат);
				

				   //ДатаЗаявления
				     MSWordDoc.Bookmarks("ДатаЗаявления").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=ТекущаяДата();
				   дат= Формат(датРож, "ДЛФ=ДД");
				   MSWordDoc.Application.Selection.TypeText(дат);

				   
				   
				  MSWord.Visible=1;
				  MSWord.Activate();

				  
				  
				  
				  
			
			Исключение
				
				Сообщить("Ошибка----- Печать Заявление О Процессуальном Правопреемстве");
				ТекстОшибки = ОписаниеОшибки();
				Сообщить(ТекстОшибки);

				
				
			КонецПопытки;
			
			
		КонецЕсли;	
	
	
	
КонецПроцедуры

 
 
&НаСервере
Функция ПолучитьФайлИзХран()
	
	 
	   НайтиШабл = Справочники.ШаблоныЮристы.НайтиПоНаименованию("ШаблонЗаявлениеОПроцессуальномПравопреемстве",ИСТИНА);
	 
	     Двоичные=Неопределено;
		 
		 Если НайтиШабл<>Неопределено Тогда
		 
		 	 Если НЕ НайтиШабл.ПУСТАЯ() Тогда  
 
        		Хран=НайтиШабл.ФайлШаблона;
        		Двоичные=Хран.Получить(); 
    			
    		КонецЕсли;
			

		 
		 КонецЕсли; 
    	
			
	  Возврат Двоичные;		
	 

КонецФункции // ()


