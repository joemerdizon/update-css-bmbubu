<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static" MasterPageFile="DataImportMaster.Master"  CodeBehind="clientTitles.aspx.cs" Inherits="ManageUPPRM.dashjs.admin.dataImporters.clientTitles" %>

<asp:Content ID="Content2" ContentPlaceHolderID="instructions" runat="server">
<h3>Instructions</h3>
    <h5>1. <a onclick="window.open('exampleFiles/functionalroles.xls');">Download the example file and check the file format.</a></h5>
    <h5>2. Do not forget to respect the format</h5>
    <h5>3. Fill the template you downloaded on step 1. Then upload this file to the system</h5>
    <h5>4. Select the Sheet Name and Row Number where data begins</h5>
    <h5>5. Click on import and wait for the process to finish. Then check the results on the table below.</h5>
</asp:content>

<asp:Content ID="Content1" ContentPlaceHolderID="importLocalOptions" runat="server">
</asp:Content>
