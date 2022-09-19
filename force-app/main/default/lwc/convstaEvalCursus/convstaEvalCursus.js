import { LightningElement, api, track, wire } from "lwc";

import checkStrictEvaluationDataSFDC from "@salesforce/apex/Convsta_WS_Helper_Cursus.checkStrictEvaluationData";
import wsPostEvalSFDC from "@salesforce/apex/Convsta_WS_Helper_Cursus.wsPostEval";
export default class Convsta_CursusLWC extends LightningElement {
  @api caseId;
  error;
  updateButtonErrorMessage = " ";
  @track strictDataCheck = "pending";
  // @track strictEvalDataCheck = ' '; //evalcheck
  @track isSendButtonDisabled = true;
  @track showSpinner = true;
  @wire(checkStrictEvaluationDataSFDC, { caseId: "$caseId" })
  handleReturn({ error, data }) {
    if (data) {
      let result = JSON.parse(data);
      console.log("checkStrictTotalDataSFDC result : ", result);
      if (result.allDataOK) {
        this.strictDataCheck = "OK";
        this.isSendButtonDisabled = false;
        this.showSpinner = false;
      } else {
        console.log("result.message : ", result.message);
        this.updateButtonErrorMessage =
          "La mise à jour des données vers Cursus n’a pas été effectuée en raison d’un ou plusieurs contrôles non concluants sur la demande de stage.";
        this.strictDataCheck = "NOK";
        this.dataerror = result.message;
        this.showSpinner = false;
      }
    } else if (error) {
      this.updateButtonErrorMessage =
        "La mise à jour des données vers Cursus n’a pas été effectuée en raison d’un ou plusieurs contrôles non concluants sur la demande de stage.";
      this.strictDataCheck = "NOK";
      this.showSpinner = false;
    }
  }

  connectedCallback() {
    this.error = null;
  }

  refreshData() {
    this.updateButtonErrorMessage = " ";
    this.error = "";
    this.cursusPhaseState = "pending";
    this.strictDataCheck = "pending";
    this.cursusEntrepriseState = "pending";
    this.cursusMaitreStageState = "pending";
    this.cursusTuteurState = "pending";
    this.isSendButtonDisabled = true;
    this.showSpinner = true;
    this.checkEval();
  }
  checkEval() {
    if (this.caseId) {
      checkStrictEvaluationDataSFDC({ caseId: this.caseId })
        .then((res) => {
          let result = JSON.parse(res);
          console.log("checkStrictTotalDataSFDC result : ", result);
          if (result.allDataOK) {
            this.strictDataCheck = "OK";
            this.isSendButtonDisabled = false;
            this.showSpinner = false;
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
          this.strictDataCheck = "NOK";
          this.isSendButtonDisabled = true;
          this.showSpinner = false;
          this.error = error;
        });
    }
  }

  // check if all SF data are ready to be sent to "Cursus"
  tryCursusUpdate() {
    console.log("checkStrictTotalDataForSend JS");
    this.isSendButtonDisabled = true;
    this.showSpinner = true;

    wsPostEvalSFDC({ caseId: this.caseId })
      .then((res) => {
        this.isSendButtonDisabled = true; // not sending twice in a row ?
        this.showSpinner = false;
        alert(res);
        console.log("checkStrictTotalDataSFDC result : ", res);
      })
      .catch((error) => {
        alert(error);
        this.error = error;
        console.log("checkStrictTotalDataSFDC catch error: ", error);
        this.showSpinner = false;
      });
  }
}