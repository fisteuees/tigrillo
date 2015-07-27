//
//  conexionBase.h
//  PracticarRun1
//
//  Created by FISTE on 10/06/14.
//
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface conexionBase : NSObject{
    sqlite3 *db;
}
//Para base de datos
-(NSString *) filePath;
-(void)abrirBD;

-(void)crearTabla: (NSString *) nombreTabla conCampo1:(NSString *) campo1 conCampo2:(NSString *) campo2 conCampo3:(NSString *) campo3 conCampo4:(NSString *) campo4;
//-(void)crearTabla_Bosque: (NSString *)puntaje nivel:(NSString *) nivel;
//-(void)crearTabla_Hielo: (NSString *)puntaje nivel:(NSString *) nivel;
//-(void)crearTabla_Agua: (NSString *)puntaje nivel:(NSString *) nivel;
//-(void)crearTabla_Fuego: (NSString *)puntaje nivel:(NSString *) nivel;
//-(void)crearTabla_Cementerio: (NSString *)puntaje nivel:(NSString *) nivel;
-(void)insert: (int) monedas;
//NUEVAS FUNCIONES
-(void)creartablas;
-(void)insertPuntajeMundo:(int)puntaje mundo:(int)mundo;
-(void)insertPuntajeNivel:(int)puntaje mundo:(int)mundo nivel:(int)nivel;
-(int)selectMaxMundo:(int)mundo;
-(int)selectNivel:(int)mundo nivel:(int)nivel;
-(void)updateMundo:(int)mundo puntaje:(int)puntaje;
-(void)updateNivel:(int)mundo nivel:(int)nivel puntaje:(int)puntaje;
@end
