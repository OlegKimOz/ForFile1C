﻿&НаКлиенте
Процедура ПоказатьКарточку(Команда)
	Если Элементы.Должники.ТекущаяСтрока = Неопределено Тогда
		ПоказатьПредупреждение(, "Не выбрана строка.", 10);
	Иначе
		СтрокаДолжника = Объект.Должники.НайтиПоИдентификатору(Элементы.Должники.ТекущаяСтрока);
		текДолжник = СтрокаДолжника.Должник;
		ПоказатьЗначение(, текДолжник);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Свернуть(Команда)
	СвернутьНаСервере();
КонецПроцедуры

&НаСервере
Процедура СвернутьНаСервере()
	Об = РеквизитФормыВЗначение("Объект");
	Об.Должники.Свернуть("Должник, Договор, ТекущийОсновнойДолг, ВсегоЗадолженность, ПросроченныеПроценты, ПросроченныйОсновнойДолг, Неустойка, ДатаРасчетаЗадолженности, ДнейПросрочки", "");
КонецПроцедуры // ()
