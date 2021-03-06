﻿// В данном модуле содержатся функции
// для построения текстов запросов фильтра должников, фильтра передачи,
// а также функции построения виртуальных таблиц фильтра

Функция ПолучитьВиртуальнуюТаблицу(МенеджерВременныхТаблиц, ИмяТаблицы) Экспорт
    Перем Запрос;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Должники.Должник
	|ИЗ
	|	" + ИмяТаблицы + " КАК Должники";
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции // ПолучитьВиртуальнуюТаблицу()

// ИсключитьАрхивныхДолжников
Функция ИсключитьАрхивныхДолжников(ТаблицаДолжников, Момент) Экспорт
	Перем Запрос;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПривязкаОтделСрезПоследних.Должник
	|ИЗ
	|	РегистрСведений.ПривязкаОтдел.СрезПоследних(
	|			&Момент,
	|			Должник В (&СписокДолжников)
	|				И Отдел.РольОтдела <> &Архив) КАК ПривязкаОтделСрезПоследних";
	
	СписокДолжников = ТаблицаДолжников.ВыгрузитьКолонку("Должник");
	
	Запрос.УстановитьПараметр("Момент", 			Момент);
	Запрос.УстановитьПараметр("СписокДолжников", 	СписокДолжников);
	Запрос.УстановитьПараметр("Архив", 				Перечисления.РольОтдела.Архив);
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции // ИсключитьАрхивныхДолжников()

// ВТ ДолжникиОтдела
Процедура ДобавитьВиртуальнуюТаблицуДолжниковВОтделе(МенеджерВременныхТаблиц, Отдел, Момент, СвободныйПул = Ложь, ТаблицаДолжников = 0) Экспорт
	Перем Запрос;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Если ТаблицаДолжников = 0 Тогда
		Условие = "";
	ИначеЕсли НЕ ТаблицаДолжников.Количество() = 0 Тогда
		Условие = " Должник В (&Список)"; 
		Запрос.УстановитьПараметр("Список", ТаблицаДолжников.ВыгрузитьКолонку("Должник"));
	КонецЕсли; 	
	               
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПривязкаОтделСрезПоследних.Должник,
	|	ПривязкаОтделСрезПоследних.Отдел
	|ПОМЕСТИТЬ ДолжникиОтдела
	|ИЗ
	|	РегистрСведений.ПривязкаОтдел.СрезПоследних(&Момент, " + Условие + " ) КАК ПривязкаОтделСрезПоследних
	|ГДЕ
	|	ПривязкаОтделСрезПоследних.СвободныйПул = &СвободныйПул
	|	И ПривязкаОтделСрезПоследних.Отдел = &Отдел";
	
	Запрос.УстановитьПараметр("Момент", 		Момент);
	Запрос.УстановитьПараметр("Отдел", 			Отдел);
	Запрос.УстановитьПараметр("СвободныйПул", 	СвободныйПул);
	
    Запрос.Выполнить();
КонецПроцедуры // ДобавитьВиртуальнуюТаблицуДолжниковВОтделе()

// ВТ ДолжникиСотрудника
Процедура ДобавитьВиртуальнуюТаблицуДолжниковСотрудника(МенеджерВременныхТаблиц, Сотрудник, Момент, ТаблицаДолжников = 0) Экспорт
	Перем Запрос;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Если ТаблицаДолжников = 0 Тогда
		Условие = "";
	ИначеЕсли НЕ ТаблицаДолжников.Количество() = 0 Тогда
		Условие = " Должник В (&Список)"; 
		Запрос.УстановитьПараметр("Список", ТаблицаДолжников.ВыгрузитьКолонку("Должник"));
	КонецЕсли; 	
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПривязкаСотрудникСрезПоследних.Должник,
	|	ПривязкаСотрудникСрезПоследних.Сотрудник
	|ПОМЕСТИТЬ ДолжникиСотрудника
	|ИЗ
	|	РегистрСведений.ПривязкаСотрудник.СрезПоследних(&Момент, " + Условие + ") КАК ПривязкаСотрудникСрезПоследних
	|ГДЕ
	|	ПривязкаСотрудникСрезПоследних.Сотрудник = &Сотрудник";
	
	Запрос.УстановитьПараметр("Момент", 	Момент);
	Запрос.УстановитьПараметр("Сотрудник", 	Сотрудник);
	
    Запрос.Выполнить();
КонецПроцедуры // ДобавитьВиртуальнуюТаблицуДолжниковСотрудника()

Процедура ДобавитьВиртуальнуюТаблицуДолжниковСотрудникаНеАрхивные(МенеджерВременныхТаблиц, Сотрудник, Момент, ТаблицаДолжников = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ПривязкаСотрудникСрезПоследних.Должник КАК Должник,
	|	ПривязкаСотрудникСрезПоследних.Сотрудник КАК Сотрудник,
	|	ПривязкаСотрудникСрезПоследних.СотрМенеджер КАК СотрМенеджер
	|ПОМЕСТИТЬ ДолжникиСотрудника
	|ИЗ
	|	РегистрСведений.ПривязкаСотрудник.СрезПоследних(&Момент, Должник В (&СписокДолжников)) КАК ПривязкаСотрудникСрезПоследних
	|ГДЕ
	|	(ПривязкаСотрудникСрезПоследних.Сотрудник = &Сотрудник
	|			ИЛИ ПривязкаСотрудникСрезПоследних.СотрМенеджер = &Сотрудник)";
	
	Запрос.УстановитьПараметр("Момент", Момент);
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Если ТаблицаДолжников = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Должник В (&СписокДолжников)", "");
	Иначе
		Запрос.УстановитьПараметр("СписокДолжников", ТаблицаДолжников.ВыгрузитьКолонку("Должник"));
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.Выполнить();
	
КонецПроцедуры // ДобавитьВиртуальнуюТаблицуДолжниковСотрудника()

// ВТ ДолжникиРегиона
Процедура ДобавитьВиртуальнуюТаблицуДолжниковРегиона(МенеджерВременныхТаблиц, Регион, ТаблицаДолжников = 0) Экспорт
	Перем Запрос;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Если ТаблицаДолжников = 0 Тогда
		Условие = "";
	ИначеЕсли НЕ ТаблицаДолжников.Количество() = 0 Тогда
		Условие = " И Должники.Ссылка В (&Список)"; 
		Запрос.УстановитьПараметр("Список", ТаблицаДолжников.ВыгрузитьКолонку("Должник"));
	КонецЕсли; 	
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Должники.Ссылка КАК Должник
	|ПОМЕСТИТЬ ДолжникиРегиона
	|ИЗ
	|	Справочник.Должники КАК Должники
	|ГДЕ
	|	Должники.Регион = &Регион " + Условие;
	
	Запрос.УстановитьПараметр("Регион", 	Регион);
	
    Запрос.Выполнить();
КонецПроцедуры // ДобавитьВиртуальнуюТаблицуДолжниковРегиона()

// ВТ ДолжникиРеестра
Процедура ДобавитьВиртуальнуюТаблицуДолжниковРеестра(МенеджерВременныхТаблиц, Реестр, ТаблицаДолжников = 0) Экспорт
	Перем Запрос;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Если ТаблицаДолжников = 0 Тогда
		Условие = "";
	ИначеЕсли НЕ ТаблицаДолжников.Количество() = 0 Тогда
		Условие = " РеестрДолжники.Должник В (&Список)"; 
		Запрос.УстановитьПараметр("Список", ТаблицаДолжников.ВыгрузитьКолонку("Должник"));
	КонецЕсли; 	
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеестрДолжники.Должник
	|ПОМЕСТИТЬ ДолжникиРеестра
	|ИЗ
	|	Документ.Реестр.Должники КАК РеестрДолжники
	|ГДЕ
	|	РеестрДолжники.Ссылка = &Реестр " + Условие;
	
	Запрос.УстановитьПараметр("Реестр", 	Реестр);
	
    Запрос.Выполнить();
КонецПроцедуры // ДобавитьВиртуальнуюТаблицуДолжниковРеестра()

// ВТ КоличествоКонтактовДолжников
Процедура ДобавитьВиртуальнуюТаблицуКоличествоКонтактовДолжников(МенеджерВременныхТаблиц, НазваниеВременнойТаблицыДолжников, Момент) Экспорт
	Перем Запрос;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонтактыОбороты.ВсегоОборот КАК КоличествоКонтактов,
	|	КонтактыОбороты.РезультативныхОборот КАК КоличествоРезультативныхКонтактов,
	|	КонтактыОбороты.Должник
	|ПОМЕСТИТЬ КоличествоКонтактовДолжников
	|ИЗ
	|	" + НазваниеВременнойТаблицыДолжников + " КАК ВременнаяДолжники 
	//|	ВременнаяДолжники КАК ВременнаяДолжники
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Контакты.Обороты(, &Момент, , ) КАК КонтактыОбороты
	|		ПО ВременнаяДолжники.Должник = КонтактыОбороты.Должник";
	
	
	Запрос.УстановитьПараметр("Момент", Момент);
	
	Запрос.Выполнить();
КонецПроцедуры // ДобавитьВиртуальнуюТаблицуДолжниковРеестра()

// ВТ ПланированиеКонтактов
Процедура ДобавитьВиртуальнуюТаблицуПланированиеКонтактов(МенеджерВременныхТаблиц, НазваниеВременнойТаблицыДолжников, Момент) Экспорт
	Перем Запрос;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПланированиеКонтактовСрезПоследних.Должник,
	|	ПланированиеКонтактовСрезПоследних.ДатаПланирования,
	|	ПланированиеКонтактовСрезПоследних.Сотрудник,
	|	ПланированиеКонтактовСрезПоследних.ТипКонтакта
	|ПОМЕСТИТЬ КоличествоКонтактовДолжников
	|ИЗ
	|	" + НазваниеВременнойТаблицыДолжников + " КАК ВременнаяДолжники
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПланированиеКонтактов.СрезПоследних КАК ПланированиеКонтактовСрезПоследних
	|		ПО ВременнаяДолжники.Должник = ПланированиеКонтактовСрезПоследних.Должник";
	
//	|	" + НазваниеВременнойТаблицыДолжников + " КАК " + НазваниеВременнойТаблицыДолжников + "
	
	Запрос.УстановитьПараметр("Момент", Момент);
	
	Запрос.Выполнить();
КонецПроцедуры // ДобавитьВиртуальнуюТаблицуДолжниковРеестра()

// ВТ ДолжникиОтветственного
Процедура ДобавитьВиртуальнуюТаблицуДолжниковОтветственного(МенеджерВременныхТаблиц, Сотрудник, Момент, ТаблицаДолжников = 0) Экспорт
	Перем Запрос;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Если ТаблицаДолжников = 0 Тогда
		Условие = "";
	ИначеЕсли НЕ ТаблицаДолжников.Количество() = 0 Тогда
		Условие = " Должник В (&Список)"; 
		Запрос.УстановитьПараметр("Список", ТаблицаДолжников.ВыгрузитьКолонку("Должник"));
	КонецЕсли; 	
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПривязкаОтветственныйСрезПоследних.Должник,
	|	ПривязкаОтветственныйСрезПоследних.Ответственный
	|ПОМЕСТИТЬ ДолжникиОтветственного
	|ИЗ
	|	РегистрСведений.ПривязкаОтветственный.СрезПоследних(&Момент, " + Условие + ") КАК ПривязкаОтветственныйСрезПоследних
	|ГДЕ
	|	ПривязкаОтветственныйСрезПоследних.Ответственный = &Сотрудник";
	
	Запрос.УстановитьПараметр("Момент", 	Момент);
	Запрос.УстановитьПараметр("Сотрудник", 	Сотрудник);
	
    Запрос.Выполнить();
КонецПроцедуры // ДобавитьВиртуальнуюТаблицуДолжниковОтветственного()
