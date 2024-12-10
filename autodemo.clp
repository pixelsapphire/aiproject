
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
                     (response Yes)
                     (valid-answers No Yes))))
   
(defrule determine-marks-higher ""

   (logical (responsible-job Yes))

   =>

   (assert (UI-state (display MarksQuestion)
                     (relation-asserted marks-higher)
                     (response Yes)
                     (valid-answers No Yes))))

(defrule determine-study-hard ""
    (or
   (logical (marks-higher Yes))
   (logical (done-this No))
    )
   =>

   (assert (UI-state (display StudyHardQuestion)
                     (relation-asserted study-hard)
                     (response Yes)
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
                     (response Yes)
                     (valid-answers No Yes))))
(defrule determine-languages ""
    (or
    (logical (help-society Yes))
    (logical (remedial Next))
    )
   =>

   (assert (UI-state (display LanguagesQuestion)
                     (relation-asserted languages)
                     (response Yes)
                     (valid-answers No Yes))))
(defrule determine-rich ""

   (logical (languages Yes))

   =>

   (assert (UI-state (display RichQuestion)
                     (relation-asserted rich)
                     (response No)
                     (valid-answers No Yes))))
(defrule determine-practical ""

   (logical (rich No))

   =>

   (assert (UI-state (display PracticalQuestion)
                     (relation-asserted practical)
                     (response Yes)
                     (valid-answers No Yes))))

(defrule determine-endless ""

   (logical (practical Yes))

   =>

   (assert (UI-state (display EndlessQuestion)
                     (relation-asserted endless)
                     (response No)
                     (valid-answers No Yes))))

(defrule determine-science ""

   (logical (endless No))

   =>

   (assert (UI-state (display ScienceQuestion)
                     (relation-asserted science)
                     (response Yes)
                     (valid-answers No Yes))))

(defrule determine-math ""

   (logical (science Yes))

   =>

   (assert (UI-state (display MathQuestion)
                     (relation-asserted math)
                     (response Yes)
                     (valid-answers No Yes))))

(defrule determine-math-good ""

   (logical (math Yes))

   =>

   (assert (UI-state (display MathGoodQuestion)
                     (relation-asserted math-good)
                     (response Yes)
                     (valid-answers No Yes))))
(defrule determine-logic ""

   (logical (math-good Yes))

   =>

   (assert (UI-state (display LogicQuestion)
                     (relation-asserted logic)
                     (response Yes)
                     (valid-answers No Yes))))
(defrule determine-application ""

   (logical (logic Yes))

   =>

   (assert (UI-state (display ApplicationQuestion)
                     (relation-asserted application)
                     (response Yes)
                     (valid-answers No Yes))))
(defrule determine-math-a-lot ""

   (logical (tuition Next))

   =>

   (assert (UI-state (display MathALotQuestion)
                     (relation-asserted math-a-lot)
                     (response Yes)
                     (valid-answers No Yes))))
(defrule determine-electronics ""

   (logical (math-a-lot Yes))

   =>

   (assert (UI-state (display ElectronicsQuestion)
                     (relation-asserted electronics)
                     (response Yes)
                     (valid-answers No Yes))))
(defrule determine-wish ""

   (logical (electrical Next))

   =>

   (assert (UI-state (display WishQuestion)
                     (relation-asserted wish)
                     (response No)
                     (valid-answers No Yes))))
(defrule determine-graduate ""

   (logical (wish No))

   =>

   (assert (UI-state (display GraduateQuestion)
                     (relation-asserted graduate)
                     (response No)
                     (valid-answers No Yes))))
(defrule determine-administration ""

   (logical (graduate Yes))

   =>

   (assert (UI-state (display AdministrationQuestion)
                     (relation-asserted administration)
                     (response No)
                     (valid-answers No Yes))))
(defrule determine-math-really ""

   (logical (administration No))

   =>

   (assert (UI-state (display MathReallyQuestion)
                     (relation-asserted math-really)
                     (response No)
                     (valid-answers No Yes))))
(defrule determine-teaching ""
    (or
    (logical (graduate-degree Next))
    (logical (business Next))
    )
   =>

   (assert (UI-state (display TeachingQuestion)
                     (relation-asserted teaching)
                     (response No)
                     (valid-answers No Yes))))
(defrule determine-research ""
    (logical (teaching No))
   =>

   (assert (UI-state (display ResearchQuestion)
                     (relation-asserted research)
                     (response No)
                     (valid-answers No Yes))))
(defrule determine-sales ""
    (or
    (logical (graduate No))
    (logical (research No))
    )
   =>

   (assert (UI-state (display SalesQuestion)
                     (relation-asserted sales)
                     (response No)
                     (valid-answers No Yes))))
(defrule determine-management ""
    (logical (sales No))
   =>

   (assert (UI-state (display ManagementQuestion)
                     (relation-asserted management)
                     (response No)
                     (valid-answers No Yes))))
(defrule determine-own-business ""
    (logical (sales No))
   =>

   (assert (UI-state (display OwnBusinessQuestion)
                     (relation-asserted own-business)
                     (response No)
                     (valid-answers No Yes))))

;;;****************
;;;* UNIQUE STATEMENTS RULES *
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
(defrule statement-remedial ""

   (logical (languages No))

   =>

   (assert (UI-state (display RemedialStatement)
                     (relation-asserted remedial)
                     (response Next)
                     (valid-answers Next))))
(defrule statement-aptitude ""

   (logical (application Yes))

   =>

   (assert (UI-state (display AptitudeStatement)
                     (relation-asserted aptitude)
                     (response Next)
                     (valid-answers Next))))
(defrule statement-college ""

   (logical (aptitude Next))

   =>

   (assert (UI-state (display CollegeStatement)
                     (relation-asserted college)
                     (response Next)
                     (valid-answers Next))))
(defrule statement-tuition ""

   (logical (college Next))

   =>

   (assert (UI-state (display TuitionStatement)
                     (relation-asserted tuition)
                     (response Next)
                     (valid-answers Next))))
(defrule statement-electrical ""

   (logical (electronics Yes))

   =>

   (assert (UI-state (display ElectricalStatement)
                     (relation-asserted electrical)
                     (response Next)
                     (valid-answers Next))))
(defrule statement-business ""

   (logical (administration Yes))

   =>

   (assert (UI-state (display BusinessStatement)
                     (relation-asserted business)
                     (response Next)
                     (valid-answers Next))))
(defrule statement-graduate-degree ""

    (logical (math-really Yes))

   =>

   (assert (UI-state (display GraduateDegreeStatement)
                     (relation-asserted graduate-degree)
                     (response Next)
                     (valid-answers Next))))
(defrule statement-years-experience ""

    (logical (own-business Yes))

   =>

   (assert (UI-state (display YearsExperienceStatement)
                     (relation-asserted years-experience)
                     (response Next)
                     (valid-answers Next))))
;;;****************
;;;* UNIVERSAL STATEMENTS RULES *
;;;****************
(defrule statement-unrealistic""

   (logical (endless Yes))

   =>

   (assert (UI-state (display UnrealisticStatement)
                     (relation-asserted unrealistic)
                     (response Next)
                     (valid-answers Next))))

(defrule flowsheet-can-not-help ""
   (or
   (logical (unrealistic Next))
   (logical (rich Yes))
   (logical (science No))
   )

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
;;;* UNIVERSAL ENDING RULES *
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

;;;****************
;;;* JOB ENDING RULES *
;;;****************

(defrule statistician ""
   (logical (practical No))
   =>

   (assert (UI-state (display StatisticianJob)
                     (state final))))
(defrule field-biologist ""
   (logical (math No))
   =>

   (assert (UI-state (display FieldBiologistJob)
                     (state final))))
(defrule technical-journalist ""
   (logical (math-good No))
   =>

   (assert (UI-state (display TechnicalJournalistJob)
                     (state final))))
(defrule research-scientist""
   (logical (application No))
   =>

   (assert (UI-state (display ResearchScientistJob)
                     (state final))))
(defrule still-research-scientist""
   (logical (wish Yes))
   =>

   (assert (UI-state (display StillResearchScientistJob)
                     (state final))))
(defrule other-field""
   (logical (math-really No))
   =>

   (assert (UI-state (display OtherFieldJob)
                     (state final))))
(defrule professor""
   (logical (teaching Yes))
   =>

   (assert (UI-state (display ProfessorJob)
                     (state final))))
(defrule research-department ""
    (logical (research Yes))
    =>

    (assert (UI-state (display ResearchDepartmentJob)
                      (state final))))
(defrule technical-rep ""
    (logical (sales Yes))
    =>

    (assert (UI-state (display TechnicalRepJob)
                      (state final))))
(defrule technical-staff ""
    (logical (management Yes))
    =>

    (assert (UI-state (display TechnicalStaffJob)
                      (state final))))
(defrule production-staff ""
    (logical (own-business No))
    =>

    (assert (UI-state (display ProductionStaffJob)
                      (state final))))
(defrule consulting ""
    (logical (years-experience Next))
    =>

    (assert (UI-state (display ConsultingJob)
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
   
