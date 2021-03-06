
Функция ОбработкаСтраны(ОписаниеПрокси) Экспорт
	
	Если Не ЗначениеЗаполнено(ОписаниеПрокси.КодСтраны) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтранаМираСсылка = Справочники.СтраныМира.НайтиПоКоду(ОписаниеПрокси.КодСтраны);
	
	Если Не ЗначениеЗаполнено(СтранаМираСсылка) Тогда	
		СтранаОбъект 			= Справочники.СтраныМира.СоздатьЭлемент();
	Иначе
		СтранаОбъект			= СтранаМираСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	СтранаОбъект.Код 			= ОписаниеПрокси.КодСтраны;
	
	СтранаОбъект.Наименование  = ОписаниеПрокси.Страна;
	
	СтранаОбъект.Записать();
	
	СтранаМираСсылка = СтранаОбъект.Ссылка;
		
	Возврат СтранаМираСсылка;
	
КонецФункции