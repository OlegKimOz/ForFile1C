﻿Функция ПолучитьДоговорыДолжника(Должник) Экспорт
	Перем Запрос, Договоры;
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Договоры.Ссылка КАК Договор
	|ИЗ
	|	Справочник.Договоры КАК Договоры
	|ГДЕ
	|	Договоры.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец", Должник);
	
	МассивДоговоров = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Договор");
	
	// Список значений делаем для отборов
	Договоры = Новый СписокЗначений;
	Договоры.ЗагрузитьЗначения(МассивДоговоров);
	
	Возврат Договоры;
КонецФункции // ПолучитьДоговорыДолжника()
 
Функция ПолучитьДанныеДоговоров(Должник, Момент) Экспорт
	Перем Запрос;
	Запрос = Новый Запрос;
	
	Договоры = ПолучитьДоговорыДолжника(Должник);
	
	тзТемп = Новый ТаблицаЗначений; 
	массивРез=Новый Массив;
	
	Для каждого дог Из Договоры Цикл
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ДанныеДоговоровСрезПоследних.Договор КАК Договор,
			|	ДанныеДоговоровСрезПоследних.ВсегоЗадолженность КАК ВсегоЗадолженность,
			|	ДанныеДоговоровСрезПоследних.ДатаРасчетаЗадолженности КАК ДатаРасчетаЗадолженности,
			|	ДанныеДоговоровСрезПоследних.ДнейПросрочки КАК ДнейПросрочки
			|ИЗ
			|	РегистрСведений.ДанныеДоговоров.СрезПоследних(, Договор = &Договор) КАК ДанныеДоговоровСрезПоследних
			|
			|УПОРЯДОЧИТЬ ПО
			|	ДанныеДоговоровСрезПоследних.Период УБЫВ,
			|	ДанныеДоговоровСрезПоследних.НомерСтроки УБЫВ";
		
		Запрос.УстановитьПараметр("Договор", дог.Значение);
		
		РезультатЗапроса = Запрос.Выполнить();
		ТЗ = РезультатЗапроса.Выгрузить();
		
		массивИсточник = ОбщегоНазначения.ТаблицаЗначенийВМассив(ТЗ);
		
		ОбщегоНазначения.ЗаполнитьМассивУникальнымиЗначениями(массивРез, МассивИсточник);
	КонецЦикла;
	
	
	
	//
	//Запрос.Текст = 
	//"ВЫБРАТЬ
	//|	ДанныеДоговоровСрезПоследних.Договор КАК Договор,
	//|	ДанныеДоговоровСрезПоследних.ВсегоЗадолженность КАК ВсегоЗадолженность,
	//|	ДанныеДоговоровСрезПоследних.ДатаРасчетаЗадолженности КАК ДатаРасчетаЗадолженности,
	//|	ДанныеДоговоровСрезПоследних.ДнейПросрочки КАК ДнейПросрочки
	//|ИЗ
	//|	РегистрСведений.ДанныеДоговоров.СрезПоследних(&Момент, Договор В (&Договоры)) КАК ДанныеДоговоровСрезПоследних";
	//
	//Запрос.УстановитьПараметр("Момент", 	Момент);
	//Запрос.УстановитьПараметр("Договоры", 	Договоры);
	//
	//РезультатЗапроса = Запрос.Выполнить();
	//ТЗ = РезультатЗапроса.Выгрузить();
	//
	//
	
	
	Результат = "";
	Для каждого СтрокаТЗ Из массивРез Цикл
		Результат = Результат + ?(ПустаяСтрока(Результат), "", "*) ");
		//Павлов А.О.
		Если СтрокаТЗ.Договор.Статус = Перечисления.СтатусыДоговоров.Архив Тогда
			Продолжить;
			//Результат = Результат + "АРХИВ " + СокрЛП(СтрокаТЗ.Договор.Наименование) + Символы.ПС;
		ИначеЕсли СтрокаТЗ.Договор.Статус = Перечисления.СтатусыДоговоров.Предархив Тогда
			Результат = Результат + "Предархив " + СокрЛП(СтрокаТЗ.Договор.Наименование) + Символы.ПС;
		Иначе
			Результат = Результат + СокрЛП(СтрокаТЗ.Договор.Наименование) + Символы.ПС;		
		КонецЕсли;
		//Павлов А.О.
		//Результат = Результат + СокрЛП(СтрокаТЗ.Договор.Наименование) + Символы.ПС;
	    Результат = Результат + "Всего задолженность: " + СтроковыеФункцииКлиентСервер.глФорматЧ(СтрокаТЗ.ВсегоЗадолженность) +" "+ СтрокаТз.Договор.Валюта + Символы.ПС;
	    Результат = Результат + "Дней просрочки: " + Строка(СтрокаТЗ.ДнейПросрочки) + Символы.ПС;
	    Результат = Результат + "Дата расчёта: " + Формат(СтрокаТЗ.ДатаРасчетаЗадолженности, "ДЛФ=DD; ДП=-") + Символы.ПС;
	КонецЦикла; 
	
	Возврат Результат;
КонецФункции // ПолучитьДанныеДоговоров()

Функция ПолучитьДанныеПривязки(Должник, Момент, Архивный) Экспорт
    Перем Результат;
	
	ТекущийОтдел = Привязка.ПолучитьОтдел(Должник, Момент);
	
	Результат = "Статус: " + Привязка.ПолучитьСтатусДолжника(Должник, Момент);
	//Результат = Результат + Символы.ПС + "Ответственный: " + Привязка.ПолучитьОтветственного(Должник, Момент);
	Результат = Результат + Символы.ПС + "Отдел: " + ТекущийОтдел;
	Результат = Результат + Символы.ПС + "Сотрудник: " + Привязка.ПолучитьСотрудника(Должник, Момент);

	Архивный = ?(ТекущийОтдел.РольОтдела = Перечисления.РольОтдела.Архив, Истина, Ложь);
	
	Возврат Результат;
КонецФункции // ПолучитьДанныеПривязки()

Функция СтатистикаОператора(Сотрудник, Дата) Экспорт
    Перем Запрос, тзСтатистика;
	Запрос = Новый Запрос;
	
	//Запрос.Текст = 
	//"ВЫБРАТЬ
	//|	ОбещанияОбороты_День.СуммаОборот КАК Обещаний_День,
	//|	КонтактыОбороты_День.ВсегоОборот КАК Контактов_День,
	//|	КонтактыОбороты_День.РезультативныхОборот КАК Результативных_День,
	//|	КонтактыОбороты_Месяц.ВсегоОборот КАК Контактов_Месяц,
	//|	КонтактыОбороты_Месяц.РезультативныхОборот КАК Результативных_Месяц,
	//|	ОбещанияОбороты_Месяц.СуммаОборот КАК Обещаний_Месяц,
	//|	НормыДляОтделовСрезПоследних.Дневная_КоличествоКонтактов КАК ДневнаяНорма_КоличествоКонтактов,
	//|	НормыДляОтделовСрезПоследних.Месячная_КоличествоКонтактов КАК МесячнаяНорма_КоличествоКонтактов,
	//|	НормыДляОтделовСрезПоследних.Дневная_КоличествоДолжников КАК ДневнаяНорма_КоличествоДолжников,
	//|	НормыДляОтделовСрезПоследних.Месячная_КоличествоДолжников КАК МесячнаяНорма_КоличествоДолжников,
	//|	КонтактыОбороты_День.НетКонтактаОборот КАК НетКонтакта_День,
	//|	КонтактыОбороты_День.ОставленаИнформацияОборот КАК ОставленаИнформация_День,
	//|	КонтактыОбороты_Месяц.НетКонтактаОборот КАК НетКонтакта_Месяц,
	//|	КонтактыОбороты_Месяц.ОставленаИнформацияОборот КАК ОставленаИнформация_Месяц,
	//|	ПередачиОбороты_День.ПолучилОборот КАК Получил_День,
	//|	ПередачиОбороты_День.ПередалОборот КАК Передал_День,
	//|	ПередачиОбороты_Месяц.ПолучилОборот КАК Получил_Месяц,
	//|	ПередачиОбороты_Месяц.ПередалОборот КАК Передал_Месяц
	//|ИЗ
	//|	РегистрНакопления.Обещания.Обороты(&Начало, &Конец, , Сотрудник = &Сотрудник) КАК ОбещанияОбороты_День,
	//|	РегистрНакопления.Обещания.Обороты(&НачалоМесяца, &КонецМесяца, , Сотрудник = &Сотрудник) КАК ОбещанияОбороты_Месяц,
	//|	РегистрНакопления.Контакты.Обороты(&НачалоМесяца, &КонецМесяца, , Сотрудник = &Сотрудник) КАК КонтактыОбороты_Месяц,
	//|	РегистрНакопления.Контакты.Обороты(&Начало, &Конец, , Сотрудник = &Сотрудник) КАК КонтактыОбороты_День,
	//|	РегистрСведений.НормыДляОтделов.СрезПоследних(&Конец, Отдел = &Отдел) КАК НормыДляОтделовСрезПоследних,
	//|	РегистрНакопления.Передачи.Обороты(&Начало, &Конец, , Сотрудник = &Сотрудник) КАК ПередачиОбороты_День,
	//|	РегистрНакопления.Передачи.Обороты(&НачалоМесяца, &КонецМесяца, , Сотрудник = &Сотрудник) КАК ПередачиОбороты_Месяц
	//|";
	//
	//Запрос.УстановитьПараметр("Начало", 		НачалоДня(Дата));
	//Запрос.УстановитьПараметр("Конец", 			КонецДня(Дата));
	//Запрос.УстановитьПараметр("НачалоМесяца", 	НачалоМесяца(Дата));
	//Запрос.УстановитьПараметр("КонецМесяца", 	КонецМесяца(Дата));
	//Запрос.УстановитьПараметр("Сотрудник", 		Сотрудник);
	//Запрос.УстановитьПараметр("Отдел", 			Привязка.ПолучитьОтделСотрудника(Сотрудник, Дата));
	//
	//тзСтатистика = Запрос.Выполнить().Выгрузить();
	
	ОтделСотрудника = Привязка.ПолучитьОтделСотрудника(Сотрудник, Дата);
	
// Обещания
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОбещанияОбороты_День.СуммаОборот КАК Обещаний_День,
	|	ОбещанияОбороты_Месяц.СуммаОборот КАК Обещаний_Месяц,
	|	ОбещанияОбороты_День.ПодтвержденоОборот КАК Подтверждено_День,
	|	ОбещанияОбороты_Месяц.ПодтвержденоОборот КАК Подтверждено_Месяц
	|ИЗ
	|	РегистрНакопления.Обещания.Обороты(&Начало, &Конец, , Сотрудник = &Сотрудник) КАК ОбещанияОбороты_День,
	|	РегистрНакопления.Обещания.Обороты(&НачалоМесяца, &КонецМесяца, , Сотрудник = &Сотрудник) КАК ОбещанияОбороты_Месяц";
	
	Запрос.УстановитьПараметр("Начало", 		НачалоДня(Дата));
	Запрос.УстановитьПараметр("Конец", 			КонецДня(Дата));
	Запрос.УстановитьПараметр("НачалоМесяца", 	НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецМесяца", 	КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Сотрудник", 		Сотрудник);
	Запрос.УстановитьПараметр("Отдел", 			ОтделСотрудника);
	
	тзСтатистика = Запрос.Выполнить().Выгрузить();
	
	Если тзСтатистика.Количество() = 0 Тогда
		тзСтатистика.Добавить();
	КонецЕсли;
	
// Контакты
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонтактыОбороты_День.ВсегоОборот КАК Контактов_День,
	|	КонтактыОбороты_День.РезультативныхОборот КАК Результативных_День,
	|	КонтактыОбороты_Месяц.ВсегоОборот КАК Контактов_Месяц,
	|	КонтактыОбороты_Месяц.РезультативныхОборот КАК Результативных_Месяц,
	|	КонтактыОбороты_День.НетКонтактаОборот КАК НетКонтакта_День,
	|	КонтактыОбороты_День.ОставленаИнформацияОборот КАК ОставленаИнформация_День,
	|	КонтактыОбороты_Месяц.НетКонтактаОборот КАК НетКонтакта_Месяц,
	|	КонтактыОбороты_Месяц.ОставленаИнформацияОборот КАК ОставленаИнформация_Месяц
	|ИЗ
	|	РегистрНакопления.Контакты.Обороты(&НачалоМесяца, &КонецМесяца, , Сотрудник = &Сотрудник) КАК КонтактыОбороты_Месяц,
	|	РегистрНакопления.Контакты.Обороты(&Начало, &Конец, , Сотрудник = &Сотрудник) КАК КонтактыОбороты_День
	|";
	
	Запрос.УстановитьПараметр("Начало", 		НачалоДня(Дата));
	Запрос.УстановитьПараметр("Конец", 			КонецДня(Дата));
	Запрос.УстановитьПараметр("НачалоМесяца", 	НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецМесяца", 	КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Сотрудник", 		Сотрудник);
	Запрос.УстановитьПараметр("Отдел", 			ОтделСотрудника);
	
	тз = Запрос.Выполнить().Выгрузить();
	
	тзСтатистика.Колонки.Добавить("Контактов_День");
	тзСтатистика.Колонки.Добавить("Результативных_День");
	тзСтатистика.Колонки.Добавить("Контактов_Месяц");
	тзСтатистика.Колонки.Добавить("Результативных_Месяц");
	тзСтатистика.Колонки.Добавить("НетКонтакта_День");
	тзСтатистика.Колонки.Добавить("ОставленаИнформация_День");
	тзСтатистика.Колонки.Добавить("НетКонтакта_Месяц");
	тзСтатистика.Колонки.Добавить("ОставленаИнформация_Месяц");
	
	Если НЕ тз.Количество() = 0 Тогда
		тзСтатистика[0].Контактов_День 				= тз[0].Контактов_День;
		тзСтатистика[0].Результативных_День 		= тз[0].Результативных_День;
		тзСтатистика[0].Контактов_Месяц 			= тз[0].Контактов_Месяц;
		тзСтатистика[0].Результативных_Месяц 		= тз[0].Результативных_Месяц;
		тзСтатистика[0].НетКонтакта_День 			= тз[0].НетКонтакта_День;
		тзСтатистика[0].ОставленаИнформация_День 	= тз[0].ОставленаИнформация_День;
		тзСтатистика[0].НетКонтакта_Месяц 			= тз[0].НетКонтакта_Месяц;
		тзСтатистика[0].ОставленаИнформация_Месяц 	= тз[0].ОставленаИнформация_Месяц;
	КонецЕсли; 
	
// НормыДляОтделов
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НормыДляОтделовСрезПоследних.Дневная_КоличествоКонтактов КАК ДневнаяНорма_КоличествоКонтактов,
	|	НормыДляОтделовСрезПоследних.Месячная_КоличествоКонтактов КАК МесячнаяНорма_КоличествоКонтактов,
	|	НормыДляОтделовСрезПоследних.Дневная_КоличествоДолжников КАК ДневнаяНорма_КоличествоДолжников,
	|	НормыДляОтделовСрезПоследних.Месячная_КоличествоДолжников КАК МесячнаяНорма_КоличествоДолжников
	|ИЗ
	|	РегистрСведений.НормыДляОтделов.СрезПоследних(&Конец, Отдел = &Отдел) КАК НормыДляОтделовСрезПоследних
	|";
	
	Запрос.УстановитьПараметр("Начало", 		НачалоДня(Дата));
	Запрос.УстановитьПараметр("Конец", 			КонецДня(Дата));
	Запрос.УстановитьПараметр("НачалоМесяца", 	НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецМесяца", 	КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Сотрудник", 		Сотрудник);
	Запрос.УстановитьПараметр("Отдел", 			ОтделСотрудника);
	
	тз = Запрос.Выполнить().Выгрузить();
	
	тзСтатистика.Колонки.Добавить("ДневнаяНорма_КоличествоКонтактов");
	тзСтатистика.Колонки.Добавить("МесячнаяНорма_КоличествоКонтактов");
	тзСтатистика.Колонки.Добавить("ДневнаяНорма_КоличествоДолжников");
	тзСтатистика.Колонки.Добавить("МесячнаяНорма_КоличествоДолжников");
	
	Если НЕ тз.Количество() = 0 Тогда
		тзСтатистика[0].ДневнаяНорма_КоличествоКонтактов 	= тз[0].ДневнаяНорма_КоличествоКонтактов;
		тзСтатистика[0].МесячнаяНорма_КоличествоКонтактов 	= тз[0].МесячнаяНорма_КоличествоКонтактов;
		тзСтатистика[0].ДневнаяНорма_КоличествоДолжников 	= тз[0].ДневнаяНорма_КоличествоДолжников;
		тзСтатистика[0].МесячнаяНорма_КоличествоДолжников 	= тз[0].МесячнаяНорма_КоличествоДолжников;
	КонецЕсли; 
	
// Передачи
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПередачиОбороты_День.ПолучилОборот КАК Получил_День,
	|	ПередачиОбороты_День.ПередалОборот КАК Передал_День,
	|	ПередачиОбороты_Месяц.ПолучилОборот КАК Получил_Месяц,
	|	ПередачиОбороты_Месяц.ПередалОборот КАК Передал_Месяц
	|ИЗ
	|	РегистрНакопления.Передачи.Обороты(&Начало, &Конец, , Сотрудник = &Сотрудник) КАК ПередачиОбороты_День,
	|	РегистрНакопления.Передачи.Обороты(&НачалоМесяца, &КонецМесяца, , Сотрудник = &Сотрудник) КАК ПередачиОбороты_Месяц
	|";
	
	Запрос.УстановитьПараметр("Начало", 		НачалоДня(Дата));
	Запрос.УстановитьПараметр("Конец", 			КонецДня(Дата));
	Запрос.УстановитьПараметр("НачалоМесяца", 	НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецМесяца", 	КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Сотрудник", 		Сотрудник);
	Запрос.УстановитьПараметр("Отдел", 			ОтделСотрудника);
	
	тз = Запрос.Выполнить().Выгрузить();
	
	тзСтатистика.Колонки.Добавить("Получил_День");
	тзСтатистика.Колонки.Добавить("Передал_День");
	тзСтатистика.Колонки.Добавить("Получил_Месяц");
	тзСтатистика.Колонки.Добавить("Передал_Месяц");
	
	Если НЕ тз.Количество() = 0 Тогда
		тзСтатистика[0].Получил_День 	= тз[0].Получил_День;
		тзСтатистика[0].Передал_День 	= тз[0].Передал_День;
		тзСтатистика[0].Получил_Месяц 	= тз[0].Получил_Месяц;
		тзСтатистика[0].Передал_Месяц 	= тз[0].Передал_Месяц;
	КонецЕсли; 
	
	// Платежи
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПлатежиОбороты_День.СуммаОборот КАК Платежей_День,
	|	ПлатежиОбороты_Месяц.СуммаОборот КАК Платежей_Месяц
	|ИЗ
	|	РегистрНакопления.Платежи.Обороты(&Начало, &Конец, , Ответственный = &Сотрудник) КАК ПлатежиОбороты_День,
	|	РегистрНакопления.Платежи.Обороты(&НачалоМесяца, &КонецМесяца, , Ответственный = &Сотрудник) КАК ПлатежиОбороты_Месяц";
	
	Запрос.УстановитьПараметр("Начало", 		НачалоДня(Дата));
	Запрос.УстановитьПараметр("Конец", 			КонецДня(Дата));
	Запрос.УстановитьПараметр("НачалоМесяца", 	НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецМесяца", 	КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Сотрудник", 		Сотрудник);
	
	тз = Запрос.Выполнить().Выгрузить();
	
	тзСтатистика.Колонки.Добавить("Платежей_День");
	тзСтатистика.Колонки.Добавить("Платежей_Месяц");
	
	Если НЕ тз.Количество() = 0 Тогда
		тзСтатистика[0].Платежей_День 	= тз[0].Платежей_День;
		тзСтатистика[0].Платежей_Месяц 	= тз[0].Платежей_Месяц;
	КонецЕсли; 
	
	// Должников
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонтактыДокументыОбороты_День.ВсегоОборот КАК Должников_День,
	|	КонтактыДокументыОбороты_Месяц.ВсегоОборот КАК Должников_Месяц
	|ИЗ
	|	РегистрНакопления.КонтактыДокументы.Обороты(&Начало, &Конец, , Сотрудник = &Сотрудник) КАК КонтактыДокументыОбороты_День,
	|	РегистрНакопления.КонтактыДокументы.Обороты(&НачалоМесяца, &КонецМесяца, , Сотрудник = &Сотрудник) КАК КонтактыДокументыОбороты_Месяц";
	
	Запрос.УстановитьПараметр("Начало", 		НачалоДня(Дата));
	Запрос.УстановитьПараметр("Конец", 			КонецДня(Дата));
	Запрос.УстановитьПараметр("НачалоМесяца", 	НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецМесяца", 	КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Сотрудник", 		Сотрудник);
	
	тз = Запрос.Выполнить().Выгрузить();
	
	тзСтатистика.Колонки.Добавить("Должников_День");
	тзСтатистика.Колонки.Добавить("Должников_Месяц");
	
	Если НЕ тз.Количество() = 0 Тогда
		тзСтатистика[0].Должников_День 		= тз[0].Должников_День;
		тзСтатистика[0].Должников_Месяц 	= тз[0].Должников_Месяц;
	КонецЕсли; 
	
	Возврат тзСтатистика;
КонецФункции // СтатистикаОператора()

Функция ПолучитьДневнуюНорму(Дата, Отдел) Экспорт
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НормыДляОтделовСрезПоследних.Дневная_КоличествоКонтактов КАК ДневнаяНорма_КоличествоКонтактов
	|ИЗ
	|	РегистрСведений.НормыДляОтделов.СрезПоследних(&Конец, Отдел = &Отдел) КАК НормыДляОтделовСрезПоследних
	|";
	
	Запрос.УстановитьПараметр("Конец", Дата);
	Запрос.УстановитьПараметр("Отдел", Отдел);
	
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		Возврат Выборка.ДневнаяНорма_КоличествоКонтактов;
	КонецЕсли; 
	
	Возврат 0;
КонецФункции // ПолучитьДневнуюНорму()

Функция ПолучитьКоличествоКонтактовВДень(Дата, Сотрудник) Экспорт
	Перем Запрос;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонтактыОбороты_День.ВсегоОборот КАК Контактов_День
	|ИЗ
	|	РегистрНакопления.Контакты.Обороты(&Начало, &Конец, , Сотрудник = &Сотрудник) КАК КонтактыОбороты_День
	|";
	
	Запрос.УстановитьПараметр("Начало", 		НачалоДня(Дата));
	Запрос.УстановитьПараметр("Конец", 			КонецДня(Дата));
	Запрос.УстановитьПараметр("Сотрудник", 		Сотрудник);
	
	тз = Запрос.Выполнить().Выгрузить();
	
	Если НЕ тз.Количество() = 0 Тогда
		Возврат тз[0].Контактов_День;
	КонецЕсли; 
	
	Возврат 0;
КонецФункции // ПолучитьДневнуюНорму()

Функция ПолучитьТаблицуДанныхПоДоговорам(СписокДолжников, Момент) Экспорт
	Перем Запрос;
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(ДанныеДоговоровСрезПоследних.ТекущийОсновнойДолг) КАК ТекущийОсновнойДолг,
	|	СУММА(ДанныеДоговоровСрезПоследних.ВсегоЗадолженность) КАК ВсегоЗадолженность,
	|	СУММА(ДанныеДоговоровСрезПоследних.ПросроченныеПроценты) КАК ПросроченныеПроценты,
	|	СУММА(ДанныеДоговоровСрезПоследних.ПросроченныйОсновнойДолг) КАК ПросроченныйОсновнойДолг,
	|	СУММА(ДанныеДоговоровСрезПоследних.Неустойка) КАК Неустойка,
	|	ДанныеДоговоровСрезПоследних.ДатаРасчетаЗадолженности,
	|	СУММА(ДанныеДоговоровСрезПоследних.ДнейПросрочки) КАК ДнейПросрочки,
	|	ДанныеДоговоровСрезПоследних.Договор.Владелец КАК Должник,
	|	СУММА(ДанныеДоговоровСрезПоследних.ТекущиеПроценты) КАК ТекущиеПроценты,
	|	СУММА(ДанныеДоговоровСрезПоследних.Госпошлина) КАК Госпошлина,
	|	СУММА(ДанныеДоговоровСрезПоследних.Прочее) КАК Прочее
	|ИЗ
	|	РегистрСведений.ДанныеДоговоров.СрезПоследних(&Момент, Договор.Владелец В (&СписокДолжников)) КАК ДанныеДоговоровСрезПоследних
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДоговоровСрезПоследних.Договор.Владелец,
	|	ДанныеДоговоровСрезПоследних.ДатаРасчетаЗадолженности";
	
	Запрос.УстановитьПараметр("Момент", 			Момент);
	Запрос.УстановитьПараметр("СписокДолжников", 	СписокДолжников);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
КонецФункции // ПолучитьДанныеДоговоров()
