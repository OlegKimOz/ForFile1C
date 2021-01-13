
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Вставить содержимое обработчика
	
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
         	  Объект.Наименование="Заявление о выдаче судебного приказа";
	  
 

		     Объект.ДатаРожденияДолжника=Параметры.ДатаРожденияДолжника;
	 
			 Объект.АдресРегистрацииДолжника=Параметры.АдресРегистрацииДолжника;

			 Объект.ПаспортныеДанныеДолжника=Параметры.ПаспортныеДанныеДолжника;
			 
			 Объект.ПаспортДатаВыдачи=Параметры.ПаспортныеДанныеДолжникаДатаВыдачи;
			 
			 
			 Объект.МестоРожденияДолжника=Параметры.МестоРожденияДолжника;
			 
			 Объект.НаименованиеПервоначальногоКредитора=Параметры.НаименованиеПервоначальногоКредитора;
			 
			 Объект.НомерДоговораЦессии=Параметры.НомерДоговораЦессии;
			 
			 Объект.ДатаДоговораЦессии=Параметры.ДатаДоговораЦессии;
			 
			 Объект.ТипДокумента=Перечисления.ТипДокумента.исх;
			 
			 Объект.СтадияДокумента=Перечисления.СтадияДокумента.СП;
			 
			 Объект.НаименованиеСуда=Параметры.НазваниеСуда;
			 
             Объект.АдресСуда=Параметры.АдресСудаВкладка;
			 
			 Объект.Исполнитель=Параметры.Исполнитель;
			 Объект.СуммаКредита=Параметры.СуммаКредита;
			 
			 
	  Иначе
		  
		      Если   ЗначениеЗаполнено(Объект.НазваниеЗаявителя) Тогда
		          ЮридическийАдресЗаявителя=Объект.НазваниеЗаявителя.ЮридическийАдрес;
	              EmailЗаявителя=Объект.НазваниеЗаявителя.ЭлектронныйАдрес;
	              Телефон=Объект.НазваниеЗаявителя.Телефон;
		   	
		   
		   КонецЕсли;

			 
		  
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
			
				имяД=Строка(Объект.Исполнитель)+"_ЗаявлениеОВыдачеСудебногоПриказа";
				  
							
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
				   
				   //ДатаРожденияДолжника
				    MSWordDoc.Bookmarks("ДатаРожденияДолжника").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаРожденияДолжника;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   MSWordDoc.Application.Selection.TypeText(дат);

				   
				   //МестоРожденияДолжника
				   MSWordDoc.Bookmarks("МестоРожденияДолжника").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.МестоРожденияДолжника);
				   
				   //ПаспортНомер
				   MSWordDoc.Bookmarks("ПаспортНомер").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.ПаспортныеДанныеДолжника);
				   
				   
				   //ПаспортДатаВыдачи
				   MSWordDoc.Bookmarks("ПаспортДатаВыдачи").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ПаспортДатаВыдачи;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   MSWordDoc.Application.Selection.TypeText(дат);

				   //АдресРегистрации
				    MSWordDoc.Bookmarks("АдресРегистрации").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.АдресРегистрацииДолжника);
				   
				   
				   //СуммаЗадолженности
				     MSWordDoc.Bookmarks("СуммаЗадолженности").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.ОбщаяСуммаЗадолженностиПоДоговору);
				   
					//ГосПошлина
				   MSWordDoc.Bookmarks("ГосПошлина").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.ГоспошлинаНаша);
				   
				   //ПервоначальныйКредитор
				    MSWordDoc.Bookmarks("ПервоначальныйКредитор").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   MSWordDoc.Application.Selection.TypeText(Объект.НаименованиеПервоначальногоКредитора+" ");
				   
				   //ФИОДолжника_Между
				     MSWordDoc.Bookmarks("ФИОДолжника_Между").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Строка(Объект.ФИОДолжника)+" ");
				   
				   
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

				   
				   //ПервоначальныйКредитор_заключенной
				      MSWordDoc.Bookmarks("ПервоначальныйКредитор_заключенной").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   MSWordDoc.Application.Selection.TypeText(Объект.НаименованиеПервоначальногоКредитора+" ");
				  
				   //СуммаКредита
				         MSWordDoc.Bookmarks("СуммаКредита").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   MSWordDoc.Application.Selection.TypeText(Объект.СуммаКредита);
				   
				   
				   //ДатаЦессии
				        MSWordDoc.Bookmarks("ДатаЦессии").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаДоговораЦессии;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   длина=СтрДлина(дат);
				   дат=Лев(дат,длина-2);
				   MSWordDoc.Application.Selection.TypeText(дат);
				   
				   //ПервоначальныйКредитор_ДатаЦессии
				         MSWordDoc.Bookmarks("ПервоначальныйКредитор_ДатаЦессии").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   MSWordDoc.Application.Selection.TypeText(Объект.НаименованиеПервоначальногоКредитора+" ");
				   
				   //НомерЦессии
				      MSWordDoc.Bookmarks("НомерЦессии").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   MSWordDoc.Application.Selection.TypeText(Объект.НомерДоговораЦессии+" ");
				   
				   
				   //ДатаЦессии_БылЗаключен
				       MSWordDoc.Bookmarks("ДатаЦессии_БылЗаключен").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаДоговораЦессии;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   MSWordDoc.Application.Selection.TypeText(дат);

				   
				   //НомерКредитногоДоговора_кредитномудого
				         MSWordDoc.Bookmarks("НомерКредитногоДоговора_кредитномудого").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.НомерКредитногоДоговора);
				   
				   
				   //ДатаКредитногоДоговора_кредитномудог
				       MSWordDoc.Bookmarks("ДатаКредитногоДоговора_кредитномудог").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаКредитногоДоговора;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   MSWordDoc.Application.Selection.TypeText(дат);

				   
				   //ПервоначальныйКредитор_заключенного_межд
				        MSWordDoc.Bookmarks("ПервоначальныйКредитор_заключенного_межд").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   MSWordDoc.Application.Selection.TypeText(Объект.НаименованиеПервоначальногоКредитора+" ");
				   
				   
				   //ФИОДолжника_заключенного_между
				      MSWordDoc.Bookmarks("ФИОДолжника_заключенного_между").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Строка(Объект.ФИОДолжника)+" ");
				  

				   //ДатаЦессии_уступаемых
				         MSWordDoc.Bookmarks("ДатаЦессии_уступаемых").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаДоговораЦессии;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   MSWordDoc.Application.Selection.TypeText(дат);

					//ОбщаяСуммаЗадолженностиПоЦессии
			       MSWordDoc.Bookmarks("ОбщаяСуммаЗадолженностиПоЦессии").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.ОбщаяСуммаЗадолженностиПоДоговору);
				   
				   
				   //ОбщаяСуммаЗадолженностиПоЦессии_составля
				    MSWordDoc.Bookmarks("ОбщаяСуммаЗадолженностиПоЦессии_составля").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.ОбщаяСуммаЗадолженностиПоДоговору);
				   
				   //НомерКредитногоДоговора_выполнении
				   MSWordDoc.Bookmarks("НомерКредитногоДоговора_выполнении").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.НомерКредитногоДоговора);
				 
				   
				   //ДатаКредитногоДоговора_выполнении
				         MSWordDoc.Bookmarks("ДатаКредитногоДоговора_выполнении").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаКредитногоДоговора;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   MSWordDoc.Application.Selection.TypeText(дат);

				   
				   //ФИОДолжника_Прошу_выдать
				         MSWordDoc.Bookmarks("ФИОДолжника_Прошу_выдать").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Строка(Объект.ФИОДолжника)+" ");
				  
				   
					//ОбщаяСуммаЗадолженностиПоЦессии_Прошу
					  MSWordDoc.Bookmarks("ОбщаяСуммаЗадолженностиПоЦессии_Прошу").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.ОбщаяСуммаЗадолженностиПоДоговору);
				  
				   //НомерКредитногоДоговора_Прошу
				    MSWordDoc.Bookmarks("НомерКредитногоДоговора_Прошу").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.НомерКредитногоДоговора);
				 
				   
				   //ДатаКредитногоДоговора_Прошу
				          MSWordDoc.Bookmarks("ДатаКредитногоДоговора_Прошу").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаКредитногоДоговора;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   MSWordDoc.Application.Selection.TypeText(дат);

				   
				   //ПервоначальныйКредитор_Прошу
				   MSWordDoc.Bookmarks("ПервоначальныйКредитор_Прошу").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   MSWordDoc.Application.Selection.TypeText(Объект.НаименованиеПервоначальногоКредитора+" ");
				   
				   
				   //ФИОДолжника_Прошу_Взыскать
				   MSWordDoc.Bookmarks("ФИОДолжника_Прошу_Взыскать").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Строка(Объект.ФИОДолжника)+" ");
				   
				   
				   //СуммаГоспошлины_Прошу
				      MSWordDoc.Bookmarks("СуммаГоспошлины_Прошу").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.ГоспошлинаНаша);
				 
				   
				   //НомерКредитногоДоговора_Приложение
				      MSWordDoc.Bookmarks("НомерКредитногоДоговора_Приложение").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
                   MSWordDoc.Application.Selection.TypeText(Объект.НомерКредитногоДоговора);
				   
				   
				   //ДатаКредитногоДоговора_Приложение
				   MSWordDoc.Bookmarks("ДатаКредитногоДоговора_Приложение").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаКредитногоДоговора;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   MSWordDoc.Application.Selection.TypeText(дат);


				   //НомерЦессии_Приложение
				          MSWordDoc.Bookmarks("НомерЦессии_Приложение").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   MSWordDoc.Application.Selection.TypeText(Объект.НомерДоговораЦессии+" ");
				   
				   //ДатаЦессии_Приложение
				          MSWordDoc.Bookmarks("ДатаЦессии_Приложение").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаДоговораЦессии;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   MSWordDoc.Application.Selection.TypeText(дат);

				   
				   //ДатаЦессии_Приложение_5
				    MSWordDoc.Bookmarks("ДатаЦессии_Приложение_5").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=Объект.ДатаДоговораЦессии;
				   дат= Формат(датРож, "ДЛФ=ДД");
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
				
					Сообщить("Ошибка----- Печать Заявление О Выдаче Судебного Приказа");
				ТекстОшибки = ОписаниеОшибки();
				Сообщить(ТекстОшибки);

				
			КонецПопытки;
			
		КонецЕсли;
			
	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьФайлИзХран()
	
	 
	   НайтиШабл = Справочники.ШаблоныЮристы.НайтиПоНаименованию("ШаблонЗаявлениеОВыдачеСудебногоПриказа",ИСТИНА);
	 
	     Двоичные=Неопределено;
		 
		 Если НайтиШабл<>Неопределено Тогда
		 
		 	 Если НЕ НайтиШабл.ПУСТАЯ() Тогда  
 
        		Хран=НайтиШабл.ФайлШаблона;
        		Двоичные=Хран.Получить(); 
    			
    		КонецЕсли;
			

		 
		 КонецЕсли; 
    	
			
	  Возврат Двоичные;		
	 

КонецФункции // ()


	  
	  
	  
