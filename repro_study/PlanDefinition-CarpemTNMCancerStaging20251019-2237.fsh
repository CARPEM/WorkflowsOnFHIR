Instance: CarpemTNMCancerStaging20251019v1
InstanceOf: PlanDefinition
Title: "Carpem TNM Cancer Staging (v1)"
Description: "PlanDefinition for TNM cancer staging workflow based on pathology reports, tumor board reports, and tumor board report documents. Generated from BPMN workflow on 2025-10-19."
Usage: #definition

* name = "CarpemTNMCancerStaging20251019v1"
* status = #active

* action[0]
  * title = "TNM Cancer Staging Workflow"
  * description = "Complete TNM cancer staging workflow"
  * code = CarpemTransformation#CarpemTNMCancerStaging

  // Parallel Gateway: Split into 3 parallel pathways
  * action[0]
    * id = "parallel-gateway-split"
    * title = "Parallel Processing Gateway"
    * description = "Split into three parallel pathways for processing different input sources"
    * groupingBehavior = #logical-group
    * selectionBehavior = #all

    // Pathway 1: Pathology Report
    * action[0]
      * id = "struct-pathology-to-fhir"
      * title = "Structure Pathology Report to FHIR"
      * description = "Structure pathology report to FHIR DocumentReference"
      * code = CarpemTransformation#STRUCT_PathologyToFHIR
      * type = http://terminology.hl7.org/CodeSystem/action-type#create
      * output[0]
        * type = #DocumentReference

      * relatedAction[0]
        * actionId = "extract-tnm-pathology"
        * relationship = #before-start

    * action[1]
      * id = "extract-tnm-pathology"
      * title = "Extract TNM from Pathology"
      * description = "Extract TNM observations from pathology report"
      * code = CarpemTransformation#EXTRACT_TNM_Pathology
      * type = http://terminology.hl7.org/CodeSystem/action-type#create
      * input[0]
        * type = #DocumentReference
      * output[0]
        * type = #Observation
        * profile[0] = Canonical(CarpemTNMStageGroup)

      * relatedAction[0]
        * actionId = "parallel-gateway-join"
        * relationship = #before-start

    // Pathway 2: Tumor Board
    * action[2]
      * id = "struct-tumor-board-to-fhir"
      * title = "Structure Tumor Board to FHIR"
      * description = "Structure tumor board report to FHIR Observation"
      * code = CarpemTransformation#STRUCT_TumorBoardToFHIR
      * type = http://terminology.hl7.org/CodeSystem/action-type#create
      * output[0]
        * type = #QuestionnaireResponse

      * relatedAction[0]
        * actionId = "extract-tnm-tumor-board"
        * relationship = #before-start

    * action[3]
      * id = "extract-tnm-tumor-board"
      * title = "Extract TNM from Tumor Board"
      * description = "Extract TNM observations from tumor board report"
      * code = CarpemTransformation#EXTRACT_TNM_TumorBoard
      * type = http://terminology.hl7.org/CodeSystem/action-type#create
      * input[0]
        * type = #QuestionnaireResponse
      * output[0]
        * type = #Observation
        * profile[0] = Canonical(CarpemTNMStageGroup)

      * relatedAction[0]
        * actionId = "parallel-gateway-join"
        * relationship = #before-start

    // Pathway 3: Tumor Board Report Document
    * action[4]
      * id = "struct-tumor-board-report-to-fhir"
      * title = "Structure Tumor Board Report Document to FHIR"
      * description = "Structure tumor board report to FHIR DocumentReference"
      * code = CarpemTransformation#STRUCT_TumorBoardReportToFHIR
      * type = http://terminology.hl7.org/CodeSystem/action-type#create
      * output[0]
        * type = #DocumentReference

      * relatedAction[0]
        * actionId = "extract-tnm-tumor-board-report"
        * relationship = #before-start

    * action[5]
      * id = "extract-tnm-tumor-board-report"
      * title = "Extract TNM from Tumor Board Report Document"
      * description = "Extract TNM observations from tumor board report"
      * code = CarpemTransformation#EXTRACT_TNM_TumorBoardReport
      * type = http://terminology.hl7.org/CodeSystem/action-type#create
      * input[0]
        * type = #DocumentReference
      * output[0]
        * type = #Observation
        * profile[0] = Canonical(CarpemTNMStageGroup)

      * relatedAction[0]
        * actionId = "parallel-gateway-join"
        * relationship = #before-start

  // Parallel Gateway: Join
  * action[1]
    * id = "parallel-gateway-join"
    * title = "Parallel Processing Join Gateway"
    * description = "Wait for all parallel pathways to complete"
    * groupingBehavior = #logical-group
    * selectionBehavior = #all

    * relatedAction[0]
      * actionId = "consolidate-tnm"
      * relationship = #before-start

  // Final Consolidation
  * action[2]
    * id = "consolidate-tnm"
    * title = "Consolidate TNM Observations"
    * description = "Consolidate TNM observations from multiple sources"
    * code = CarpemTransformation#CONSOLID_TNM
    * type = http://terminology.hl7.org/CodeSystem/action-type#create
    * input[0]
      * type = #Observation
      * profile[0] = Canonical(CarpemTNMStageGroup)
    * input[1]
      * type = #Observation
      * profile[0] = Canonical(CarpemTNMStageGroup)
    * input[2]
      * type = #Observation
      * profile[0] = Canonical(CarpemTNMStageGroup)
    * output[0]
      * type = #Observation
      * profile[0] = Canonical(CarpemTNMStageGroup)
