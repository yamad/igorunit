============================
 Editing this documentation
============================

To make editing plain text easier, I have used `org-mode`_ for the
`emacs`_ editor.

org-mode has a wonderful table editing environment that is very easy
to work with. This environment can be used in any major mode by
turning on the *orgtbl* minor mode. To turn on orgtbl mode for
rst-mode all the time, add the following line to your *.emacs* file::

    (add-hook 'rst-mode-hook 'turn-on-orgtbl)

As of version 6.33, `org-mode`_ has a feature called `radio tables`_
that allows conversion of org-mode tables to an arbitrary format.

The source table is written in org-mode format. At the top of the table, add the line::

    #+ORGTBL: SEND <table_name> orgtbl-to-rst

The translated table is automatically placed at the target site, defined by the following lines::

    .. BEGIN RECEIVE ORGTBL <table_name>
    .. END RECEIVE ORGTBL <table_name>

Hitting *C-c C-c* while in the source table will insert the translated
table between the above lines. The source table must be commented out
when it is not being edited, which can be done with *M-x
orgtbl-toggle-comment*.

Therefore, to edit a table:

 #) Navigate to the source table
 #) *M-x orgtbl-toggle-comment* to uncomment the source table
 #) Do edits...
 #) *C-c C-c* to generate the translated table
 #) *M-x orgtbl-toggle-comment* to comment the source table

Note that the function *orgtbl-to-rst* must be available. Add this
function to your *.emacs* file::

    ;; rst export for orgtbl
    (defun tbl-line (start end sep width-list field-func)
      (concat
       start
       (mapconcat (lambda (width) (funcall field-func width))
                  width-list sep)
       end))
    (defun tbl-hline (start end sep line-mark width-list)
      (tbl-line start end sep width-list
                (lambda (width)
                  (apply 'string (make-list width line-mark)))))

    (defun orgtbl-to-rst (table params)
      (let* ((hline (tbl-hline "+-" "-+" "-+-" ?- org-table-last-column-widths))
             (hlline (tbl-hline "+=" "=+" "=+=" ?= org-table-last-column-widths))
             (rst-fmt (tbl-line "| " " |" " | " org-table-last-column-widths
                                (lambda (width) (format "%%-%ss" width))))
             (rst-lfmt (concat
                        rst-fmt "\n" hline))
             (rst-hlfmt (concat
                         rst-fmt "\n" hlline))
             (params_default
              (list
               :tstart hline
               :lfmt (lambda (line) (apply 'format (cons rst-lfmt line)))
               :hlfmt (lambda (line) (apply 'format (cons rst-hlfmt line)))
               ))
             )
        (orgtbl-to-generic table (org-combine-plists params_default params))))

.. _org-mode: http://orgmode.org
.. _emacs: http://www.gnu.org/s/emacs
.. _`radio tables`: http://orgmode.org/manual/Tables-in-arbitrary-syntax.html
