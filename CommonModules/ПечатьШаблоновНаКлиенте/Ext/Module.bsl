&НаКлиенте
Процедура ВыпискиИзРеестраУступПрав(спрОбСтруктура) Экспорт

	 видД="ШаблонВыпискиИзРеестра";
	 
	  ДвоичныеДанные=ФункцииДляОтчетов.ПолучитьФайлИзХран(видД);
	  
       Если ДвоичныеДанные<>Неопределено  Тогда
		   
		    Попытка
			
					имяД=Строка(спрОбСтруктура.Исполнитель)+"__ВыпискиИзРеестра";
					

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

					 
					  MSWordDoc.Bookmarks("Цессия_заголовок").Select();
			    	  MSWordDoc.Application.Selection.Font.Color = 1;
                      MSWordDoc.Application.Selection.TypeText(Строка(спрОбСтруктура.Цессия_заголовок));

					  
					   //ЦессияДата_заголовок
				    MSWordDoc.Bookmarks("ЦессияДата_заголовок").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датЦессия=спрОбСтруктура.ЦессияДата_заголовок;
				   дат= Формат(датЦессия, "ДЛФ=ДД");
				   MSWordDoc.Application.Selection.TypeText(дат);

				   
				    //Дата_Рождения
				    MSWordDoc.Bookmarks("Дата_Рождения").Select();
				   MSWordDoc.Application.Selection.Font.Color = 1;
				   датРож=спрОбСтруктура.Дата_Рождения;
				   дат= Формат(датРож, "ДЛФ=ДД");
				   MSWordDoc.Application.Selection.TypeText(дат);

				   
				   //Цессия_Название
					  MSWordDoc.Bookmarks("Цессия_Название").Select();
			    	  MSWordDoc.Application.Selection.Font.Color = 1;
                      MSWordDoc.Application.Selection.TypeText(Строка(спрОбСтруктура.Цессия_Название));

					  //ЦессияДата_Название
				         MSWordDoc.Bookmarks("ЦессияДата_Название").Select();
					   MSWordDoc.Application.Selection.Font.Color = 1;
					   датЦессия=спрОбСтруктура.ЦессияДата_Название;
					   дат= Формат(датЦессия, "ДЛФ=ДД");
					   MSWordDoc.Application.Selection.TypeText(дат);

					   
					 // ФИО_Должник
					   MSWordDoc.Bookmarks("ФИО_Должник").Select();
			    	  MSWordDoc.Application.Selection.Font.Color = 1;
                      MSWordDoc.Application.Selection.TypeText(Строка(спрОбСтруктура.ФИО_Должник));

					  //НомерКредитногоДоговора
					    MSWordDoc.Bookmarks("НомерКредитногоДоговора").Select();
			    	  MSWordDoc.Application.Selection.Font.Color = 1;
                      MSWordDoc.Application.Selection.TypeText(Строка(спрОбСтруктура.НомерКредитногоДоговора));

					   
					  //Дата_ВыдачиКредитногоДоговора
					       MSWordDoc.Bookmarks("Дата_ВыдачиКредитногоДоговора").Select();
					   MSWordDoc.Application.Selection.Font.Color = 1;
					   датЦессия=спрОбСтруктура.Дата_ВыдачиКредитногоДоговора;
					   дат= Формат(датЦессия, "ДЛФ=ДД");
					   MSWordDoc.Application.Selection.TypeText(дат);

					   
					   //ОстатокПросроченнойЗадПоОсновнДолг
					  MSWordDoc.Bookmarks("ОстатокПросроченнойЗадПоОсновнДолг").Select();
			    	  MSWordDoc.Application.Selection.Font.Color = 1;
                      MSWordDoc.Application.Selection.TypeText(Строка(спрОбСтруктура.ОстатокПросроченнойЗадПоОсновнДолг));

					  
					  //ОстатокПросроченнойЗадПоПроцентам
					  MSWordDoc.Bookmarks("ОстатокПросроченнойЗадПоПроцентам").Select();
			    	  MSWordDoc.Application.Selection.Font.Color = 1;
                      MSWordDoc.Application.Selection.TypeText(Строка(спрОбСтруктура.ОстатокПросроченнойЗадПоПроцентам));

					  
					  //СуммаПросроченнойКомиссии
					    MSWordDoc.Bookmarks("СуммаПросроченнойКомиссии").Select();
			    	  MSWordDoc.Application.Selection.Font.Color = 1;
                      MSWordDoc.Application.Selection.TypeText(Строка(спрОбСтруктура.СуммаПросроченнойКомиссии));

					   //ШтрафыИНеустойки
					   MSWordDoc.Bookmarks("ШтрафыИНеустойки").Select();
			    	  MSWordDoc.Application.Selection.Font.Color = 1;
                      MSWordDoc.Application.Selection.TypeText(Строка(спрОбСтруктура.ШтрафыИНеустойки));

					  //СуммаПроцНаПросрочЗадолж
					    MSWordDoc.Bookmarks("СуммаПроцНаПросрочЗадолж").Select();
			    	  MSWordDoc.Application.Selection.Font.Color = 1;
                      MSWordDoc.Application.Selection.TypeText(Строка(спрОбСтруктура.СуммаПроцНаПросрочЗадолж));

					  
					  //Госпошлина
					     MSWordDoc.Bookmarks("Госпошлина").Select();
			    	  MSWordDoc.Application.Selection.Font.Color = 1;
                      MSWordDoc.Application.Selection.TypeText(Строка(спрОбСтруктура.Госпошлина));

					  //Итого
					        MSWordDoc.Bookmarks("Итого").Select();
			    	  MSWordDoc.Application.Selection.Font.Color = 1;
                      MSWordDoc.Application.Selection.TypeText(Строка(спрОбСтруктура.Итого));

					  
						 //Дата_подвал
					   MSWordDoc.Bookmarks("Дата_подвал").Select();
					   MSWordDoc.Application.Selection.Font.Color = 1;
					   датЦессия=ТекущаяДата();
					   дат= Формат(датЦессия, "ДЛФ=ДД");
					   MSWordDoc.Application.Selection.TypeText(дат);

					   
					  
					   
					  
					      MSWord.Visible=0;
						
						//MSWord.Activate();
						MSWordDoc.Application.PrintOut();
						
						MSWordDoc.Close(0);
						
						
						
						MSWord.Application.Quit();

					   
					   
				
			Исключение
				   	  Сообщить("Ошибка----- Печать Выписки из реестра");
				   ТекстОшибки = ОписаниеОшибки();
				   Сообщить(ТекстОшибки);

				
			КонецПопытки;
		   
		   
	   КонецЕсли; 
	  
	
	

КонецПроцедуры





