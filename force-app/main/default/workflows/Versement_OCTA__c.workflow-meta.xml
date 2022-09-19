<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Mise_Jour_Montant_Net_OCTA</fullName>
        <field>Montant_net__c</field>
        <formula>IF(ISNULL(Octa_Montant_A__c) ,0,Octa_Montant_A__c)+IF(ISNULL(Octa_Montant_B__c) ,0,Octa_Montant_B__c)</formula>
        <name>Mise à Jour Montant Net OCTA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>OCTA Totalisation Montant A et Montant B</fullName>
        <actions>
            <name>Mise_Jour_Montant_Net_OCTA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
