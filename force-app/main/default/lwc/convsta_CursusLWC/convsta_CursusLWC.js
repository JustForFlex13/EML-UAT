import { LightningElement, api, track } from "lwc";

import NUM_ETUDIANT_FIELD from "@salesforce/schema/Case.Contact.Identifiant_Etudiant__c";
import DATE_DEB_FIELD from "@salesforce/schema/Case.Convsta_DateStart__c";
import DATE_FIN_FIELD from "@salesforce/schema/Case.Convsta_DateEnd__c";

import wsGetCodePhase from "@salesforce/apex/Convsta_WS_Helper_Cursus.wsGetCodePhaseFront";
import getStageSFDC from "@salesforce/apex/Convsta_WS_Helper_Cursus.getStage";
import getEntreprise from "@salesforce/apex/Convsta_WS_Helper_Cursus.wsgetEntreprise";
import getFEGCodeTuteur from "@salesforce/apex/Convsta_WS_Helper_Cursus.wsgetTuteur";
import getRefintCode from "@salesforce/apex/Convsta_WS_Helper_Cursus.wsGetCodeProf";
import checkStrictTotalDataSFDC from "@salesforce/apex/Convsta_WS_Helper_Cursus.checkStrictTotalData";
import checkStrictEvaluationDataSFDC from "@salesforce/apex/Convsta_WS_Helper_Cursus.checkStrictEvaluationData";
import wsPostPhase from "@salesforce/apex/Convsta_WS_Helper_Cursus.wsPostPhase";
import updateStageCursusDoneBolean from "@salesforce/apex/Convsta_WS_Helper_Cursus.updateStageCursusDoneBolean";
export default class Convsta_CursusLWC extends LightningElement {
  @api caseId;
  case;
  numEtudiant;
  dateDebutStage;
  dateFinStage;
  typeDemande;
  codePhase;
  error;
  isAvenant;
  updateButtonErrorMessage = " ";
  @track cursusPhaseState = "pending";
  @track strictDataCheck = "pending";
  @track cursusEntrepriseState = "pending";
  @track cursusMaitreStageState = "pending";
  @track cursusTuteurState = "pending";
  // @track strictEvalDataCheck = ' '; //evalcheck
  @track isSendButtonDisabled = true;
  @track showSpinner = true;

  connectedCallback() {
    this.error = null;
    this.getStage();
  }

  refreshData() {
    this.updateButtonErrorMessage = " ";
    this.error = "";
    this.dataerror = "";
    this.cursusPhaseState = "pending";
    this.strictDataCheck = "pending";
    this.cursusEntrepriseState = "pending";
    this.cursusMaitreStageState = "pending";
    this.cursusTuteurState = "pending";
    this.isSendButtonDisabled = true;
    this.showSpinner = true;
    this.getStage();
  }
  getStage() {
    getStageSFDC({ caseId: this.caseId })
      .then((result) => {
        this.case = result;
        this.isAvenant = result.RecordType.DeveloperName == "Convsta_Avenant";
        if (this.isAvenant) {
          this.numEtudiant = result.Parent.Contact.convsta_code_etudiant_EM__c;
          this.dateDebutStage =
            result.Convsta_Nouvelle_date_de_debut__c != null
              ? result.Convsta_Nouvelle_date_de_debut__c
              : result.Parent.Convsta_DateStart__c;
          this.dateFinStage =
            result.Convsta_Nouvelle_date_de_fin__c != null
              ? result.Convsta_Nouvelle_date_de_fin__c
              : result.Parent.Convsta_DateEnd__c;
          this.typeDemande = result.Parent.Convsta_Type_de_demande__c;
        } else {
          this.numEtudiant = result.Contact.convsta_code_etudiant_EM__c;
          this.dateDebutStage = result.Convsta_DateStart__c;
          this.dateFinStage = result.Convsta_DateEnd__c;
          this.typeDemande = result.Convsta_Type_de_demande__c;
        }
        this.callGetCompleteData();
      })
      .catch((error) => {
        this.error = error;
      });
  }
  callGetCompleteData() {
    checkStrictTotalDataSFDC({ stage: this.case })
      .then((res) => {
        let result = JSON.parse(res);
        console.log("checkStrictTotalDataSFDC result : ", result);
        if (result.allDataOK) {
          this.strictDataCheck = "OK";
          this.callWsGetCodePhase();
        } else {
          console.log("result.message : ", result.message);
          this.updateButtonErrorMessage =
            "La mise à jour des données vers Cursus n’a pas été effectuée en raison d’un ou plusieurs contrôles non concluants sur la demande de stage.";
          this.strictDataCheck = "NOK";
          this.dataerror = result.message;
          this.showSpinner = false;
        }
      })
      .catch((error) => {
        this.error = error;
        console.log("checkStrictTotalDataSFDC catch error: ", error);
        this.showSpinner = false;
      });
  }
  callWsGetCodePhase() {
    wsGetCodePhase({
      numEtudiant: this.numEtudiant,
      debut: this.dateDebutStage,
      fin: this.dateFinStage
    })
      .then((resJSON) => {
        let result = JSON.parse(resJSON);
        if (result.success) {
          this.codePhase = result.codePhase;
          // Cursus has a suitable phase with matching student, startDate and endDate
          this.cursusPhaseState = "OK";
          this.callWsGetEntreprise();
        } else {
          this.cursusPhaseState = "NOK";
          this.updateButtonErrorMessage = result.errorMsg;
          this.showSpinner = false;
        }
      })
      .catch((error) => {
        this.cursusPhaseState = "NOK";
        this.showSpinner = false;
        this.error = JSON.stringify(error);
        console.log("wsGetCodePhase catch error: " + JSON.stringify(error));
      });
  }

  callWsGetEntreprise() {
    let idCompte = this.isAvenant
      ? this.case.Parent.Convsta_Entreprise__c
      : this.case.Convsta_Entreprise__c;
    getEntreprise({
      idSFCompteEntreprise: idCompte
    }).then((result) => {
      if (result != null && result != "") {
        this.cursusEntrepriseState = "OK";
        this.getMaitreStage();
      } else {
        this.cursusEntrepriseState = "NOK";
        this.error = "Entreprise non trouvée dans FEG";
        this.showSpinner = false;
      }
    });
  }

  getMaitreStage() {
    let idTuteur = this.isAvenant
      ? this.case.Parent.Convsta_Tuteur__c
      : this.case.Convsta_Tuteur__c;
    if (idTuteur) {
      getFEGCodeTuteur({
        idSFCompteEntreprise: this.isAvenant
          ? this.case.Parent.Convsta_Tuteur__r.AccountId
          : this.case.Convsta_Tuteur__r.AccountId,
        idSfTutor: idTuteur,
        function: this.isAvenant
          ? this.case.Parent.Convsta_Tuteur__r.Fonctions__c
          : this.case.Convsta_Tuteur__r.Fonctions__c
      }).then((result) => {
        if (result != null && result != "") {
          this.cursusMaitreStageState = "OK";
          this.getTuteurEm();
        } else {
          this.cursusMaitreStageState = "NOK";
          this.showSpinner = false;
        }
      });
    } else {
      this.cursusMaitreStageState = "aucun";
      this.getTuteurEm();
    }
  }

  getTuteurEm() {
    if (
    /*  (this.case &&
        this.case.Convsta_Referent_pedagogique__r &&
        this.case.Convsta_Referent_pedagogique__r.LastName) ||
      (this.case.Parent &&
        this.case.Parent.Convsta_Referent_pedagogique__r &&
        this.case.Parent.Convsta_Referent_pedagogique__r.LastName) */

        (this.case &&
          this.case.Convsta_Referent_pedagogique__r &&
          this.case.Convsta_Referent_pedagogique__r.Email) ||
        (this.case.Parent &&
          this.case.Parent.Convsta_Referent_pedagogique__r &&
          this.case.Parent.Convsta_Referent_pedagogique__r.Email)
  
    ) {
      getRefintCode({
      /*  name: this.isAvenant
          ? this.case.Parent.Convsta_Referent_pedagogique__r.LastName
          : this.case.Convsta_Referent_pedagogique__r.LastName */

          email: this.isAvenant
          ? this.case.Parent.Convsta_Referent_pedagogique__r.Email
          : this.case.Convsta_Referent_pedagogique__r.Email
          
      }).then((resultJson) => {
        console.log("tuteurEM resultJson : " + JSON.stringify(resultJson));
        let result = JSON.parse(resultJson);
        console.log(
          "tuteurEM result : " + result.isSuccess + "error" + result.error
        );
        if (result != null && result.isSuccess) {
          this.cursusTuteurState = "OK";
          this.isSendButtonDisabled = false;
          this.showSpinner = false;
        } else {
          this.errorMsg = result
            ? result.error
            : "erreur responsable pédagogique";
          this.cursusTuteurState = "NOK";
          this.showSpinner = false;
        }
      });
    } else {
      this.cursusTuteurState = "aucun";
      this.isSendButtonDisabled = false;
      this.showSpinner = false;
    }
  }
  // check if all SF data are ready to be sent to "Cursus"
  tryCursusUpdate() {
    console.log("checkStrictTotalDataForSend JS");
    this.isSendButtonDisabled = true;
    this.showSpinner = true;
    console.log("@stage : ", this.case);
    this.strictDataCheck = "pending";

    checkStrictTotalDataSFDC({ stage: this.case })
      .then((res) => {
        let result = JSON.parse(res);
        console.log("checkStrictTotalDataSFDC result : ", result);
        if (result.allDataOK) {
          this.strictDataCheck = "OK";
          this.wsPostPhaseJS();
        } else {
          console.log("result.message : ", result.message);
          this.updateButtonErrorMessage =
            "La mise à jour des données vers Cursus n’a pas été effectuée en raison d’un ou plusieurs contrôles non concluants sur la demande de stage.";
          this.strictDataCheck = "NOK";
          this.showSpinner = false;
        }
      })
      .catch((error) => {
        this.error = error;
        console.log("checkStrictTotalDataSFDC catch error: ", error);
        this.showSpinner = false;
      });
  }

  wsPostPhaseJS() {
    console.log("wsPostPhase JS");
    wsPostPhase({ stage: this.case })
      .then((res) => {
        console.log("wsPostPhase raw result (shouldn't be any): ", res);
        if (res == "success") {
          if (!this.isAvenant) {
            this.doUpdateStageCursusDoneBoleanJS();
          } else {
            alert("Données d'Arpège envoyées à Cursus.");
            this.isSendButtonDisabled = true; // not sending twice in a row ?
            this.showSpinner = false;
          }
        } else {
          alert("erreur cursus : " + res);
          this.showSpinner = false;
        }
      })
      .catch((error) => {
        this.error = error;
        console.log(
          "wsPostPhase catch error : ",
          JSON.parse(JSON.stringify(error))
        );
        if (
          error.body != null &&
          error.body.message.startsWith("EXCEPTION on codeProf", 0)
        ) {
          let badCodeProf = error.body.message.split(":")[1];
          this.updateButtonErrorMessage =
            'Une erreur est survenue : le "Code Prof" est invalide : ' +
            badCodeProf;
          this.isSendButtonDisabled = false; // allowing retry ?
        } else {
          this.updateButtonErrorMessage =
            "Une erreur est survenue lors de l'envoi des données à Cursus.";
          this.isSendButtonDisabled = false; // allowing retry ?
        }
        this.showSpinner = false;
      });
  }

  doUpdateStageCursusDoneBoleanJS() {
    alert("Données d'Arpège envoyées à Cursus.");
    console.log("doUpdateStageCursusDoneBolean JS");
    updateStageCursusDoneBolean({ stageId: this.case.Id })
      .then((res) => {
        console.log(
          "updateStageCursusDoneBolean result (shouldn't be any): ",
          res
        );
        this.isSendButtonDisabled = true; // not sending twice in a row ?
        this.showSpinner = false;
      })
      .catch((error) => {
        this.error = error;
        console.log("updateStageCursusDoneBolean catch error: " + error);
        this.showSpinner = false;
      });
  }

  /* //evalcheck
    checkStrictEvaluationDataJS() {
      console.log('checkStrictEvaluationDataJS');
      this.strictEvalDataCheck = 'strictEvalDataCheck';
      checkStrictEvaluationData({ stageId: this.case.Id })
        .then((res) => {
          let result = JSON.parse(res);
          console.log('checkStrictEvaluationData result : ', result);
          if (result.allDataOK) {
            this.strictEvalDataCheck = 'OK';
            this.wsPostPhaseJS();
          } else {
            console.log('result.message : ', result.message);
            this.updateButtonErrorMessage = "La mise à jour des données vers Cursus n’a pas été effectuée en raison d’un ou plusieurs contrôles non concluants sur l'évaluation.";
            this.strictEvalDataCheck = 'NOK';
            this.showSpinner = false;
          }
        })
        .catch((error) => {
          this.error = error;
          console.log("checkStrictEvaluationData catch error: " + error);
          this.showSpinner = false
        });
  
    }
  */
}