//
Account cuenta = new Account(Name = 'Prueba de fuego', Phone = '55555');
cuenta.Id = '0018a00001tHZAcAAO';
insert cuenta;
System.debug('Nombre = ' + cuenta.Name);
System.debug('Teléfono = ' + cuenta.Phone);



//Con metodos
Account cuenta2 = new Account(Name = 'Prueba de fuego2', Phone = '4444');
Database.SaveResult resultado = Database.insert(cuenta2, false);
System.debug('Resultado 2 -->' + resultado);

cuenta.Name = 'Prueba de hielo';
cuenta.BillingAddress = 'Medellín';
try{
    update cuenta;
}catch(DmlException dmlE){

}
Account cuenta2 = new Account();
cuenta2.Id = '0018a00001tHZFIAA4';
cuenta2.Name = 'prueba de hielo';
Database.SaveResult actualizar = Database.update(cuenta2, false);
System.debug('Resultado 2 -->' + actualizar);


List<Account> acct = new List<Account>();
Account cuenta2 = new Account();
cuenta2.Id = '0018a00001tHZFIAA4';
cuenta2.Name = 'prueba con upsert';
acct.add(cuenta2);

Account cuenta3 = new Account();
cuenta3.Name = 'prueba 3';
Database.SaveResult resultado = Database.insert(cuenta3, false);
acct.add(cuenta3);
try{
    upsert acct;
    System.debug('Resultado upsert -->' + acct);
}catch(DmlException dmlE){

}
System.debug('Resultado 3 -->' + resultado);

Account cuenta3 = new Account();
cuenta3.Id = '0018a00001tHZQuAAO';
try{
    delete cuenta3;
    System.debug('Resultado 3 eliminación -->' + cuenta3);

}catch(DmlException dmlE){

}


Account cuenta3 = new Account();
cuenta3.Id = '0018a00001tHZQuAAO';
try{
    undelete cuenta3;
    System.debug('Resultado 3 undelete -->' + cuenta3);

}catch(DmlException dmlE){

}

List<Account> lista = new List<Account>();
Account cuenta1 = new Account();
cuenta1.Id = '0018a00001tHZAcAAO';
cuenta1.Name = 'Facebook';
update cuenta1;

Account cuenta2 = new Account();
cuenta2.Id = '0018a00001tHZFIAA4';
cuenta2.Name = 'Microsoft';
update cuenta2;
lista.add(cuenta2);

Account cuenta3 = new Account();
cuenta3.Id = '0018a00001tHZQuAAO';
cuenta3.Name = 'TATA';
update cuenta3;
lista.add(cuenta3);
try{
    merge cuenta1 lista;
    System.debug('Resultado Merge -->' + cuenta1);

}catch(DmlException dmlE){

}

