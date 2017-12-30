;;;;Disciplina de IA - 2017/2018
;;;;Projeto 1 - Blokus Uno
;;;;Autor: Andreia Pereira (n 150221021) e Lucas Fischer (n 140221004)
;;;Implementacao do Algoritmo AlfaBeta e da funcao sucessores
;;;;;;;; Sucessores ;;;;;;;;

;; sucessores 

(defun sucessores (no operadores algoritmo heuristica &optional (profundidade nil))
  "Funcao que devolve a lista de todos os sucessores de um determinado no passado como argumento"

  (cond

   ((equal algoritmo 'dfs)
    (cond
     ((>= (get-profundidade-no no) profundidade) nil)  ;So se aplica os sucessores caso a profundidade do no seja inferior a profundidade maxima

     (T (apply #'append (mapcar #'(lambda(operador)
                                    (aplicar-operador-no no operador heuristica)
                                  ) operadores)))
     )
   )

   (T (apply #'append (mapcar #'(lambda(operador)
                                  (aplicar-operador-no no operador heuristica)
                                ) operadores)))
  )
)





;;aplicar-operador-no

(defun aplicar-operador-no (no operador heuristica-escolhida)
  "Funcao que aplica apenas um operador a um determinado no. Consoante o operador passado por argumento esta funcao ira determinar as jogadas possiveis para esse operador e ira criar um no (um sucessor) para cada uma dessas jogadas possives"
  (let
    (
     (jogadas-possiveis (cond
                         ((equal operador 'inserir-peca-pequena)
                          (jogadas-possiveis (get-estado-no no) 'pequena))

                         ((equal operador 'inserir-peca-media)
                          (jogadas-possiveis (get-estado-no no) 'media))

                         ((equal operador 'inserir-peca-cruz)
                          (jogadas-possiveis (get-estado-no no) 'cruz))
                         )
                        )

     (numero-peca-pequena (cond
                           ((equal operador 'inserir-peca-pequena)
                            (1- (first (get-pecas-no no)))
                           )
                           (T (first (get-pecas-no no)))
                           )
                          )

     (numero-peca-media (cond
                           ((equal operador 'inserir-peca-media)
                            (1- (second (get-pecas-no no)))
                           )
                           (T (second (get-pecas-no no)))
                          )
                        )

     (numero-peca-cruz (cond
                           ((equal operador 'inserir-peca-cruz)
                            (1- (third (get-pecas-no no)))
                           )
                           (T (third (get-pecas-no no)))
                          )
                       )

    )
    
    (cond
     ((and (equal operador 'inserir-peca-pequena) (< numero-peca-pequena 0)) nil) ;Se nao existir pecas para o operador que queremos usar, devolve nil
     ((and (equal operador 'inserir-peca-media) (< numero-peca-media 0)) nil)
     ((and (equal operador 'inserir-peca-cruz) (< numero-peca-cruz 0)) nil)
     
     (T 
      (mapcar #'(lambda (jogada)
                  (let* (
                        (estado (funcall operador (first jogada) (second jogada) (get-estado-no no)))
                        (pecas-novas (list numero-peca-pequena numero-peca-media numero-peca-cruz))
                        (heuristica-novo-no (funcall heuristica-escolhida estado pecas-novas))
                        (profundidade-novo-no (1+ (get-profundidade-no no)))
                        (custo-novo-no (+ profundidade-novo-no heuristica-novo-no))
                       )
                    (cria-no estado pecas-novas profundidade-novo-no heuristica-novo-no custo-novo-no no)
                 )
                ) jogadas-possiveis)
      )
    )
  )
)

