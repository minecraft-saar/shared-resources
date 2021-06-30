(defdomain rectangle25 (
;;new or adjusted as comment over new or adjusted methods/operators, otherwise it is just copied from house.lisp
;;costs of operators choosen equal to similiar methods
 
;;Operators, correspond to actions in PDDL
 (:operator (!place-block ?block-type ?x ?y ?z ?x2 ?y2 ?z2)
        ((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ((block-at ?block-type ?x ?y ?z) (last-placed ?x ?y ?z))
        2
 )
 
 (:operator (!remove-block ?block-type ?x ?y ?z)
        ((block-at ?block-type ?x ?y ?z))
        ((block-at ?block-type ?x ?y ?z))
        ((clear ?x ?y ?z))
 )

;; Methods can be decomposed into other methods or operators
;; Operators are marked with ! methods are just given by name 
(:method (remove-block ?x ?y ?z)
    block-is-empty
    ((clear ?x ?y ?z))
    ()

    block-is-filled
    ((block-at ?a ?x ?y ?z))
    ((!remove-block ?a ?x ?y ?z))
    )

(:method (place-block ?block-type ?x ?y ?z)
    block-is-empty
        ((last-placed ?x2 ?y2 ?z2) (not (block-at ?a ?x ?y ?z)))
        ;;old line:((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ((!place-block ?block-type ?x ?y ?z ?x2 ?y2 ?z2))

    block-is-same
        ((block-at ?block-type ?x ?y ?z))
        ()

    block-is-different
        ((block-at ?a ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ()

)

(:method (build-rectangle-east ?x ?y ?z)
    ()
    (
    (place-block stone ?x ?y ?z)
    (place-block stone (call + ?x 4) ?y ?z)
    (place-block stone (call + ?x 4) ?y (call + ?z 4))
    (place-block stone ?x ?y (call + ?z 4))
    (place-block stone (call + ?x 1) ?y ?z)
    (place-block stone (call + ?x 3) ?y ?z)
    (place-block stone (call + ?x 2) ?y ?z)
    (place-block stone (call + ?x 4) ?y (call + ?z 1))
    (place-block stone (call + ?x 4) ?y (call + ?z 2))
    (place-block stone ?x ?y (call + ?z 1))
    (place-block stone (call + ?x 3) ?y (call + ?z 4))
    (place-block stone ?x ?y (call + ?z 3))
    (place-block stone ?x ?y (call + ?z 2))
    (place-block stone (call + ?x 1) ?y (call + ?z 4))
    (place-block stone (call + ?x 2) ?y (call + ?z 4))
    (place-block stone (call + ?x 4) ?y (call + ?z 3))
    )
)

(:method (build-rectangle-west ?x ?y ?z)
    ()
    (
    (place-block stone ?x ?y ?z)
    (place-block stone (call - ?x 4) ?y ?z)
    (place-block stone (call - ?x 4) ?y (call - ?z 4))
    (place-block stone ?x ?y (call - ?z 4))
    (place-block stone (call - ?x 1) ?y ?z)
    (place-block stone (call - ?x 3) ?y ?z)
    (place-block stone (call - ?x 2) ?y ?z)
    (place-block stone (call - ?x 4) ?y (call - ?z 1))
    (place-block stone (call - ?x 4) ?y (call - ?z 2))
    (place-block stone ?x ?y (call - ?z 1))
    (place-block stone (call - ?x 3) ?y (call - ?z 4))
    (place-block stone ?x ?y (call - ?z 3))
    (place-block stone ?x ?y (call - ?z 2))
    (place-block stone (call - ?x 1) ?y (call - ?z 4))
    (place-block stone (call - ?x 2) ?y (call - ?z 4))
    (place-block stone (call - ?x 4) ?y (call - ?z 3))
    )
)

(:method (build-rectangle-north ?x ?y ?z)
    ()
    (
    (place-block stone ?x ?y ?z)
    (place-block stone ?x ?y (call - ?z 4))
    (place-block stone (call + ?x 4) ?y (call - ?z 4))
    (place-block stone (call + ?x 4) ?y ?z)
    (place-block stone ?x ?y (call - ?z 1))
    (place-block stone ?x ?y (call - ?z 3))
    (place-block stone ?x ?y (call - ?z 2))
    (place-block stone (call + ?x 1) ?y (call - ?z 4))
    (place-block stone (call + ?x 2) ?y (call - ?z 4))
    (place-block stone (call + ?x 1) ?y ?z)
    (place-block stone (call + ?x 4) ?y (call - ?z 3))
    (place-block stone (call + ?x 3) ?y ?z)
    (place-block stone (call + ?x 2) ?y ?z)
    (place-block stone (call + ?x 4) ?y (call - ?z 1))
    (place-block stone (call + ?x 4) ?y (call - ?z 2))
    (place-block stone (call + ?x 3) ?y (call - ?z 4))
    )
)

(:method (build-rectangle-south ?x ?y ?z)
    ()
    (
    (place-block stone ?x ?y ?z)
    (place-block stone ?x ?y (call + ?z 4))
    (place-block stone (call - ?x 4) ?y (call + ?z 4))
    (place-block stone (call - ?x 4) ?y ?z)
    (place-block stone ?x ?y (call + ?z 1))
    (place-block stone ?x ?y (call + ?z 3))
    (place-block stone ?x ?y (call + ?z 2))
    (place-block stone (call - ?x 1) ?y (call + ?z 4))
    (place-block stone (call - ?x 2) ?y (call + ?z 4))
    (place-block stone (call - ?x 1) ?y ?z)
    (place-block stone (call - ?x 4) ?y (call + ?z 3))
    (place-block stone (call - ?x 3) ?y ?z)
    (place-block stone (call - ?x 2) ?y ?z)
    (place-block stone (call - ?x 4) ?y (call + ?z 1))
    (place-block stone (call - ?x 4) ?y (call + ?z 2))
    (place-block stone (call - ?x 3) ?y (call + ?z 4))
    )
)

(:method (build-rectangle25 ?x ?y ?z ?dir)
        east
        ((call equal ?dir 1))
        ((build-rectangle-east ?x ?y ?z))
        
        west
        ((call equal ?dir 2))
        ((build-rectangle-west ?x ?y ?z))
        
        north
        ((call equal ?dir 3))
        ((build-rectangle-north ?x ?y ?z))
        
        south
        ((call equal ?dir 4))
        ((build-rectangle-south ?x ?y ?z))
)   

;;Axioms
(:- (clear ?x ?y ?z)
    ((not (block-at ?type ?x ?y ?z)))
    )

)
)

