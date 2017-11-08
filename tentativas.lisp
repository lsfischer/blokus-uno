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
   '(0 0 0 0 0 0 0 0 1 0 0 0 0 0)
   '(0 0 0 0 0 0 0 1 1 1 0 0 0 0)
   '(0 0 0 0 0 0 0 0 1 0 1 0 0 0)
   '(0 0 0 0 0 0 0 0 0 0 0 1 1 0)
   '(0 0 0 0 0 0 0 0 0 0 0 1 1 0)
   '(0 0 0 0 0 0 0 0 0 0 0 0 0 1)
  )
)

(defun peca-pequena-contagem (linha coluna tabuleiro)
  (cond
   ((and (zerop linha) (zerop coluna)) 0)
   ((= coluna -1) (peca-pequena-contagem (1- linha) 13 tabuleiro))
   ((= (nth coluna (nth linha tabuleiro)) 1) (+ (peca-pequenap linha coluna tabuleiro) (peca-pequena-contagem linha (1- coluna) tabuleiro)))
   (T (peca-pequena-contagem linha (1- coluna) tabuleiro))
  )
)

(defun peca-pequenap (linha coluna tabuleiro)
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


