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
    NSString *mundo = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'mundos' ('id' INTEGER PRIMARY KEY AUTOINCREMENT, 'nombre' TEXT, 'bloqueado' INTEGER, 'puntos_totales' INTEGER, 'completado' INTEGER);"];
    if(sqlite3_exec(db, [mundo UTF8String], NULL, NULL, &err1) != SQLITE_OK){
        sqlite3_close(db);
        NSAssert(0, @"No se pudo crear la tabla");
    }else{
        NSLog(@"Tabla creada");
    }
    
    //
    
    NSString *niveles = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'niveles' ('id' TEXT, 'mundo' TEXT, 'bloqueado' INTEGER, 'mejor_puntaje' INTEGER, 'completado' INTEGER);"];
    if(sqlite3_exec(db, [niveles UTF8String], NULL, NULL, &err2) != SQLITE_OK){
        sqlite3_close(db);
        NSAssert(0, @"No se pudo crear la tabla");
    }else{
        NSLog(@"Tabla creada");
    }
}

-(void)insertMundo{
    
}

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
