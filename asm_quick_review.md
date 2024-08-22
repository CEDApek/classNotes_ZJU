==不能带计算机==

## 考试格式内容

(45 分钟 理论 + 80分钟 实验)

**理论**

**一、判断题**

**二、单选题**

**实验**

**三、程序填空题** (2题)

**四、程序阅读** (2题)



# **回顾内容**

> ## 逻辑地址 <----> 物理地址 
>

逻辑地址基本格式: ***seg_addr : off_addr***   *(16位段地址 ：16位偏移地址)* 

找到物理地址公式：***phy_addr = seg_addr x 10h + off_addr*** || (phy_addr = seg_addr * 16 + off_addr) 

​		例如:

​		***1234h : 5678h*** => 1234h * 10h + 5678h = **179B8h**

​			      		(74560 + 22136 = 96696)

> ## 标志(FL)

### Clearing Flag:

* **clc** *(clear carry flag)* CF = 0
* **stc** *(set carry flag)* CF = 1
* **cli** *(clear interrupt flag)* IF = 0
* **stc** (set interrupt flag) IF = 1
* **cld** *(clear direction flag)* DF = 0
* **std** *(set direction flag)* DF = 1

**FL** 里面有**9**种标志为：**CF、ZF、OF、SF、DF、IF、TF、AF、PF**

* **控制CPU** (CF, ZF, SF, OF, PF, AF)：

  * **CF** (Carry Flag) *add, sub, mul, imul*; 

    ==CF = 1 如果有rounding的时候==;
    
    ```assembly
    mov ah, 0FFh ; max ah(256) ; 0FFh = 255 ; range only 0 - 255
    add ah, 1 ; ah = 00h, CF = 1 back to 0 from 255
    add ah, 2 ; ah = 02h, CF = 0
    add ah, 4
    shr ah, 1
    ```
    
    pair with *jc, jnc, clc*，等等
    
  * **ZF** (Zero Flag) *算术运算，逻辑运算，移位指令*；(arithmetic, logic, bitwise operation effect)
  
    ==ZF = 1, 任何运算结果 = 0==;
  
    ```assembly
    ;ax 范围为[0 - 65536] 16 bit
    sub ax, ax ; ax = 0, ZF = 1, CF = 0
    add ax, 1 ; ax = 1, ZF = 0, CF = 0
    add ax, 0FFFFh ; ax = 0, ZF = 0, CF = 0   ; 0FFFFh = 655335
    ```
  
  * **OF** (Overflow Flag) *add, sub, mul, imul*;
  
    OF = 1, when overflow (changing sign from operation)
  
    ```assembly
    mov ah, 7Fh ; ah = 127
    add ah, 1 ; ah = 80h, OF = 1 (127 * 1 = -128)
    ```
  
    pair with *jo, jno*;
  
  * **SF** (Sign Flag) *effected by any operator*
  
    SF = 1, when its negative, select the MSB(right most bit)
  
    ```assembly
    mov ah, 7Fh ; ah = 127
    add ah, 1 ; ah = 80h (128) = 1000 0000 B, SF = 1 (look at the most right bit when 1)
    sub ah, 1 ; ah = 7Fh (127) = 0111 1111 B, SF = 0
    ```
  
    pair with *js, jns*;
  
  * **PF** (Parity Flag) 
  
    PF = 1, **when the 1's in binary represent is ==even==** 
  
    ```assembly
    mov ah, 4
    add ah, 1 ; ah = 5 = 0000 0101 so PF = 1
    ```
  
    pair with *jp, jnp, jnpe, jnpo*;
  
  * **AF** (Auxiliary Flag) *加法于减法*
  
    AF = 1, when there is a borrow or carry-in bit specifically in ==3 bit from LSB== (bit **3** borrow or carry from/ to bit **4**)
  
    ```assembly
    mov ah, 2Dh		; ah =	0010 1101
    add ah, 4	   	;      	0000 0100 (+)
    			   ;       0011 0001 (3rd bit carry to 4th bit) AF = 1
    add ah, 8		;       0000 1000 (+)
    			   ;        0011 1001 AF = 0, no carry
    ```
  
    *no related instruction for AF*

* **控制标志** (DF, IF, TF)
  
  * **DF** (Direction Flag) 控制字符串作指令。
  
    When DF = 0，正方向, (先低地址，在再地址做操作)
  
    When DF = 1，负方向（先搞地址，再低地址操作） 
  
    pair with *cld, std* [cld(clear direction):arrow_right: DF = 0] [std(set direction) :arrow_right: DF = 1] 
  
  * **IF** (Interrupt Flag) 禁止,充许硬件中断
  
    IF = 0, disallowing hardware interrupt
  
    IF = 1, allowing hardware interupt
  
  * **TF** (Trap Flag) 位于 FL 寄存器的<u>第8位</u>，控制CPU的运行模式
  
    TF = 1, CPU runs single step mode (单步模式) 每一条指令 :arrow_right: int 01h 中断
  
    TF = 0, CPU runs normal mode (常规模式)

**note****==当数据大于8位，在内存底8为在前，8高位在后==**

> ## **寄存器(Registers)** 
>

![image-20240621184505935](C:\Users\ASUS\AppData\Roaming\Typora\typora-user-images\image-20240621184505935.png)

### 通用寄存器

* **AX, BX, CX, DX** 

  * 分别两个部分 AH (高8位)， AL (底8位)

    ![image-20240621184913620](C:\Users\ASUS\AppData\Roaming\Typora\typora-user-images\image-20240621184913620.png)样子

### **段地址寄存器**

* **CS, DS, ES, SS**

  * CS (Code segment address)

    * 不能用 *mov* 指令，只能用 jmp far ptr, jmp dword ptr, call far ptr, call dword ptr, retf, intm iret;

  * DS (Data segment address), ES (Extra segment address), SS (Stack segment address)

    * 能用 *mov* 指令，可是源操作数只能<u>寄存器或变量</u>

    ```assembly
    mov ds, 1000h ; 错误
    
    mov ax, 1000h
    mov ds, ax ; 正确
    ; 或者
    mov word ptr ds : [bx], 1000h
    mov es, ds : [bx] ; 正确
    ```

## Mini note:

#### CS 是当前指令的短地址，IP 是当前指令的偏移地址 [CS:IP]



> ## **偏移地址寄存器** (Offset Address Register)
>

* **IP, SP, BP, SI, DI**
  * IP 跟 CS 匹配
  * SP 跟 SS 匹配 (Stack [ SS:SP ] )

> ## **间接寻址** (Indirect addressing)
>

4 ways of indirect addressing :

* *[寄存器]* = [bx], [bp], [si], [di]
* *[寄存器 + 常熟]* = [bx+1], [bp+1], [si+1], [di+1]
* *[寄存器 + 寄存器]* = [bx+si], [bp+di], [si+si], [di+di]
* *[寄存器 + 寄存器 + 常熟]* = [bx+si+1], [bp+di-1], [si+si+2], [di+di-2]

==**We can only use the register BX, BP, SI, DI INSIDE THE BRACKET**==

准确的形式：***<u>段寄存器 : [ 寄存器1 + 寄存器2 x N + 常数]</u>*** (N 为 集合{1, 2, 4, 8} 内的一个元素)

选择 (8) : EAX, EBX, ECX, EDX, ESP, EBP, ESI, EDI

如果变量名为 *var*, 形式：**<u>*var[ 寄存器1 + 寄存器2 + 常数 ]*</u>**

列：

* ds: s[bx+2] 或 ds: [s+bx+2]
* ds: s[bs+si+2]

> ## **缺省段址 (Default Segment Address)**
>

如果操作数的地址中省略段地址，就使用缺省址。(if the segment address in the registers is deleted directly use the default address values)

**规则: **

* 直接寻址方式的缺省段址为 DS (default is DS for direct addressing)
* 使用间接寻址方式的操作数编译地址中若含有寄存器BP，则缺省段址为SS (indirect and contains BP, use SS)
* 使用间接寻址方式的操作数编译地址中若不含有寄存器BP，则缺省段址为DS (indirect and don't have BP, use DS)

> ## **指令: **

* **mov** 赋值

  ```assembly
  mov ah, bh ; ah = bh
  ```

  * 不影响标志
  * 操作数==不能全为内存变量==(memory address)

* **xchg** 交换

  ```assembly
  xchg ax, bx 	; temp = ax
  			   ; ax = bx
  			   ; bx = temp
  ```

  * 不影响标志
  * 操作数不能有<u>段寄存器</u>(segment register : CS, DS, 等等)

* **push** (op) & **pop** (op)

  we use the stack segment (SP), if we push op with 2 bytes, it will decrement the value of sp by 2

  ```assembly
  push ax ; push the value of ax to sp 8 bytes
  pop dx ; pop 8 bytes from the top of segment and put to bx
  ```

* **pushf** & **popf**

  push and pop the Flag register (任何标志假如，ZF, SF, 等等)

* **lea** (lea *destination*, *src*) (load effective address)

  src offset address's value assign to destination

  ```assembly
  lea bx, ds:[10F8h] ; bx = 10F8
  mov bx, 1000h
  mov si, 1234h
  lea di, [bx+si+2] ; di = bx + si + 2 = 2236h
  ```

* **lds** (load data segment) 

  把段地址部分赋值给DS，再把偏移地址赋值给dest

* **les** 

  先把段地址赋值给es，再把偏移地址赋值给dest

* **cbw** (convert byte to word)  expand al to ax

* **cwd** (convert word to double word) expand ax lower 32 bit and add 16 bit from upper 

* **add** 

  ```assembly
  mov ax, 5 
  add ax, 4 ; ax = ax + 4
  		 ; ax = 5 + 4 = 9
  ```

* **adc** (add with carry) + CF so when CF = 1 :arrow_right: dest += src + CF

* **inc** (op++)

  ```assembly
  mov al, 2
  inc al 		; al = 3
  ```

* **sub**

  ```assembly
  mov ah, 3
  sub ah, 1 ; ah = 2
  ```

* **sbb** (subtract with borrow) *dest = dest - src - CF*

* **dec**

  ```assembly
  dec al, 2
  dec al 		; al = 1
  ```

* **mul** (multiply) (unsigned)

  ```assembly
  mov ax, 3
  mul ax, 4 ; ax = 12
  ```

* **imul** (multiply) (signed)

* **div** (division) (unsigned)

  ```assembly
  mov ax, 6
  div ax, 3 ; ax = 2
  ```

* **idiv** (division) (signed)

* **xlat** (translate) 把 byte ptr ds:[bx+AL]赋值给AL

* **in** & **out** ==输入输出指令==

  * **in** reads data from I/O port and put to dest

    ```assembly
    in al, dx ; dx[000h, 0FFFFh]
    ```

  * **out** writes data from the register to the I/O port

    ```assembly
    out 21h, al ; 把 al 的值赋值给 21h 的端口
    ```

### 逻辑运算指令:

* **and** (*and* logic operator)

  ```assembly
  and ax, bx ; ax & bx
  ```

* **or** (*or* logic operator)

  ```assembly
  or ax, bx ; ax | bx
  ```

* **xor** (*xor* logic operator)

  ```assembly
  xor ax, bx ; ax ^ bx
  ```

* **not** (1's complement opr (bitwise))

  ```assembly
  not ax ; ax = ~ ax
  ```

* **neg** (negate sign)

  ```assembly
  mov ax, 2
  neg ax ; ax = -2
  neg ax ; ax = 2
  ```

* **test** (test operation but doesn't pass the the value, only in temporary variables)

  ```assembly
  mov ax, 2
  mov bx, 1
  test ax, bx
  jz yes_daddy ; jmp to yes_daddy because 2 & 1, ZF = 0
  ```

* **shl** (shift left operation (x2)) ≡ **sal** (shift arithmetic left) "CF gets substituted by the most left bit"

* **shr** (shift right operation (/2))

* **sar** (shift arithmetic right) not equals to shr when its negative, the 1 on the right stays

* **ror** (rotate right) "geser ke kanan" "CF gets substituted and put at most right"

  ```assembly
  mov al, 0A5h ; al = 1010 010(1) B
  ror al, 1 ; al = (1)101 0010
  ```

* **rol** (rotate left) same with right but left  "CF gets substituted and put at most left"

* **rcl** (rotate through carry left) :arrow_right: we included the CF so the value of CF substituted (pos: left)

* **rcr** (rotate through carry right) :arrow_right: we included the CF so the value of CF substituted (pos: right)

* **cmp** (比较 op1 op2) 放在结果temp变量 op1 - op2

  ```assembly
  mov al, 2
  mov bl, 1
  cmp al, bl ; temp = 1| CF = 0, ZF = 0, SF = 0, OF = 0
  mov ah, 1
  cmp ah, 2 ; temp = -1| CF = 1, ZF = 0, SF = 1, OF = 0
  cmp ah, 1 ; temp = 0| CF = 0, ZF = 1, SF = 0, OF = 0
  ```

  

## **条件跳转指令** Jcc

* **ja** (jump if above) ≡ **jnbe** (jump if not below or equal)
* **jb** (jump if below) ≡ **jc** (jump if carry) ≡ **jnae** (jump if not above or equal)
* **jae** (jump if above or equal) ≡ **jnc** (jump if not carry) ≡ **jnb** (jump if not below)
* **jbe** (jump if below or equal) ≡ **jna** (jump if not above)
* **jg** (jump if greater) ≡ **jnle** (jump if not lower or equal)
* **jl** (jump if lower) ≡ **jnge** (jump if not greater or equal)
* **jz** (jump if zero) ≡ **je** (jump if equal)
* **jnz** (jump if not zero) ≡ **jne** (jump if not equal)
* **jcxz** (jump if *CX* is zero) 
* **js** (jump if sign) :arrow_right: SF = 1
* **jns** (jump if not sign)
* **jo** (jump if overflow) :arrow_right: OF = 1
* **jno** (jump if not overflow)

## **Loop**

in loop we use CX as the counter, CX will decrease each time by 1

```assembly
	mov ax, 0
	mov bx, 1
	mov cx, 100
again:
	add ax, bx 	; ax = ax + bx
	inv bx 		; bx = bx + 1
	loop again	; cx = cx - 1 | jnz again
```

## call & ret

*<u>"when we use the call, after calling we need to use ret to get back to the line where it called"</u>*

## callf & retf

*<u>"basically the same but just further"</u>*

## int 3

:arrow_right: break point interrupt (软件断点中断)

## iret (interrupt return)

:arrow_right: pop flag from register, pop CS, IP, FL, SP also popped

## 字符串指令:

* **repne (repeat while not equal) / repe (reeat while equal)** cmpsb (compare string in byte)
* **repne / repe** scasb (Scan String byte)
* **rep stosb** (repeat move string byte) 
* **lodsb** (load string byte)
* **stosb** (store string byte)
* **rep stosb** (repeat store string byte)

## **用堆栈传递参数时**, **如何用**[bp+?]实现对参数的引用

[bx+si+2] | [bx + 1] (if right above)
