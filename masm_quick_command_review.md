# Important Notes

## int 21h (interupt)

### getchar()

```assembly
mov ah, 1
int 21h ; al = getchar()
```



### gets()

```assembly
	mov esi, 0 ;clear si prepare for string
	xor eax, eax
	mov ah, 0Ah ;0Ah = signal interupt for string input
	int  21h
	mov bl, buf[1] ; bl = length of buf
	lea si, buf[2] ; ds:si
begin_processing:
;.....

```



### lodsb

```assembly
lodsb ;put the byte taken to al
cmp al, 'a'
;.....
```



