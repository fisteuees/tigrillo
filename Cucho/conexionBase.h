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
-(void)insert: (int) monedas;

@end
