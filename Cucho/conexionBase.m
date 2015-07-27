//
//  conexionBase.m
//  PracticarRun1
//
//  Created by FISTE on 10/06/14.
//
//

#import "conexionBase.h"

@implementation conexionBase

//PARA BASE DE DATOS

//Para el archivo
-(NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"db.sql"];
}

//Para abrir la base de datos
-(void)abrirBD{
    if(sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK){
        sqlite3_close(db);
        NSAssert(0,@"Falló en abrir la base de datos");
    }else{
        NSLog(@"La base de datos si se abrió");
    }
}

//Para crear tabla
-(void)crearTabla: (NSString *) nombreTabla conCampo1:(NSString *) campo1 conCampo2:(NSString *) campo2 conCampo3:(NSString *) campo3 conCampo4:(NSString *) campo4{
    char *err;
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' INTEGER, '%@' TEXT);",nombreTabla, campo1, campo2, campo3, campo4];
    if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK){
        sqlite3_close(db);
        NSAssert(0, @"No se pudo crear la tabla");
    }else{
        NSLog(@"Tabla creada");
    }
}

//Nuevo para base de datos
-(void)creartablas{
    char *err1;
    char *err2;
    char *err3;
    char *err4;
    char *err5;
    char *err6;
    NSString *bosque = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'bosque' ('mejor_puntaje' INTEGER);"];
    if(sqlite3_exec(db, [bosque UTF8String], NULL, NULL, &err1) != SQLITE_OK){
        sqlite3_close(db);
        NSAssert(0, @"No se pudo crear la tabla");
    }else{
        NSLog(@"Tabla bosque creada");
    }
    
    //
    
    NSString *hielo = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'hielo' ('mejor_puntaje' INTEGER);"];
    if(sqlite3_exec(db, [hielo UTF8String], NULL, NULL, &err2) != SQLITE_OK){
        sqlite3_close(db);
        NSAssert(0, @"No se pudo crear la tabla");
    }else{
        NSLog(@"Tabla hielo creada");
    }
    
    NSString *agua = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'agua' ('mejor_puntaje' INTEGER);"];
    if(sqlite3_exec(db, [agua UTF8String], NULL, NULL, &err3) != SQLITE_OK){
        sqlite3_close(db);
        NSAssert(0, @"No se pudo crear la tabla");
    }else{
        NSLog(@"Tabla agua creada");
    }
    
    NSString *fuego = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'fuego' ('mejor_puntaje' INTEGER);"];
    if(sqlite3_exec(db, [fuego UTF8String], NULL, NULL, &err4) != SQLITE_OK){
        sqlite3_close(db);
        NSAssert(0, @"No se pudo crear la tabla");
    }else{
        NSLog(@"Tabla fuego creada");
    }
    
    NSString *cementerio = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'cementerio' ('mejor_puntaje' INTEGER);"];
    if(sqlite3_exec(db, [cementerio UTF8String], NULL, NULL, &err5) != SQLITE_OK){
        sqlite3_close(db);
        NSAssert(0, @"No se pudo crear la tabla");
    }else{
        NSLog(@"Tabla cementerio creada");
    }
    
    NSString *niveles = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'niveles'  ('nro_mundo' INTEGER, 'nro_nivel' INTEGER, 'mejor_puntaje' INTEGER);"];
    if (sqlite3_exec(db, [niveles UTF8String], NULL, NULL, &err6) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"No se puedo crear la tabla");
    }else{
        NSLog(@"Tabla niveles creada");
    }
}

/*-(void)insertMundo:(int)puntaje conMundo:(NSString*)mundo{
    char *err;
    NSString *sql1 = [NSString stringWithFormat:@"INSERT INTO mundos ('nroMundo', 'puntos_totales') VALUES ('%@', '%d')",mundo,puntaje];
    if (sqlite3_exec(db, [sql1 UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"No se pudo hacer el insert");
    }else{
        NSLog(@"Insert realizado exitosamente");
    }
}

-(void)insertNivel:(int)puntaje conMundo:(NSString*)mundo conNivel:(NSString*)nivel{
    char *err;
    NSString *sql1 = [NSString stringWithFormat:@"INSERT INTO niveles ('nroNivel', 'nroMundo', 'mejor_puntaje') VALUES ('%@','%@','%d')",nivel,mundo,puntaje];
    if (sqlite3_exec(db, [sql1 UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"No se pudo hacer el insert");
    }else{
        NSLog(@"Insert realizado exitosamente");
    }
}*/

-(void)insertPuntajeMundo:(int)puntaje mundo:(int)mundo{
    char *err;
    NSString *mundoStr;
    if (mundo==1) {
        mundoStr = @"bosque";
    }else if (mundo==2){
        mundoStr = @"hielo";
    }else if (mundo==3){
        mundoStr = @"agua";
    }else if (mundo==4){
        mundoStr = @"fuego";
    }else if (mundo==5){
        mundoStr = @"cementerio";
    }
    NSString *sql1 = [NSString stringWithFormat:@"INSERT INTO %@ ('mejor_puntaje') VALUES ('%i')",mundoStr,puntaje];
    if (sqlite3_exec(db, [sql1 UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"No se pudo hacer el insert");
    }else{
        NSLog(@"Insert mundo realizado exitosamente");
    }
}

-(void)insertPuntajeNivel:(int)puntaje mundo:(int)mundo nivel:(int)nivel{
    char *err;
    NSString *sql1 = [NSString stringWithFormat:@"INSERT INTO niveles ('nro_mundo', 'nro_nivel', 'mejor_puntaje') VALUES ('%i', '%i', '%i')",mundo,nivel,puntaje];
    if (sqlite3_exec(db, [sql1 UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"No se pudo hacer el insert");
    }else{
        NSLog(@"Insert nivel realizado exitosamente");
    }
}

-(int)selectMaxMundo:(int)mundo{
    NSString *mundoStr;
    int puntaje = 0;
    if (mundo==1) {
        mundoStr = @"bosque";
    }else if (mundo==2){
        mundoStr = @"hielo";
    }else if (mundo==3){
        mundoStr = @"agua";
    }else if (mundo==4){
        mundoStr = @"fuego";
    }else if (mundo==5){
        mundoStr = @"cementerio";
    }
    
    
        //const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement;
        
        //if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
        //{
            NSString *querySelect = [[NSString alloc] initWithFormat:@"SELECT mejor_puntaje FROM %@", mundoStr];
            const char *query_stmt = [querySelect UTF8String];
            //puntaje = 0;
            if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    //Employee *employee = [[Employee alloc] init];
                    //employee.employeeID = sqlite3_column_int(statement, 0);
                    //employee.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    //employee.department = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    //employee.age = sqlite3_column_int(statement, 3);
                    //[employeeList addObject:employee];
                    
                    puntaje = sqlite3_column_int(statement, 0);
                    NSLog(@"El puntaje mundo es %i en while",puntaje);
                }
                sqlite3_finalize(statement);
            }
            //sqlite3_close(db);
       // }
    NSLog(@"El puntaje del mundo es %i",puntaje);
    return puntaje;
}

-(int)selectNivel:(int)mundo nivel:(int)nivel{
    int puntaje = 0;
    sqlite3_stmt *statement;
    //NSString *querySelect = [[NSString alloc] initWithFormat:@"SELECT mejor_puntaje FROM niveles WHERE nro_mundo=? AND nro_nivel=?"];
    const char *query_stmt = "SELECT mejor_puntaje FROM niveles WHERE nro_mundo=? AND nro_nivel=?";//[querySelect UTF8String];
    if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, mundo);
        sqlite3_bind_int(statement, 2, nivel);
        while (sqlite3_step(statement)==SQLITE_ROW) {
            puntaje = sqlite3_column_int(statement, 0);
            NSLog(@"El puntaje es %i en while",puntaje);
        }
        sqlite3_finalize(statement);
        
    }
    NSLog(@"El puntaje del nivel es %i",puntaje);
    return puntaje;
}

-(void)updateMundo:(int)mundo puntaje:(int)puntaje{
    const char *sql;
    if (mundo==1) {
        sql = "update bosque SET mejor_puntaje = ?";
    }else if (mundo==2){
        sql = "update hielo SET mejor_puntaje = ?";
    }else if (mundo==3){
        sql = "update agua SET mejor_puntaje = ?";
    }else if (mundo==4){
        sql = "update fuego SET mejor_puntaje = ?";
    }else{
        sql = "update cementerio SET mejor_puntaje = ?";
    }
    sqlite3_stmt *updateStmt;

        if(sqlite3_prepare_v2(db, sql, -1, &updateStmt, NULL)==SQLITE_OK){
            
            sqlite3_bind_int(updateStmt, 1, puntaje);

        }
    
    char* errmsg;
    sqlite3_exec(db, "COMMIT", NULL, NULL, &errmsg);
    
    if(SQLITE_DONE != sqlite3_step(updateStmt)){
        NSLog(@"Error while updating. %s", sqlite3_errmsg(db));
    }else{
        NSLog(@"Update realizado con éxito de mundo");
    }
    sqlite3_finalize(updateStmt);
    //sqlite3_close(contactDB);
}

-(void)updateNivel:(int)mundo nivel:(int)nivel puntaje:(int)puntaje{
    const char *sql = "update niveles SET mejor_puntaje=? WHERE nro_nivel=? AND nro_mundo=?";
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL)==SQLITE_OK){
        sqlite3_bind_int(statement, 1, puntaje);
        sqlite3_bind_int(statement, 2, nivel);
        sqlite3_bind_int(statement, 3, mundo);
    }
    char *error;
    sqlite3_exec(db, "COMMIT", NULL, NULL, &error);
    if(SQLITE_DONE != sqlite3_step(statement)){
        NSLog(@"Error en la actualizacion %s", sqlite3_errmsg(db));
    }else{
        NSLog(@"Update de nivel realizado con éxtio");
    }
    sqlite3_finalize(statement);
}
/*-(void)selectNivel:(int)nivel mundo:(int)mundo{
    char *err;
    NSString *select = [NSString stringWithFormat:@"select max(mejor_puntaje) from niveles where nroNivel=%i && nroMundo=%i", nivel, mundo];
    int respuesta;
    respuesta = sqlite3_exec(db, [select UTF8String], NULL, NULL, &err);
    if (respuesta != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"No se pudo hacer el insert");
    }else{
        NSLog(@"select realizado exitosamente");
        while (sqlite3_step(respuesta) == SQLITE_ROW) //get each row in loop
        {
            
        }
    }
}*/

-(void)insert:(int)monedas{
    char *err;
    int puntaje;
    puntaje = monedas*5;
    NSString *sql1 = [NSString stringWithFormat:@"INSERT INTO prueba ('nombre', 'puntaje', 'tema') VALUES ('Primer nivel', '%d', 'Bosque')",puntaje];
    if (sqlite3_exec(db, [sql1 UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"No se pudo hacer el insert");
    }else{
        NSLog(@"Insert realizado exitosamente");
    }
    NSLog(@"Monedas: %d",monedas);
}



@end
