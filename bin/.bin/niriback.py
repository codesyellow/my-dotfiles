#!/usr/bin/env python3

# store current focused window id to a file
#
import threading
import time
import sys

# Recursos internos
recursos = {
    "processados": 0,
    "erros": 0
}

def motor_principal():
    while True:
        recursos["processados"] += 1
        time.sleep(2)

def interface_cli():
    print("Comandos disponíveis: 'status', 'reset', 'sair'")
    while True:
        comando = input("\n[Comando]> ").strip().lower()
        if comando == "status":
            print(f"-> Recursos atuais: {recursos}")
        elif comando == "reset":
            recursos["processados"] = 0
            print("-> Contador resetado!")
        elif comando == "sair":
            print("Encerrando...")
            sys.exit()

if __name__ == "__main__":
    # Roda o processamento no fundo
    t = threading.Thread(target=motor_principal, daemon=True)
    t.start()
    
    # Mantém a CLI ativa no loop principal
    interface_cli()
