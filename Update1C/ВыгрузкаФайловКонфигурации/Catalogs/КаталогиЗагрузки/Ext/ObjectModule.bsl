﻿
Процедура ПередЗаписью(Отказ)
	
	Если Не ОбменДанными.Загрузка Тогда
		
		Если ТипКаталога = Перечисления.ТипыКаталогов.Локальный Тогда
			
			Если Не ЗначениеЗаполнено(Адрес) Тогда
				
				ОМ_Сервер.СообщитьПользователю("Поле " + """" + "Адрес" + """" + " обязательно для заполнения");
				Отказ = Истина;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
