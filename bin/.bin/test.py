#!/usr/bin/env python3


def e_palindromo(palavra: str) -> bool:
    palavra_reversa: list = list(palavra)[::-1]

    palavra_reversa_convertida: str = ""

    for letra in palavra_reversa:
        palavra_reversa_convertida += letra

    return palavra_reversa_convertida == palavra


print(e_palindromo(palavra="radar"))
