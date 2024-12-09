
;;;======================================================
;;;   Automotive Expert System
;;;
;;;     This expert system diagnoses some simple
;;;     problems with a car.
;;;
;;;     CLIPS Version 6.3 Example
;;;
;;;     For use with the Auto Demo Example
;;;======================================================

;;; ***************************
;;; * DEFTEMPLATES & DEFFACTS *
;;; ***************************

(deftemplate UI-state
   (slot id (default-dynamic (gensym*)))
   (slot display)
   (slot relation-asserted (default none))
   (slot response (default none))
   (multislot valid-answers)
   (slot state (default middle)))
   
(deftemplate state-list
   (slot current)
   (multislot sequence))
  
(deffacts startup
   (state-list))
   
;;;****************
;;;* STARTUP RULE *
;;;****************

(defrule system-banner ""

  =>
  
  (assert (UI-state (display WelcomeMessage)
                    (relation-asserted start)
                    (state initial)
                    (valid-answers))))

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule determine-responsible-job ""

   (logical (start))

   =>

   (assert (UI-state (display StartQuestion)
                     (relation-asserted responsible-job)
                     (response No)
                     (valid-answers No Yes))))
   
(defrule determine-marks-higher ""

   (logical (responsible-job Yes))

   =>

   (assert (UI-state (display MarksQuestion)
                     (relation-asserted marks-higher)
                     (response No)
                     (valid-answers No Yes))))

(defrule determine-study ""
    (or
   (logical (marks-higher Yes))
   (logical (done-this No))
    )
   =>

   (assert (UI-state (display StudyHardQuestion)
                     (relation-asserted study-hard)
                     (response No)
                     (valid-answers No Maybe Yes))))
(defrule determine-done-this ""

   (logical (work Next))

   =>

   (assert (UI-state (display DoneThisQuestion)
                     (relation-asserted done-this)
                     (response No)
                     (valid-answers No Yes))))
(defrule determine-help-society ""

   (logical (university Next))

   =>

   (assert (UI-state (display HelpSocietyQuestion)
                     (relation-asserted help-society)
                     (response No)
                     (valid-answers No Yes))))
(defrule determine-languages ""

   (logical (help-society Yes))

   =>

   (assert (UI-state (display LanguagesQuestion)
                     (relation-asserted languages)
                     (response No)
                     (valid-answers No Yes))))
(defrule determine-rich ""

   (logical (languages Yes))

   =>

   (assert (UI-state (display RichQuestion)
                     (relation-asserted rich)
                     (response No)
                     (valid-answers No Yes))))


;;;****************
;;;* STATEMENTS RULES *
;;;****************

(defrule statement-hippie ""
   (logical (responsible-job No))

   =>

   (assert (UI-state (display HippieStatement)
                     (relation-asserted hippie)
                     (response Next)
                     (valid-answers Next))))

(defrule statement-university ""

   (logical (study-hard Yes))

   =>

   (assert (UI-state (display UniversityStatement)
                     (relation-asserted university)
                     (response Next)
                     (valid-answers Next))))
(defrule statement-work ""

   (logical (study-hard Maybe))

   =>

   (assert (UI-state (display WorkStatement)
                     (relation-asserted work)
                     (response Next)
                     (valid-answers Next))))
(defrule statement-pension ""

   (logical (done-this Yes))

   =>

   (assert (UI-state (display PensionStatement)
                     (relation-asserted pension)
                     (response Next)
                     (valid-answers Next))))
(defrule statement-lawyer ""

   (logical (help-society No))

   =>

   (assert (UI-state (display LawyerStatement)
                     (relation-asserted lawyer)
                     (response Next)
                     (valid-answers Next))))
(defrule statement-parliment ""

   (logical (lawyer Next))

   =>

   (assert (UI-state (display ParliamentStatement)
                     (relation-asserted parliament)
                     (response Next)
                     (valid-answers Next))))
(defrule statement-senate ""

   (logical (parliament Next))

   =>

   (assert (UI-state (display SenateStatement)
                     (relation-asserted senate)
                     (response Next)
                     (valid-answers Next))))

(defrule flowsheet-can-not-help ""

   (logical (rich Yes))

   =>

   (assert (UI-state (display FlowSheetCanNotHelpStatement)
                     (relation-asserted flow-sheet)
                     (response Next)
                     (valid-answers Next))))
(defrule someone-else ""

   (logical (flow-sheet Next))

   =>

   (assert (UI-state (display SomeoneElseStatement)
                     (relation-asserted someone-else)
                     (response Next)
                     (valid-answers Next))))


;;;****************
;;;* ENDING RULES *
;;;****************

(defrule stop ""
    (or
   (logical (hippie Next))
   (logical (senate Next))
   (logical (pension Next))
   )
   =>

   (assert (UI-state (display Stop)
                     (state final))))


(defrule go-away ""
   (logical (someone-else Next))
   =>

   (assert (UI-state (display GoAway)
                     (state final))))


                     
;;;*************************
;;;* GUI INTERACTION RULES *
;;;*************************

(defrule ask-question

   (declare (salience 5))
   
   (UI-state (id ?id))
   
   ?f <- (state-list (sequence $?s&:(not (member$ ?id ?s))))
             
   =>
   
   (modify ?f (current ?id)
              (sequence ?id ?s))
   
   (halt))

(defrule handle-next-no-change-none-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
                      
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-response-none-end-of-chain

   (declare (salience 10))
   
   ?f <- (next ?id)

   (state-list (sequence ?id $?))
   
   (UI-state (id ?id)
             (relation-asserted ?relation))
                   
   =>
      
   (retract ?f)

   (assert (add-response ?id)))   

(defrule handle-next-no-change-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
     
   (UI-state (id ?id) (response ?response))
   
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-change-middle-of-chain

   (declare (salience 10))
   
   (next ?id ?response)

   ?f1 <- (state-list (current ?id) (sequence ?nid $?b ?id $?e))
     
   (UI-state (id ?id) (response ~?response))
   
   ?f2 <- (UI-state (id ?nid))
   
   =>
         
   (modify ?f1 (sequence ?b ?id ?e))
   
   (retract ?f2))
   
(defrule handle-next-response-end-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)
   
   (state-list (sequence ?id $?))
   
   ?f2 <- (UI-state (id ?id)
                    (response ?expected)
                    (relation-asserted ?relation))
                
   =>
      
   (retract ?f1)

   (if (neq ?response ?expected)
      then
      (modify ?f2 (response ?response)))
      
   (assert (add-response ?id ?response)))   

(defrule handle-add-response

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id ?response)
                
   =>
      
   (str-assert (str-cat "(" ?relation " " ?response ")"))
   
   (retract ?f1))   

(defrule handle-add-response-none

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id)
                
   =>
      
   (str-assert (str-cat "(" ?relation ")"))
   
   (retract ?f1))   

(defrule handle-prev

   (declare (salience 10))
      
   ?f1 <- (prev ?id)
   
   ?f2 <- (state-list (sequence $?b ?id ?p $?e))
                
   =>
   
   (retract ?f1)
   
   (modify ?f2 (current ?p))
   
   (halt))
   
