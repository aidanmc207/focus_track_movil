# Habilita la aceleracion por hardware del emulador Android (Practica 13, Problema 1).
# Ejecutar en PowerShell como Administrador y reiniciar el equipo al terminar.

#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'

# Paso 3: Plataforma del hipervisor de Windows (WHPX) y Plataforma de maquina virtual
Enable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart

# Paso 4: Forzar el arranque del hipervisor desde el gestor de arranque
bcdedit /set hypervisorlaunchtype auto

Write-Host ''
Write-Host 'Listo. Reinicie el equipo y luego verifique con:' -ForegroundColor Green
Write-Host '  D:\Android\Sdk\emulator\emulator.exe -accel-check'
