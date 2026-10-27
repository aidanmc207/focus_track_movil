# Diagnóstico y resolución del entorno (Práctica 13)

## Toolchain

| Componente | Versión / ubicación |
|---|---|
| Flutter | 3.47.8 stable — `D:\src\flutter` |
| Dart | 3.13.7 |
| Java | Temurin OpenJDK 21.0.6 LTS (`JAVA_HOME`) |
| Git | 2.45.1 |
| Android SDK | `D:\Android\Sdk` (platform 36, build-tools 36.1.0, NDK 28.2) |
| AVD | `Pixel_8_API_36` (x86_64, Google APIs) en `D:\Android\avd` |

`flutter doctor -v`: Flutter, Android toolchain (licencias aceptadas), Chrome y
dispositivos conectados en verde. El aviso de Visual Studio solo aplica a apps
de escritorio Windows y no afecta el desarrollo móvil.

## Problemas encontrados y solución

### Problema 1 — El emulador no tiene aceleración por hardware

```
> emulator -accel-check
Android Emulator hypervisor driver is not installed on this machine
```

- **Paso 1:** CPU AMD Ryzen 5 5600X; `systeminfo` reporta
  *"Se habilitó la virtualización en el firmware: Sí"*.
- **Paso 2 (BIOS SVM):** no requerido, ya está habilitado.
- **Pasos 3 y 4 (WHPX + `bcdedit`):** automatizados en
  [`tool/habilitar_virtualizacion.ps1`](../tool/habilitar_virtualizacion.ps1).
  Ejecutar como Administrador y reiniciar.
- **Paso 5 (gráficos):** en `Pixel_8_API_36.avd\config.ini` se cambió
  `hw.gpu.mode=auto` → `host` y `hw.gpu.enabled=yes` (equivalente a
  *Hardware - GLES 2.0* en el Device Manager).

Alternativa sin reinicio: instalar el *Android Emulator Hypervisor Driver*
(`D:\Android\Sdk\extras\google\Android_Emulator_Hypervisor_Driver\silent_install.bat`
como Administrador).

### Gradle no instala el NDK automáticamente

```
Android sdkmanager did not install NDK 28.2.13676358 into D:\Android\Sdk.
```

Las Command-line Tools 23 reemplazaron `sdkmanager` por la nueva CLI `android`
y los nombres de paquete usan `/`. Solución:

```powershell
sdkmanager.bat ndk/28.2.13676358
```

### Problema 6 — Java/Gradle

No se presentó: `JAVA_HOME` apunta a Java 21 LTS, compatible con el wrapper.
