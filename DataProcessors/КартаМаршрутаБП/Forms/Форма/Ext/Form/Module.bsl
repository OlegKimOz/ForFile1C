﻿
&НаСервере
Процедура БППриИзмененииНаСервере()
	Карта=БП.ПолучитьОбъект().ПолучитьКартуМаршрута();
	
	
КонецПроцедуры

&НаКлиенте
Процедура БППриИзменении(Элемент)
	БППриИзмененииНаСервере();
КонецПроцедуры
