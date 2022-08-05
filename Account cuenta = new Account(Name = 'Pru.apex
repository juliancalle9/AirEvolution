Account cuenta = new Account(Name = 'Prueba de fuego database tarea', Phone = '666');
//id 0018a00001tULODAA4
Database.SaveResult resultado = Database.insert(cuenta, false);
System.debug('Resultado = ' + resultado);

Account cuenta2 = new Account(Name = 'Prueba de fuego2 tarea', Phone = '123456');
Database.SaveResult resultado = Database.insert(cuenta2, false);
System.debug('Resultado 2 -->' + resultado);
//id 0018a00001tULPaAAO

Account cuenta2 = new Account();
cuenta2.Name = 'Prueba de tarea';

try{
    Database.SaveResult resultado = Database.update(cuenta2, false);
    System.debug('Resultado actualización= ' + resultado);
}catch(DmlException dmlE){

}

List<Account> acct = new List<Account>();
Account cuenta2 = new Account();
cuenta2.Id = '0018a00001tULPaAAO';
cuenta2.Name = 'prueba con upsert';
acct.add(cuenta2);

Account cuenta3 = new Account();
cuenta3.Name = 'prueba 3 metodos upsert';
Database.SaveResult resultado = Database.insert(cuenta3, false);
acct.add(cuenta3);
try{
    List<Database.upsertResult> results = Database.upsert(acct,false);
    System.debug('Resultado upsert -->' + acct);
}catch(DmlException dmlE){

}
System.debug('Resultado 3 -->' + resultado);

Account cuenta3 = new Account();
cuenta3.Id = '0018a00001tULODAA4';
try{
    Database.delete(cuenta3, false);
    System.debug('Resultado 3 eliminación -->' + cuenta3);

}catch(DmlException dmlE){

}


Account cuenta3 = new Account();
cuenta3.Id = '0018a00001tULPaAAO';
try{
    Database.undelete(cuenta3, false);
    System.debug('Resultado 3 undelete -->' + cuenta3);

}catch(DmlException dmlE){

}

List<Account> lista = new List<Account>();
Account cuenta1 = new Account();
cuenta1.Id = '0018a00001tULODAA4';
cuenta1.Name = 'Facebook';
Database.update(cuenta1);


Account cuenta2 = new Account();
cuenta2.Id = '0018a00001tULPaAAO';
cuenta2.Name = 'Facebook';
Database.update(cuenta2);
lista.add(cuenta2);

try{
    List<Database.MergeResult> results = Database.merge(cuenta1, lista, false);
    System.debug('Resultado Merge -->' + cuenta1);

}catch(DmlException dmlE){

}