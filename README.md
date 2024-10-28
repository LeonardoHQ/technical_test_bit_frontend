# bit_app

Desafío de Bittechnologies

## Setup

### Flutter
Estas instrucciones no abarcan la instalacion y setup del framework flutter la cual varía acorde a la plataforma en la que se ejecute. Referencias:
- https://docs.flutter.dev/get-started/install

### Emulador de Android o dispositivo físico
Para ejecutar el proyecto es necesario contar con un emulador de android o un dispositivo físico con, al menos, android 10. Estas instrucciones no abarcan la instalacion y setup de dicho dispositivo (físico o virtual). Referencias:
- https://developer.android.com/studio/run/managing-avds

### IDE
Los sistemas en Flutter pueden ser ejecutados en distintos IDEs como ```VsCode``` y ```Android Studio```. Estas instrucciones abarcan únicamente los pasos necesario en el IDE ```VsCode```. Referencias:
- https://code.visualstudio.com/download
- https://developer.android.com/studio

### Puesta en marcha de la aplicación
Asumiendo que se tiene, por lo menos, la versión ```3.24.4 de Flutter``` y algún dispositivo físico o virtual con, por lo menos, Android 10, se debe proceder con:

1. Clonar el repositorio: ```git clone https://github.com/LeonardoHQ/technical_test_bit_frontend```.
2. Dirigirse a la carpeta ```bit_app/``` y ejecutar ```flutter pub get ```
3. Instalar la extensión ```Flutter``` en VsCode 
4. Dirigirse al archivo ```bit_app/lib/main.dart``` dentro de VsCode y ejecutar el mismo desde el IDE tanto en debug mode o release mode según se requiera. 


## Notas
El sistema:
- Posee hardcodeadas algunas variables de entorno las cuales apuntan al backend del mismo únicamente por cuestiones de comodidad. 
- Posee login y todas las requests realizadas al servidor (a excepción del mismo login) usan tokens de autentificación. 
- Cuenta con un Singleton, ```HttpAuthedClient```, el cual se encarga de manejar todas las requests hacia el servidor. 
- Tiene fuertemente divididas sus capas de abstracción siendo estas:
    - **Repositorios**: Encargados de gestionar requests y responses hacia el backend. Transforman todas las requests y responses en objetos (modelos) entendibles por el sistema/ \
    - **Controladores**: Toda la lógica encarga de gestionar las acciones del usuario y el estado de la aplicación. Se comunican directamente con los repositorios.
    - **UI**: Capa autodescriptiva. NO se comunica con repositorios, únicamente con controladores.   