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
    addi $a1,$t0,0                       #Okunan cümleyi $a1 parametresine gönderir
    addi $t9, $zero 0                    #cümle baþý kontrolü için $t9 a 0 atanýr(flag)
    isDigit:
        addi $t0,$a1,0                   #cümle $t0 a atanýr. Eðer 0 ise cümle baþý olduðu kabul edilir.
        lb $t1, ($t0)                    #cümlenin ilk karakteri okunur ve $t1 e atanýr
        beq $t1, $zero exit              #eðer boþ ise programdan çýkýlýr.
        
        #okunan karakterin sayý olup olmadýðýný kontrol eder.
        #eðer charackter sayý ise checkSltTen ile sayýnýn 10 dan küçük olup olmadýðýna bakýlýr.    
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
         
        
        beq $t1 '.' checkSpace    #eðer karakter sayý deðil nokta ise yeni cümle olup olmadýðýný kontrol eder(checkSpace)
         
        #eðer sayý ve nokta dýþýnda bir karakter ise ekrana print edilir(printChar)
        #$a1 parametresinden okunan karakter dýþýndakiler return edilir.
        jal printChar

        addi $a1,$a1,1
        addi $t9,$zero,10

        syscall
        addi $a3, $a1,0
        lb $t3, ($a3)
        #eðer cümle sonu ise ve nokta yoksa nokta eklenir.
        #akin cam --->akin cam.
        beq $t3 '\0' endOfSentence
        j isDigit
    #Exception durumlarýnda programdan çýkmak için kullanýlýr.
    exit:
        li $v0, 10
        syscall
    #noktadan sonrasýna bakýlýr
    #eðer noktadan sonra cümle bitiyorsa exit ile programdan çýkýlýr.
    #eðer boþluk var ise yeni cümleye geçmek için hazýrlýk yapýlýr
    #eðer boþluk yok ise boþluk ekenir ve isDigit yeniden çaðrýlýr.
    checkSpace:
        addi $a3, $a1,1
        lb $t3, ($a3)
        beq $t3,' ' newSentence #. dan sonra boþluk var ise yeni cümleye geçilir
     	li $v0,11 
        addi $a0,$t1,0
        syscall
        beq $t3,'\0' exit  # eðer cümle sonu ise çkýlýr.
      
        li $v0,11
        addi $t6,$zero,' '
        addi $a0,$t6,0
        addi $a1,$a1,1
        addi $t9,$zero,0
        syscall
        j isDigit
    
    #yeni cümleye geçilir flag 0 olarak iþaretlenir.
    #isDigit yeniden çaðrýlýr.	
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
    #sayýnýn float olup olmadýðý kontrol edilir.
    #sayýnýn cümle baþýnda olup olmadýðý kontrol edilir.
    #sayý 10 dan büyükse loop2 ile sayý ekrana yazýlýr.   	    
    checkSltTen:
        addi $a2,$a1,1
        lb $t3, ($a2)
        beq $t3,' ' checkHeadLine
        
        beq $t3 '.' checkIsFloat
        loop2:          #sayý 10 dan büyükse loop2 ile sayý ekrana yazýlýr.   	      
            jal printChar
            beq $t1, ' ' isDigit
            beq $t1, '\0' endOfSentence   #sayý sonunda nokta yoksa . eklenir ve program sonlanýr
            addi $a1,$a1,1
            addi $t0,$a1,0
            lb $t1, ($t0)
            syscall
            j loop2
        syscall   
    #sayýnýn cümlenin sonunda olup olmadýðýný kontrol eder.
    #cümle sonunda ise sayý ekrana yazýlýr ve yeni cümleye geçilir.(assNewSentence)
    #eðer cümlenin son karakteri ise sayý ve nokta eklenir ve programdan çýkýlýr.(endOfSentenceNumber)    
    checkIsFloat:
       addi $a3,$a1,2
       lb $t4, ($a3)
       beq $t4, ' ' passNewSentence
       
       beq $t4 '\0' endOfSentenceNumber
       
       #sayýdsn sonra nokta var ve yeni cümleye geçmek için boþluk kullanýlmýyor ise
       #boþluk ekler ve cümleye devam edilir. akin 4.cam ----> akin four. cam
       addi $t7,$zero 'A'
       loop3:
           beq $t4,$t7 newSpace
           beq $t7 'z' loop
           addi $t7,$t7 1
      
           j loop3
    
    #float ise floatýn ekrana yazýlmasýný saðlar.                 
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
    
    #sayýdan sonra nokta var ve ondan sonra boþluk yok ise yeni cümleye geçmek için kullanýlýr.
    #sayý yazýlýr nokta eklenir. Ana cumlede olmayan boþluk eklenir ve isDigit çaðrýlýr.
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
    #sayý cümlenin sonunda ise sayýyý yazar nokta koyar ve programdan çýkýlýr.   
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
    #cümlenin sonunda ise nokta koyar ve programdan çýkýlýr.        
    endOfSentence:
        addi $t6,$zero,'.'
        li $v0,11
        addi $a0,$t6 0
        syscall
        li $v0, 10 
        syscall
       
   #sayý cümlenim sonunda ise sayýyý yazar nokta boþluk ekler yeni cümleye geçer.    
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
    
    #eðer flag($t9) 0 ise cümle baþý olduðu kabul edilir ve assignUpper çaðrýlýr.
    #aksi takdirde küçük harflerle sayý yazýlýr ve isDigit çaðrýlýr.            
    checkHeadLine:       
        beqz $t9, assignUpper
        li $v0,4
        addi $a0,$t2,0
        addi $a1,$a1,1
        addi $t9, $zero 0
        syscall
        j isDigit
    
    #Yeni cümle baþlangýcý bir sayý olduðunda bu method çaðrýlýr
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
    #verilen numara(baþ harfi büyük) ekrana yazýlýr ve isDigit çaðrýlýr 
    writeHeadNumber:
         li $v0,4 
         addi $a0,$t2,0
         addi $a1,$a1,1
         addi $t9,$zero 100
         syscall
         j isDigit
         
    #programý bitirir  
    li $v0, 10
    syscall
#dosyadan okumayý saðlayan bir procedure
readFile:
    #dosyayý açar  
    li   $v0, 13       
    la   $a0, fileName     
    li   $a1, 0        
    syscall       
    add $s0, $zero, $v0           
    
    #dosyayý okur
    li   $v0, 14
    add $a0, $zero, $s0            
    la   $a1, fileStr  
    li   $a2, 256    
    syscall           
    
    
    la $t0, fileStr
    
    #cümleyi ekrana yazar.
    li $v0,4
    addi, $a0,$t0,0
    syscall
    
    #yemi satýr karakteri
    addi $t1,$zero '\n'
    li $v0,11
    addi, $a0,$t1,0
    syscall
    
    #dosyayý kapatýr
    li   $v0, 16       
    add $a0, $zero, $s0       
    syscall
	
    jr $ra       

#verilen karakterleri ekrana yazan bir procedure
printChar:
    li $v0,11 
    addi $a0,$t1,0
    jr $ra  		
    	
    	
    	
    	
