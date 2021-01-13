﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	Отказ = ДоступностьИзмененийПоДатеЗапрета(Дата);
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	Для Каждого ТекСтрокаВремя Из Время Цикл
		// регистр РабочееВремя Приход
		Движение = Движения.РабочееВремя.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Сотрудник = Сотрудник;
		Движение.Дата = Дата;
		Движение.КоличествоМинут = ТекСтрокаВремя.Минут;
	КонецЦикла;
	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры
