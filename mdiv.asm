section .text
global mdiv

mdiv:
    ; Prolog
    push    rbp
    mov     rbp, rsp

    ; Przygotowanie rejestrów
    mov     rsi, rdi       ; rsi <- x
    mov     rcx, rdx       ; rcx <- n
    mov     rdx, 0         ; rdx <- 0 (reszta)
    mov     rax, 0         ; rax <- 0 (iloraz)
    mov     r8, rsi        ; r8 <- x (kopie wskaźnika na x)

    ; Iteracja przez tablicę x
next_number:
    ; Wczytaj 64-bitową liczbę z tablicy x
    mov     rdi, [rsi]     ; rdi <- *x

    ; Dzielenie rdi przez y
    cqo                     ; Rozszerzenie znaku rdi do rdx:rax
    idiv    r8             ; rax <- rdi / y, rdx <- rdi % y

    ; Sprawdź, czy iloraz mieści się w 64 bitach
    test    rdx, rdx       ; Sprawdź resztę
    jnz     overflow       ; Jeśli reszta != 0, przejdź do obsługi nadmiaru

    ; Zapisz iloraz w tablicy x
    mov     [rsi], rax     ; *x <- iloraz

    ; Przejdź do następnej liczby w tablicy x
    add     rsi, 8         ; Przesuń wskaźnik na następną liczbę
    loop    next_number    ; Powtórz dla wszystkich liczb w tablicy

    ; Epilog
    mov     rax, rdx       ; Zwróć resztę
    pop     rbp
    ret

overflow:
    ; Jeśli doszło do nadmiaru, zgłoś przerwanie
    mov     rax, 0         ; rax <- 0 (kod błędu)
    int     0              ; Zakończ program

section .data
; Tutaj możesz umieścić jakieś stałe, jeśli potrzebujesz