.data  
    fileName: .asciiz "input_hw1.txt"      
    fileStr: .space 256
    
    zero:     .asciiz "zero"
    one:      .asciiz "one" 
    two:      .asciiz "two" 
    three:    .asciiz "three" 
    four:     .asciiz "four" 
    five:     .asciiz "five" 
    six:      .asciiz "six" 
    seven:    .asciiz "seven" 
    eight:    .asciiz "eight" 
    nine:     .asciiz "nine"

    zeroUp:     .asciiz "Zero"
    oneUp:      .asciiz "One" 
    twoUp:      .asciiz "Two" 
    threeUp:    .asciiz "Three" 
    fourUp:     .asciiz "Four" 
    fiveUp:     .asciiz "Five" 
    sixUp:      .asciiz "Six" 
    sevenUp:    .asciiz "Seven" 
    eightUp:    .asciiz "Eight" 
    nineUp:     .asciiz "Nine"
    
    

.text
main:
    jal readFile                         #Dosyadan okuma
    addi $a1,$t0,0                       #Okunan c�mleyi $a1 parametresine g�nderir
    addi $t9, $zero 0                    #c�mle ba�� kontrol� i�in $t9 a 0 atan�r(flag)
    isDigit:
        addi $t0,$a1,0                   #c�mle $t0 a atan�r. E�er 0 ise c�mle ba�� oldu�u kabul edilir.
        lb $t1, ($t0)                    #c�mlenin ilk karakteri okunur ve $t1 e atan�r
        beq $t1, $zero exit              #e�er bo� ise programdan ��k�l�r.
        
        #okunan karakterin say� olup olmad���n� kontrol eder.
        #e�er charackter say� ise checkSltTen ile say�n�n 10 dan k���k olup olmad���na bak�l�r.    
        la $t2,zero          
        beq $t1,'0' checkSltTen
             
        la $t2,one       
        beq $t1,'1' checkSltTen  
         
        la $t2,two       
        beq $t1,'2' checkSltTen
         
        la $t2,three          
        beq $t1,'3' checkSltTen
             
        la $t2,four       
        beq $t1,'4' checkSltTen 
         
        la $t2,five       
        beq $t1,'5' checkSltTen
         
        la $t2,six          
        beq $t1,'6' checkSltTen
             
        la $t2,seven       
        beq $t1,'7' checkSltTen  
         
        la $t2,eight       
        beq $t1,'8' checkSltTen
         
        la $t2,nine       
        beq $t1,'9' checkSltTen
         
        
        beq $t1 '.' checkSpace    #e�er karakter say� de�il nokta ise yeni c�mle olup olmad���n� kontrol eder(checkSpace)
         
        #e�er say� ve nokta d���nda bir karakter ise ekrana print edilir(printChar)
        #$a1 parametresinden okunan karakter d���ndakiler return edilir.
        jal printChar

        addi $a1,$a1,1
        addi $t9,$zero,10

        syscall
        addi $a3, $a1,0
        lb $t3, ($a3)
        #e�er c�mle sonu ise ve nokta yoksa nokta eklenir.
        #akin cam --->akin cam.
        beq $t3 '\0' endOfSentence
        j isDigit
    #Exception durumlar�nda programdan ��kmak i�in kullan�l�r.
    exit:
        li $v0, 10
        syscall
    #noktadan sonras�na bak�l�r
    #e�er noktadan sonra c�mle bitiyorsa exit ile programdan ��k�l�r.
    #e�er bo�luk var ise yeni c�mleye ge�mek i�in haz�rl�k yap�l�r
    #e�er bo�luk yok ise bo�luk ekenir ve isDigit yeniden �a�r�l�r.
    checkSpace:
        addi $a3, $a1,1
        lb $t3, ($a3)
        beq $t3,' ' newSentence #. dan sonra bo�luk var ise yeni c�mleye ge�ilir
     	li $v0,11 
        addi $a0,$t1,0
        syscall
        beq $t3,'\0' exit  # e�er c�mle sonu ise �k�l�r.
      
        li $v0,11
        addi $t6,$zero,' '
        addi $a0,$t6,0
        addi $a1,$a1,1
        addi $t9,$zero,0
        syscall
        j isDigit
    
    #yeni c�mleye ge�ilir flag 0 olarak i�aretlenir.
    #isDigit yeniden �a�r�l�r.	
    newSentence:
        li $v0,11 
        addi $a0,$t1,0
        syscall
        li $v0,11 
        addi $a0,$t3,0
        addi $a1,$a1,1
        addi $a1,$a1,1
        addi $t9,$zero,0
        syscall
        j isDigit
    #say�n�n float olup olmad��� kontrol edilir.
    #say�n�n c�mle ba��nda olup olmad��� kontrol edilir.
    #say� 10 dan b�y�kse loop2 ile say� ekrana yaz�l�r.   	    
    checkSltTen:
        addi $a2,$a1,1
        lb $t3, ($a2)
        beq $t3,' ' checkHeadLine
        
        beq $t3 '.' checkIsFloat
        loop2:          #say� 10 dan b�y�kse loop2 ile say� ekrana yaz�l�r.   	      
            jal printChar
            beq $t1, ' ' isDigit
            beq $t1, '\0' endOfSentence   #say� sonunda nokta yoksa . eklenir ve program sonlan�r
            addi $a1,$a1,1
            addi $t0,$a1,0
            lb $t1, ($t0)
            syscall
            j loop2
        syscall   
    #say�n�n c�mlenin sonunda olup olmad���n� kontrol eder.
    #c�mle sonunda ise say� ekrana yaz�l�r ve yeni c�mleye ge�ilir.(assNewSentence)
    #e�er c�mlenin son karakteri ise say� ve nokta eklenir ve programdan ��k�l�r.(endOfSentenceNumber)    
    checkIsFloat:
       addi $a3,$a1,2
       lb $t4, ($a3)
       beq $t4, ' ' passNewSentence
       
       beq $t4 '\0' endOfSentenceNumber
       
       #say�dsn sonra nokta var ve yeni c�mleye ge�mek i�in bo�luk kullan�lm�yor ise
       #bo�luk ekler ve c�mleye devam edilir. akin 4.cam ----> akin four. cam
       addi $t7,$zero 'A'
       loop3:
           beq $t4,$t7 newSpace
           beq $t7 'z' loop
           addi $t7,$t7 1
      
           j loop3
    
    #float ise float�n ekrana yaz�lmas�n� sa�lar.                 
    loop:
        jal printChar
        beq $t1 ' ' isDigit
        beq $t1 '\0' endOfSentence 
          
        addi $a1,$a1,1
        addi $t0,$a1,0
        addi $t9, $zero 0
        lb $t1, ($t0)
        syscall
        j loop
          
    syscall
    j isDigit
    
    #say�dan sonra nokta var ve ondan sonra bo�luk yok ise yeni c�mleye ge�mek i�in kullan�l�r.
    #say� yaz�l�r nokta eklenir. Ana cumlede olmayan bo�luk eklenir ve isDigit �a�r�l�r.
     newSpace:
         li $v0, 4
         addi $a0,$t2,0
         syscall
         li $v0,11
         addi $t6,$zero,'.'
         addi $a0,$t6,0
         syscall
         li $v0,11
         addi $t6,$zero,' '
         addi $a0,$t6,0
         addi $a1,$a1 1
         addi $a1,$a1 1
         syscall
         j isDigit
    #say� c�mlenin sonunda ise say�y� yazar nokta koyar ve programdan ��k�l�r.   
    endOfSentenceNumber:
        li $v0,4
        addi $a0,$t2 0
        syscall  
        addi $t6,$zero,'.'
        li $v0,11
        addi $a0,$t6 0
        syscall
        li $v0, 10 
        syscall
    #c�mlenin sonunda ise nokta koyar ve programdan ��k�l�r.        
    endOfSentence:
        addi $t6,$zero,'.'
        li $v0,11
        addi $a0,$t6 0
        syscall
        li $v0, 10 
        syscall
       
   #say� c�mlenim sonunda ise say�y� yazar nokta bo�luk ekler yeni c�mleye ge�er.    
   passNewSentence:
       li $v0,4
       addi $a0, $t2,0
       addi $t9, $zero 0
       syscall
       li $v0,11
       addi $a0, $t3,0
       syscall
       li $v0, 11
       addi $a0,$t4,0
       
       
       addi $a1,$a1,1
       addi $a1,$a1,1 
       addi $a1,$a1,1  
       syscall
       j isDigit
    
    #e�er flag($t9) 0 ise c�mle ba�� oldu�u kabul edilir ve assignUpper �a�r�l�r.
    #aksi takdirde k���k harflerle say� yaz�l�r ve isDigit �a�r�l�r.            
    checkHeadLine:       
        beqz $t9, assignUpper
        li $v0,4
        addi $a0,$t2,0
        addi $a1,$a1,1
        addi $t9, $zero 0
        syscall
        j isDigit
    
    #Yeni c�mle ba�lang�c� bir say� oldu�unda bu method �a�r�l�r
    assignUpper:
        addi $t9, $zero 100
        la $t2,zeroUp         
        beq $t1,'0' writeHeadNumber
             
        la $t2,oneUp       
        beq $t1,'1' writeHeadNumber 
         
        la $t2,twoUp       
        beq $t1,'2' writeHeadNumber
         
        la $t2,threeUp          
        beq $t1,'3' writeHeadNumber
             
        la $t2,fourUp       
        beq $t1,'4' writeHeadNumber 
         
        la $t2,fiveUp       
        beq $t1,'5' writeHeadNumber
         
        la $t2,sixUp          
        beq $t1,'6' writeHeadNumber
             
        la $t2,sevenUp       
        beq $t1,'7' writeHeadNumber 
         
        la $t2,eightUp       
        beq $t1,'8' writeHeadNumber
         
        la $t2,nineUp       
        beq $t1,'9' writeHeadNumber
        syscall 
    #verilen numara(ba� harfi b�y�k) ekrana yaz�l�r ve isDigit �a�r�l�r 
    writeHeadNumber:
         li $v0,4 
         addi $a0,$t2,0
         addi $a1,$a1,1
         addi $t9,$zero 100
         syscall
         j isDigit
         
    #program� bitirir  
    li $v0, 10
    syscall
#dosyadan okumay� sa�layan bir procedure
readFile:
    #dosyay� a�ar  
    li   $v0, 13       
    la   $a0, fileName     
    li   $a1, 0        
    syscall       
    add $s0, $zero, $v0           
    
    #dosyay� okur
    li   $v0, 14
    add $a0, $zero, $s0            
    la   $a1, fileStr  
    li   $a2, 256    
    syscall           
    
    
    la $t0, fileStr
    
    #c�mleyi ekrana yazar.
    li $v0,4
    addi, $a0,$t0,0
    syscall
    
    #yemi sat�r karakteri
    addi $t1,$zero '\n'
    li $v0,11
    addi, $a0,$t1,0
    syscall
    
    #dosyay� kapat�r
    li   $v0, 16       
    add $a0, $zero, $s0       
    syscall
	
    jr $ra       

#verilen karakterleri ekrana yazan bir procedure
printChar:
    li $v0,11 
    addi $a0,$t1,0
    jr $ra  		
    	
    	
    	
    	
