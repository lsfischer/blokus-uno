(defun tabuleiro-vazio ()
  "Funcao que retorna um tabuleiro vazio"
  (list 
   '(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   '(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   '(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   '(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   '(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   '(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   '(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   '(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   '(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   '(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   '(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   '(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
   '(0 0 0 0 0 0 0 0 0 0 0 0 1 0)
   '(0 0 0 0 0 0 0 0 0 0 0 0 0 1)
  )
)

;;peca-contagem
(defun peca-contagem (tabuleiro tipo-peca &optional (linha 13) (coluna 13))
  "Funcao que permite contar o numero de pecas do jogador existentes no tabuleiro conforme o seu tipo"
  (cond
   ((and (zerop linha) (zerop coluna)) 
    (cond
     ((and 
       (equal tipo-peca 'pequena)
       (eq (nth 0 (nth 0 tabuleiro)) 1)
       (not (eq (nth 1 (nth 0 tabuleiro)) 1))
       (not (eq (nth 0 (nth 1 tabuleiro)) 1))
      ) 1)
     (T 0)
    )
   )
   ((= coluna -1) (peca-contagem tabuleiro tipo-peca (1- linha) 13 ))
   ((= (nth coluna (nth linha tabuleiro)) 1) (+ (tipo-pecap linha coluna tabuleiro tipo-peca) (peca-contagem tabuleiro tipo-peca linha (1- coluna))))
   (T (peca-contagem tabuleiro tipo-peca linha (1- coluna)))
  )
)

;;tipo-pecap
(defun tipo-pecap (linha coluna tabuleiro tipo-peca)
  "Funcao que ao passarmos uma posicao de um tabuleiro verifica se essa peca e do tipo de peca enviado por argumento"
  (cond

   ((equal tipo-peca 'pequena)
    (cond
     ((or
       (eq (nth (1+ coluna) (nth linha tabuleiro)) 1)
       (eq (nth (1- coluna) (nth linha tabuleiro)) 1)
       (eq (nth coluna (nth (1+ linha) tabuleiro)) 1)
       (eq (nth coluna (nth (1- linha) tabuleiro)) 1)
       ) 0)
     (T 1)
     )
   )

   ((equal tipo-peca 'media)
    (cond
     ((and
       (not (= coluna 0 ))
       (not (= linha 0 ))
       (eq (nth (1- coluna) (nth linha tabuleiro)) 1)
       (eq (nth coluna (nth (1- linha) tabuleiro)) 1)
       (eq (nth (1- coluna) (nth (1- linha) tabuleiro)) 1)
       ) 1)
     (T 0)
    )
   )

   ((equal tipo-peca 'cruz)
    (cond
     ((and
       (not (= coluna 13))
       (not (= coluna 0))
       (not (< linha 2))
       (eq (nth coluna (nth (1- linha) tabuleiro)) 1)
       (eq (nth (1- coluna) (nth (1- linha) tabuleiro)) 1)
       (eq (nth (1+ coluna) (nth (1- linha) tabuleiro)) 1)
       (eq (nth coluna (nth (- linha 2) tabuleiro)) 1)
      ) 1)
     (T 0)
    )
   )

   (T nil)

  )
)

(defun jogadas-possiveis (tabuleiro tipo-peca)
  "Funcao que ve todas as jogadas possiveis para um determinado no"
  (cond
   ((and 
     (not (equal (nth 0 (nth 0 tabuleiro)) 1)) ;Caso ainda nao exista pe�as nossas em nenhum dos cantos do tabuleiro entao as jogadas possiveis sao os cantos do tabuleiro
     (not (equal (nth 13 (nth 0 tabuleiro)) 1))
     (not (equal (nth 0 (nth 13 tabuleiro)) 1))
     (not (equal (nth 13 (nth 13 tabuleiro)) 1))
     )
    (cond
     ((equal tipo-peca 'pequena) (list '(0 0) '(0 13)'(13 0) '(13 13)))
     ((equal tipo-peca 'media) (list '(0 0) '(0 12)'(12 0) '(12 12)))
     (T nil)
     )
    )

   (T (jogadas-possiveis-para-peca tabuleiro tipo-peca))
   )
)

(defun jogadas-possiveis-para-peca (tabuleiro tipo-peca &optional (linha 13) (coluna 13))
  (cond
   ((and (zerop linha) (zerop coluna)) nil)

   ((= coluna -1) (jogadas-possiveis-para-peca tabuleiro tipo-peca (1- linha) 13))

   ((= (nth coluna (nth linha tabuleiro)) 1) (append (aux (1- linha) (1- coluna) tabuleiro tipo-peca linha coluna) (jogadas-possiveis-para-peca tabuleiro tipo-peca linha (1- coluna))))

   (t (jogadas-possiveis-para-peca tabuleiro tipo-peca linha (1- coluna)))
  )
)

;;Ver em que linha e coluna estamos e alterar isto conforme isso 
;;SE ELE BATER LOGO NO PRIMEIRO CASO IGNORA OS OUTROS CASOS, NAO QUEREMOS ISSO
(defun jogadas-para-peca (linha coluna tabuleiro tipo-peca)
  (cond
   ((equal (nth (1+ coluna) (nth (1- linha) tabuleiro)) 0) (pode-colocarp (1- linha) (1+ coluna) tabuleiro tipo-peca))

   ((equal (nth (1- coluna) (nth (1- linha) tabuleiro)) 0) (pode-colocarp (1- linha) (1- coluna) tabuleiro tipo-peca))

   ((equal (nth (1+ coluna) (nth (1+ linha) tabuleiro)) 0) (pode-colocarp (1+ linha) (1+ coluna) tabuleiro tipo-peca))
   
   ((equal (nth (1- coluna) (nth (1+ linha) tabuleiro)) 0) (pode-colocarp (1+ linha) (1- coluna) tabuleiro tipo-peca))

   (T nil)
  )
)

;;Como e que eu crio uma funcao recursiva que veja os cantos do quadrado ?
;;Se eu fizer como esta na funcao assim e ele bater no primeiro caso nao ve os outros
;;isto por enquanto parece estar a dar !!
(defun aux (linha coluna tabuleiro tipo-peca &optional linha-original coluna-original)
  
  (cond
   ((and (= linha (1+ linha-original)) (= coluna (1+ coluna-original))) (append (pode-colocarp linha coluna tabuleiro tipo-peca)))

   ((>= coluna (+ coluna-original 2)) (aux (+ linha 2) (- coluna-original 1) tabuleiro tipo-peca linha-original coluna-original))

   ((equal (nth coluna (nth linha tabuleiro)) 0) (append (pode-colocarp linha coluna tabuleiro tipo-peca) (aux linha (+ coluna 2) tabuleiro tipo-peca linha-original coluna-original )))

   (T (aux linha (+ coluna 2) tabuleiro tipo-peca linha-original coluna-original))
  )

)


(defun pode-colocarp (linha coluna tabuleiro tipo-peca)
  (progn 
    (print coluna)
  (cond
   ((and
       (not (eq (nth (1+ coluna) (nth linha tabuleiro)) 1))
       (not (eq (nth (1- coluna) (nth linha tabuleiro)) 1))
       (not (eq (nth coluna (nth (1+ linha) tabuleiro)) 1))
       (not (eq (nth coluna (nth (1- linha) tabuleiro)) 1))
       (eq (nth coluna (nth linha tabuleiro)) 0)
       ) (list (list linha coluna)))
  )
)
)
