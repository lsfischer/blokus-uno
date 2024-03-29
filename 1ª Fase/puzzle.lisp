;;;; puzzle.lisp
;;;; Disciplina de IA - 2017/2018
;;;; Projeto 1 - Blokus Uno
;;;; Autor: Andreia Pereira (n 150221021) e Lucas Fischer (n 140221004)
;;;; Funcoes do dominio do problema


(defun tabuleiro ()
  '(
    (0 0 0 0 2 2 0 0 2 0 2 0)
    (0 0 0 0 2 2 0 2 2 2 0 2)
    (0 0 0 2 0 0 2 0 2 0 2 0)
    (0 2 2 0 0 2 2 2 0 2 2 2)
    (0 2 2 0 0 0 2 0 2 0 2 0)
    (0 0 0 0 0 0 0 2 2 2 0 2)
    (0 0 0 0 0 0 2 0 2 0 2 0)
    (0 0 0 0 0 2 2 2 0 2 2 2)
    (0 0 0 0 2 0 2 0 2 0 2 0)
    (0 0 0 2 2 2 0 2 2 2 0 2)
    (0 0 2 1 2 1 2 0 2 0 2 0)
    (1 2 2 2 1 2 2 2 0 2 2 2)
    (0 1 2 1 2 0 2 0 2 0 2 0)
    (1 0 0 2 0 2 0 2 0 2 0 0)
    (0 0 0 2 0 2 0 2 0 2 0 0)
    (1 0 1 2 1 2 0 2 0 2 0 0)
  )
)


(defun tabuleiro-vazio ()
  '(
    (0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 0 0 0 0 0 0 0 0 0)
    (0 0 0 0 0 0 0 0 0 0 0 0)
  )
)

;;;;;;;;;; Construtor ;;;;;;;;;;

;; cria-no

(defun cria-no (estado pecas &optional (profundidade 0) (heuristica 0) (f 0) (no-pai nil))
  "Cria uma lista que representa um no que tem um estado. Este no pode tambem ter uma profunidade, heuristica, f e um no que o gerou"
  (list estado pecas profundidade heuristica f no-pai)
)


;;;;;;;;;; Getters ;;;;;;;;;;

;; get-estado-no

(defun get-estado-no (no)
  "Funcao que retorna o estado de um no"
  (first no)
)



;; get-pecas-no

(defun get-pecas-no (no)
  "Funcao que retorna uma lista com 3 elementos que identificam o numero de pecas pequenas, o numero de pecas medias e o numero de pecas em cruz respetivamente"
  (second no)
)



;; get-profundidade-no

(defun get-profundidade-no (no)
  "Funcao que retorna a profundidade de um no"
  (third no)
)



;; get-heuristica-no

(defun get-heuristica-no (no)
  "Funcao que retorna a heuristica de um no"
  (fourth no)
)



;; get-f-no

(defun get-f-no (no)
  "Funcao que retorna o f de um no"
  (fifth no)
)



;; get-pai-no

(defun get-pai-no (no)
  "Funcao que retorna o no gerador de um determinado no"
  (sixth no)
)



;;;;;;;;;; Funcoes auxiliares ;;;;;;;;;;

;; peca-contagem, alterado

(defun peca-contagem (tabuleiro tipo-peca &optional (linha 0) (coluna 0))
  "Funcao que permite contar o numero de pecas do jogador existentes no tabuleiro conforme o seu tipo. Percore o tabuleiro das posicoes 13,13 ate a posicao 0,0"
  (cond
   ((null (nth linha tabuleiro)) 0)

   ((null (nth coluna (nth linha tabuleiro))) (peca-contagem tabuleiro tipo-peca (1+ linha) 0)) ; Quando ja tiver chegado a ultima coluna, muda de linha

   ((= (nth coluna (nth linha tabuleiro)) 1) (+ (tipo-pecap linha coluna tabuleiro tipo-peca) (peca-contagem tabuleiro tipo-peca linha (1+ coluna))))

   (T (peca-contagem tabuleiro tipo-peca linha (1+ coluna)))

  )
)





;; tipo-pecap

(defun tipo-pecap (linha coluna tabuleiro tipo-peca)
  "Funcao que ao passarmos uma posicao de um tabuleiro verifica se essa peca e do tipo de peca enviado por argumento"
  (cond

   ((equal tipo-peca 'pequena)
    (cond
     ((or ;Se em algumas das casas vizinhas estiver la um 1 entao devolvemos 0
       (casa-com-ump linha (1+ coluna) tabuleiro)
       (casa-com-ump linha (1- coluna) tabuleiro)
       (casa-com-ump (1+ linha) coluna tabuleiro)
       (casa-com-ump (1- linha) coluna tabuleiro)
       ) 0)
     (T 1)
     )
   )

   ((equal tipo-peca 'media)
    (cond
     ((and ;Se tiver 1 nestas posicoes entao e porque e uma peca media
       (casa-com-ump linha (1- coluna) tabuleiro)
       (casa-com-ump (1- linha) coluna tabuleiro)
       (casa-com-ump (1- linha) (1- coluna) tabuleiro)
       ) 1)
     (T 0)
    )
   )

   ((equal tipo-peca 'cruz)
    (cond
     ((and  ;Se tiver 1 nestas posicoes entao e porque e uma peca em cruz
       (not (= coluna 13))
       (not (= coluna 0))
       (not (< linha 2))
       (casa-com-ump (1- linha) coluna tabuleiro)
       (casa-com-ump (1- linha) (1- coluna) tabuleiro)
       (casa-com-ump (1- linha) (1+ coluna) tabuleiro)
       (casa-com-ump (- linha 2) coluna tabuleiro)
      ) 1)
     (T 0)
    )
   )

   (T nil)

  )
)





;; jogada-in-jogadas-possiveis-p

(defun jogada-in-jogadas-possiveis-p (jogada tabuleiro tipo-peca)
  "Funcao que verifica se uma determinada jogada existe na lista de jogadas possiveis para a peca passada por argumento"
  (let (
        (jogadas-possiveis (funcall #'jogadas-possiveis tabuleiro tipo-peca))
       )
    (eval (cons 'or (mapcar #'(lambda (jogada-possivel) 
                                (cond
                                 ((equal jogada-possivel jogada) T)
                                 (T nil)
                                 )
                                ) jogadas-possiveis))) 
  )
)





;; quadrados-por-preencher-numa-linha

(defun quadrados-por-preencher-numa-linha (linha)
  "Conta o numero de quadrados por preencher numa determinada linha (posicoes que estao a 0 nessa linha)"
  (cond
   ((null linha) 0)

   ((zerop (first linha)) (+ 1 (quadrados-por-preencher-numa-linha (rest linha))))

   (T (quadrados-por-preencher-numa-linha (rest linha)))
  )
)






;; quadrados-por-preencher

(defun quadrados-por-preencher (tabuleiro)
  "Conta o numero de posicoes que estao a 0 num tabuleiro, que corresponde ao numero de quadrados por preencher num tabuleiro"
  (cond
   ((null tabuleiro) 0)

   (T (+ (quadrados-por-preencher-numa-linha (first tabuleiro)) (quadrados-por-preencher (rest tabuleiro))))
  )
)






;; quadrados-ja-preenchidos, alterado

(defun quadrados-ja-preenchidos (tabuleiro)
  "Funcao que conta o numero de quadrados ja preenchidos atraves da subtracao do total pelo numero de quadrados por preencher"
  (let (
        (numero-total-pecas (get-numero-total tabuleiro))
       )

    (- numero-total-pecas (quadrados-por-preencher tabuleiro))

  )
)


;; get-numero-total, nova funcao

(defun get-numero-total (tabuleiro)
  "Funcao que devolver o numero total de posicoes existente num tabuleiro"
  (let (
        (numero-linhas (length tabuleiro))
        (numero-colunas (length (first tabuleiro)))
       )

    (* numero-linhas numero-colunas)
    
  )
)





;; construir-listas

(defun construir-listas (elems listas)
  "Funcao auxiliar que permite juntar os elementos removidos da cabeca das listas novamente com as mesmas de forma a manter a integridade das listas"
  (mapcar #'cons elems listas)
)







;; inserir-peca-pequena-na-coluna

(defun inserir-peca-pequena-na-coluna (coluna lista)
  "Permite inserir a peca mais pequena numa determinada coluna da lista passada como argumento"
  (cond 
   ((null lista) nil)

   ((= coluna 0) (cons 1 (rest lista)))

   (T (cons (first lista) (inserir-peca-pequena-na-coluna (1- coluna) (rest lista))))

  )
)







;; inserir-peca-media-na-coluna

(defun inserir-peca-media-na-coluna (coluna linhas)
  "Funcao que permite inserir uma peca media numa determinada coluna colocando o primeiro quadrado no canto superior esquerdo da peca"
  (let (
        (linha-cima (first linhas)) 
        (linha-baixo (second linhas))
       )

    (cond
     ((null linha-cima) nil)

     ((= coluna 0) 
      (list
       (append '(1 1) (rest (rest linha-cima))) ;;cddr 
       (append '(1 1) (rest (rest linha-baixo))) ;;cddr
       )
      )

     (T
      (construir-listas 
        (list (first linha-cima) (first linha-baixo))
        (inserir-peca-media-na-coluna (1- coluna) (list (rest linha-cima) (rest linha-baixo)))
      )
     )

    )
  )
)








;; inserir-peca-cruz-na-coluna

(defun inserir-peca-cruz-na-coluna (coluna linhas)
  "Funcao auxiliar da funcao inserir-peca-cruz que permite inserir uma peca em cruz numa determinada colocando o primeiro quadrado na ponta esquerda da peca"
  (let (
        (linha-cima (first linhas)) 
        (linha-meio (second linhas))
        (linha-baixo (third linhas))
       )

    (cond
     ((null linha-meio) nil)
     
     ((= coluna 0)
      (list
       (cons (first linha-cima) (cons 1 (rest (rest linha-cima))))
       (append '(1 1 1) (rest (rest (rest linha-meio))))
       (cons (first linha-baixo) (cons 1 (rest (rest linha-baixo))))
      )
     )

     (T
      (construir-listas
       (list (first linha-cima) (first linha-meio) (first linha-baixo))
       (inserir-peca-cruz-na-coluna (1- coluna) (list (rest linha-cima) (rest linha-meio) (rest linha-baixo)))
      )
     )

    )
  )
)







;;;;;;;;;; Operadores ;;;;;;;;;;

;; inserir-peca-pequena

(defun inserir-peca-pequena (linha coluna tabuleiro &optional (linha-original linha) (coluna-original coluna) (tabuleiro-original tabuleiro))
  "Funcao que permite inserir a peca mais pequena numa determinada linha e coluna. A linha e coluna sao argumentos numericos"
  (cond
   ((null tabuleiro) nil)

   ((not (jogada-in-jogadas-possiveis-p (list linha-original coluna-original) tabuleiro-original 'pequena)) nil)  ;Se nao for uma jogada possivel nao pode jogar

   ((= linha 0) (cons (inserir-peca-pequena-na-coluna coluna (first tabuleiro)) (rest tabuleiro))) ;Retiramos a linha onde vamos colocar a peca media e juntamos-a com o resto do tabuleiro

   (T 
    (cons 
     (first tabuleiro) 
     (inserir-peca-pequena (1- linha) coluna (rest tabuleiro) linha-original coluna-original tabuleiro-original))
    )

  )
)







;; inserir-peca-media   

(defun inserir-peca-media (linha coluna tabuleiro &optional (linha-original linha) (coluna-original coluna) (tabuleiro-original tabuleiro))
  "Funcao que permite inserir a peca media numa determinada linha e coluna do tabuleiro passado por argumento. A linha e coluna sao argumentos numericos"
  (cond 
   ((null tabuleiro) nil)

   ((not (jogada-in-jogadas-possiveis-p (list linha-original coluna-original) tabuleiro-original 'media)) nil)  ;Se nao for uma jogada possivel nao pode jogar

   ((= linha 0) 
    (append 
     (inserir-peca-media-na-coluna coluna (list (first tabuleiro) (second tabuleiro))) 
     (rest (rest tabuleiro)) ;;cddr
    ) ;Retira-se as 2 linhas onde vamos colocar os 1's para construir a peca media e juntamos-as com o resto do tabuleiro
   )

   (T
    (cons 
     (first tabuleiro) 
     (inserir-peca-media (1- linha) coluna (rest tabuleiro) linha-original coluna-original tabuleiro-original)
    )
   )

  )
)







;; inserir-peca-cruz

(defun inserir-peca-cruz (linha coluna tabuleiro &optional (linha-original linha) (coluna-original coluna) (tabuleiro-original tabuleiro) )
  "Funcao que permite inserir uma peca em cruz no tabuleiro passado como argumento numa determinada linha e coluna. A linha e coluna sao argumentos numericos"
  (cond
   ((null tabuleiro) nil)

   ((not (jogada-in-jogadas-possiveis-p (list linha-original coluna-original) tabuleiro-original 'cruz)) nil) ;Se nao for uma jogada possivel nao pode jogar
   
   ((= linha 1) ;;tem que ser uma linha antes para por a peca de cima
    (append
     (inserir-peca-cruz-na-coluna coluna (list (first tabuleiro) (second tabuleiro) (third tabuleiro)))
     (rest (rest (rest tabuleiro))) ;;cdddr
    ) ;Retira-se as 3 linhas onde vamos colocar os 1's para construir a peca em cruz e juntamos-as com o resto do tabuleiro
   )

   (T
    (cons
     (first tabuleiro)
     (inserir-peca-cruz (1- linha) coluna (rest tabuleiro) linha-original coluna-original tabuleiro-original)
    )
   )

  )
)





;; operadores

(defun operadores ()
  "Funcao que lista todos os operadores existentes no dominio do problema"
  (list 'inserir-peca-cruz 'inserir-peca-pequena 'inserir-peca-media )
)






;;;;;;;;;; Jogadas possiveis ;;;;;;;;;;

;; jogadas-possives

(defun jogadas-possiveis (tabuleiro tipo-peca)
  "Funcao que determina todas as jogadas possiveis para um tipo de peca num determinado tabuleiro, devolvendo-as numa lista"

  (let (
        (ultima-coluna (1- (length (first tabuleiro))))
        (ultima-linha (1- (length tabuleiro)))
       )

    (cond
     ((and  ;Se ainda nao existir nenhum 1 nas posicoes dos cantos do tabuleiro
       (not (casa-com-ump 0 0 tabuleiro))
       (not (casa-com-ump 0 ultima-coluna tabuleiro))
       (not (casa-com-ump ultima-linha 0 tabuleiro))
       (not (casa-com-ump ultima-linha ultima-coluna tabuleiro))
      ) (cond
          ((or (equal tipo-peca 'pequena) (equal tipo-peca 'media))
           (jogada-inicial-p tabuleiro tipo-peca)
          )
          (T nil)
         )
     )

     (T (percorre-matriz-peca tabuleiro tipo-peca))  ;Caso ja exista pelo menos um 1 num dos cantos do tabuleiro
   )
  )
)







;jogada-inicial-p, alterado

(defun jogada-inicial-p (tabuleiro tipo-peca &optional (linha 0) (coluna 0))
  "Funcao que caso o jogador ainda nao tenha lancado nenhuma peca ira determinar quais as jogadas iniciais possiveis"
  (let (
        (ultima-coluna (1- (length (first tabuleiro))))
        (ultima-linha (1- (length tabuleiro)))
       )

    (cond
     ((and (= linha ultima-linha) (= coluna ultima-coluna)) 
      (cond
       ((and (not (casa-com-ump ultima-linha ultima-coluna tabuleiro)) (zerop (nth ultima-coluna (nth ultima-linha tabuleiro))) (equal tipo-peca 'pequena)) 
        (list (list ultima-linha ultima-coluna))
        )
       ((and (not (casa-com-ump ultima-linha ultima-coluna tabuleiro)) (zerop (nth ultima-coluna (nth ultima-linha tabuleiro))) (equal tipo-peca 'media) (pode-colocarp (1- ultima-linha) (1- ultima-coluna) tabuleiro 'media)) 
        (list (list (1- ultima-linha) (1- ultima-coluna)))
        )
       (T nil)
       )
      )

     ((and (zerop linha) (zerop coluna))
      (cond
       ((and (not (casa-com-ump 0 0 tabuleiro)) (zerop (nth 0 (nth 0 tabuleiro))) (equal tipo-peca 'pequena) )
        (append (list (list 0 0)) (jogada-inicial-p tabuleiro tipo-peca 0 ultima-coluna))
        )  ;Caso seja uma peca pequena e na posicao 0,0 esteja um zero entao e uma jogada possivel, passamos a verificar a posicao 0,ultima-coluna

       ((and (not (casa-com-ump 0 0 tabuleiro)) (zerop (nth 0 (nth 0 tabuleiro))) (equal tipo-peca 'media) (pode-colocarp 0 0 tabuleiro 'media) )
        (append (list (list 0 0)) (jogada-inicial-p tabuleiro tipo-peca 0 ultima-coluna))
        ) ;Caso seja uma peca media e na posicao 0,0 esteja um zero entao e uma jogada possivel, passamos a verificar a posicao 0,ultima-coluna

       (T (jogada-inicial-p tabuleiro tipo-peca 0 ultima-coluna))  ;Passamos a verificar a posicao 0,ultima-coluna
       )
      )

     ((and (zerop linha) (= coluna ultima-coluna))
      (cond
       ((and (not (casa-com-ump 0 ultima-coluna tabuleiro)) (zerop (nth ultima-coluna (nth 0 tabuleiro))) (equal tipo-peca 'pequena))
        (append (list (list 0 ultima-coluna)) (jogada-inicial-p tabuleiro tipo-peca ultima-linha 0))
        ) ;Caso seja uma peca pequena e na posicao 0,ultima-coluna esteja um zero entao e uma jogada possivel, passamos a verificar a posicao ultima-linha,0

       ((and (not (casa-com-ump 0 ultima-coluna tabuleiro)) (zerop (nth ultima-coluna (nth 0 tabuleiro))) (equal tipo-peca 'media) (pode-colocarp 0 (1- ultima-coluna) tabuleiro 'media))
        (append (list (list 0 (1- ultima-coluna))) (jogada-inicial-p tabuleiro tipo-peca ultima-linha 0))
        )  ;Caso seja uma peca media e na posicao 0,ultima-coluna esteja um zero entao e uma jogada possivel, passamos a verificar a posicao ultima-linha,0

       (T (jogada-inicial-p tabuleiro tipo-peca ultima-linha 0))  ;Passamos a verificar a posicao ultima-linha,0
       )
      )

     ((and (= linha ultima-linha) (zerop coluna))
      (cond
       ((and (not (casa-com-ump ultima-linha 0 tabuleiro)) (zerop (nth 0 (nth ultima-linha tabuleiro))) (equal tipo-peca 'pequena))
        (append (list (list ultima-linha 0)) (jogada-inicial-p tabuleiro tipo-peca ultima-linha ultima-coluna))
        ) ;Caso seja uma peca pequena e na posicao ultima-linha,0 esteja um zero entao e uma jogada possivel, passamos a verificar a posicao ultima-linha,ultima-coluna

       ((and (not (casa-com-ump ultima-linha 0 tabuleiro)) (zerop (nth 0 (nth ultima-linha tabuleiro))) (equal tipo-peca 'media) (pode-colocarp (1- ultima-linha) 0 tabuleiro 'media))
        (append (list (list (1- ultima-linha) 0)) (jogada-inicial-p tabuleiro tipo-peca ultima-linha ultima-coluna))
        )  ;Caso seja uma peca media e na posicao ultima-linha,0 esteja um zero entao e uma jogada possivel, passamos a verificar a posicao ultima-linha,ultima-coluna

       (T (jogada-inicial-p tabuleiro tipo-peca ultima-linha ultima-coluna)) ;passmos a verificar a posicao ultima-linha,ultima-coluna
       )
      )

     (T nil)

     )

  )
  
  
)







;; percorre-matriz-peca, alterado

(defun percorre-matriz-peca (tabuleiro tipo-peca &optional (linha (1- (length tabuleiro))) (coluna (1- (length (first tabuleiro)))) )
  "Funcao que percorre a matriz a partir do seu fim e caso encontre alguma peca jogada pelo jogador ira verificar se e possivel colocar uma nova peca num dos seus cantos"
  (cond
   ((and (zerop linha) (zerop coluna)) ;;Ja percorreu a matriz inteira e esta na posicao (0,0) 
      (cond

        ((equal tipo-peca 'pequena)
          (cond
            ((casa-com-ump linha coluna tabuleiro) (pode-colocarp 1 1 tabuleiro 'pequena))  ;Caso exista um 1 na posicao 0,0 verificar se podemos colocar uma peca pequena
            (T nil)
          )
        )

        ((equal tipo-peca 'media)
          (cond
            ((casa-com-ump linha coluna tabuleiro) (pode-colocarp 1 1 tabuleiro 'media))  ;Caso exista um 1 na posicao 0,0 verificar se podemos colocar uma peca media
            (T nil)
          )
        )

        ((equal tipo-peca 'cruz)
          (cond
            ((casa-com-ump linha coluna tabuleiro) (append (pode-colocarp 2 0 tabuleiro 'cruz) (pode-colocarp 1 1 tabuleiro 'cruz) ))   ;Caso exista um 1 na posicao 0,0 verificar se podemos colocar uma peca em cruz
            (T nil)
          )
        )

      )
    )

   ((= coluna -1) (percorre-matriz-peca tabuleiro tipo-peca (1- linha) (1- (length (first tabuleiro))))) ;Quando estivermos na coluna -1, vamos para a linha de cima e voltamos a coluna 13

   ((casa-com-ump linha coluna tabuleiro) ;Caso a posicao em que estejamos atualmente tenha la um 1
    (cond

      ((equal tipo-peca 'pequena)
        (append (cantos-disponiveis-peca-pequena (1- linha) (1- coluna) tabuleiro linha coluna) (percorre-matriz-peca tabuleiro tipo-peca linha (1- coluna)))  
      )

      ((equal tipo-peca 'media)
        (append (cantos-disponiveis-peca-media (- linha 2) (- coluna 2) tabuleiro linha coluna) (percorre-matriz-peca tabuleiro tipo-peca linha (1- coluna)))
      )

      ((equal tipo-peca 'cruz)
        (append (append (cantos-disponiveis-peca-cruz-horizontal (1- linha) (- coluna 3) tabuleiro linha coluna) (cantos-disponiveis-peca-cruz-vertical (- linha 2) (- coluna 2) tabuleiro linha coluna)) (percorre-matriz-peca tabuleiro tipo-peca linha (1- coluna)))
      )

      (T nil)
    )
   )

   (t (percorre-matriz-peca tabuleiro tipo-peca linha (1- coluna)))
  )
)





;;;;;;;;;; Cantos possiveis peca cruz ;;;;;;;;;;

;; cantos-disponiveis-peca-horizontal

(defun cantos-disponiveis-peca-cruz-horizontal (linha coluna tabuleiro linha-original coluna-original)
  "Funcao que ira percorrer todos os cantos de uma determinada peca situada na linha e coluna passada como argumentos para averiguar se e possivel colocar uma peca em cruz de modo a que as pecas laterias da peca em cruz fiquem diagonalmente colocadas com a peca em questao"
  (cond

   ((and (= linha (1+ linha-original)) (= coluna (1+ coluna-original))) (append (pode-colocarp linha coluna tabuleiro 'cruz)))

   ((>= coluna (+ coluna-original 2)) (cantos-disponiveis-peca-cruz-horizontal (1+ linha-original) (- coluna-original 3) tabuleiro linha-original coluna-original ))

   ((< coluna 0) (cantos-disponiveis-peca-cruz-horizontal linha (+ coluna 4) tabuleiro linha-original coluna-original))

   ((< linha 1) (cantos-disponiveis-peca-cruz-horizontal (1+ linha-original) coluna tabuleiro linha-original coluna-original))


   ((verifica-casas-vazias tabuleiro (list
                                      (list (1- linha) (1+ coluna))
                                      (list linha coluna) (list linha (1+ coluna)) (list linha (+ coluna 2))
                                      (list (1+ linha) (1+ coluna))
                                      )) (append (pode-colocarp linha coluna tabuleiro 'cruz) (cantos-disponiveis-peca-cruz-horizontal linha (+ coluna 4) tabuleiro linha-original coluna-original)))


   (T (cantos-disponiveis-peca-cruz-horizontal linha (+ coluna 4) tabuleiro linha-original coluna-original))

  )
)






;; cantos-disponiveis-peca-cruz-vertical

(defun cantos-disponiveis-peca-cruz-vertical (linha coluna tabuleiro linha-original coluna-original)
  "Funcao que ira percorrer todos os cantos de uma determinada peca situada na linha e coluna passada como argumentos para averiguar se e possivel colocar uma peca em cruz de modo a que as pecas verticais da peca em cruz fiquem diagonalmente colocadas com a peca em questao"
  (cond

   ((and (= linha (+ linha-original 2)) (= coluna coluna-original)) (append (pode-colocarp linha coluna tabuleiro 'cruz)))

   ((>= coluna (1+ coluna-original)) (cantos-disponiveis-peca-cruz-vertical (+ linha-original 2) (- coluna-original 2) tabuleiro linha-original coluna-original ))


   ((< coluna 0) (cantos-disponiveis-peca-cruz-vertical linha (+ coluna 2) tabuleiro linha-original coluna-original))


   ((< linha 1) (cantos-disponiveis-peca-cruz-vertical (+ linha-original 2) coluna tabuleiro linha-original coluna-original))
   

   ((verifica-casas-vazias tabuleiro (list
                                      (list (1- linha) (1+ coluna))
                                      (list linha coluna) (list linha (1+ coluna)) (list linha (+ coluna 2))
                                      (list (1+ linha) (1+ coluna))
                                      )) (append (pode-colocarp linha coluna tabuleiro 'cruz) (cantos-disponiveis-peca-cruz-vertical linha (+ coluna 2) tabuleiro linha-original coluna-original)))

  (T (cantos-disponiveis-peca-cruz-vertical linha (+ coluna 2) tabuleiro linha-original coluna-original))

  )

)






;;;;;;;;;; Cantos possiveis peca media ;;;;;;;;;;

;; cantos-disponiveis-peca-media

(defun cantos-disponiveis-peca-media (linha coluna tabulerio &optional linha-original coluna-original)
  "Funcao que ira percorrer todos os cantos possiveis de uma determinada peca situada na linha e coluna passada como argumentos e averiguar se e possivel colocar uma peca media nesses cantos"
  (cond

   ((<= linha -1) (cantos-disponiveis-peca-media (+ linha 3) coluna tabulerio linha-original coluna-original))

   ((<= coluna -1) (cantos-disponiveis-peca-media linha (+ coluna 3) tabulerio linha-original coluna-original))
   

   ((and (= linha (1+ linha-original)) (= coluna (1+ coluna-original))) (append (pode-colocarp linha coluna tabulerio 'media)))

   ((>= coluna (+ coluna-original 2)) (cantos-disponiveis-peca-media (+ linha 3) (- coluna-original 2) tabulerio linha-original coluna-original))

   ((verifica-casas-vazias tabulerio (list 
                                      (list linha coluna) (list linha (1+ coluna))
                                      (list (1+ linha) coluna) (list (1+ linha) (1+ coluna))
                                      )) (append (pode-colocarp linha coluna tabulerio 'media)
                                                 (cantos-disponiveis-peca-media linha (+ coluna 3) tabulerio linha-original coluna-original)))

   (T (cantos-disponiveis-peca-media linha (+ coluna 3) tabulerio linha-original coluna-original))

  )
)





;;;;;;;;;; Cantos possiveis peca pequena ;;;;;;;;;;

;; cantos-disponiveis-peca-pequena

(defun cantos-disponiveis-peca-pequena (linha coluna tabuleiro &optional linha-original coluna-original)
  "Funcao que ira percorrer todos os cantos possiveis de uma determinada peca situada na linha e coluna passada como argumentos e averiguar se e possivel colocar uma peca pequna nesses cantos"
  (cond
   ((= linha -1) (cantos-disponiveis-peca-pequena (+ linha 2) coluna tabuleiro linha-original coluna-original)) ;;Se os cantos superiores ja estiverem fora do tabuleiro nao vale a pena ve-los
   
   ((= coluna -1) (cantos-disponiveis-peca-pequena linha (+ coluna 2) tabuleiro linha-original coluna-original)) ;; Se os cantos laterais esquerdos estiverem fora do tabuleiro nao vale a pena ve-los

   ((and (= linha (1+ linha-original)) (= coluna (1+ coluna-original))) (append (pode-colocarp linha coluna tabuleiro 'pequena)))

   ((>= coluna (+ coluna-original 2)) (cantos-disponiveis-peca-pequena (+ linha 2) (- coluna-original 1) tabuleiro linha-original coluna-original))

   ((equal (nth coluna (nth linha tabuleiro)) 0) (append (pode-colocarp linha coluna tabuleiro 'pequena) (cantos-disponiveis-peca-pequena linha (+ coluna 2) tabuleiro linha-original coluna-original )))

   (T (cantos-disponiveis-peca-pequena linha (+ coluna 2) tabuleiro linha-original coluna-original))
  )

)







;; verifica-casas-vazias

(defun verifica-casas-vazias (tabuleiro casas)
  "Funcao auxiliar para determinar se uma peca ira sobrepor alguma peca ja existente ou nao"
  (eval (cons 'and (mapcar #'(lambda (casa) 
              (cond
                ((eq (nth (second casa) (nth (first casa) tabuleiro)) 0) T) ;Se a posicao dada conter um 0, entao esta vazia
                (T nil)
              )
            ) casas)))
)






;; casa-com-ump

(defun casa-com-ump (linha coluna tabuleiro)
  "Funcao que determina se uma posicao tem la uma peca do jogador ou nao"
  (cond
   ((or (= linha -1) (= coluna -1)) NIL)
   ((eq (nth coluna (nth linha tabuleiro)) 1) T)
   (T nil)
  )
)






;; pode-colocarp

(defun pode-colocarp (linha coluna tabuleiro tipo-peca)
  "Funcao que verifica se , ao colocarmos uma peca num dos cantos de uma peca ja existe, nao fica posicionada lateralmente com uma peca ja jogada pelo jogador "
  (cond

   ((equal tipo-peca 'cruz)
    (cond
     ((and 
       (not (casa-com-ump linha (1- coluna) tabuleiro))
       (not (casa-com-ump (1- linha) coluna tabuleiro))
       (not (casa-com-ump (1+ linha) coluna tabuleiro))
       (not (casa-com-ump (- linha 2) (1+ coluna) tabuleiro))
       (not (casa-com-ump (+ linha 2) (1+ coluna) tabuleiro))
       (not (casa-com-ump (1- linha) (+ coluna 2) tabuleiro))
       (not (casa-com-ump (1+ linha) (+ coluna 2) tabuleiro))
       (not (casa-com-ump linha (+ coluna 3) tabuleiro))
       (eq (nth (1+ coluna) (nth (1- linha) tabuleiro)) 0)
       (eq (nth coluna (nth linha tabuleiro)) 0)
       (eq (nth (1+ coluna) (nth linha tabuleiro)) 0)
       (eq (nth (+ coluna 2) (nth linha tabuleiro)) 0)
       (eq (nth (1+ coluna) (nth (1+ linha) tabuleiro)) 0)
       ) (list (list linha coluna)))
     (T NIL)
     )
   )

   ((equal tipo-peca 'media)
    (cond
     ((and 
       (not (casa-com-ump (1- linha) coluna tabuleiro))
       (not (casa-com-ump (1- linha) (1+ coluna) tabuleiro))
       (not (casa-com-ump linha (1- coluna) tabuleiro))
       (not (casa-com-ump linha (+ coluna 2) tabuleiro))
       (not (casa-com-ump (1+ linha) (1- coluna) tabuleiro))
       (not (casa-com-ump (1+ linha) (+ coluna 2) tabuleiro))
       (not (casa-com-ump (+ linha 2) coluna tabuleiro))
       (not (casa-com-ump (+ linha 2) (1+ coluna) tabuleiro))
       (eq (nth coluna (nth linha tabuleiro)) 0)
       (eq (nth (1+ coluna) (nth linha tabuleiro)) 0)
       (eq (nth coluna (nth (1+ linha) tabuleiro)) 0)
       (eq (nth (1+ coluna) (nth (1+ linha) tabuleiro)) 0)
       ) (list (list linha coluna)))
     (T NIL)
     )
   )


   ((equal tipo-peca 'pequena)
    (cond
     ((and
       (not (casa-com-ump linha (1+ coluna) tabuleiro))
       (not (casa-com-ump linha (1- coluna) tabuleiro))
       (not (casa-com-ump (1+ linha) coluna tabuleiro))
       (not (casa-com-ump (1- linha) coluna tabuleiro))
       (eq (nth coluna (nth linha tabuleiro)) 0)
       ) (list (list linha coluna)))
     (T nil)
     )
   )

  )
)





;;;;;;;;;; Heuristicas ;;;;;;;;;;

;; heuristica

(defun heuristica (tabuleiro &optional (pecas nil))
  "Funcao heuristica do problema, implementa uma funcao que subtrai os quadrados por preencher de um tabuleiro pelos quadrados ja preenchidos, priviligiando os tabuleiros com maior numedo de quadrados preenchidos"
  (- (quadrados-por-preencher tabuleiro) (quadrados-ja-preenchidos tabuleiro))
)






;; heuristica2

(defun heuristica2 (tabuleiro &optional (pecas nil))
  "Segunda funcao heuristica do problema. Esta funcao heuristica tente priviligiar os tabuleiros onde o numero de jogadas possiveis for mais pequeno porque em geral quanto menos jogadas forem possiveis mais rapidamente chega-se a um no onde nao existem jogadas possiveis"
  (let (
        (jogadas-pequena (cond
                          ((<= (first pecas) 0) 0)
                          (T (length (jogadas-possiveis tabuleiro 'pequena)))
                         )) ; Se ja nao existirem pecas pequenas entao ha 0 jogadas possives para a peca pequena, caso contrario vamos conta-las

        (jogadas-media (cond
                        ((<= (second pecas) 0))
                        (T (length (jogadas-possiveis tabuleiro 'media)))
                       )) ; Se ja nao existirem pecas medias entao ha 0 jogadas possives para a peca media, caso contrario vamos conta-las


        (jogadas-cruz (cond
                       ((<= (third pecas) 0) 0)
                       (T (length (jogadas-possiveis tabuleiro 'cruz)))
                      )) ; Se ja nao existirem pecas em cruz entao ha 0 jogadas possives para a peca em cruz, caso contrario vamos conta-las
       )
    (+ jogadas-pequena jogadas-media jogadas-cruz) ; Soma de todas as jogadas possiveis para obter o numero total de jogadas possiveis
  )
)






;; heuristica 3
(defun heuristica3 (tabuleiro &optional (pecas nil))
  "Tentativa de criar uma heuristica que trabalhasse com o numero de pecas no tabuleiro, nao esta a funcionar"
  (let (
        (pecas-pequenas (peca-contagem tabuleiro 'pequena))
        (pecas-media (peca-contagem tabuleiro 'media))
        (pecas-cruz (peca-contagem tabuleiro 'cruz))
       )
    (- 35 pecas-pequenas pecas-media pecas-cruz)
  )
)







;;;;;;;;;; Solucao ;;;;;;;;;;

;;no-objetivo-p

(defun no-objetivo-p (no)
  "Funcao que determina se um no e no objetivo ou nao, ou seja, se um no ja nao tem mais pecas para jogar ou se um no ja nao tem jogadas possiveis"
  (let
      (
       (tabuleiro (get-estado-no no))
       (pecas-no (get-pecas-no no))
      )

    (cond

     ((or
       (and (not (null (jogadas-possiveis tabuleiro 'pequena))) (> (first pecas-no) 0))
       (and (not (null (jogadas-possiveis tabuleiro 'media))) (> (second pecas-no) 0))
       (and (not (null (jogadas-possiveis tabuleiro 'cruz))) (> (third pecas-no) 0))
      ) nil)

     (T T)

    )
  )
)
