﻿
&НаКлиенте
Процедура ГиперСсылкаНажатие(Элемент, СтандартнаяОбработка)
	
	ОМ_КлиентСервер.ПерейтиПоГИперСсылке(Объект.ГиперСсылка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперСсылкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ГиперСсылкиГиперссылка Тогда
		
		ТекущиеДанные = Элементы.ГиперСсылки.ТекущиеДанные;
		
		Если ЗначениеЗаполнено(ТекущиеДанные.Гиперссылка) Тогда
			
			ОМ_КлиентСервер.ПерейтиПоГИперСсылке(ТекущиеДанные.Гиперссылка, СтандартнаяОбработка);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
