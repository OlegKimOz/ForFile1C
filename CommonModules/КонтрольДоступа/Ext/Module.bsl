﻿// Возвращает истину, если у текущего пользователя есть роль администратора
Функция глАдминистратор() Экспорт
	ТекПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	Возврат ТекПользователь.Роли.Содержит(Метаданные.Роли.Администратор);
КонецФункции // глАдминистратор()


Функция ДоступностьИзмененийПоДатеЗапрета(Дата) Экспорт
	
	Если РольДоступна("Оператор") И НачалоДня(Дата) < НачалоДня(ТекущаяДата()) тогда
		Сообщить("Редактирование документов задним числом запрещено!");
		Возврат Истина;
	КонецЕсли;
	
	
	
	
	Если (КонецДня(Константы.ДатаЗапретаИзменения.Получить()) >= Дата) И Не РольДоступна("ДатаЗапрета") тогда
		Сообщить("Редактирование этого периода запрещено!");
		Возврат Истина;
		
	Иначе
		возврат Ложь;
	КонецЕсли;
	
КонецФункции

//Должники ИЗ РегистрСведений.ПривязкаСотрудник КАК ПривязкаСотрудник
//	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Должники КАК Должники
//	ПО ПривязкаСотрудник.Должник = Должники.Ссылка
//ГДЕ ПривязкаСотрудник.Сотрудник = &Сотрудник

