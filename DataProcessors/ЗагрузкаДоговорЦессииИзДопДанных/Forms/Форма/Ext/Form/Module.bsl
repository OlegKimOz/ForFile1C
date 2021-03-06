﻿
&НаКлиенте
Процедура ЗапуститьПеренос(Команда)
	
	
	      ПеренестиЦессии();
	
	
	
КонецПроцедуры


&НаСервере
Процедура ПеренестиЦессии()

	допРеквДогЦессии=Справочники.ДополнительныеРеквизиты.НайтиПоНаименованию("Договор цессии",Истина);
	
	допРеквДатаЦессии=Справочники.ДополнительныеРеквизиты.НайтиПоНаименованию("Дата цессии",Истина);
	
	
				
				Запрос = Новый Запрос;
				Запрос.Текст = 
					"ВЫБРАТЬ
					|	Должники.Ссылка КАК Ссылка
					|ИЗ
					|	Справочник.Должники КАК Должники";
				
				РезультатЗапроса = Запрос.Выполнить();
				
				ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
				
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					
							
							Запрос = Новый Запрос;
							Запрос.Текст = 
								"ВЫБРАТЬ
								|	Договоры.Ссылка КАК Ссылка,
								|	Договоры.Владелец КАК Владелец
								|ИЗ
								|	Справочник.Договоры КАК Договоры
								|ГДЕ
								|	Договоры.Владелец = &Владелец";
							
							Запрос.УстановитьПараметр("Владелец", ВыборкаДетальныеЗаписи.Ссылка);
							
							РезультатЗапроса = Запрос.Выполнить();
							
							Выборка = РезультатЗапроса.Выбрать();
							
							Если Выборка.Количество()=1  Тогда
								Выборка.Следующий(); 
								
								 НомерДоговораЦессии="";
								 ДатаДогЦессии="";
								 				
												Запрос = Новый Запрос;
												Запрос.Текст = 
													"ВЫБРАТЬ
													|	ДополнительныеДанные.Реквизит КАК Реквизит,
													|	ДополнительныеДанные.Наименование КАК Наименование
													|ИЗ
													|	Справочник.ДополнительныеДанные КАК ДополнительныеДанные
													|ГДЕ
													|	ДополнительныеДанные.Владелец = &Владелец";
												
												Запрос.УстановитьПараметр("Владелец", ВыборкаДетальныеЗаписи.Ссылка);
												
												РезультатЗапроса = Запрос.Выполнить();
												
												ВыборкаДопДанные = РезультатЗапроса.Выбрать();
												
												Пока ВыборкаДопДанные.Следующий() Цикл
													
													Если  ВыборкаДопДанные.Реквизит=допРеквДогЦессии Тогда
														
														НомерДоговораЦессии= ВыборкаДопДанные.Наименование;
														
													
													КонецЕсли;
													
													
													Если  ВыборкаДопДанные.Реквизит=допРеквДатаЦессии Тогда
														
														ДатаДогЦессии= ВыборкаДопДанные.Наименование;
														
													
													КонецЕсли;
													
													
													
													
												КонецЦикла;
												
									
												
												
											// Запишу в справочник ДоговорЦессии
											
											Если НомерДоговораЦессии<>"" И ДатаДогЦессии<>""  Тогда
												
												//   Проверю есть ли такой договор цессии
														Запрос = Новый Запрос;
														Запрос.Текст = 
															"ВЫБРАТЬ
															|	ДоговорЦессии.НомерДоговора КАК НомерДоговора
															|ИЗ
															|	Справочник.ДоговорЦессии КАК ДоговорЦессии
															|ГДЕ
															|	ДоговорЦессии.Владелец = &Владелец
															|	И ДоговорЦессии.НомерДоговора = &НомерДоговора";
														
														Запрос.УстановитьПараметр("Владелец", Выборка.Ссылка);
														Запрос.УстановитьПараметр("НомерДоговора", НомерДоговораЦессии);
														
														РезультатЗапроса = Запрос.Выполнить();
														
														ВыборкаДоговорЦессии = РезультатЗапроса.Выбрать();
														
														Если ВыборкаДоговорЦессии.Количество()=0 Тогда
															
															спрНоваяСтр=Справочники.ДоговорЦессии.СоздатьЭлемент();
															
															спрНоваяСтр.Владелец= Выборка.Ссылка;
															
															спрНоваяСтр.НомерДоговора=НомерДоговораЦессии;
															
															Попытка
															
																спрНоваяСтр.ДатаЦессии=Дата(ДатаДогЦессии);

															
															Исключение
																
																Если СтрДлина(ДатаДогЦессии)=8 Тогда
																	
																	годЦессии= Прав(ДатаДогЦессии,2);
																	
																	годЦессии="20"+годЦессии;
																	
																	ДатаДогЦессии=Лев(ДатаДогЦессии,5);
																	
																	ДатаДогЦессии=ДатаДогЦессии+"."+годЦессии+" 0:00:00"
																 	
																Иначе	
																	
																  ДатаДогЦессии=ДатаДогЦессии+" 0:00:00";	
																
																КонецЕсли;
																
																 
																Попытка
																
																	 спрНоваяСтр.ДатаЦессии= Дата(ДатаДогЦессии);

																
																Исключение
																	
																	 спрНоваяСтр.ДатаЦессии=Дата(1, 1, 1, 0, 0, 0); 
																	
																КонецПопытки;
																
																   																 
																 
															КонецПопытки;
															
															
																														
															
															
															спрНоваяСтр.Записать();
															
														
														КонецЕсли;
				
							
							              КонецЕсли;
												
								
							
							КонецЕсли;
							
														
											
					
					
					
					
				КонецЦикла;
				
			
	
	
	
	

КонецПроцедуры
