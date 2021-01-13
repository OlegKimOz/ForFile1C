﻿
// Устанавливает параметры загрузки данных из файла
//
// Параметры:
//     Параметры - Структура - Список параметров. Поля: 
//         * Заголовок - Строка - Заголовок окна 
//         * ОбязательныеКолонки -  Массив - Список имен колонок, обязательных для заполнения
//         * ТипДанныхКолонки - Соответствие, Ключ - Имя колонки, Значение - Описание типа данных 
//
Процедура ОпределитьПараметрыЗагрузкиДанныхИзФайла(Параметры) Экспорт
	
	Параметры.Заголовок = НСтр("ru = 'Загрузка из ЛК почты.'");
	
	ОписаниеТипаНаименование =  Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(255));
	Параметры.ТипДанныхКолонки.Вставить("НаименованиеАдресат", ОписаниеТипаНаименование);
	
КонецПроцедуры

// Производит сопоставление загружаемых данных с данными в ИБ.
//
// Параметры:
//   ЗагружаемыеДанные - ТаблицаЗначений - таблица значений с загружаемыми данными:
//     * СопоставленныйОбъект - СправочникСсылка - Ссылка на сопоставленный объект. Заполняется внутри процедуры
//     * <другие колонки>     - Произвольный - Состав колонок соответствует макету "ЗагрузкаИзФайла"
//
Процедура СопоставитьЗагружаемыеДанныеИзФайла(ЗагружаемыеДанные) Экспорт
	
КонецПроцедуры

// Загрузка данных из файла
//
// Параметры:
//   ЗагружаемыеДанные - ТаблицаЗначений с колонками:
//     * СопоставленныйОбъект         - СправочникСсылка - Ссылка на сопоставленный объект
//     * РезультатСопоставленияСтроки - Строка       - Cтатусом загрузки, возможны варианты: Создан, Обновлен, Пропущен   
//     * ОписаниеОшибки               - Строка       - расшифровка ошибки загрузки данных
//     * Идентификатор                - Число        - Уникальный номер строки 
//     * <другие колонки>             - Произвольный - Строки загружаемого файла в соответствии с макетом
// ПараметрыЗагрузки                  - Структура    - Параметры загрузки
//     * СоздаватьНовые               - Булево       - Требуется ли создавать новые элементы справочника
//     * ОбновлятьСуществующие        - Булево       - Требуется ли обновлять элементы справочника
// Отказ                              - Булево       - Отмена загрузки
Процедура ЗагрузитьИзФайла(ЗагружаемыеДанные, ПараметрыЗагрузки, Отказ) Экспорт
	
	Для Каждого Строка Из ЗагружаемыеДанные Цикл
		Если Строка = Истина Тогда
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры